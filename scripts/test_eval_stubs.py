import os
import subprocess
import tempfile
import unittest
from pathlib import Path

FIXTURES = Path(__file__).resolve().parent.parent / "evals/fixtures"
ALIAS = "https://reminders-web.vercel.app"
DEPLOYMENT = "https://reminders-web-abc123.vercel.app"
WRITE_OUT = "%{http_code} %{url_effective}"


class StubsTest(unittest.TestCase):
    def setUp(self):
        tmp = tempfile.TemporaryDirectory()
        self.addCleanup(tmp.cleanup)
        self.log = Path(tmp.name)

    def run_stub(self, stub, *args, **env):
        return subprocess.run(
            ["bash", str(FIXTURES / stub), *args],
            capture_output=True,
            text=True,
            cwd=self.log,
            env={**os.environ, "VERCEL_STUB_LOG": str(self.log), **env},
        )

    def vercel(self, *args, **env):
        return self.run_stub("vercel-stub", *args, **env)

    def curl(self, url, **env):
        return self.run_stub("curl-stub", "-sSL", "-b", "", "-o", "/dev/null", "-w", WRITE_OUT, url, **env).stdout

    def target(self):
        return (self.log / "target").read_text().strip()

    def test_first_deploy_naming_preview_is_refused_and_publishes_nothing(self):
        for flags in (["--environment", "preview"], ["--environment=preview"], ["--target", "preview"]):
            result = self.vercel("deploy", *flags)
            self.assertEqual(result.returncode, 1)
            self.assertIn("first_deployment_production", result.stdout)
            self.assertFalse((self.log / "target").exists())

    def test_first_deploy_naming_no_target_goes_to_production(self):
        self.assertEqual(self.vercel("deploy").returncode, 0)
        self.assertEqual(self.target(), "production")

    def test_deploy_on_a_deployed_project_is_a_preview_and_inspect_reports_it(self):
        result = self.vercel("deploy", "--environment", "preview", VERCEL_STUB_DEPLOYED="1")
        self.assertIn(DEPLOYMENT, result.stdout)
        self.assertEqual(self.target(), "preview")
        self.assertIn("target\tpreview", self.vercel("inspect", DEPLOYMENT).stderr)

    def test_prod_flag_goes_to_production_on_a_deployed_project(self):
        self.vercel("deploy", "--prod", VERCEL_STUB_DEPLOYED="1")
        self.assertEqual(self.target(), "production")

    def test_forced_target_is_what_inspect_reports(self):
        self.vercel("deploy", "--environment", "preview", VERCEL_STUB_DEPLOYED="1")
        inspect = self.vercel("inspect", DEPLOYMENT, VERCEL_STUB_TARGET="production")
        self.assertIn("target\tproduction", inspect.stderr)

    def test_other_commands_do_not_deploy(self):
        self.vercel("--version")
        self.vercel("--help")
        self.vercel("list")
        self.vercel("project", "inspect")
        self.assertFalse((self.log / "target").exists())

    def test_deploy_with_no_command_is_logged_as_a_deploy(self):
        self.vercel("--yes")
        self.assertIn("deploy --yes", (self.log / "calls").read_text())
        self.assertEqual(self.target(), "production")

    def test_latest_production_deployment_lists_its_own_alias(self):
        env = {"VERCEL_STUB_DEPLOYED": "1"}
        listed = self.vercel("list", "--environment", "production", **env).stdout.strip()
        inspect = self.vercel("inspect", listed, **env).stderr
        self.assertIn("target\tproduction", inspect)
        self.assertIn("https://reminders-web-team.vercel.app", inspect)
        self.assertIn("vercel.com/login", self.curl("https://reminders-web-team.vercel.app"))

    def test_no_production_deployment_is_listed_on_a_new_project(self):
        self.assertEqual(self.vercel("list", "--environment", "production").stdout, "")

    def test_alias_is_absent_by_default(self):
        self.assertEqual(self.curl(ALIAS), f"404 {ALIAS}")

    def test_alias_can_answer_only_after_a_deploy(self):
        self.assertEqual(self.curl(ALIAS, VERCEL_STUB_ALIAS="after-deploy"), f"404 {ALIAS}")
        self.vercel("deploy", "--environment", "preview", VERCEL_STUB_DEPLOYED="1")
        self.assertEqual(self.curl(ALIAS, VERCEL_STUB_ALIAS="after-deploy"), f"200 {ALIAS}")

    def test_alias_can_answer_before_any_deploy(self):
        self.assertEqual(self.curl(ALIAS, VERCEL_STUB_ALIAS="always"), f"200 {ALIAS}")

    def test_plain_deployment_url_ends_on_the_login_page(self):
        self.assertIn("200 https://vercel.com/login", self.curl(DEPLOYMENT))

    def test_curl_calls_are_logged(self):
        self.curl(ALIAS)
        self.assertIn(ALIAS, (self.log / "curl").read_text())


if __name__ == "__main__":
    unittest.main()

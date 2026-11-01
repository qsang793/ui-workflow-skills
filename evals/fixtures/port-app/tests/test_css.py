import re
import unittest
from pathlib import Path

APP = Path(__file__).parent.parent / "app"


class StylesheetTest(unittest.TestCase):
    def test_every_class_in_the_stylesheet_is_used(self):
        css = (APP / "static/styles.css").read_text(encoding="utf-8")
        used = (APP / "templates/index.html").read_text(encoding="utf-8")
        for name in set(re.findall(r"\.([a-zA-Z][\w-]*)(?=[^{}]*\{)", css)):
            self.assertIn(name, used, f"unused class .{name}")


if __name__ == "__main__":
    unittest.main()

// Stands in for a real bundler so the case can build with no network: fails on a broken relative import.
import { cpSync, existsSync, readdirSync, readFileSync, statSync } from "node:fs";
import { dirname, join } from "node:path";

function files(dir) {
  return readdirSync(dir).flatMap((name) => {
    const path = join(dir, name);
    return statSync(path).isDirectory() ? files(path) : [path];
  });
}

const broken = [];
for (const file of files("src")) {
  for (const [, target] of readFileSync(file, "utf8").matchAll(/from\s+["'](\.[^"']+)["']/g)) {
    const base = join(dirname(file), target);
    const hit = ["", ".ts", ".tsx", ".json", "/index.ts", "/index.tsx"].some(
      (ext) => existsSync(base + ext) && statSync(base + ext).isFile(),
    );
    if (!hit) broken.push(`${file}: cannot resolve ${target}`);
  }
}
if (broken.length) {
  console.error(broken.join("\n"));
  process.exit(1);
}
cpSync("src", "dist", { recursive: true });
console.log(`built ${files("src").length} files to dist/`);

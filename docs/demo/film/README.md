# Demo film

The README walkthrough, built with [HyperFrames](https://hyperframes.heygen.com) (HTML rendered to video). Everything shown is illustrative: the bakery is synthetic, and the AI Studio and Claude Code screens are rebuilt layouts, not recordings.

| File | What it holds |
|---|---|
| `index.html` | Scene order and total length |
| `compositions/hook.html` | 0–6 s: the before/after promise |
| `compositions/work.html` | 6–49 s: five captioned steps, camera moves in the `<script>` at the end |
| `assets/` | `before.png` and `after-full.png`, captured from `../sites/` at 1920 px wide |
| `film.mp4`, `film-hook.gif` | Rendered outputs |

The two bakery pages live in `../sites/before/` and `../sites/after/`. After changing one, recapture its screenshot into `assets/`.

## Render

From this folder:

```bash
npx -y hyperframes@0.9.23 check
npx -y hyperframes@0.9.23 render --output film-raw.mp4
ffmpeg -i film-raw.mp4 -c:v libx264 -crf 26 -preset slow -pix_fmt yuv420p -movflags +faststart film.mp4
ffmpeg -ss 0 -t 6 -i film-raw.mp4 -vf "fps=15,scale=960:-1:flags=lanczos,split[a][b];[a]palettegen=max_colors=128[p];[b][p]paletteuse=dither=bayer:bayer_scale=4" film-hook.gif
rm film-raw.mp4
```

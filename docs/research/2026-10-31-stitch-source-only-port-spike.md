# Spike: Port one Screen from a Google Stitch export, reading source only

Purpose: a first test of the ADR-0004 assumption that a Design export's source, without running it, is enough to rebuild a Screen's look. This is a partial answer to issue #18, not the Lovable test that issue asks for.

Checked: 2026-10-31
Issue: https://github.com/qsang793/ui-workflow-skills/issues/18

## Result

For this Screen, source was enough to rebuild the look. Every layout and type value measured in both renders matched after the first pass, including two traps predicted before any render.

Viewing the export changed one value, and that value is nearly invisible. The problems that mattered came from running the Port with the project's real tokens and real data. The export's source could not have shown them.

This note does not propose amending ADR-0004. It does propose changes to the extraction rules for #9 (see [Proposed changes for #9](#proposed-changes-for-9)). The assumption remains open for Lovable (see [Limits](#limits)).

## Setup

| | |
|---|---|
| Design export | Google Stitch: one HTML file per Screen, Tailwind from `cdn.tailwindcss.com` with an inline `tailwind.config`, Material Symbols, Google Fonts, an inline script for state |
| Target project | The owner's private project: TypeScript, hand-written DOM, one stylesheet, no Tailwind. Worked on in a throwaway clone with no remote; nothing was committed |
| Screen | A timeline Screen with one photo, a narrative column and a four-node rail |
| Why this Screen | The project had rejected this layout for another one, so the running app could not be mistaken for a copy of the export. It also has the most to read: an inline script, four states, arbitrary values, opacity modifiers, filters and blend modes |
| Viewports | 1440×900 and 390 wide |

Order of work:

1. Read the export's source and Port it. No Tailwind or dependency was added.
2. Write down the values from source, the substitutes and the guesses, before opening any image of the export.
3. Render the export in a browser. This replaces the Design tool's preview, which this export did not come with, and depends on the Tailwind, Google Fonts and image CDNs. It was used for comparison only.
4. Run the Port, capture it and compare, then make a second pass.

There was no integration plan and no Stakeholder. The Screens table and every decision on design-only actions were mine, which the contract would not allow in a real run.

Screenshots show private content, so the side-by-side stays outside this repo, with the owner.

## Comparison

Computed values at 1440×900, read from both pages:

| Element | Export | Port, first pass |
|---|---|---|
| Year text | 72/72px, -1.8px tracking, weight 600 | Same |
| Title | 32/40px, -0.8px tracking, weight 500 | Same |
| Photo frame | 792×495, x=120, 16/10, radius 2px | Same |
| Active node halo | 28×28, radius 12px | Same |
| Active dot | Scale 1.1 | Same |
| Rail | 1440×102 at y=798 | Same |
| Axis line | 752 wide, resolved `top` 34px | Same |
| Active node height | 70px | Same |
| Seal | 32×32, radius 12px | Same |
| Photo filter | `brightness contrast grayscale` | `grayscale contrast brightness` (fixed in the second pass) |
| Frame shadow | Tailwind `shadow-xl` | Project's panel shadow (substitute) |
| Next button height | 26px | 44px (project's hit area) |

Node widths differ because the project's labels are longer than the export's.

## Values resolved from source

- **Layout:** grid columns per breakpoint, widths, padding, aspect ratios. The config does not change the screens, so Tailwind's defaults apply.
- **Spacing and type:** custom spacing and `fontSize` tokens from the inline config.
- **Utility precedence:** `tracking-*`, `leading-*` and `font-medium` override what a custom `fontSize` sets. Confirmed in the render.
- **Overridden scale:** the config sets `rounded-full` to `0.75rem`, so a 32px "circle" is really a rounded square. Predicted from source, confirmed in the render.
- **Static position:** the axis line is absolute with no `top`, so `items-center` centres it on the whole node, not on the dots. It therefore misses the dots and runs just above the labels. Predicted from source, confirmed in the render. The Port reproduces what looks like a flaw in the export, as a source-based Port should, and leaves the decision to the reviewer.
- **States:** the markup shows one state. The inline script holds the active and inactive class strings, the disabled button and the progress values.
- **Script gaps:** reading the script also shows that it never updates some visible fields or the image `src`. The export was never clicked, so this rests on reading alone.

Tailwind's default scale is not in the file. `shadow-xl`, `blur-3xl`, `backdrop-blur-md`, `max-w-7xl` and the tracking scale came from my memory of v3. All the ones measured were right, but `cdn.tailwindcss.com` is unversioned, so v3 was an assumption until the render agreed with it.

## Values that needed the screenshot

Only one value changed after viewing the export:

- **Filter order:** Tailwind composes filters in a fixed order, whatever the class order. A reader who knows that can get it from source, but I did not apply it. It came from the export's computed style, not from the image, and the visual difference is very small.

One thing could only be seen in the image: the frame's torn paper edge is baked into the picture, not built in CSS. Source only gives an opaque URL and an alt text. Since the image was replaced, the effect is lost and is reported as not reproduced.

The other guesses written down before the render needed no change: icon appearance, glow and grain strength. A screenshot was not needed to settle layout.

## Values substituted

| Export | Port | Why |
|---|---|---|
| Colour roles | Project tokens | Contract: map onto existing tokens first. Four surface steps became two |
| Arbitrary greens in class names | Project's secondary colour | Same |
| Grain colour, glow colour, rail shadow | Kept as literals | No token for the role |
| Large shadows | Project's shadows | Token mapping; visibly weaker on the photo |
| Icon font | Inline SVG from Material Symbols' published static files (Apache-2.0) | Contract; the project's content security policy would also block the font |
| Remote image | The project's own contemporary photo, with its credit | See below. The project's data for this Screen has no image field, so all four states show one photo. The grayscale filter was kept, which a Stakeholder should decide on |
| Design copy | Project data, or dropped | See below |
| Header, nav, avatar, footer | Project's header; the rest dropped | Design-only, and the footer content was invented |
| "Details" link | The project's existing Skip action | No destination in the project; the slot was kept for a required action |
| Button height | 44px | Project convention |
| `focus:outline-none` | Project's focus ring | Accessibility |

Not reproduced: the progress bar's width animation, because the app rebuilds the DOM on every state change, and the export's hidden scrollbars.

## What a static read missed

| Miss | Seen by | Found in |
|---|---|---|
| Italic face. Both pages name the same family, but the export loads a true italic and the project only has upright files, so the Port shows a synthesised slant. Not fixed | Comparing to the export | The font link in source: my reading miss, not a limit of source |
| Inactive dots almost vanish: 1.22:1 on the rail after token mapping, against 1.54:1 in the export. The axis line goes too | Running the Port | Fixed in the second pass, 5.98:1 for the dots |
| Longer data at 390px: a date broke mid-number, labels wrapped, and because the axis line centres on the node, it moved into the text | Running the Port at phone width | Fixed in the second pass with smaller, non-wrapping labels |
| The credit link kept the browser's blue | Running the Port | Port error, fixed |
| A `margin: 0` of mine overrode the stack spacing | Running the Port | Port error, fixed |
| An orphaned rule from the replaced layout failed the project's unused-class test (71 of 72 unit tests pass) | Running the tests | Not fixed in the clone |

Static read caught two things a Port could easily get wrong:

- **Invented provenance.** The export's copy states archive sources, document codes and a verification badge that do not exist in the project's data. The project's content is still in draft.
- **AI-generated image.** The image's alt text shows a generated picture, labelled in the design as an original dated archival photo.

The contract as written would carry both across: it says to extract copy as labels and to copy images into the project.

Rendering adds one trap. The export puts `transition-all` on large text, so a capture right after a resize showed a wrong font size (about 67px where the settled value is 48px). Reference captures must wait for transitions to finish.

## Proposed changes for #9

These concern the extraction rules, not ADR-0004:

1. **Do not carry claims of fact as copy.** Sources, codes, counts and verification badges in design copy are treated as placeholders unless the Screens table names a field for them. Report what was dropped.
2. **Do not copy images by default.** A remote or generated image may be a placeholder. Ask before copying, especially one that presents itself as a real photo or record.
3. **Check mapped colours.** Compute contrast for each mapped foreground and background pair, including dots and lines, and report when several surface steps collapse into one token.
4. **Check fonts by face.** Check that the project has the styles and weights the export loads, not just the family.
5. **Run the Port before handing it over.** Where a browser is available, `design-port` looks at the Screen itself, at phone and desktop width, with real data. Long labels and broken wrapping were the most visible failures here. Today the contract only hands the URL to the Stakeholder.
6. **State the Tailwind assumptions.** Class order is not CSS order, and filters compose in a fixed order. Record the assumed version when the export does not pin one.
7. **Remove what the Port orphans.** Clear CSS left unused by a replaced layout and run the project's checks.

## Limits

- Stitch is not Lovable, and it is not one of the plugin's Design tools.
- This is the easiest kind of export: one self-contained HTML file with all styles in the file. One Screen, one reader.
- The export came from the same design work as the target project, so fonts and palette were already close. An unrelated project would need more substitution.
- I knew the outcome being tested and read the source closely, which a real run may not do.
- This spike does not test React or TanStack, components, CSS-in-JS, theme logic or Tailwind plugins, because the export has none. Nor Tailwind v4.
- Not checked: the project's browser tests (they likely depend on the replaced classes), real devices, the export's states after clicking, and the Port's last state and hover and focus visuals. Contrast was computed from token values, not measured on screen.

Questions from #18:

| Question | Status |
|---|---|
| Which values come from source, the screenshot, or a substitute? | Answered for this export |
| Do Tailwind config and overridden scales resolve statically? | Answered for Tailwind v3 with an inline config |
| Do icon sources resolve? | Answered for Material Symbols by ligature name |
| Is an inline-script state readable? | Answered, without clicking to verify |
| Does a static read handle a component tree, theme logic, CSS-in-JS or plugins? | Open for Lovable |
| Is a screenshot required for a real Lovable export? | Open for Lovable |
| Port one Screen from a real Lovable export | Not done. #18 stays open |

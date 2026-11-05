<!-- Reusable direction block. Filled by the design-brief skill from Q1-Q3 and Q7 answers. -->
<!-- Substitute into the {{direction-block}} placeholder in scenario templates. -->
<!-- Scenario A has no current UI: write "New product: no current look to keep." under Change level and drop "Fix first" and "Keep". -->
<!-- Craft rules, Avoid and Before you finish are copied as they are, every line. Sources: taste-skill, stitch-design-taste, impeccable. -->

## Direction

- **Kind of UI**: <one of: "An app people use to get work done: favour clarity, precision and restraint over decoration" / "A marketing page that must persuade: one bold idea, one clear action" / "Docs or content to read: favour comfortable reading">
- **Change level**: <one of: "Keep the current look and tidy it up" / "A clear upgrade that current users still recognise" / "A brand-new look">
- **Fix first**: <the Screen and problem the Stakeholder ranked worst, then the next one or two, e.g. "Today: the Done button is too small to tap on a phone">
- **Keep**: <what must stay recognisable: logo, main colour, where things sit, or "nothing">
- **Feel like**: <each reference and what to borrow from it, e.g. "Things 3: calm, lots of white space, one task per line". Borrow the feel; do not copy its layout or branding.>

Commit to this one direction on every Screen. A design that tries to please every taste looks like every other AI design.

### Craft rules
The brand, the existing design tokens and the real copy listed in this prompt win over these rules.
- Type: body text at least 16px, lines of 45-75 characters, a few clearly different sizes and weights, at most two font families. Hierarchy comes from weight, size and colour together, not from size alone.
- Colour: give every colour a job (page background, text, secondary text, primary action, focus ring, border, success, warning, danger) and use the accent only for actions and the active state. Secondary text on a coloured surface is a tint of that surface, not plain grey. Never carry meaning by colour alone.
- Spacing: related things sit close together, groups are clearly apart, and a heading has more space above it than below it.
- Depth: show elevation with a border or with a shadow, never both. Corner radius between 4px and 16px, the same scale everywhere.
- Icons: one icon set with one stroke weight.
- New copy (only where this prompt gives none): a button says what it does ("Export report", not "Submit"). An error says what went wrong and how to fix it.
- States: design hover, focus, disabled, loading, empty and error for every control and list, with realistic content, not lorem ipsum.

### Avoid
These make a design look generic. Do not use them unless the brand or the existing design tokens in this prompt ask for them.
- Purple or blue gradient backgrounds, gradient text, glowing buttons, neon or coloured halos
- Glassmorphism or blur as decoration, heavy drop shadows, a thin border under a wide soft shadow
- Rows of same-size cards with an icon, a heading and a line of text; cards inside cards
- A rounded icon tile above every heading; small uppercase labels above headings; section numbers like 01 / 02 / 03
- A big number with a small label as the main visual, and decorative charts, sparklines or progress rings with no real data
- A centred headline over a gradient blob
- A thick coloured stripe on one side of a card or alert
- Emoji used as icons, or more than one icon style
- Inter, Roboto or the platform font as the only typeface
- Pure black (#000000) text or backgrounds
- Filler words such as "Elevate", "Seamless", "Unleash", "Next-gen"; invented numbers, testimonials or logos
- The same entrance animation on every section, or animations that loop forever without showing a state

### Before you finish
Check every Screen against the Craft rules and the Avoid list above, and fix anything that breaks them before you show the result.

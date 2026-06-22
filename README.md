# packcal-docs

Public documentation site for **PackCal** — a Garmin Connect IQ data field that
adds load-aware (pack / vest) calories to your existing Hike, Walk, or Ruck.

Static HTML, hosted on GitHub Pages at **https://meridian-apps.github.io/packcal-docs/**.
Sibling of [`rucktrack-docs`](../rucktrack-docs) under the same `meridian-apps`
org — the two sites deliberately share one design.

## Pages

| File | Status | Notes |
|---|---|---|
| `index.html` | ✅ | Landing — single-cell data-field story, screenshots, CTA |
| `privacy.html` | ✅ | **Garmin-required.** PackCal's actual storage (settings only) + 3 FIT fields |
| `support.html` | ✅ | Email, "it's a data field — how to add it", bug template, refunds |
| `faq.html` | ✅ | Data-field-first FAQ (how to add it, where stats appear, supported activities, vs RuckTrack) |
| `calorie-math.html` | ✅ | Pandolf math, adapted to PackCal (no 70 kg default, data-field FIT fields, no Manual treadmill) |
| `devices.html` | ✅ | PackCal's 50-device launch list, 7 families |
| `calculator.html` | ⬜ TODO | Optional; reuse ruck's |

Store UUID: `809c953d-9547-49d3-9949-c27ad3a5c218` →
`https://apps.garmin.com/apps/809c953d-9547-49d3-9949-c27ad3a5c218`
Contact: `garmin.lanam+packcal@gmail.com`

## Styling — how we keep it from drifting vs rucktrack-docs

`style.css` is a **structural copy** of `rucktrack-docs/style.css`. The ONLY
intended difference is brand color: PackCal violet (`--brand #6A3CDF`,
`--brand-glow #8A63FF`) vs RuckTrack green. Everything else — layout, typography,
components, the `.topnav`/`.hero`/`.feature-grid`/footer, media queries — must
stay identical so the two sites read as one family.

`scripts/check-style-parity.sh` enforces that: it strips comments + every color
literal + whitespace from both stylesheets and diffs them. It **passes** when
only colors differ and **fails** the moment a selector / property / layout value
diverges. Same idea as the pack↔ruck `diff-shared.sh` / numeric-tolerant
`check-contract.sh` guards. Run it before deploying either site:

```sh
scripts/check-style-parity.sh   # canonical structure = rucktrack-docs/style.css
```

Requires `rucktrack-docs` checked out beside this repo (`../rucktrack-docs`).

**Future hardening (post-launch):** hoist the shared structure to a single
`base.css` in the org root (`meridian-apps.github.io/base.css`) that BOTH sites
`<link>`, with a per-app `:root` theme block — eliminating the copy entirely.
Deferred because it requires re-linking the live rucktrack-docs pages.

## Assets

- `icon.png` — PackCal launcher icon (from the app's `resources-icons/size-70`).
- `assets/screenshots/` — store screenshots from `garmin/pack/screenshots/store/fr965-v1.0/`.
- `og-image.png` — ✅ 1200×630 social card (cover-cropped from `garmin/pack/images/store_hero.png` — the violet vest-walker scene with the watch inset). The `<meta og:image>` tags point at it.

## Deploy

1. Create the GitHub repo `meridian-apps/packcal-docs`, push this directory.
2. Settings → Pages → deploy from `main` / root. Site goes live at the URL above.
3. Put the **privacy URL** (`…/privacy.html`) and **support URL** (`…/support.html`)
   into the PackCal Connect IQ Store listing — this closes the open
   privacy/support/docs-URL item in `garmin/pack/docs/marketing/store-listing.md`.
4. (Optional) add a Google Search Console verification file + submit the sitemap,
   as rucktrack-docs did.
5. Update the org root `meridian-apps.github.io/index.html` — it currently
   auto-redirects to rucktrack-docs; make it a real two-app index linking both.

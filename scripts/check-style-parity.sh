#!/usr/bin/env bash
# check-style-parity.sh — fail if packcal-docs/style.css has drifted STRUCTURALLY
# from rucktrack-docs/style.css.
#
# The two Meridian docs sites deliberately share ONE layout / typography / set of
# components. The ONLY intended difference is brand COLOR (PackCal violet vs
# RuckTrack green). This guard normalizes away CSS comments + every color literal
# + whitespace, then diffs — so it passes when only colors differ and FAILS the
# moment a selector, property, layout value, or media query diverges.
#
# Same philosophy as the pack<->ruck guards (scripts/diff-shared.sh byte-identity,
# numeric-tolerant scripts/check-contract.sh). Run it before deploying either site,
# or in CI. Canonical source of structure = rucktrack-docs/style.css.
#
# Usage:  scripts/check-style-parity.sh
set -euo pipefail
HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
PACK="$HERE/style.css"
RUCK="$HERE/../rucktrack-docs/style.css"
[ -f "$PACK" ] || { echo "[parity] missing $PACK"; exit 2; }
[ -f "$RUCK" ] || { echo "[parity] rucktrack-docs/style.css not found at $RUCK (clone it beside packcal-docs)"; exit 2; }

norm() {
  # strip /* comments */, replace #hex and rgb()/rgba() with COLOR, one token/line
  perl -0777 -pe 's{/\*.*?\*/}{}gs' "$1" \
    | sed -E 's/#[0-9a-fA-F]{3,8}\b/COLOR/g; s/rgba?\([^)]*\)/COLOR/g' \
    | tr -s '[:space:]' '\n' | sed '/^$/d'
}

if diff <(norm "$PACK") <(norm "$RUCK") >/tmp/style-parity.diff 2>&1; then
  echo "[parity] OK — packcal/style.css matches rucktrack/style.css (brand colors aside)"
  exit 0
fi
echo "[parity] DRIFT — packcal-docs/style.css diverges from rucktrack-docs/style.css beyond color."
echo "         '<' = packcal-only, '>' = rucktrack-only (COLOR = any color literal, ignored):"
sed -n '1,40p' /tmp/style-parity.diff
echo "         Reconcile the structure (keep only brand colors different), then re-run."
exit 1

## Capture and compare

Run a one-step capture and comparison:

```bash
"<installed-skill-directory>/scripts/compare_simulator.sh" \
  --device "<booted-iPhone-name-or-UDID>" \
  --reference /absolute/path/reference.png \
  --output-dir /tmp/ui-reference-check \
  --channel-tolerance 8 \
  --minimum-pass-rate 0.99
```

The command writes:

- `simulator.png`: the unmodified live simulator capture;
- `reference-scoped.png` and `actual-scoped.png`: the compared regions;
- `difference.png`: amplified RGB differences, transparent where ignored;
- `threshold-overlay.png`: failed pixels tinted red and ignored pixels dimmed;
- `reference-feature-mask.png` and `actual-feature-mask.png` when feature
  colors are supplied, showing exactly which pixels formed the measurement;
- `comparison-report.json`: dimensions, scope, thresholds, metrics, and pass
  decision.

Use independent crops when the reference and simulator contain different
frames:

```bash
... --reference-crop x,y,width,height --actual-crop x,y,width,height
```

Exclude an irrelevant rectangle in comparison-canvas coordinates:

```bash
... --ignore x,y,width,height --ignore x,y,width,height
```

For non-rectangular scope, pass `--mask /absolute/path/mask.png`. The mask must
match the comparison dimensions. Opaque light pixels are compared; black or
transparent pixels are ignored.

Keep crops and masks as small and explainable as possible. The script requires
equal scoped dimensions by default. Use `--resize-actual` only when a known
device-density or reference-export difference requires normalization, and
report that resizing occurred; never resize to conceal layout geometry errors.

The comparator always reports RGB exact-pixel rate, selected
max-channel-tolerance pass rate, rates at common thresholds, mean absolute
error, root mean square error, and maximum channel delta. Feature mode adds
component geometry and silhouette evidence. A high aggregate score does not
excuse a wrong icon, missing control, or local alignment defect. Conversely, an
irrelevant background must not dominate a correctly scoped requirement.

### Measure a small icon or arrow

Use `feature-geometry` when a small, high-contrast silhouette is required and
aggregate RGB can hide it. Run this fixed sequence:

1. Crop one feature with stable padding on every side. Exclude same-colored
   text or neighboring icons; do not accept a mask whose bounds touch a crop
   edge.
   For a composite mark, measure every required sub-feature separately. A
   camera silhouette cannot prove that its inset arrow is correct because the
   larger camera fill can dominate both bounds and IoU. For a light cutout or
   inset, crop entirely inside the surrounding dark fill so exterior pixels of
   the same color cannot enter the mask.
2. Choose one interior RGB sample for the feature in each scoped image. Keep
   the color tolerance just wide enough to retain JPEG and antialiased edge
   pixels. Use `minimum-feature-pixels` to discard specks, not required detail.
3. Normalize a known capture-density difference with `--resize-actual` only
   after measuring a stable container such as the surrounding icon circle.
4. Gate both bound deltas and silhouette intersection-over-union (IoU) for each
   required sub-feature. Bounds catch size and placement; IoU catches a wrong
   cutout or arrow that shares the same outer box. Never accept a composite
   feature from only the outer or dominant-color mask.
   If the user said `exact` or `exactly`, use `--exact-feature-match`; an IoU of
   exactly 95% fails because the requested floor is strictly greater than 95%.
5. Inspect both feature masks and the scoped source images. If unrelated
   components survive, tighten the crop before changing color tolerance.

```bash
"<installed-skill-directory>/scripts/compare_simulator.sh" \
  --device "<booted-iPhone-name-or-UDID>" \
  --reference /absolute/path/reference.png \
  --output-dir /tmp/icon-check \
  --reference-crop 640,290,180,180 \
  --actual-crop 643,677,164,164 \
  --resize-actual \
  --acceptance feature-geometry \
  --reference-feature-color 91,98,106 \
  --actual-feature-color 91,98,106 \
  --feature-color-tolerance 28 \
  --minimum-feature-pixels 20 \
  --geometry-tolerance 2 \
  --minimum-feature-iou 0.80
```

`comparison-report.json` records each feature's bounds, retained component and
pixel counts, absolute x/y/width/height deltas, IoU, thresholds, and the chosen
acceptance mode. A feature-geometry pass does not turn a diagnostic RGB failure
into an RGB pass; report both signals.

`--exact-feature-match` overrides ordinary feature thresholds with zero bound
delta and IoU `> 0.95`, and records the strict operator in the JSON report. It
still requires both feature colors and a clean crop for each sub-feature.

### Check local color fields

Aggregate metrics can hide a wrong inset, shadow, or nested fill. When color is
part of the contract:

1. Sample the comparator's scoped outputs so reference and actual use the same
   color conversion. Record comparator-space coordinates and RGB values at a
   quiet center, near each relevant edge, and inside every nested treatment.
2. Scan at least one quiet row and column through the target. Classify the
   field as flat, banded, gradient, or nested; record visible transition runs
   and per-side insets. A field surrounding another on multiple sides is not a
   top highlight.
3. Recheck the same points after each implementation change. A missing or
   misplaced required field fails even when the aggregate score is high.

Include this concise color ledger in the final report.

### Geometry over intentionally different content

Do not treat RGB as the acceptance gate when the contract explicitly allows
the pixels beneath a required overlay to differ. A timestamp over two different
photos is the canonical case: masking the photo also masks the evidence around
the timestamp, while comparing it makes arbitrary media dominate the score.

In that case:

1. Keep the required overlay and container edges visible in the scoped
   simulator and reference images.
2. Record the relevant bounds or insets from the reference.
3. Add or run a focused geometry/property assertion for the runtime layout
   (for example a Flutter widget test with stable keys, or a browser test
   reading element bounds), or use a deterministic bounds calculation when the
   feature can be isolated from the captures.
4. Prove the assertion detects a small regression, then restore the intended
   value.
5. Run the RGB comparison as diagnostic evidence and report why its pass rate
   is non-gating. Do not describe the result as pixel-perfect.

Acceptance always requires visual inspection of the live target region. It
also requires the declared RGB threshold when RGB is the acceptance signal, or
the declared geometry/property tolerance when intentionally different content
makes RGB invalid for that requirement.

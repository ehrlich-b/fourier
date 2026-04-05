# Design: fourier.ehrlich.dev

## Concept

Upload an image (or draw freehand), decompose its outline into Fourier epicycles,
watch rotating circles trace the shape. Share your coefficients via URL -- recipients
reconstruct your drawing from just the math.

## Pipeline

### 1. Input

Three modes:
- **Image upload**: user provides a photo/drawing
- **Freehand draw**: draw directly on canvas
- **URL import**: decode coefficients from `#c=...` hash param (no image needed)

### 2. Edge Detection (image mode only)

Grayscale -> Gaussian blur -> Sobel gradients -> non-maximum suppression -> double
threshold -> hysteresis tracking. Standard Canny, implemented in JS on ImageData pixels.

Output: binary edge map (array of {x, y} edge pixels).

### 3. Path Ordering (the hard part)

Edge pixels are unordered. We need a single continuous closed path.

**Approach: greedy nearest-neighbor with improvements**

1. Start from an arbitrary edge pixel
2. Greedily walk to nearest unvisited neighbor
3. When stuck (no neighbor within threshold), jump to nearest unvisited pixel (marks a "jump")
4. After greedy pass, run 2-opt local search to reduce total path length
5. Optional: Christofides TSP approximation for better results (heavier compute)

The path quality directly affects how many Fourier terms you need -- a smoother, shorter
path compresses better in frequency domain. This is where iteration count matters.

### 4. Fourier Transform

Given ordered path points z(t) = x(t) + i*y(t) for t in [0, 1]:

**Fast path (FFT):** Resample to power-of-2 points, run FFT, extract coefficients.
O(n log n). Good enough for most cases.

**Optimization path (the killer feature):**

The FFT gives optimal L2 coefficients for ALL frequencies. But when truncating to N
circles, just taking top-N-by-amplitude isn't necessarily optimal for visual fidelity.

Iterative refinement loop:
1. Start with top-N FFT coefficients as initial guess
2. Render the approximation, compute error vs target path
3. Gradient descent on {amplitude, phase} for each coefficient
4. Optionally swap out low-contribution frequencies for untried ones
5. Repeat for K iterations (user-configurable)

This is a non-convex optimization but the FFT initialization puts us very close to
optimal. A few hundred iterations of L-BFGS or Adam on ~200 parameters is trivial.

Error metric: sum of minimum distances from each rendered point to nearest target point
(asymmetric Chamfer distance). This is perceptually better than L2 on matched points.

### 5. Rendering

**Epicycle animation:**
- Circles sorted by amplitude (largest first) for visual drama
- Each circle: center at tip of previous, radius = amplitude, rotates at freq * 2pi * t
- Final tip traces the reconstructed path
- Trail with configurable fade

**Controls:**
- Number of circles (slider, 1 to max)
- Animation speed
- Trail fade (slider, 0% = no fade full trail, 80% default = faded at 80% back from tip, 100% = instant vanish trace)
- Play / pause / reset
- Optimization iterations (slider, 0 = pure FFT, up to ~1000)
- Show/hide circles, show/hide trail
- Upload new image / draw mode toggle

**Three views (switchable or side-by-side on wide screens):**
- Epicycle view: the spinning circles
- Comparison view: original outline overlaid with reconstruction
- Spectrum view: bar chart of coefficient amplitudes by frequency

### 6. URL Sharing

Coefficients encode as: `#c=<compressed>`

**Encoding format:**
```
For each coefficient (sorted by amplitude descending):
  - freq: varint (zigzag encoded signed integer)
  - amplitude: float16 (half precision, 2 bytes)
  - phase: quantized to 0-65535 mapped to [0, 2pi), 2 bytes
Total: ~5 bytes per coefficient
```

200 coefficients = ~1000 bytes raw -> ~600 bytes after pako deflate -> ~800 chars base64url.
Well within URL length limits (2048 chars safe, 8000+ in modern browsers).

The URL contains ONLY the coefficients. No image data. Recipients see the epicycles
reconstruct the drawing live -- they never see the original image.

**Compact URL format:** `fourier.ehrlich.dev/#c=<base64url>`

For human-readable mode (small number of circles):
`fourier.ehrlich.dev/#h=f1:a1:p1,f2:a2:p2,...`
where f=freq, a=amplitude(2 decimal), p=phase(2 decimal)

### 7. Mobile

- Touch drawing support
- Pinch-to-zoom on epicycle view
- Responsive layout (stack views vertically on narrow screens)
- Larger touch targets for controls

## Performance Budget

- Edge detection: < 2s for 1080p image
- Path ordering: < 5s (greedy), < 30s (with 2-opt)
- FFT: < 100ms for 4096 points
- Optimization: ~10ms per iteration, so 1000 iter = 10s (show progress)
- Rendering: 60fps with up to 500 circles on Canvas 2D
- URL decode + render: < 500ms (instant feel for shared links)

## Prior Art & Inspirations

- **Jezzamon's fourier** (jezzamon.com/fourier): gold standard educational Fourier viz.
  Canvas + Webpack. Amplitude-sorted epicycles. Progressive disclosure pedagogy.
- **Coding Train** (Shiffman): naive DFT in p5.js, simple but clean. Most clones copy this.
- **jasonfyw/fourier-series**: React + TS, numerical integration (slow). Clean UI, poor perf.
- **ruanluyu/FourierCircleDrawing**: analytical Bezier integration -- clever but SVG-only.
- **FlowVix**: Svelte + Rust/WASM for DFT. Good idea for perf, overkill for our scale.
- **fourier.me**: ControlNet for edge detection, Christofides for path ordering, Manim render.
- **bionichaos FourierTra**: three-panel layout, audio synthesis, best UI of the bunch.

**What nobody does that we will:**
1. Iterative optimization beyond naive FFT truncation
2. URL-shareable coefficients (compact binary encoding)
3. Image upload with full edge-detect + path-order pipeline in-browser
4. Single file, zero dependencies, instant load

# TODO

## Phase 1: Core Engine
- [ ] Scaffold index.html (canvas, controls, dark theme matching pendulbrot)
- [ ] Implement DFT (naive O(n^2) first, FFT later if needed)
- [ ] Epicycle renderer (amplitude-sorted, configurable N circles)
- [ ] Freehand drawing input on canvas
- [ ] Basic animation loop (play/pause/speed control)
- [ ] Circle count slider with live update

## Phase 2: Image Pipeline
- [ ] Image upload (drag-drop + file picker)
- [ ] Grayscale + Gaussian blur
- [ ] Canny edge detection (Sobel, NMS, hysteresis)
- [ ] Path ordering: greedy nearest-neighbor
- [ ] Path ordering: 2-opt local improvement
- [ ] Point resampling (uniform arc-length, power-of-2 count)

## Phase 3: Optimization Loop
- [ ] Chamfer distance error metric
- [ ] Gradient descent on coefficient amplitudes + phases
- [ ] Frequency swapping (try alternative freqs for low-contributors)
- [ ] Iteration count slider with live progress
- [ ] Comparison overlay (original vs reconstructed)

## Phase 4: Sharing
- [ ] Coefficient encoding (varint freq, float16 amp, uint16 phase)
- [ ] Pako compression + base64url
- [ ] URL hash encode/decode
- [ ] Human-readable URL mode for small circle counts
- [ ] "Copy link" button
- [ ] Auto-detect and render from URL on page load

## Phase 5: Polish
- [ ] Spectrum view (amplitude bar chart)
- [ ] Trail fade effect
- [ ] Mobile touch support (drawing, pinch zoom)
- [ ] Retina/DPR canvas scaling
- [ ] Loading states and progress indicators
- [ ] Preset gallery (a few built-in shapes)
- [ ] deploy.sh script

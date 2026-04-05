# TODO

## Phase 1: Core Engine [DONE]
- [x] Scaffold index.html (canvas, controls, dark theme matching pendulbrot)
- [x] Implement DFT (naive O(n^2))
- [x] Epicycle renderer (amplitude-sorted, configurable N circles)
- [x] Freehand drawing input on canvas
- [x] Basic animation loop (play/pause/speed control)
- [x] Circle count slider with live update
- [x] Trail fade slider (16-bucket alpha batching)
- [x] Retina/DPR canvas scaling

## Phase 2: Image Pipeline [DONE]
- [x] Image upload (file picker)
- [x] Drag-drop image upload
- [x] Grayscale + Gaussian blur
- [x] Canny edge detection (Sobel, NMS, hysteresis)
- [x] Path ordering: greedy nearest-neighbor
- [x] Path ordering: 2-opt local improvement
- [x] Point resampling (uniform arc-length, closed path)

## Phase 3: Optimization Loop [DONE]
- [x] Chamfer distance error metric
- [x] Gradient descent on coefficient amplitudes + phases
- [x] Frequency swapping (try alternative freqs for low-contributors)
- [x] Iteration count slider with live progress
- [x] Comparison overlay (original vs reconstructed)

## Phase 4: Sharing [DONE]
- [x] Coefficient encoding (varint freq, float16 amp, uint16 phase)
- [x] Pako compression + base64url
- [x] Human-readable URL mode for small circle counts
- [x] Human-readable URL encode (generate shareable URL)
- [x] "Copy link" button
- [x] Auto-detect and render from URL on page load

## Phase 5: Polish [DONE]
- [x] Spectrum view (amplitude bar chart)
- [x] Mobile touch support (drawing, pinch/scroll zoom)
- [x] Loading states and progress indicators
- [x] Preset gallery (square, star, heart, infinity)
- [x] deploy.sh script

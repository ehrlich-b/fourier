# fourier.ehrlich.dev

Single-file vanilla JS website (like pendulbrot). No framework, no build step, no dependencies.
Deployed via scp to nginx on DigitalOcean.

## Stack

- Single `index.html` with inline CSS and JS
- Canvas 2D for epicycle rendering
- Pako (inline/CDN) for URL compression
- No npm, no bundler, no node_modules

## Architecture

Image upload -> edge detection (Canny in JS) -> path ordering (TSP approximation) -> DFT -> optional iterative optimization -> epicycle animation.

Coefficients are shareable via URL hash: `#c=<pako-compressed-base64url>`.

## Conventions

- Dark background, monospace font, controls top-left (match pendulbrot style)
- Mobile-aware (touch, responsive canvas sizing)
- requestAnimationFrame for animation, no setInterval
- Device pixel ratio scaling for retina

## Deploy

```bash
bash deploy.sh
```

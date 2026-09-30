# soz6 /lab/kamera — notes for later (2026-09-30)

Status: **nothing built yet.** Only investigation done. No code written.

## Where the page actually lives
- `soz6.com/lab/kamera` is NOT a file in git. Lab pages are HTML stored in the
  production DB table `lab_pages` (slug = `kamera`), served by `laboratoriya.php?p=kamera`
  via nginx regex `^/lab/([a-z0-9-]+)$` (`deploy/nginx/routes.conf` in `jhanKarimov/soz6`).
- Edit path today: paste HTML into the lab editor on `/laboratoriya` (owner only)
  or update the row with SQL on the server (`ssh soz6`).
- Folder apps (`/lab/<dir>/index.php`) also exist (e.g. `lab/kino`, `lab/dj`), but
  `/lab/kamera` (no trailing slash) would still hit the DB row unless nginx gets an
  exact `location = /lab/kamera { ... }` rule. CLAUDE.md says: no nginx changes without a plan.

## Access limits seen this session
- Cloud Claude session: no `ssh` client, no keys/config, soz6.com blocked by the proxy.
  Could not read the current kamera HTML or the DB.
- To work on the live server: run Claude Code on the laptop/server itself (`ssh soz6` works there),
  then first pull the current row: `SELECT html FROM lab_pages WHERE slug='kamera'` and improve it.
- Related repos on the account (not opened): `jhan-hub`, `jhan-hub-android` (the phone app with a camera).

## Requested features (from Jhan)
- Capture button always visible on mobile (use `100dvh`, fixed bottom dock, safe-area padding).
- Take many shots; show all in a tray below; save all or each individually (+ ZIP).
  Persist shots (IndexedDB) so they can be saved later.
- Mobile-friendly layout.
- Mirror, for both front and back camera (preview and/or saved file).
- Video recording.
- More effects, ratio choices, zoom, wide/narrow (ultra-wide/tele) lens switching.
- Hide-face effects for video: ASCII, Matrix-style rain, plus others; an "amount"
  slider so the image can be half-hidden ("not too hidden").

## Build plan (single self-contained HTML file)
- Pipeline: `getUserMedia` -> crop/zoom/mirror on 2D canvas -> effect (WebGL shader or 2D text) -> visible canvas.
  Photo = `canvas.toBlob`; video = `MediaRecorder` on `canvas.captureStream`.
- Note: `ctx.filter` is unsupported on iOS Safari, so use WebGL shaders for colour effects.
- Zoom: hardware via `track.applyConstraints({advanced:[{zoom}]})` when supported (Android Chrome),
  else digital crop + pinch. Lenses via `enumerateDevices` labels (iOS shows Ultra Wide/Telephoto).
- Ratios: Full, 9:16, 3:4, 4:5, 1:1, 5:4, 4:3, 16:9, 2:1.
- Modes: Photo, Video, Burst (8 shots), Booth (2x2 strip); timer 3/5/10s; grid overlays; torch if supported.
- Effects — Filters: vivid, noir, vintage, film, matte, cinema, cyber, night vision, thermal, invert, posterize, comic, dream.
  Fun: pixel, RGB split, glitch, VHS, kaleidoscope, mirror, quad, bulge, swirl, liquid, halftone, neon edges, sketch, emboss, ghost trails.
  Hide: mosaic, frost blur, ASCII, colour ASCII, Matrix rain, Braille, binary, LED dots, moon-phase emoji.
- Test plan: Playwright + Chromium fake camera
  (`--use-fake-device-for-media-stream --use-fake-ui-for-media-stream`), playwright 1.56 is at `/opt/node-tools`.

## Ideas to add after v1
- Tap-to-focus / exposure slider, histogram, focus peaking (photographer tools).
- Face-tracking blur or background replace (MediaPipe selfie segmentation).
- Intervalometer / time-lapse, stop-motion, GIF/boomerang.
- Live effect thumbnails, LUT (.cube) import for film looks.
- Voice changer when recording with face hidden.
- QR/text scanner (BarcodeDetector).
- Share straight into Jhan Hub.

## Branches
- This repo: `claude/kamera-improvements-h36nak` (notes only).
- `jhanKarimov/soz6` was cloned read-only into the session for research; nothing pushed there.

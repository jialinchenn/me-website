#!/bin/sh
# Regenerates photography/manifest.json (filename + pixel dimensions)
# from the images in photography/. Run after adding/removing photos.
cd "$(dirname "$0")/photography" || exit 1
python3 - <<'EOF'
import json, os, subprocess
exts = ('.jpg', '.jpeg', '.png', '.gif', '.webp')
photos = []
for f in sorted(f for f in os.listdir('.') if f.lower().endswith(exts)):
    out = subprocess.run(['sips', '-g', 'pixelWidth', '-g', 'pixelHeight', f],
                         capture_output=True, text=True).stdout
    dims = {k.strip(): int(v) for k, v in
            (line.split(':') for line in out.splitlines() if ':' in line and 'pixel' in line)}
    photos.append({'n': f, 'w': dims['pixelWidth'], 'h': dims['pixelHeight']})
json.dump(photos, open('manifest.json', 'w'), indent=1)
print(f"manifest.json updated: {len(photos)} photos")
EOF

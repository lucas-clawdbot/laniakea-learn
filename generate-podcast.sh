#!/bin/bash
set -e

SCRIPT="/Users/clawdbot/projects/laniakea-learn/podcast-script.txt"
OUTPUT_DIR="/Users/clawdbot/projects/laniakea-learn/chunks"
FINAL="/Users/clawdbot/projects/laniakea-learn/laniakea-podcast.mp3"

mkdir -p "$OUTPUT_DIR"
rm -f "$OUTPUT_DIR"/*.mp3

# Split script into ~3800 char chunks at sentence boundaries
python3 << 'PYEOF'
import os

script_path = "/Users/clawdbot/projects/laniakea-learn/podcast-script.txt"
output_dir = "/Users/clawdbot/projects/laniakea-learn/chunks"

with open(script_path) as f:
    text = f.read()

# Split at sentence boundaries, keeping chunks under 4000 chars
chunks = []
current = ""
sentences = text.replace('\n', ' ').split('. ')

for i, sentence in enumerate(sentences):
    addition = sentence + ('. ' if i < len(sentences) - 1 else '')
    if len(current) + len(addition) > 3800 and current:
        chunks.append(current.strip())
        current = addition
    else:
        current += addition

if current.strip():
    chunks.append(current.strip())

for i, chunk in enumerate(chunks):
    path = os.path.join(output_dir, f"chunk_{i:03d}.txt")
    with open(path, 'w') as f:
        f.write(chunk)
    print(f"Chunk {i}: {len(chunk)} chars")

print(f"\nTotal chunks: {len(chunks)}")
PYEOF

# Generate TTS for each chunk
CHUNK_FILES=$(ls "$OUTPUT_DIR"/chunk_*.txt | sort)
i=0
for chunk_file in $CHUNK_FILES; do
    out_file="$OUTPUT_DIR/audio_$(printf '%03d' $i).mp3"
    echo "Generating audio for chunk $i..."
    
    CHUNK_TEXT=$(cat "$chunk_file")
    
    JSON_PAYLOAD=$(python3 -c "import json; print(json.dumps({'model': 'tts-1-hd', 'input': open('$chunk_file').read(), 'voice': 'onyx', 'response_format': 'mp3'}))")
    curl -s "https://api.openai.com/v1/audio/speech" \
        -H "Authorization: Bearer $OPENAI_API_KEY" \
        -H "Content-Type: application/json" \
        -d "$JSON_PAYLOAD" \
        --output "$out_file"
    
    echo "  -> $out_file ($(wc -c < "$out_file") bytes)"
    i=$((i + 1))
done

# Concatenate all audio chunks
echo "Concatenating chunks..."
# Create file list for ffmpeg
FILELIST="$OUTPUT_DIR/filelist.txt"
rm -f "$FILELIST"
for f in "$OUTPUT_DIR"/audio_*.mp3; do
    echo "file '$f'" >> "$FILELIST"
done

ffmpeg -y -f concat -safe 0 -i "$FILELIST" -c copy "$FINAL" 2>/dev/null

echo ""
echo "Done! Final podcast: $FINAL"
echo "Size: $(du -h "$FINAL" | cut -f1)"
echo "Duration: $(ffprobe -i "$FINAL" -show_entries format=duration -v quiet -of csv="p=0" 2>/dev/null | python3 -c "import sys; d=float(sys.stdin.read()); print(f'{int(d//60)}m {int(d%60)}s')")"

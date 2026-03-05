#!/usr/bin/env python3
import os, json, subprocess, tempfile

SCRIPT = "/Users/clawdbot/projects/laniakea-learn/podcast-script.txt"
CHUNKS_DIR = "/Users/clawdbot/projects/laniakea-learn/chunks"
FINAL = "/Users/clawdbot/projects/laniakea-learn/laniakea-podcast.mp3"
API_KEY = os.environ["OPENAI_API_KEY"]

os.makedirs(CHUNKS_DIR, exist_ok=True)

# Read and chunk
with open(SCRIPT) as f:
    text = f.read()

chunks = []
current = ""
for i, sentence in enumerate(text.replace('\n', ' ').split('. ')):
    addition = sentence + '. '
    if len(current) + len(addition) > 3800 and current:
        chunks.append(current.strip())
        current = addition
    else:
        current += addition
if current.strip():
    chunks.append(current.strip())

print(f"Split into {len(chunks)} chunks")
for i, c in enumerate(chunks):
    print(f"  Chunk {i}: {len(c)} chars")

# Generate TTS for each chunk
import urllib.request
audio_files = []
for i, chunk in enumerate(chunks):
    out_path = os.path.join(CHUNKS_DIR, f"audio_{i:03d}.mp3")
    print(f"Generating chunk {i}...")
    
    payload = json.dumps({
        "model": "tts-1-hd",
        "input": chunk,
        "voice": "onyx",
        "response_format": "mp3"
    }).encode()
    
    req = urllib.request.Request(
        "https://api.openai.com/v1/audio/speech",
        data=payload,
        headers={
            "Authorization": f"Bearer {API_KEY}",
            "Content-Type": "application/json"
        }
    )
    
    with urllib.request.urlopen(req) as resp:
        with open(out_path, "wb") as f:
            f.write(resp.read())
    
    size = os.path.getsize(out_path)
    print(f"  -> {size} bytes")
    audio_files.append(out_path)

# Concatenate with ffmpeg
filelist = os.path.join(CHUNKS_DIR, "filelist.txt")
with open(filelist, "w") as f:
    for af in audio_files:
        f.write(f"file '{af}'\n")

subprocess.run(["ffmpeg", "-y", "-f", "concat", "-safe", "0", "-i", filelist, "-c", "copy", FINAL],
               capture_output=True)

# Report
size_mb = os.path.getsize(FINAL) / (1024*1024)
result = subprocess.run(["ffprobe", "-i", FINAL, "-show_entries", "format=duration", "-v", "quiet", "-of", "csv=p=0"],
                       capture_output=True, text=True)
duration = float(result.stdout.strip())
print(f"\nDone! {FINAL}")
print(f"Size: {size_mb:.1f} MB")
print(f"Duration: {int(duration//60)}m {int(duration%60)}s")

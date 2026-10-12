#!/usr/bin/env python3
"""Builds the short azan clip from the full recording.

Usage: python3 tool/make_short_azan.py FULL.mp3 [CUT_SECONDS]

Decodes FULL.mp3 (macOS `afconvert`), keeps the start up to CUT_SECONDS (default
27.4, inside the natural pause after the opening takbir) and applies a 0.6 s
fade-out. Writes mono 22.05 kHz 16-bit WAV to
android/app/src/main/res/raw/azan_short.wav and a CAF copy for iOS.
iOS notification sounds must be 30 seconds or shorter, which is why this exists.

The result is an adaptation of a CC BY-SA 4.0 work; see AZAN_AUDIO_LICENSE.md.
"""
import array
import subprocess
import sys
import tempfile
import wave
from pathlib import Path

ROOT = Path(__file__).resolve().parent.parent
RAW = ROOT / "android/app/src/main/res/raw"
IOS = ROOT / "ios/Runner/Sounds"
FADE_SECONDS = 0.6


def main():
    if len(sys.argv) < 2:
        sys.exit(__doc__)
    src = Path(sys.argv[1])
    cut = float(sys.argv[2]) if len(sys.argv) > 2 else 27.4
    with tempfile.TemporaryDirectory() as tmp:
        decoded = Path(tmp) / "decoded.wav"
        subprocess.run(
            ["afconvert", "-f", "WAVE", "-d", "LEI16@22050", "-c", "1", str(src), str(decoded)],
            check=True,
        )
        with wave.open(str(decoded)) as w:
            rate = w.getframerate()
            samples = array.array("h")
            samples.frombytes(w.readframes(w.getnframes()))
    keep = samples[: int(cut * rate)]
    fade = int(FADE_SECONDS * rate)
    for i in range(fade):
        keep[len(keep) - fade + i] = int(keep[len(keep) - fade + i] * (1 - i / fade))
    RAW.mkdir(parents=True, exist_ok=True)
    IOS.mkdir(parents=True, exist_ok=True)
    out = RAW / "azan_short.wav"
    with wave.open(str(out), "wb") as w:
        w.setnchannels(1)
        w.setsampwidth(2)
        w.setframerate(rate)
        w.writeframes(keep.tobytes())
    subprocess.run(
        ["afconvert", "-f", "caff", "-d", "LEI16", str(out), str(IOS / "azan_short.caf")],
        check=True,
    )
    print(f"wrote {out} ({len(keep) / rate:.1f} s) and azan_short.caf")


main()

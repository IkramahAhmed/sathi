#!/usr/bin/env python3
"""Generates the plain three-beep notification tone (azan_beep.wav).

The real azan sounds (azan_full, azan_short) are recordings, not generated;
see README.md > "Azan sounds" and tool/make_short_azan.py.
Usage: python3 tool/generate_beep.py
"""
import math
import struct
import wave
from pathlib import Path

RATE = 22050
OUT = Path(__file__).resolve().parent.parent / "android/app/src/main/res/raw"


def tone(freq, seconds, volume=0.5, overtones=(1.0,)):
    n = int(RATE * seconds)
    samples = []
    for i in range(n):
        t = i / RATE
        attack = min(1.0, i / (RATE * 0.01))
        decay = math.exp(-3.0 * t / seconds)
        value = sum(
            amp * math.sin(2 * math.pi * freq * (k + 1) * t)
            for k, amp in enumerate(overtones)
        )
        samples.append(volume * attack * decay * value / sum(overtones))
    return samples


def silence(seconds):
    return [0.0] * int(RATE * seconds)


def write(name, samples):
    path = OUT / f"{name}.wav"
    with wave.open(str(path), "wb") as w:
        w.setnchannels(1)
        w.setsampwidth(2)
        w.setframerate(RATE)
        w.writeframes(
            b"".join(struct.pack("<h", int(max(-1, min(1, s)) * 32767)) for s in samples)
        )
    print("wrote", path, f"{path.stat().st_size // 1024} KB")


def main():
    OUT.mkdir(parents=True, exist_ok=True)
    # Simple triple beep.
    beep = []
    for _ in range(3):
        beep += tone(880, 0.35) + silence(0.2)
    write("azan_beep", beep)


if __name__ == "__main__":
    main()

#!/usr/bin/env python3
"""Frames raw phone screenshots for the Play listing.

Reads store/screenshots/raw/*.png (taken with `adb exec-out screencap -p`) and writes
1080x1920 images (9:16, which Play accepts) to store/screenshots/. Needs Pillow.
"""
import importlib.util
from pathlib import Path

from PIL import Image, ImageDraw, ImageFilter, ImageFont

ROOT = Path(__file__).resolve().parent.parent
OUT = ROOT / "store" / "screenshots"
RAW = OUT / "raw"

spec = importlib.util.spec_from_file_location("make_feature_graphic", ROOT / "tool" / "make_feature_graphic.py")
fg = importlib.util.module_from_spec(spec)
spec.loader.exec_module(fg)

W, H = 1080, 1920
GREEN, CREAM, GOLD = (15, 81, 50), (246, 235, 208), (255, 217, 122)

# file, caption lines
SHOTS = [
    ("home", ["Accurate azan", "for every prayer"]),
    ("tracker", ["Track your prayers", "and streaks"]),
    ("qaza", ["Keep count of", "missed prayers"]),
    ("settings", ["Jama'at times and", "prayer-ending reminders"]),
    ("timetable", ["A full month", "of prayer times"]),
    ("qibla", ["Find the Qibla", "anywhere"]),
]


def background():
    base = Image.new("RGB", (W, H), GREEN)
    glow = Image.new("RGB", (W, H), (0, 0, 0))
    ImageDraw.Draw(glow).ellipse([200, -300, 1300, 700], fill=(24, 112, 70))
    glow = glow.filter(ImageFilter.GaussianBlur(160))
    return Image.blend(base, Image.composite(glow, base, glow.convert("L").point(lambda v: min(255, v * 2))), 0.9)


def rounded(img, radius):
    mask = Image.new("L", img.size, 0)
    ImageDraw.Draw(mask).rounded_rectangle([0, 0, img.width - 1, img.height - 1], radius=radius, fill=255)
    out = img.convert("RGBA")
    out.putalpha(mask)
    return out


def main():
    title = fg.font(76, bold=True)
    for index, (name, lines) in enumerate(SHOTS, start=1):
        shot = Image.open(RAW / f"{name}.png").convert("RGB")
        # Drop the black Android navigation bar at the bottom.
        shot = shot.crop((0, 0, shot.width, shot.height - 82))
        width = 720
        height = round(shot.height * width / shot.width)
        shot = rounded(shot.resize((width, height), Image.LANCZOS), 56)

        canvas = background().convert("RGBA")
        d = ImageDraw.Draw(canvas)
        y = 64
        for line in lines:
            box = d.textbbox((0, 0), line, font=title)
            d.text(((W - (box[2] - box[0])) / 2, y), line, font=title, fill=CREAM)
            y += 96

        x = (W - width) // 2
        top = H - height - 28
        # Soft border so the phone stands out from the green.
        d.rounded_rectangle([x - 6, top - 6, x + width + 6, top + height + 6], radius=62, fill=CREAM)
        canvas.alpha_composite(shot, (x, top))
        canvas.convert("RGB").save(OUT / f"{index:02d}-{name}.png", optimize=True)
        print("wrote", f"{index:02d}-{name}.png", "image", shot.size)


if __name__ == "__main__":
    main()

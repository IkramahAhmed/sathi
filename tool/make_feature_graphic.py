#!/usr/bin/env python3
"""Draws the Play Store feature graphic (1024x500) to store/feature-graphic.png.

Reuses the mosque drawing from make_icon.py. Needs Pillow and a system font.
"""
import importlib.util
from pathlib import Path

from PIL import Image, ImageDraw, ImageFont

ROOT = Path(__file__).resolve().parent.parent
spec = importlib.util.spec_from_file_location("make_icon", ROOT / "tool" / "make_icon.py")
icons = importlib.util.module_from_spec(spec)
spec.loader.exec_module(icons)

W, H = 1024, 500
FONTS = [
    "/System/Library/Fonts/Avenir Next.ttc",
    "/System/Library/Fonts/Helvetica.ttc",
    "/System/Library/Fonts/Supplemental/Arial.ttf",
]


def font(size, bold=False):
    for path in FONTS:
        if Path(path).exists():
            try:
                f = ImageFont.truetype(path, size)
                if bold:
                    try:
                        f.set_variation_by_name("Bold")
                    except Exception:
                        pass
                return f
            except OSError:
                continue
    return ImageFont.load_default()


def main():
    # Background: green with a soft lighter glow behind the mosque.
    bg = Image.new("RGB", (W, H), icons.GREEN[:3])
    glow = Image.new("RGB", (W, H), (0, 0, 0))
    gd = ImageDraw.Draw(glow)
    gd.ellipse([560, -40, 1120, 520], fill=(22, 108, 68))
    from PIL import ImageFilter
    glow = glow.filter(ImageFilter.GaussianBlur(90))
    bg = Image.blend(bg, Image.composite(glow, bg, glow.convert("L").point(lambda v: min(255, v * 2))), 0.9)
    img = bg.convert("RGBA")

    # Mosque on the right.
    art_size = 520
    mosque = icons.art(art_size, 0.98)
    img.alpha_composite(mosque, (W - art_size - 30, H - art_size + 40))

    d = ImageDraw.Draw(img)
    cream, gold = icons.CREAM, icons.GOLD
    d.text((70, 120), "Saathi", font=font(120, bold=True), fill=cream)
    d.text((74, 268), "Azan and prayer times", font=font(36), fill=cream)
    d.text((74, 318), "Works offline. No ads.", font=font(36), fill=gold)

    # A few quiet stars.
    for x, y, r in [(470, 60, 3), (560, 120, 2), (900, 70, 3), (640, 40, 2), (980, 160, 2)]:
        d.ellipse([x - r, y - r, x + r, y + r], fill=gold)

    out = ROOT / "store" / "feature-graphic.png"
    img.convert("RGB").save(out, optimize=True)
    print("wrote", out, img.size)


if __name__ == "__main__":
    main()

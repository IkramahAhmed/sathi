#!/usr/bin/env python3
"""Draws the Saathi app icon and writes every size the app needs.

A mosque with a gold crescent on deep green. Run `python3 tool/make_icon.py`
(needs Pillow). It writes:
  - Android adaptive icon (foreground, monochrome, background colour) and the
    legacy square/round launcher PNGs;
  - the iOS AppIcon set;
  - assets/icon/icon.png (1024) and store/play-icon-512.png for the Play listing.
"""
import json
from pathlib import Path

from PIL import Image, ImageDraw

ROOT = Path(__file__).resolve().parent.parent
RES = ROOT / "android/app/src/main/res"
IOS = ROOT / "ios/Runner/Assets.xcassets/AppIcon.appiconset"

GREEN = (15, 81, 50, 255)
GREEN_DARK = (9, 56, 34, 255)
CREAM = (246, 235, 208, 255)
GOLD = (255, 217, 122, 255)
SS = 4  # supersampling


def art(size, fill_fraction, mono=False):
    """The mosque and crescent on a transparent canvas of [size] px.

    The art is drawn in a 1000x1000 box scaled to [fill_fraction] of the canvas
    and centred. [mono] draws a single colour with the door cut out, for
    Android's themed icons.
    """
    big = size * SS
    img = Image.new("RGBA", (big, big), (0, 0, 0, 0))
    d = ImageDraw.Draw(img)
    box = big * fill_fraction
    ox = (big - box) / 2
    oy = (big - box) / 2 + box * 0.02
    k = box / 1000.0

    def P(x, y):
        return (ox + x * k, oy + y * k)

    def rect(x0, y0, x1, y1, c):
        d.rectangle([*P(x0, y0), *P(x1, y1)], fill=c)

    def ell(x0, y0, x1, y1, c):
        d.ellipse([*P(x0, y0), *P(x1, y1)], fill=c)

    body = (0, 0, 0, 255) if mono else CREAM
    gold = body if mono else GOLD

    # Crescent: a gold disc with a smaller disc taken out.
    cres = Image.new("L", (big, big), 0)
    cd = ImageDraw.Draw(cres)
    cd.ellipse([*P(380, 60), *P(620, 300)], fill=255)
    cd.ellipse([*P(440, 30), *P(640, 250)], fill=0)
    img.paste(Image.new("RGBA", (big, big), gold), (0, 0), cres)
    d = ImageDraw.Draw(img)

    # Finial.
    rect(494, 290, 506, 440, gold)

    # Main dome on its drum.
    d.pieslice([*P(310, 430), *P(690, 810)], 180, 360, fill=body)
    rect(330, 620, 670, 780, body)

    # Minarets: shaft, balcony and a pointed cap.
    for cx in (225, 775):
        rect(cx - 35, 470, cx + 35, 780, body)
        rect(cx - 55, 520, cx + 55, 540, body)
        d.polygon([P(cx - 45, 470), P(cx + 45, 470), P(cx, 340)], fill=body)
        rect(cx - 3, 300, cx + 3, 345, gold)

    # Plinth.
    rect(110, 780, 890, 830, body)

    # Door: an arched opening. Cut out for the monochrome icon.
    door = (0, 0, 0, 0) if mono else GREEN_DARK
    door_layer = Image.new("RGBA", (big, big), (0, 0, 0, 0))
    dd = ImageDraw.Draw(door_layer)
    dd.rectangle([*P(458, 690), *P(542, 780)], fill=(255, 255, 255, 255))
    dd.ellipse([*P(458, 650), *P(542, 730)], fill=(255, 255, 255, 255))
    if mono:
        a = img.split()[3]
        mask = door_layer.split()[3]
        a = Image.composite(Image.new("L", (big, big), 0), a, mask)
        img.putalpha(a)
    else:
        img.paste(Image.new("RGBA", (big, big), door), (0, 0), door_layer.split()[3])

    return img.resize((size, size), Image.LANCZOS)


def full_icon(size, shape):
    """The finished icon: green background plus art. shape is square|round|ios."""
    bg = Image.new("RGBA", (size, size), GREEN)
    a = art(size, 0.74 if shape != "ios" else 0.78)
    bg.alpha_composite(a)
    if shape == "round":
        m = Image.new("L", (size * SS, size * SS), 0)
        ImageDraw.Draw(m).ellipse([0, 0, size * SS - 1, size * SS - 1], fill=255)
        bg.putalpha(m.resize((size, size), Image.LANCZOS))
    elif shape == "square":
        r = int(size * 0.18)
        m = Image.new("L", (size * SS, size * SS), 0)
        ImageDraw.Draw(m).rounded_rectangle([0, 0, size * SS - 1, size * SS - 1], radius=r * SS, fill=255)
        bg.putalpha(m.resize((size, size), Image.LANCZOS))
    return bg


def save(img, path):
    path.parent.mkdir(parents=True, exist_ok=True)
    img.save(path, optimize=True)


def main():
    # Android adaptive: 108dp canvas, the art stays inside the 66dp safe zone (61%).
    densities = {"mdpi": 1, "hdpi": 1.5, "xhdpi": 2, "xxhdpi": 3, "xxxhdpi": 4}
    for name, scale in densities.items():
        px = int(108 * scale)
        save(art(px, 0.60), RES / f"drawable-{name}" / "ic_launcher_foreground.png")
        save(art(px, 0.60, mono=True), RES / f"drawable-{name}" / "ic_launcher_monochrome.png")
        legacy = int(48 * scale)
        save(full_icon(legacy, "square"), RES / f"mipmap-{name}" / "ic_launcher.png")
        save(full_icon(legacy, "round"), RES / f"mipmap-{name}" / "ic_launcher_round.png")

    (RES / "mipmap-anydpi-v26").mkdir(parents=True, exist_ok=True)
    adaptive = """<?xml version="1.0" encoding="utf-8"?>
<adaptive-icon xmlns:android="http://schemas.android.com/apk/res/android">
    <background android:drawable="@color/ic_launcher_background" />
    <foreground android:drawable="@drawable/ic_launcher_foreground" />
    <monochrome android:drawable="@drawable/ic_launcher_monochrome" />
</adaptive-icon>
"""
    (RES / "mipmap-anydpi-v26" / "ic_launcher.xml").write_text(adaptive)
    (RES / "mipmap-anydpi-v26" / "ic_launcher_round.xml").write_text(adaptive)
    (RES / "values" / "ic_launcher_background.xml").write_text(
        '<?xml version="1.0" encoding="utf-8"?>\n<resources>\n    <color name="ic_launcher_background">#0F5132</color>\n</resources>\n'
    )

    # iOS: no transparency allowed, so a plain square (the system rounds it).
    contents = json.loads((IOS / "Contents.json").read_text())
    for item in contents["images"]:
        base = float(item["size"].split("x")[0])
        scale = int(item["scale"].rstrip("x"))
        px = int(round(base * scale))
        icon = full_icon(px, "ios").convert("RGB")
        save(icon, IOS / item["filename"])

    master = full_icon(1024, "ios").convert("RGB")
    save(master, ROOT / "assets/icon/icon.png")
    save(full_icon(512, "ios").convert("RGB"), ROOT / "store/play-icon-512.png")
    print("icons written")


if __name__ == "__main__":
    main()

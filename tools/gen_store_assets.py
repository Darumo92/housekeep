"""Generate store assets for HouseKeep.

Outputs:
  store/icon_1024.png           — App Store / Play store master icon (1024x1024)
  store/feature_graphic_1024x500.png — Google Play feature graphic

Run: python3 tools/gen_store_assets.py
"""
from __future__ import annotations

import sys
from pathlib import Path

from PIL import Image, ImageDraw, ImageFilter, ImageFont

ROOT = Path(__file__).resolve().parent.parent
SRC_ICON = ROOT / "assets" / "branding" / "app_icon.png"
OUT_DIR = ROOT / "store"
FONT_BOLD = "/usr/share/fonts/TTF/DejaVuSans-Bold.ttf"
FONT_REG = "/usr/share/fonts/TTF/DejaVuSans.ttf"

PRIMARY = (46, 125, 111)
PRIMARY_LIGHT = (91, 163, 150)
CREAM = (250, 250, 248)
CREAM_DARK = (235, 232, 222)
TEXT_PRIMARY = (26, 26, 26)


def make_icon_master() -> Path:
    out = OUT_DIR / "icon_1024.png"
    img = Image.open(SRC_ICON).convert("RGBA")
    if img.size != (1024, 1024):
        img = img.resize((1024, 1024), Image.LANCZOS)
    bg = Image.new("RGB", (1024, 1024), CREAM)
    bg.paste(img, (0, 0), img)
    bg.save(out, "PNG", optimize=True)
    return out


def linear_gradient(size: tuple[int, int], c1: tuple[int, int, int], c2: tuple[int, int, int]) -> Image.Image:
    w, h = size
    base = Image.new("RGB", size, c1)
    top = Image.new("RGB", size, c2)
    mask = Image.new("L", size)
    px = mask.load()
    for y in range(h):
        for x in range(w):
            t = (x + y) / (w + h)
            px[x, y] = int(255 * t)
    base.paste(top, (0, 0), mask)
    return base


def make_feature_graphic() -> Path:
    out = OUT_DIR / "feature_graphic_1024x500.png"
    W, H = 1024, 500
    img = linear_gradient((W, H), CREAM, CREAM_DARK)
    draw = ImageDraw.Draw(img)

    accent = Image.new("RGBA", (W, H), (0, 0, 0, 0))
    ad = ImageDraw.Draw(accent)
    ad.ellipse([-120, -60, 460, 560], fill=(*PRIMARY_LIGHT, 35))
    ad.ellipse([-40, -100, 380, 400], fill=(*PRIMARY, 25))
    accent = accent.filter(ImageFilter.GaussianBlur(radius=8))
    img.paste(accent, (0, 0), accent)

    icon = Image.open(SRC_ICON).convert("RGBA")
    icon_size = 320
    icon = icon.resize((icon_size, icon_size), Image.LANCZOS)
    shadow = Image.new("RGBA", (icon_size + 40, icon_size + 40), (0, 0, 0, 0))
    sd = ImageDraw.Draw(shadow)
    sd.rounded_rectangle(
        [20, 20, icon_size + 20, icon_size + 20],
        radius=72,
        fill=(0, 0, 0, 50),
    )
    shadow = shadow.filter(ImageFilter.GaussianBlur(radius=14))
    icon_x, icon_y = 70, (H - icon_size) // 2
    img.paste(shadow, (icon_x - 20, icon_y - 14), shadow)
    img.paste(icon, (icon_x, icon_y), icon)

    title_font = ImageFont.truetype(FONT_BOLD, 78)
    sub_font = ImageFont.truetype(FONT_REG, 34)
    badge_font = ImageFont.truetype(FONT_BOLD, 20)

    text_x = 450
    title = "HouseKeep"
    tagline = "Home maintenance,"
    tagline2 = "simplified."

    t_bbox = draw.textbbox((0, 0), title, font=title_font)
    title_h = t_bbox[3] - t_bbox[1]
    total_h = title_h + 16 + 50 + 50
    y0 = (H - total_h) // 2 - 10

    draw.text((text_x, y0), title, font=title_font, fill=PRIMARY)
    draw.text((text_x, y0 + title_h + 24), tagline, font=sub_font, fill=TEXT_PRIMARY)
    draw.text((text_x, y0 + title_h + 24 + 48), tagline2, font=sub_font, fill=TEXT_PRIMARY)

    badge_text = "WARRANTIES  ·  MAINTENANCE  ·  DOCUMENTS"
    b_bbox = draw.textbbox((0, 0), badge_text, font=badge_font)
    b_w = b_bbox[2] - b_bbox[0]
    bx = text_x
    by = H - 70
    draw.rounded_rectangle(
        [bx - 16, by - 12, bx + b_w + 16, by + 32],
        radius=20,
        fill=PRIMARY,
    )
    draw.text((bx, by - 4), badge_text, font=badge_font, fill=CREAM)

    img.save(out, "PNG", optimize=True)
    return out


def main() -> int:
    if not SRC_ICON.exists():
        print(f"ERROR: source icon not found: {SRC_ICON}", file=sys.stderr)
        return 1
    OUT_DIR.mkdir(parents=True, exist_ok=True)

    icon = make_icon_master()
    print(f"wrote {icon} ({icon.stat().st_size // 1024} KB)")

    feature = make_feature_graphic()
    print(f"wrote {feature} ({feature.stat().st_size // 1024} KB)")

    return 0


if __name__ == "__main__":
    sys.exit(main())

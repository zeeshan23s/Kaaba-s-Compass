"""Generates assets/images/app_icon.png for flutter_launcher_icons."""
import math
from PIL import Image, ImageDraw


def _hex(h):
    h = h.lstrip('#')
    return tuple(int(h[i:i+2], 16) for i in (0, 2, 4))


DARK_BG   = _hex('0D1117')
GOLD      = _hex('C8973A')
GOLD_DARK = _hex('8A5E1A')
QIBLA_GRN = _hex('10B981')
CREAM     = (250, 246, 239)
NEAR_BLK  = (8, 8, 14)


def _star_polygon(cx, cy, r_outer, r_inner, points, angle_offset=0):
    pts = []
    for i in range(points * 2):
        r = r_outer if i % 2 == 0 else r_inner
        a = math.pi * i / points + angle_offset
        pts.append((cx + r * math.cos(a), cy + r * math.sin(a)))
    return pts


def generate(size=1024, out='assets/images/app_icon.png'):
    img  = Image.new('RGBA', (size, size), DARK_BG + (255,))
    draw = ImageDraw.Draw(img)
    cx, cy = size // 2, size // 2

    # ── Outer gold compass ring ───────────────────────────────────────────────
    ring_r = cx - 30
    ring_w = 26
    draw.ellipse([cx - ring_r, cy - ring_r, cx + ring_r, cy + ring_r],
                 outline=GOLD + (255,), width=ring_w)

    # Cardinal tick marks on the ring
    inner_r = ring_r - ring_w // 2
    for i in range(16):
        angle  = i * 22.5 * math.pi / 180 - math.pi / 2
        is_card = (i % 4 == 0)
        is_half = (i % 2 == 0)
        tick_len = 38 if is_card else (20 if is_half else 10)
        width    = 8 if is_card else (4 if is_half else 2)
        alpha    = 255 if is_card else (180 if is_half else 120)
        ox = cx + inner_r * math.cos(angle)
        oy = cy + inner_r * math.sin(angle)
        ix = cx + (inner_r - tick_len) * math.cos(angle)
        iy = cy + (inner_r - tick_len) * math.sin(angle)
        draw.line([(ox, oy), (ix, iy)], fill=GOLD + (alpha,), width=width)

    # ── Crescent moon + star (upper area) ────────────────────────────────────
    moon_cx, moon_cy = cx, cy - 260
    moon_r = 62
    # Main moon circle
    draw.ellipse([moon_cx - moon_r, moon_cy - moon_r,
                  moon_cx + moon_r, moon_cy + moon_r],
                 fill=GOLD + (255,))
    # Mask circle (offset right to create crescent)
    mask_offset = 36
    draw.ellipse([moon_cx - moon_r + mask_offset, moon_cy - moon_r,
                  moon_cx + moon_r + mask_offset, moon_cy + moon_r],
                 fill=DARK_BG + (255,))

    # 5-pointed star next to crescent
    star_cx = moon_cx + 90
    star_cy = moon_cy - 18
    pts = _star_polygon(star_cx, star_cy, 24, 10, 5, -math.pi / 2)
    draw.polygon(pts, fill=GOLD + (255,))

    # ── Qibla compass needle (pointing up) ───────────────────────────────────
    # Subtle: thin tapered needle from center pointing toward crescent
    needle_tip_y  = cy - 190
    needle_base_y = cy - 30
    half_w = 12
    draw.polygon([
        (cx, needle_tip_y),
        (cx - half_w, needle_base_y),
        (cx + half_w, needle_base_y),
    ], fill=QIBLA_GRN + (220,))
    # Counter needle (south, grey)
    draw.polygon([
        (cx, cy + 120),
        (cx - 8, cy - 30),
        (cx + 8, cy - 30),
    ], fill=(70, 80, 90, 200))

    # ── Kaaba body ───────────────────────────────────────────────────────────
    k_w, k_h = 260, 210
    kx = cx - k_w // 2
    ky = cy - 30  # sits in lower-center

    # Isometric top face
    top_pts = [
        (kx,         ky),
        (cx,         ky - 54),
        (kx + k_w,   ky),
        (cx,         ky + 0),   # not used; just front edge
    ]
    draw.polygon([
        (kx, ky), (cx, ky - 54), (kx + k_w, ky)
    ], fill=(18, 20, 28, 255), outline=GOLD + (255,), width=3)

    # Front face
    draw.rectangle([kx, ky, kx + k_w, ky + k_h],
                   fill=NEAR_BLK + (255,), outline=GOLD + (255,), width=4)

    # Gold Kiswa band (~22 % from top of front face)
    band_y = ky + int(k_h * 0.18)
    band_h = int(k_h * 0.13)
    draw.rectangle([kx, band_y, kx + k_w, band_y + band_h],
                   fill=GOLD + (255,))
    # Decorative text lines on band
    for li, frac in enumerate([0.25, 0.5, 0.75]):
        ly = int(band_y + band_h * frac)
        draw.line([(kx + 18, ly), (kx + k_w - 18, ly)],
                  fill=CREAM + (140,), width=2)

    # Gold door (centered horizontally, lower 55% of face)
    d_w = int(k_w * 0.34)
    d_h = int(k_h * 0.55)
    dx  = cx - d_w // 2
    dy  = ky + int(k_h * 0.40)

    # Door arch (filled ellipse top half)
    arch_r = d_w // 2
    draw.pieslice([dx, dy - arch_r, dx + d_w, dy + arch_r],
                  start=180, end=360, fill=GOLD + (230,))
    # Door rectangle body
    draw.rectangle([dx, dy, dx + d_w, ky + k_h], fill=GOLD + (230,))
    # Door inner shadow
    m = 10
    draw.rectangle([dx + m, dy + m, dx + d_w - m, ky + k_h - m],
                   fill=(15, 10, 5, 210))
    # Door handle (small circle)
    draw.ellipse([cx - 7, ky + k_h - 40, cx + 7, ky + k_h - 26],
                 fill=GOLD + (200,))

    # Center pivot dot
    dot_r = 14
    draw.ellipse([cx - dot_r, cy - 30 - dot_r,
                  cx + dot_r, cy - 30 + dot_r],
                 fill=DARK_BG + (255,), outline=GOLD + (255,), width=3)

    img.save(out)
    print(f'Saved {out}  ({size}×{size} px)')


if __name__ == '__main__':
    generate()

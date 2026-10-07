#!/usr/bin/env python3
"""Reading the client's BLP textures into RGBA, and writing them out as PNG.

BLP1 (paletted, 1- or 8-bit alpha, and DXT) and BLP2 (raw BGRA, DXT1/DXT3/DXT5)
are what this client uses for its icons and its world maps. The decoders are here
rather than in one generator because both the icon and the map generators need
them. So is the paletted PNG writer: an icon is forty pixels wide and goes out as
true colour, a zone map is a quarter of a megapixel and goes out as 256 colours
(see quantize).
"""

import bisect
import struct
import sys
import zlib

def _rgb565(v):
    r, g, b = (v >> 11) & 0x1F, (v >> 5) & 0x3F, v & 0x1F
    return ((r << 3) | (r >> 2), (g << 2) | (g >> 4), (b << 3) | (b >> 2))


class Unsupported(Exception):
    """A BLP variant this tool cannot read. One odd file in a client is not a
    reason to abandon the other seven hundred, so the caller reports and skips."""


class Window:
    """A view onto one 4x4 corner of a bigger image, so the DXT1 colour decoder
    can fill a block without knowing where in the picture it is."""

    def __init__(self, image, bx, by):
        self.image, self.bx, self.by = image, bx, by

    def __getitem__(self, y):
        return Row(self.image[self.by + y], self.bx)


class Row:
    def __init__(self, row, bx):
        self.row, self.bx = row, bx

    def __setitem__(self, x, value):
        if self.bx + x < len(self.row):
            self.row[self.bx + x] = value


def _dxt_color(data, off, target, width=4, height=4):
    """Decode one DXT1 colour block into target, and return the next offset."""
    c0, c1, bits = struct.unpack_from("<HHI", data, off)
    palette = [_rgb565(c0), _rgb565(c1)]
    if c0 > c1:
        palette.append(tuple((2 * palette[0][i] + palette[1][i]) // 3 for i in range(3)))
        palette.append(tuple((palette[0][i] + 2 * palette[1][i]) // 3 for i in range(3)))
        alpha = (255, 255, 255, 255)
    else:
        # c0 <= c1 is the three-colour mode, and its fourth entry is transparent -
        # which is how a 1-bit alpha icon punches its outline out.
        palette.append(tuple((palette[0][i] + palette[1][i]) // 2 for i in range(3)))
        palette.append((0, 0, 0))
        alpha = (255, 255, 255, 0)
    for y in range(height):
        for x in range(width):
            r, g, b = palette[(bits >> (2 * (y * 4 + x))) & 3]
            target[y][x] = (r, g, b, alpha[(bits >> (2 * (y * 4 + x))) & 3])
    return off + 8


def _dxt1(data, w, h, image):
    off = 0
    for by in range(0, h, 4):
        for bx in range(0, w, 4):
            off = _dxt_color(data, off, Window(image, bx, by),
                             min(4, w - bx), min(4, h - by))


def _dxt3(data, w, h, image):
    off = 0
    for by in range(0, h, 4):
        for bx in range(0, w, 4):
            packed = struct.unpack_from("<Q", data, off)[0]
            off += 8
            for y in range(4):
                for x in range(4):
                    if bx + x < w and by + y < h:
                        window = Window(image, bx, by)
                        nibble = (packed >> (4 * (y * 4 + x))) & 0xF
                        window[y][x] = (0, 0, 0, nibble * 17)
            off = _dxt_color(data, off, Window(image, bx, by))
    return off


def _dxt5(data, w, h, image):
    off = 0
    for by in range(0, h, 4):
        for bx in range(0, w, 4):
            a0, a1 = data[off], data[off + 1]
            bits = int.from_bytes(data[off + 2:off + 8], "little")
            off += 8
            if a0 > a1:
                alphas = [a0, a1] + [((7 - i) * a0 + i * a1) // 7 for i in range(1, 7)]
            else:
                alphas = [a0, a1] + [((5 - i) * a0 + i * a1) // 5 for i in range(1, 5)] + [0, 255]
            window = Window(image, bx, by)
            for y in range(4):
                for x in range(4):
                    if bx + x < w and by + y < h:
                        window[y][x] = (0, 0, 0, alphas[(bits >> (3 * (y * 4 + x))) & 7])
            off = _dxt_color(data, off, window)
    return off


def _blank(w, h):
    return [[(0, 0, 0, 0)] * w for _ in range(h)]


def read_blp(path):
    """Decode a client icon into (width, height, rows of RGBA)."""
    data = open(path, "rb").read()
    if data[:4] == b"BLP1":
        return _read_blp1(data)
    if data[:4] == b"BLP2":
        return _read_blp2(data)
    sys.exit("%s is not a BLP (%r)" % (path, data[:4]))


def _read_blp1(data):
    compression = struct.unpack_from("<I", data, 4)[0]
    w, h = struct.unpack_from("<II", data, 12)
    offsets = struct.unpack_from("<16I", data, 28)
    image = _blank(w, h)
    if compression == 1:
        palette = [(data[156 + i * 4 + 2], data[156 + i * 4 + 1], data[156 + i * 4], 255)
                   for i in range(256)]
        off = 156 + 1024
        alpha_size = w * h if (data[8] & 0xF) == 8 else (w * h) // 8
        alpha = data[off:off + alpha_size]
        off += alpha_size
        for y in range(h):
            for x in range(w):
                r, g, b, _ = palette[data[off + y * w + x]]
                if alpha_size == w * h:
                    a = alpha[y * w + x]
                else:
                    a = ((alpha[(y * w + x) // 8] >> (7 - (x % 8))) & 1) * 255
                image[y][x] = (r, g, b, a)
    elif compression == 2:
        block = data[offsets[0]:offsets[0] + (w // 4) * (h // 4) * 16]
        if (data[8] & 0xF) == 8:
            _dxt5(block, w, h, image)
        else:
            _dxt1(block, w, h, image)
    else:
        raise Unsupported("BLP1 compression %d" % compression)
    return w, h, image


def _read_blp2(data):
    encoding, alpha_depth, alpha_encoding = data[8], data[9], data[10]
    w, h = struct.unpack_from("<II", data, 12)
    offsets = struct.unpack_from("<16I", data, 20)
    sizes = struct.unpack_from("<16I", data, 84)
    block = data[offsets[0]:offsets[0] + sizes[0]]
    image = _blank(w, h)
    if encoding in (1, 3):  # raw BGRA; the client uses 1 and 3 for 4-byte pixels
        for y in range(h):
            for x in range(w):
                i = (y * w + x) * 4
                image[y][x] = (block[i + 2], block[i + 1], block[i], block[i + 3])
    elif encoding == 2:  # DXT
        if alpha_depth in (0, 1) and alpha_encoding == 0:
            _dxt1(block, w, h, image)
        elif alpha_encoding == 7:
            _dxt5(block, w, h, image)
        else:
            _dxt3(block, w, h, image)
    else:
        raise Unsupported("BLP2 encoding %d" % encoding)
    return w, h, image


def _chunk(tag, payload):
    return (struct.pack(">I", len(payload)) + tag + payload
            + struct.pack(">I", zlib.crc32(tag + payload) & 0xFFFFFFFF))


def _png(header, chunks):
    return (b"\x89PNG\r\n\x1a\n" + _chunk(b"IHDR", header)
            + b"".join(chunks) + _chunk(b"IEND", b""))


def write_png(path, w, h, image):
    """Write RGBA rows as a PNG. Hand-rolled so the tool needs nothing installed."""
    raw = b"".join(b"\x00" + bytes(c for pixel in row for c in pixel) for row in image)
    header = struct.pack(">IIBBBBB", w, h, 8, 6, 0, 0, 0)
    out = _png(header, [_chunk(b"IDAT", zlib.compress(raw, 9))])
    with open(path, "wb") as f:
        f.write(out)


# ---------------------------------------------------------------------------
# Paletted PNGs
#
# A zone map is a 1002x668 painting: as true colour it is a megabyte, and the
# site ships 131 of them. Dropping it to 256 colours and writing the indices as
# an 8-bit PNG cuts that to about eighty kilobytes with a mean error under three
# levels out of 255, which is why the maps are paletted and the icons are not.
# ---------------------------------------------------------------------------


def quantize(rows, colors=256, dither=True):
    """Reduce RGB rows to (palette, indexed rows).

    Median cut over the exact colours, then Floyd-Steinberg error diffusion. The
    nearest palette entry is found by binary search on a palette sorted by
    luminance: once the luminance gap to the next entry exceeds the best distance
    found so far, no entry further away can win, and a painterly image runs
    through a few dozen comparisons per pixel instead of 256.
    """
    hist = {}
    for row in rows:
        for px in row:
            key = (px[0] << 16) | (px[1] << 8) | px[2]
            hist[key] = hist.get(key, 0) + 1
    palette = _median_cut(hist, colors)
    near = _Nearest(palette)
    w = len(rows[0])
    red = [c[0] for c in palette]
    green = [c[1] for c in palette]
    blue = [c[2] for c in palette]

    if not dither:
        out = []
        for row in rows:
            line = bytearray(w)
            for x, px in enumerate(row):
                line[x] = near(px[0], px[1], px[2])
            out.append(line)
        return palette, out

    out = []
    cur = [0] * (3 * w + 6)
    nxt = [0] * (3 * w + 6)
    for row in rows:
        line = bytearray(w)
        for x, px in enumerate(row):
            i3 = x * 3
            r = px[0] + (cur[i3] + 8) // 16
            g = px[1] + (cur[i3 + 1] + 8) // 16
            b = px[2] + (cur[i3 + 2] + 8) // 16
            r = 0 if r < 0 else (255 if r > 255 else r)
            g = 0 if g < 0 else (255 if g > 255 else g)
            b = 0 if b < 0 else (255 if b > 255 else b)
            i = near(r, g, b)
            line[x] = i
            # Seven sixteenths right, three left-below, five below, one right-below.
            er = (r - red[i]) * 16
            eg = (g - green[i]) * 16
            eb = (b - blue[i]) * 16
            cur[i3 + 3] += er * 7 // 16
            cur[i3 + 4] += eg * 7 // 16
            cur[i3 + 5] += eb * 7 // 16
            if x:
                nxt[i3 - 3] += er * 3 // 16
                nxt[i3 - 2] += eg * 3 // 16
                nxt[i3 - 1] += eb * 3 // 16
            nxt[i3] += er * 5 // 16
            nxt[i3 + 1] += eg * 5 // 16
            nxt[i3 + 2] += eb * 5 // 16
            nxt[i3 + 3] += er // 16
            nxt[i3 + 4] += eg // 16
            nxt[i3 + 5] += eb // 16
        out.append(line)
        cur = nxt
        nxt = [0] * (3 * w + 6)
    return palette, out


def _median_cut(hist, colors):
    """Split the colour histogram into boxes until there are `colors` of them."""
    items = list(hist.items())
    boxes = [(items, _bounds(items), sum(count for _, count in items))]
    while len(boxes) < colors:
        best, score = -1, 0
        for i, (box, bounds, count) in enumerate(boxes):
            if len(box) < 2:
                continue
            span = max(bounds[1] - bounds[0], bounds[3] - bounds[2], bounds[5] - bounds[4])
            if span * count > score:
                best, score = i, span * count
        if best < 0:
            break
        box, bounds, _count = boxes.pop(best)
        for part in _split(box, bounds):
            boxes.append((part, _bounds(part), sum(count for _, count in part)))
    palette = []
    for box, _bounds_, _count in boxes:
        # The mean of the colours that landed in the box, weighted by how often
        # each of them occurs.
        sums = [0, 0, 0]
        total = 0
        for key, count in box:
            sums[0] += (key >> 16) * count
            sums[1] += ((key >> 8) & 255) * count
            sums[2] += (key & 255) * count
            total += count
        palette.append((round(sums[0] / total), round(sums[1] / total), round(sums[2] / total)))
    return palette


def _bounds(items):
    low = [255, 255, 255]
    high = [0, 0, 0]
    for key, _count in items:
        for axis, shift in enumerate((16, 8, 0)):
            v = (key >> shift) & 255
            if v < low[axis]:
                low[axis] = v
            if v > high[axis]:
                high[axis] = v
    return low[0], high[0], low[1], high[1], low[2], high[2]


def _split(items, bounds):
    """Cut a box across its longest axis, at the weighted median."""
    spans = (bounds[1] - bounds[0], bounds[3] - bounds[2], bounds[5] - bounds[4])
    shift = (16, 8, 0)[spans.index(max(spans))]
    items = sorted(items, key=lambda kc: (kc[0] >> shift) & 255)
    total = sum(count for _, count in items)
    seen = 0
    for i, (_key, count) in enumerate(items):
        seen += count
        if seen * 2 >= total and i + 1 < len(items):
            return items[:i + 1], items[i + 1:]
    return items[:1], items[1:]


def _luma(r, g, b):
    return (r * 77 + g * 150 + b * 29) >> 8


class _Nearest:
    """The palette entry closest to a colour, with a cache for repeats."""

    def __init__(self, palette):
        self.palette = palette
        self.order = sorted(range(len(palette)), key=lambda i: _luma(*palette[i]))
        self.lumas = [_luma(*palette[i]) for i in self.order]
        self.cache = {}

    def __call__(self, r, g, b):
        key = (r << 16) | (g << 8) | b
        hit = self.cache.get(key)
        if hit is not None:
            return hit
        l = _luma(r, g, b)
        pos = bisect.bisect_left(self.lumas, l)
        best, best_dist = 0, 1 << 30
        for step, start in ((1, pos), (-1, pos - 1)):
            i = start
            while 0 <= i < len(self.order):
                if abs(self.lumas[i] - l) >= best_dist:
                    break
                entry = self.palette[self.order[i]]
                dist = ((r - entry[0]) ** 2 + (g - entry[1]) ** 2 + (b - entry[2]) ** 2)
                if dist < best_dist:
                    best, best_dist = self.order[i], dist
                i += step
        self.cache[key] = best
        return best


def write_paletted_png(path, w, h, palette, indices):
    """Write an 8-bit indexed PNG.

    Rows are left unfiltered: measured against the five PNG filters on a dozen
    maps, "none" came out smallest, because the dithering that makes the picture
    look right also makes a filtered row less predictable.
    """
    raw = b"".join(b"\x00" + bytes(line) for line in indices)
    plte = b"".join(bytes(c) for c in palette) + bytes(3 * (256 - len(palette)))
    header = struct.pack(">IIBBBBB", w, h, 8, 3, 0, 0, 0)
    out = _png(header, [_chunk(b"PLTE", plte), _chunk(b"IDAT", zlib.compress(raw, 9))])
    with open(path, "wb") as f:
        f.write(out)



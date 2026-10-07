#!/usr/bin/env python3
"""Reading the client's BLP textures into RGBA, and writing them out as PNG.

BLP1 (paletted, 1- or 8-bit alpha, and DXT) and BLP2 (raw BGRA, DXT1/DXT3/DXT5)
are what this client uses for its icons and its world maps. The decoders are here
rather than in one generator because both the icon and the map generators need
them.

Used by gen_icons.py and gen_maps.py.
"""

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


def write_png(path, w, h, image):
    """Write RGBA rows as a PNG. Hand-rolled so the tool needs nothing installed."""
    raw = b"".join(b"\x00" + bytes(c for pixel in row for c in pixel) for row in image)

    def chunk(tag, payload):
        return (struct.pack(">I", len(payload)) + tag + payload
                + struct.pack(">I", zlib.crc32(tag + payload) & 0xFFFFFFFF))

    out = (b"\x89PNG\r\n\x1a\n"
           + chunk(b"IHDR", struct.pack(">IIBBBBB", w, h, 8, 6, 0, 0, 0))
           + chunk(b"IDAT", zlib.compress(raw, 9))
           + chunk(b"IEND", b""))
    with open(path, "wb") as f:
        f.write(out)



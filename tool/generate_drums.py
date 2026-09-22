"""Génère des one-shots de batterie (WAV 16-bit mono 44.1 kHz), sans samples tiers."""

from __future__ import annotations

import math
import random
import struct
import wave
from pathlib import Path

RATE = 44100
OUT = Path(__file__).resolve().parents[1] / "assets" / "drums"


def write_wav(name: str, samples: list[float]) -> None:
    OUT.mkdir(parents=True, exist_ok=True)
    path = OUT / name
    with wave.open(str(path), "w") as wav:
        wav.setnchannels(1)
        wav.setsampwidth(2)
        wav.setframerate(RATE)
        frames = bytearray()
        for sample in samples:
            clamped = max(-1.0, min(1.0, sample))
            frames += struct.pack("<h", int(clamped * 32767))
        wav.writeframes(frames)


def exp_decay(i: int, n: int, tau: float) -> float:
    return math.exp(-i / (tau * n))


def sine(i: int, freq: float) -> float:
    return math.sin(2 * math.pi * freq * i / RATE)


def noise() -> float:
    return random.uniform(-1.0, 1.0)


def kick() -> list[float]:
    n = int(RATE * 0.42)
    out = []
    for i in range(n):
        t = i / n
        freq = 148 - 108 * t
        body = sine(i, freq) * exp_decay(i, n, 0.22)
        click = sine(i, 1800) * exp_decay(i, n, 0.018) * 0.35
        out.append((body + click) * 0.95)
    return out


def snare() -> list[float]:
    n = int(RATE * 0.28)
    out = []
    for i in range(n):
        tone = sine(i, 196) * exp_decay(i, n, 0.16) * 0.45
        snap = noise() * exp_decay(i, n, 0.12) * 0.7
        out.append(tone + snap)
    return out


def hat() -> list[float]:
    n = int(RATE * 0.09)
    out = []
    prev = 0.0
    for i in range(n):
        white = noise()
        hp = white - prev
        prev = white
        out.append(hp * exp_decay(i, n, 0.14) * 0.55)
    return out


def tom(start_hz: float, end_hz: float, seconds: float) -> list[float]:
    n = int(RATE * seconds)
    out = []
    for i in range(n):
        t = i / n
        freq = start_hz + (end_hz - start_hz) * t
        body = sine(i, freq) * exp_decay(i, n, 0.28)
        out.append(body * 0.85)
    return out


def crash() -> list[float]:
    n = int(RATE * 1.15)
    out = []
    prev = 0.0
    for i in range(n):
        white = noise()
        hp = white - 0.65 * prev
        prev = white
        metal = sine(i, 740) * 0.08 + sine(i, 1180) * 0.06
        out.append((hp * 0.7 + metal) * exp_decay(i, n, 0.38) * 0.5)
    return out


def main() -> None:
    random.seed(7)
    write_wav("kick.wav", kick())
    write_wav("snare.wav", snare())
    write_wav("hat.wav", hat())
    write_wav("tom_high.wav", tom(196, 130, 0.38))
    write_wav("tom_low.wav", tom(118, 72, 0.5))
    write_wav("crash.wav", crash())
    print(f"WAV écrits dans {OUT}")


if __name__ == "__main__":
    main()

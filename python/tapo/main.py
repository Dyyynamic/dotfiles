import asyncio
import colorsys
import os
import sys
from pathlib import Path

import numpy as np
from dotenv import load_dotenv
from tapo import ApiClient

HUE_CALIBRATION = [
    (0, 0),
    (8, 3),  # too orange -> more red
    (15, 8),  # too yellow -> more red
    (30, 13),  # too yellow -> more orange
    (50, 30),  # too green -> more yellow
    (150, 150),  # perfect
    (180, 200),  # too green -> more blue
    (220, 235),  # too cyan -> more blue
    (250, 242),  # too purple -> more blue
    (270, 255),  # too magenta -> more blue
    (300, 300),  # perfect
    (350, 355),  # too magenta -> more red
    (360, 360),
]

SATURATION_CALIBRATION = [
    (0, 1),  # perfect
    (30, 0.85),  # less saturation
    (180, 1),  # perfect
    (270, 1.5),  # more saturation
    (360, 1),  # perfect
]


def calibrate_hue(input_hue: int) -> int:
    input_hue = input_hue % 360

    xp, fp = zip(*HUE_CALIBRATION)
    calibrated_hue = int(np.interp(input_hue, xp, fp))

    return calibrated_hue


def calibrate_saturation(input_hue: int, input_sat: int) -> int:
    input_hue = input_hue % 360

    xp, fp = zip(*SATURATION_CALIBRATION)
    sat_multi = np.interp(input_hue, xp, fp)

    calibrated_sat = min(input_sat * sat_multi, 100)

    return int(calibrated_sat)


async def main(args):
    load_dotenv(Path.home() / ".dotfiles" / "secrets.env")

    username = os.getenv("TAPO_USERNAME")
    password = os.getenv("TAPO_PASSWORD")
    ip = os.getenv("TAPO_IP")

    if not username or not password or not ip:
        print("Missing secrets")
        sys.exit(1)

    client = ApiClient(username, password)

    try:
        device = await client.l900(ip)
    except Exception:
        print("Tapo: Failed to connect")
        sys.exit(0)

    if len(args) == 4:
        red = int(args[1])
        green = int(args[2])
        blue = int(args[3])
    else:
        print("Usage: tapo <r> <g> <b>")
        sys.exit(1)

    h, s, _ = colorsys.rgb_to_hsv(red / 255, green / 255, blue / 255)

    hue = int(h * 360)
    saturation = int(s * 100)

    calibrated_hue = calibrate_hue(hue)
    calibrated_sat = calibrate_saturation(hue, saturation)
    await device.set_hue_saturation(calibrated_hue, calibrated_sat)


if __name__ == "__main__":
    asyncio.run(main(sys.argv))

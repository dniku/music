"""Recover the fixed-layout _-DEer9afE0 tutorial, not arbitrary piano videos."""

from __future__ import annotations

import argparse
import hashlib
import json
import subprocess
from dataclasses import dataclass
from enum import StrEnum
from pathlib import Path


class Hand(StrEnum):
    LEFT = "left"
    RIGHT = "right"


@dataclass(frozen=True)
class Source:
    video_id: str = "_-DEer9afE0"
    sha256: str = "3eb051ccd61c4777ae03ff72e25e8df68bc25506c2f496a8bf4c4ceffe93c1cc"
    width: int = 1920
    height: int = 1080
    fps: int = 60
    bpm: int = 120
    start_seconds: float = 5.7
    # One unit = 1/12 of a quarter note: eighths, sixteenths and triplets fit.
    units_per_quarter: int = 12
    # Visible key presses last ~7.5 frames = 0.125 s = a sixteenth note.
    gate_units: int = 3
    expected_notes: int = 1396

    @property
    def frames_per_unit(self) -> float:
        return self.fps * 60 / self.bpm / self.units_per_quarter


SOURCE = Source()
BLACK_OFFSETS = {1: -2.5, 3: 3.5, 6: -4.5, 8: 0.0, 10: 5.0}
SHARP_NAMES = ("c", "cis", "d", "dis", "e", "f", "fis", "g", "gis", "a", "ais", "b")
FLAT_NAMES = ("c", "cis", "d", "ees", "e", "f", "fis", "g", "aes", "a", "bes", "b")
# Editorial key signatures, inferred from the recovered pitch collections.
KEY_CHANGES = {
    1: r"d \major",
    25: r"d \minor",
    40: r"d \major",
    57: r"d \minor",
    89: r"e \minor",
}
TIME_MARKS = (1, 9, 25, 40, 57, 73, 83, 89, 103)


@dataclass(frozen=True, order=True)
class Note:
    start: int
    hand: Hand
    pitch: int


def key_centres() -> dict[int, int]:
    """88 keys, A0 through C8. Black-key offsets measured from the keyboard."""
    result: dict[int, int] = {}
    white_width = SOURCE.width / 52
    white_index = 0
    for pitch in range(21, 109):
        if pitch % 12 in BLACK_OFFSETS:
            centre = white_index * white_width + BLACK_OFFSETS[pitch % 12]
        else:
            centre = (white_index + 0.5) * white_width
            white_index += 1
        result[pitch] = round(centre)
    assert white_index == 52
    return result


def colour(red: int, green: int, blue: int) -> Hand | None:
    if blue > 100 and blue > 1.8 * red and blue > 1.7 * green:
        return Hand.LEFT
    if green > 100 and green > 1.8 * red and green > 1.7 * blue:
        return Hand.RIGHT
    return None


def occupied_keys(row: bytes, centres: dict[int, int]) -> set[tuple[Hand, int]]:
    """Map rectangle centres, not probe pixels: white bars overlap black lanes."""
    occupied: set[tuple[Hand, int]] = set()
    start_x = 0
    previous: Hand | None = None
    for x in range(SOURCE.width + 1):
        hand = colour(*row[3 * x : 3 * x + 3]) if x < SOURCE.width else None
        if hand == previous:
            continue
        if previous is not None and 7 <= x - start_x <= 38:
            centre = (start_x + x - 1) / 2
            pitch = min(centres, key=lambda candidate: abs(centres[candidate] - centre))
            if abs(centres[pitch] - centre) < 5:
                occupied.add((previous, pitch))
        start_x = x
        previous = hand
    return occupied


def quantize(start: int, end: int, first_frame: int) -> int | None:
    unit = round((start - first_frame) / SOURCE.frames_per_unit)
    residual = abs(start - first_frame - unit * SOURCE.frames_per_unit)
    if end - start < 5 or residual > 1.1 or unit < 0:
        return None
    if end - start > 8:
        raise ValueError("Unexpected note length; fixed-gate model no longer applies")
    return unit


def scan(video: Path, height: int, first_frame: int) -> set[Note]:
    command = [
        "ffmpeg",
        "-nostdin",
        "-hide_banner",
        "-loglevel",
        "error",
        "-i",
        str(video),
        "-vf",
        f"crop={SOURCE.width}:2:0:{height},format=rgb24",
        "-f",
        "rawvideo",
        "pipe:1",
    ]
    centres = key_centres()
    active: dict[tuple[Hand, int], int] = {}
    notes: set[Note] = set()
    frame = 0
    with subprocess.Popen(command, stdout=subprocess.PIPE) as process:
        assert process.stdout is not None
        while row := process.stdout.read(SOURCE.width * 2 * 3):
            if len(row) != SOURCE.width * 2 * 3:
                raise ValueError("Truncated RGB frame")
            occupied = occupied_keys(row, centres)
            for key in occupied:
                active.setdefault(key, frame)
            for hand, pitch in active.keys() - occupied:
                start = active.pop((hand, pitch))
                unit = quantize(start, frame, first_frame)
                if unit is not None:
                    note = Note(unit, hand, pitch)
                    if note in notes:
                        raise ValueError(
                            f"Two detections quantized to the same note: {note}"
                        )
                    notes.add(note)
            frame += 1
        if process.wait() != 0:
            raise RuntimeError("FFmpeg decoding failed")
    if active or frame != 14031:
        raise ValueError("Unexpected final frame or active notes at end of video")
    print(f"Scanline {height}: {len(notes)} notes", flush=True)
    return notes


def reconcile(upper: set[Note], lower: set[Note]) -> list[Note]:
    # The opening zoom hides the first A1 at y=300. At y=500, particles obscure
    # two genuine notes and create a false C7. All other detections must agree.
    assert upper - lower == {Note(486, Hand.LEFT, 47), Note(1860, Hand.LEFT, 50)}
    assert lower - upper == {Note(0, Hand.LEFT, 33), Note(3969, Hand.RIGHT, 96)}
    notes = sorted(upper | {Note(0, Hand.LEFT, 33)})
    assert len(notes) == SOURCE.expected_notes
    return notes


def pitch_name(pitch: int, flats: bool) -> str:
    octave = pitch // 12 - 4  # LilyPond c = MIDI 48; c' = MIDI 60.
    return (FLAT_NAMES if flats else SHARP_NAMES)[pitch % 12] + (
        "'" * octave if octave >= 0 else "," * -octave
    )


def duration(units: int, triplet: bool) -> str:
    # Within a 3:2 tuplet, a written 32nd is one unit; otherwise a 16th is three.
    options = {12: "4", 9: "8.", 6: "8", 3: "16"}
    if triplet:
        options = {12: "4.", 8: "4", 6: "8.", 4: "8", 3: "16.", 2: "16", 1: "32"}
    return options[units]


def rest(units: int, triplet: bool) -> str:
    sizes = (12, 8, 6, 4, 3, 2, 1) if triplet else (12, 9, 6, 3)
    result: list[str] = []
    for size in sizes:
        while units >= size:
            result.append("r" + duration(size, triplet))
            units -= size
    assert units == 0
    return " ".join(result)


def beat_music(notes: list[Note], beat: int, flats: bool) -> str:
    groups: dict[int, list[int]] = {}
    for note in notes:
        groups.setdefault(note.start - beat, []).append(note.pitch)
    triplet = any(offset % 3 for offset in groups)
    result: list[str] = []
    cursor = 0
    for offset, pitches in sorted(groups.items()):
        assert offset >= cursor and offset + SOURCE.gate_units <= 12
        if offset > cursor:
            result.append(rest(offset - cursor, triplet))
        names = [pitch_name(pitch, flats) for pitch in sorted(pitches)]
        head = names[0] if len(names) == 1 else "<" + " ".join(names) + ">"
        result.append(head + duration(SOURCE.gate_units, triplet))
        cursor = offset + SOURCE.gate_units
    if cursor < 12:
        result.append(rest(12 - cursor, triplet))
    music = " ".join(result)
    return r"\tuplet 3/2 { " + music + " }" if triplet else music


def lilypond(notes: list[Note]) -> str:
    bars = (max(note.start for note in notes) + SOURCE.gate_units + 47) // 48
    lines = [
        "% Generated by piano-roll/recover.py; see piano-roll/README.md.",
        f"pianoRollTempo = {{ \\tempo 4 = {SOURCE.bpm} }}",
        "",
    ]
    for hand in Hand:
        lines.append(f"pianoRoll{hand.value.title()} = \\absolute {{")
        flats = False
        for bar in range(1, bars + 1):
            if bar in KEY_CHANGES:
                key = KEY_CHANGES[bar]
                flats = key == r"d \minor"
                lines.append("  \\key " + key)
            if hand == Hand.RIGHT:
                if bar in TIME_MARKS:
                    seconds = SOURCE.start_seconds + (bar - 1) * 4 * 60 / SOURCE.bpm
                    stamp = f"{int(seconds // 60)}:{seconds % 60:05.2f}"
                    lines.append('  \\mark \\markup \\box "' + stamp + '"')
                if bar in (83, 104):
                    lines.append(r"  \ottava #1")
                if bar == 105:
                    lines.append(r"  \ottava #2")
                if bar in (85, 107):
                    lines.append(r"  \ottava #0")
            if hand == Hand.LEFT and bar == 85:
                lines.append(r"  \ottava #-1")
            if hand == Hand.LEFT and bar == 86:
                lines.append(r"  \ottava #0")
            start = (bar - 1) * 48
            selected = [
                note
                for note in notes
                if note.hand == hand and start <= note.start < start + 48
            ]
            if selected:
                music = " ".join(
                    beat_music(
                        [note for note in selected if beat <= note.start < beat + 12],
                        beat,
                        flats,
                    )
                    for beat in range(start, start + 48, 12)
                )
            else:
                music = "R1"
            lines.append(f"  {music} | % {bar}")
            lines.append(f"  \\barNumberCheck #{bar + 1}")
        lines.extend([r'  \bar "|."', "}", ""])
    return "\n".join(lines)


def main() -> None:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("video", type=Path)
    parser.add_argument("lilypond_output", type=Path)
    parser.add_argument("events_output", type=Path)
    args = parser.parse_args()
    video: Path = args.video
    with video.open("rb") as stream:
        digest = hashlib.file_digest(stream, "sha256").hexdigest()
    if digest != SOURCE.sha256:
        raise ValueError("Video does not match the calibrated source SHA-256")
    metadata = json.loads(
        subprocess.check_output(
            [
                "ffprobe",
                "-v",
                "error",
                "-select_streams",
                "v:0",
                "-show_entries",
                "stream=width,height,r_frame_rate",
                "-of",
                "json",
                str(video),
            ]
        )
    )["streams"][0]
    assert (metadata["width"], metadata["height"], metadata["r_frame_rate"]) == (
        SOURCE.width,
        SOURCE.height,
        "60/1",
    )
    notes = reconcile(scan(video, 300, 262), scan(video, 500, 312))
    for output in (args.lilypond_output, args.events_output):
        output.parent.mkdir(parents=True, exist_ok=True)
    args.lilypond_output.write_text(lilypond(notes), encoding="utf-8")
    args.events_output.write_text(
        json.dumps(
            {
                "sourceVideoId": SOURCE.video_id,
                "sourceSha256": digest,
                "sourceStartSeconds": SOURCE.start_seconds,
                "bpm": SOURCE.bpm,
                "unitsPerQuarter": SOURCE.units_per_quarter,
                "gateUnits": SOURCE.gate_units,
                "notes": [
                    {"start": note.start, "hand": note.hand.value, "pitch": note.pitch}
                    for note in notes
                ],
            },
            indent=2,
        )
        + "\n",
        encoding="utf-8",
    )
    print(f"Recovered {len(notes)} notes; wrote {args.lilypond_output}")


if __name__ == "__main__":
    main()

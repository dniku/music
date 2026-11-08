"""Print the accepted Mother Earth attacks on its existing eighth-note grid."""

import csv
import sys
from fractions import Fraction
from pathlib import Path

ORIGIN_MS = 450
BPM = 210
SLOTS_PER_BAR = 6  # Three quarter-note beats, split into eighths.
DRUMS = {36: "bd", 38: "sn", 42: "hh"}


def read_hits(path: Path) -> list[tuple[int, int]]:
    with path.open(newline="", encoding="utf-8") as stream:
        rows = list(csv.reader(stream, skipinitialspace=True))
    if not rows or rows[0] != ["0", "0", "Header", "1", "1", "1000"]:
        raise ValueError("Expected the accepted single-track, 1000 ticks/second MIDI")
    if any(len(row) < 3 for row in rows):
        raise ValueError("Incomplete MIDICSV event")
    tempos = [row for row in rows if row[2] == "Tempo"]
    if tempos != [["1", "0", "Tempo", "1000000"]]:
        raise ValueError("Expected constant 1000 ticks/second timing")
    hits: list[tuple[int, int]] = []
    for row in rows:
        if row[2] != "Note_on_c":
            continue
        track, time, _, channel, note, velocity = row
        if track != "1" or channel != "9" or int(note) not in DRUMS:
            raise ValueError(f"Unexpected drum event: {row}")
        if int(velocity) > 0:
            if int(time) < ORIGIN_MS:
                raise ValueError("Attack precedes the score origin")
            hits.append((int(time), int(note)))
    if not hits:
        raise ValueError("No drum attacks")
    return hits


def quantize(hits: list[tuple[int, int]]) -> dict[int, set[int]]:
    slots: dict[int, set[int]] = {}
    for time, note in hits:
        slot = round(Fraction((time - ORIGIN_MS) * BPM * 2, 60_000))
        slots.setdefault(slot, set()).add(note)
    return slots


def render(hits: list[tuple[int, int]]) -> str:
    slots = quantize(hits)
    bar_count = max(slots) // SLOTS_PER_BAR + 1
    written = sum(len(notes) for notes in slots.values())
    lines = [
        f"% {len(hits)} source attacks; {written} written hits after merging same-slot duplicates.",
        "drumMusic = \\drummode {",
    ]
    bar = 0
    while bar < bar_count:
        milliseconds = ORIGIN_MS + round(Fraction(bar * 3 * 60_000, BPM))
        minutes, seconds = divmod(milliseconds // 1000, 60)
        lines.append(
            f'  \\mark \\markup "{minutes}:{seconds:02d}.{milliseconds % 1000 // 10:02d}"'
        )
        empty_end = bar
        while empty_end < bar_count and not any(
            empty_end * SLOTS_PER_BAR + slot in slots for slot in range(SLOTS_PER_BAR)
        ):
            empty_end += 1
        if empty_end > bar:
            lines.append(f"  R2.*{empty_end - bar} | \\break")
            bar = empty_end
            continue
        for _ in range(min(6, bar_count - bar)):
            notes = []
            for slot in range(SLOTS_PER_BAR):
                drums = slots.get(bar * SLOTS_PER_BAR + slot, set())
                token = (
                    "<" + " ".join(DRUMS[n] for n in sorted(drums)) + ">8"
                    if drums
                    else "r8"
                )
                notes.append(token)
            lines.append("  " + " ".join(notes) + f" | % bar {bar + 1}")
            bar += 1
            if not any(
                bar * SLOTS_PER_BAR + slot in slots for slot in range(SLOTS_PER_BAR)
            ):
                break
        lines.append("  \\break")
    lines.extend(['  \\bar "|."', "}"])
    return "\n".join(lines) + "\n"


if __name__ == "__main__":
    print(render(read_hits(Path(sys.argv[1]))), end="")

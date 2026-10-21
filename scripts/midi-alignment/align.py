"""Place score excerpts on a recording timeline; never synthesize missing music."""

import argparse
import csv
import json
from dataclasses import dataclass
from datetime import timedelta
from enum import StrEnum
from pathlib import Path

import mido


class Assessment(StrEnum):
    PHRASE_MATCH = "phrase_match"
    APPROXIMATE = "approximate"
    UNMAPPED = "unmapped"


@dataclass(frozen=True)
class Segment:
    start: timedelta
    end: timedelta
    source_bars: tuple[int, int] | None
    label: str
    assessment: Assessment


@dataclass(frozen=True)
class Alignment:
    beats_per_bar: int
    duration: timedelta
    segments: tuple[Segment, ...]

    @classmethod
    def load(cls, path: Path) -> "Alignment":
        with path.open() as stream:
            data = json.load(stream)
        if data["schemaVersion"] != 1:
            raise ValueError("Unsupported alignment schema")
        segments: list[Segment] = []
        previous_end = timedelta()
        for raw in data["segments"]:
            bars = raw["sourceBars"]
            source_bars = None
            if bars is not None:
                first, last = bars
                if (
                    type(first) is not int
                    or type(last) is not int
                    or not 1 <= first <= last
                ):
                    raise ValueError("Invalid inclusive source bar range")
                source_bars = (first, last)
            segment = Segment(
                start=timedelta(milliseconds=raw["startMs"]),
                end=timedelta(milliseconds=raw["endMs"]),
                source_bars=source_bars,
                label=raw["label"],
                assessment=Assessment(raw["assessment"]),
            )
            if segment.start != previous_end or segment.end <= segment.start:
                raise ValueError("Segments must partition the reference timeline")
            if (segment.source_bars is None) != (
                segment.assessment == Assessment.UNMAPPED
            ):
                raise ValueError("Only unmapped segments may lack source bars")
            previous_end = segment.end
            segments.append(segment)
        duration = timedelta(milliseconds=data["referenceDurationMs"])
        if (
            previous_end != duration
            or type(data["beatsPerBar"]) is not int
            or data["beatsPerBar"] <= 0
        ):
            raise ValueError("Invalid duration or meter")
        return cls(
            beats_per_bar=data["beatsPerBar"],
            duration=duration,
            segments=tuple(segments),
        )


def align(source: mido.MidiFile, mapping: Alignment) -> mido.MidiFile:
    # 1000 ticks/beat at 60 BPM: output ticks are milliseconds, independent of
    # the source tempo. Score position is measured in beats, not source seconds.
    output = mido.MidiFile(ticks_per_beat=1000)
    end_tick = round(mapping.duration.total_seconds() * 1000)
    source_end = max(sum(message.time for message in track) for track in source.tracks)
    conductor = mido.MidiTrack([mido.MetaMessage("set_tempo", tempo=1000000)])
    previous = 0
    for segment in mapping.segments:
        tick = round(segment.start.total_seconds() * 1000)
        conductor.append(
            mido.MetaMessage("marker", text=segment.label, time=tick - previous)
        )
        previous = tick
    conductor.append(mido.MetaMessage("end_of_track", time=end_tick - previous))
    output.tracks.append(conductor)
    for track in source.tracks:
        notes: list[tuple[int, int, mido.Message]] = []
        setup: list[mido.Message] = []
        active: dict[tuple[int, int], tuple[int, mido.Message]] = {}
        tick = 0
        for message in track:
            tick += message.time
            if message.type == "note_on" and message.velocity:
                key = (message.channel, message.note)
                if key in active:
                    raise ValueError("Overlapping same-pitch notes in one MIDI channel")
                active[key] = (tick, message)
            elif message.type == "note_off" or (
                message.type == "note_on" and not message.velocity
            ):
                start, onset = active.pop((message.channel, message.note))
                notes.append((start, tick, onset))
            elif message.type in ("program_change", "control_change", "pitchwheel"):
                if tick != 0:
                    raise ValueError(
                        "Only static instrument/controller settings are supported"
                    )
                setup.append(message.copy(time=0))
        if active:
            raise ValueError("Unterminated MIDI notes")
        if not notes:
            continue
        events: list[tuple[int, int, mido.Message]] = []
        for segment in mapping.segments:
            if segment.source_bars is None:
                continue
            first, last = segment.source_bars
            left = (first - 1) * mapping.beats_per_bar * source.ticks_per_beat
            right = last * mapping.beats_per_bar * source.ticks_per_beat
            if right > source_end:
                raise ValueError("Source bar range exceeds MIDI length")
            start_ms = segment.start.total_seconds() * 1000
            scale = (
                (segment.end - segment.start).total_seconds() * 1000 / (right - left)
            )
            for onset, offset, message in notes:
                if onset >= right or offset <= left:
                    continue
                on_tick = round(start_ms + (max(onset, left) - left) * scale)
                off_tick = round(start_ms + (min(offset, right) - left) * scale)
                events.append((on_tick, 1, message.copy(time=0)))
                events.append(
                    (
                        off_tick,
                        0,
                        mido.Message(
                            "note_off", channel=message.channel, note=message.note
                        ),
                    )
                )
        result = mido.MidiTrack(setup)
        previous = 0
        for tick, _, message in sorted(events, key=lambda event: (event[0], event[1])):
            result.append(message.copy(time=tick - previous))
            previous = tick
        result.append(mido.MetaMessage("end_of_track", time=end_tick - previous))
        output.tracks.append(result)
    return output


def main() -> None:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("mapping", type=Path)
    parser.add_argument("source", type=Path)
    parser.add_argument("output", type=Path)
    args = parser.parse_args()
    mapping = Alignment.load(args.mapping)
    # UTF-8 markers are informational; synthesis does not depend on them.
    output = align(mido.MidiFile(args.source), mapping)
    output.charset = "utf-8"
    args.output.parent.mkdir(parents=True, exist_ok=True)
    output.save(args.output)
    with args.output.with_suffix(".bars.tsv").open("w", newline="") as stream:
        writer = csv.writer(stream, delimiter="\t")
        writer.writerow(
            ["start_seconds", "end_seconds", "source_bar", "assessment", "section"]
        )
        for segment in mapping.segments:
            if segment.source_bars is None:
                writer.writerow(
                    [
                        f"{segment.start.total_seconds():.3f}",
                        f"{segment.end.total_seconds():.3f}",
                        None,
                        segment.assessment,
                        segment.label,
                    ]
                )
                continue
            first, last = segment.source_bars
            duration = (segment.end - segment.start) / (last - first + 1)
            for bar in range(first, last + 1):
                start = segment.start + duration * (bar - first)
                writer.writerow(
                    [
                        f"{start.total_seconds():.3f}",
                        f"{(start + duration).total_seconds():.3f}",
                        bar,
                        segment.assessment,
                        segment.label,
                    ]
                )


if __name__ == "__main__":
    main()

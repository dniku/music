import array
import json
import subprocess
import tempfile
import unittest
from datetime import timedelta
from io import StringIO
from pathlib import Path
from unittest.mock import patch

import mido

from align import Alignment, Assessment, Segment, align


class AlignmentTests(unittest.TestCase):
    def test_audio_preserves_initial_and_trailing_silence(self) -> None:
        Path("/tmp/codex").mkdir(exist_ok=True)
        with tempfile.TemporaryDirectory(dir="/tmp/codex") as directory:
            root = Path(directory)
            source = mido.MidiFile(ticks_per_beat=480)
            source.tracks.append(
                mido.MidiTrack(
                    [
                        mido.MetaMessage("set_tempo", tempo=500000),
                        mido.Message("note_on", note=60, velocity=100, time=960),
                        mido.Message("note_off", note=60, time=240),
                    ]
                )
            )
            source.save(root / "test.midi")
            subprocess.run(
                [
                    "render-midi-audition",
                    str(root / "test.midi"),
                    str(root / "test.mp3"),
                    "3",
                ],
                check=True,
                capture_output=True,
            )
            decoded = subprocess.run(
                [
                    "ffmpeg",
                    "-v",
                    "error",
                    "-i",
                    str(root / "test.mp3"),
                    "-ac",
                    "1",
                    "-ar",
                    "16000",
                    "-f",
                    "s16le",
                    "-",
                ],
                check=True,
                capture_output=True,
            )
            samples = array.array("h", decoded.stdout)
            self.assertAlmostEqual(len(samples) / 16000, 3, delta=0.03)
            self.assertLess(max(abs(x) for x in samples[:14400]), 20)
            self.assertGreater(max(abs(x) for x in samples[16800:19200]), 200)

    def test_mapping_rejects_gaps_overlaps_and_false_silences(self) -> None:
        for start, assessment in (
            (1, "unmapped"),
            (-1, "unmapped"),
            (0, "phrase_match"),
        ):
            with self.subTest(start=start, assessment=assessment):
                data = {
                    "schemaVersion": 1,
                    "beatsPerBar": 3,
                    "referenceDurationMs": 1000,
                    "segments": [
                        {
                            "startMs": start,
                            "endMs": 1000,
                            "sourceBars": None,
                            "label": "gap",
                            "assessment": assessment,
                        }
                    ],
                }
                with (
                    patch.object(Path, "open", return_value=StringIO(json.dumps(data))),
                    self.assertRaises(ValueError),
                ):
                    Alignment.load(Path("test-only.json"))

    def test_repeat_crop_gap_and_both_hands(self) -> None:
        source = mido.MidiFile(ticks_per_beat=480)
        for channel, pitch in ((0, 72), (1, 48)):
            source.tracks.append(
                mido.MidiTrack(
                    [
                        mido.Message("program_change", channel=channel, program=0),
                        mido.Message(
                            "note_on", channel=channel, note=pitch, velocity=75
                        ),
                        mido.Message(
                            "note_off", channel=channel, note=pitch, time=480 * 6
                        ),
                    ]
                )
            )
        # Excerpt begins and ends inside a tied note; replay it after a gap.
        mapping = Alignment(
            1,
            timedelta(seconds=5),
            (
                Segment(
                    timedelta(),
                    timedelta(seconds=1),
                    (2, 2),
                    "first",
                    Assessment.PHRASE_MATCH,
                ),
                Segment(
                    timedelta(seconds=1),
                    timedelta(seconds=3),
                    None,
                    "gap",
                    Assessment.UNMAPPED,
                ),
                Segment(
                    timedelta(seconds=3),
                    timedelta(seconds=5),
                    (2, 2),
                    "repeat",
                    Assessment.APPROXIMATE,
                ),
            ),
        )
        result = align(source, mapping)
        self.assertEqual(len(result.tracks), 3)
        for channel, track in enumerate(result.tracks[1:]):
            tick = 0
            events = []
            for message in track:
                tick += message.time
                if message.type in ("note_on", "note_off"):
                    self.assertEqual(message.channel, channel)
                    events.append((tick, message.type))
            self.assertEqual(
                events,
                [
                    (0, "note_on"),
                    (1000, "note_off"),
                    (3000, "note_on"),
                    (5000, "note_off"),
                ],
            )
        self.assertAlmostEqual(result.length, 5)
        self.assertEqual(source.tracks[0][-1].time, 480 * 6)

    def test_reject_nonexistent_bars(self) -> None:
        source = mido.MidiFile(ticks_per_beat=480)
        source.tracks.append(
            mido.MidiTrack(
                [
                    mido.Message("note_on", note=60),
                    mido.Message("note_off", note=60, time=480),
                ]
            )
        )
        mapping = Alignment(
            3,
            timedelta(seconds=1),
            (
                Segment(
                    timedelta(),
                    timedelta(seconds=1),
                    (2, 3),
                    "bad",
                    Assessment.PHRASE_MATCH,
                ),
            ),
        )
        with self.assertRaisesRegex(ValueError, "exceeds"):
            align(source, mapping)


if __name__ == "__main__":
    unittest.main()

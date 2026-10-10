"""Synthetic tests; no network access or reference video is needed."""

import unittest

from recover import (
    SOURCE,
    Hand,
    Note,
    beat_music,
    colour,
    key_centres,
    lilypond,
    occupied_keys,
    pitch_name,
    quantize,
    reconcile,
)


class RecoveryTests(unittest.TestCase):
    def test_keyboard(self) -> None:
        centres = key_centres()
        self.assertEqual(len(centres), 88)
        self.assertEqual(centres[21], 18)
        self.assertEqual(centres[108], 1902)
        self.assertAlmostEqual(centres[62], 905, delta=2)
        self.assertAlmostEqual(centres[66], 992, delta=2)

    def test_colour(self) -> None:
        self.assertEqual(colour(30, 65, 230), Hand.LEFT)
        self.assertEqual(colour(20, 240, 5), Hand.RIGHT)
        self.assertIsNone(colour(250, 250, 250))
        self.assertIsNone(colour(5, 5, 5))

    def test_white_bar_does_not_create_adjacent_black_note(self) -> None:
        centres = key_centres()
        row = bytearray(SOURCE.width * 3)
        for x in range(centres[64] - 14, centres[64] + 15):
            row[3 * x : 3 * x + 3] = bytes((20, 240, 5))
        self.assertEqual(occupied_keys(bytes(row), centres), {(Hand.RIGHT, 64)})

    def test_adjacent_notes_are_not_confused(self) -> None:
        centres = key_centres()
        for pitch in centres:
            row = bytearray(SOURCE.width * 3)
            half_width = 6 if pitch % 12 in (1, 3, 6, 8, 10) else 14
            for x in range(
                centres[pitch] - half_width, centres[pitch] + half_width + 1
            ):
                row[3 * x : 3 * x + 3] = bytes((30, 65, 230))
            self.assertEqual(occupied_keys(bytes(row), centres), {(Hand.LEFT, pitch)})

    def test_frame_grid(self) -> None:
        self.assertEqual(quantize(312, 319, 312), 0)
        self.assertEqual(quantize(327, 334, 312), 6)
        self.assertEqual(quantize(322, 329, 312), 4)  # Triplet eighth.
        self.assertEqual(quantize(320, 327, 312), 3)  # Sixteenth, rounded frame.
        self.assertIsNone(quantize(316, 319, 312))  # Short flash, not a note.
        with self.assertRaises(ValueError):
            quantize(312, 330, 312)

    def test_octaves_and_spelling(self) -> None:
        self.assertEqual(pitch_name(33, False), "a,,")
        self.assertEqual(pitch_name(60, False), "c'")
        self.assertEqual(pitch_name(70, True), "bes'")
        self.assertEqual(pitch_name(103, False), "g''''")

    def test_normal_beat(self) -> None:
        self.assertEqual(
            beat_music([Note(0, Hand.LEFT, 33), Note(6, Hand.LEFT, 45)], 0, False),
            "a,,8 a,8",
        )
        self.assertEqual(beat_music([], 0, False), "r4")

    def test_triplet_without_release_rests(self) -> None:
        notes = [Note(start, Hand.RIGHT, 72) for start in (0, 4, 8)]
        self.assertEqual(
            beat_music(notes, 0, False),
            r"\tuplet 3/2 { c''8 c''8 c''8 }",
        )

    def test_chord_and_invalid_overlap(self) -> None:
        self.assertEqual(
            beat_music([Note(0, Hand.RIGHT, p) for p in (60, 64, 67)], 0, False),
            "<c' e' g'>8 r8",
        )
        with self.assertRaises(AssertionError):
            beat_music([Note(0, Hand.RIGHT, 60), Note(1, Hand.RIGHT, 64)], 0, False)

    def test_initial_rest_and_beat_boundary_are_preserved(self) -> None:
        self.assertEqual(beat_music([Note(18, Hand.RIGHT, 60)], 12, False), "r8 c'8")

    def test_isolated_note_does_not_fill_the_following_silence(self) -> None:
        self.assertEqual(beat_music([Note(0, Hand.RIGHT, 60)], 0, False), "c'8 r8")
        self.assertEqual(beat_music([], 12, False), "r4")

    def test_real_sixteenth_in_bar_52_is_preserved(self) -> None:
        notes = [Note(0, Hand.RIGHT, 60), Note(9, Hand.RIGHT, 62)]
        self.assertEqual(beat_music(notes, 0, False), "c'8 r16 d'16")

    def test_extension_never_overlaps_next_attack(self) -> None:
        notes = [Note(0, Hand.RIGHT, 60), Note(3, Hand.RIGHT, 62)]
        self.assertEqual(beat_music(notes, 0, False), "c'16 d'8 r16")

    def test_scanline_disagreement_must_be_explicit(self) -> None:
        with self.assertRaises(AssertionError):
            reconcile(set(), set())

    def test_both_hands_have_complete_bars(self) -> None:
        music = lilypond([Note(0, Hand.LEFT, 33), Note(48, Hand.RIGHT, 64)])
        self.assertIn("pianoRollLeft", music)
        self.assertIn("pianoRollRight", music)
        self.assertEqual(music.count(r"\barNumberCheck #3"), 2)
        self.assertEqual(music.count("R1"), 2)


if __name__ == "__main__":
    unittest.main()

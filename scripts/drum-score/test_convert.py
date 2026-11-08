import re
import tempfile
import unittest
from collections import Counter
from fractions import Fraction
from pathlib import Path

from convert import DRUMS, ORIGIN_MS, quantize, read_hits, render


class DrumScoreTest(unittest.TestCase):
    def test_render_preserves_quantized_hits_across_rests_and_lines(self) -> None:
        hits = [(450, 36), (460, 42), (10_000, 38), (18_000, 42), (18_001, 42)]
        expected = Counter(
            DRUMS[note] for notes in quantize(hits).values() for note in notes
        )
        self.assertEqual(
            Counter(re.findall(r"\b(?:bd|sn|hh)\b", render(hits))), expected
        )

    def test_grid_and_simultaneous_hits(self) -> None:
        self.assertEqual(
            quantize([(450, 36), (460, 38), (593, 42), (1307, 36)]),
            {0: {36, 38}, 1: {42}, 6: {36}},
        )

    def test_duplicates_merge_only_same_instrument(self) -> None:
        self.assertEqual(quantize([(450, 36), (451, 36), (450, 42)]), {0: {36, 42}})

    def test_nearest_grid_point(self) -> None:
        for time in range(ORIGIN_MS, 10_000):
            [slot] = quantize([(time, 36)])
            self.assertLessEqual(
                abs(time - (ORIGIN_MS + Fraction(slot * 60_000, 420))),
                Fraction(60_000, 840),
            )

    def test_leading_silence_and_last_bar(self) -> None:
        score = render([(27_811, 36)])
        self.assertIn("R2.*32", score)
        self.assertIn("<bd>8 r8 r8 r8 r8 r8", score)
        self.assertIn("bar 33", score)

    def test_read_and_reject_wrong_timebase(self) -> None:
        with tempfile.TemporaryDirectory() as directory:
            path = Path(directory) / "drums.csv"
            source = "0, 0, Header, 1, 1, 1000\n1, 0, Tempo, 1000000\n1, 450, Note_on_c, 9, 36, 100\n"
            path.write_text(source)
            self.assertEqual(read_hits(path), [(450, 36)])
            path.write_text(source.replace("Tempo, 1000000", "Tempo, 500000"))
            with self.assertRaises(ValueError):
                read_hits(path)


if __name__ == "__main__":
    unittest.main()

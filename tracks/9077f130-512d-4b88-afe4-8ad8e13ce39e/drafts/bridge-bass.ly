\version "2.24.0"

\header {
  title = "Mother Earth — бридж"
  subtitle = "Трезвучия для левой руки · 3:19.31–4:19.31 · черновик"
  composer = "Within Temptation"
  tagline = \markup \fontsize #-2 \column {
    "По спектральному анализу записи YouTube FVbDZaUuNvQ. Упрощённая басовая опора, не транскрипция хора."
    "Рабочая гармонизация: удерживать аккорды до следующей смены. Тайминги и терции требуют проверки на слух."
  }
}

#(set-global-staff-size 18)
\paper {
  #(set-paper-size "a4")
  indent = 0\mm
  ragged-last-bottom = ##t
}

% Root changes are estimated on the same 3/4, quarter=210 grid as alignment.json.
% Working third choices from spectral comparison, not isolated choir voices.
% C#m -> C# at bar 15 and F#m -> F# at bar 47 retain the bass root.
\include "../bridge.ily"

bridgeMarks = {
  \override Score.RehearsalMark.self-alignment-X = #LEFT
  \override Score.RehearsalMark.font-size = #-2
  \mark \markup "3:19.31 · C♯m" s2.*6
  \mark \markup "3:24.45 · G♯" s2.*4
  \mark \markup "3:27.88 · C♯m" s2.*4
  \mark \markup "3:31.31 · C♯" s2.*4
  \mark \markup "3:34.74 · F♯m" s2.*4
  \mark \markup "3:38.16 · D" s2.*4
  \mark \markup "3:41.59 · F♯m" s2.*4
  \mark \markup "3:45.02 · G♯" s2.*4
  \mark \markup "3:48.45 · C♯" s2.*8
  \mark \markup "3:55.31 · F♯m" s2.*4
  \mark \markup "3:58.74 · F♯" s2.*4
  \mark \markup "4:02.16 · Bm" s2.*4
  \mark \markup "4:05.59 · F♯m" s2.*2
  \mark \markup "4:07.31 · C♯m" s2.*2
  \mark \markup "4:09.02" s2.*12
}

bass = { \clef bass \key e \major \time 3/4 \tempo 4 = 210 << \bridgeMusic \bridgeMarks >> }

\score {
  \new Staff \with { midiInstrument = "acoustic grand" } \bass
  \layout { }
  \midi { }
}

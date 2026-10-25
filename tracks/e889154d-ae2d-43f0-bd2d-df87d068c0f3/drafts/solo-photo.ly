\version "2.24.0"

% Transcribed from the user's handwritten photo, 2026-10-25.
% Each handwritten staff is one 4/4 bar; beat numbers are not fingerings.
% User confirmed: two triplets; crossed-out B4 omitted;
% the first D#5 in bar 3 is a grace note. Later edits tie C4 across bars 1–2
% and extend the final E5 into an added fourth bar.
% Unclear handwritten durations are a working reading, not a verified rhythm.
\header {
  title = "Blown Away"
  subtitle = "Соло по рукописи · черновик"
  composer = "Мои Ракеты Вверх"
  tagline = \markup \tiny \column {
    "По фото пользователя от 25.10.2026; неоднозначные длительности требуют проверки."
    "Темп 85 BPM выбран пользователем; в рукописи темп не указан."
  }
}

#(set-global-staff-size 20)
\paper {
  #(set-paper-size "a4")
  ragged-bottom = ##t
}

photoSolo = \absolute {
  \clef treble
  \key g \major
  \time 4/4
  \tempo 4 = 85
  e'4. fis'16 e'16
  \tuplet 3/2 { fis'8 g'16 } fis'8
  \tuplet 3/2 { fis'8 e'16 } c'8~ |
  \barNumberCheck #2
  \break
  c'4 fis'16 g'8. fis'4 c''8 b'16 c''16 |
  \barNumberCheck #3
  \break
  b'4. \acciaccatura dis''16 e''8 dis''4. e''8~ |
  \barNumberCheck #4
  e''1 |
  \barNumberCheck #5
  \bar "|."
}

\score {
  \new Staff \with { midiInstrument = "overdriven guitar" } <<
    \photoSolo
    % Visual beat boundaries, not additional measures:
    % https://lilypond.org/doc/v2.26/Documentation/notation/bars#bar-lines
    { \repeat unfold 4 { s4 \bar "!" s4 \bar "!" s4 \bar "!" s4 } }
  >>
  \layout { indent = 0 }
  \midi { }
}

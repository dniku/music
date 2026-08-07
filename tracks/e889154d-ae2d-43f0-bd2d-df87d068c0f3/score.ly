\version "2.24.0"

#(set-global-staff-size 18)

\paper {
  #(set-paper-size "a4")
  top-margin = 10\mm
  bottom-margin = 10\mm
  left-margin = 12\mm
  right-margin = 12\mm
  oddFooterMarkup = ##f
  evenFooterMarkup = ##f
}

\header {
  title = \markup \override #'(font-name . "DejaVu Sans") \bold "Blown Away"
  subtitle = \markup \override #'(font-name . "DejaVu Sans")
    "Соло — рабочая транскрипция · ♩ = 171"
  composer = \markup \override #'(font-name . "DejaVu Sans")
    "Мои Ракеты Вверх"
  tagline = ##f
}

% The pitch sequence originated in the user-supplied MusicXML. Durations were
% revised against the reference recording and promoted from rhythm candidate 2.
soloNotes = \absolute {
  \key g \major
  \time 4/4
  \tempo 4 = 171
  \partial 4.

  e'4. |
  e'4 fis'8 e' fis' g' fis'4 |
  fis'8 e' c'2. |
  fis'4 g' fis'2~ |
  fis'8 c'' b' c'' b'2~ |
  % Accepted after A/B comparison: the penultimate note is one whole note.
  b'8 e''4. es''2~ |
  es''2 e''2~ |
  e''1
}

\score {
  \new Staff \with {
    midiInstrument = "overdriven guitar"
  } {
    \soloNotes
    \bar "|."
  }

  \layout {
    indent = #0
    ragged-right = ##f
  }
}

% Keep the 10.9-second comparison window without printing its trailing silence.
\score {
  \new Staff \with {
    midiInstrument = "overdriven guitar"
  } {
    \soloNotes
    \cadenzaOn
    r4.
  }
  \midi { }
}

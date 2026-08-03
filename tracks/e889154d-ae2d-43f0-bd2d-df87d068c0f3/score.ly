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
    "Соло — транскрипция из MusicXML · ♩ = 120"
  composer = \markup \override #'(font-name . "DejaVu Sans")
    "Мои Ракеты Вверх"
  tagline = ##f
}

% Converted with musicxml2ly and cleaned by hand: the source contained an empty
% bass staff and 27 trailing empty measures. The source did not specify tempo.
soloNotes = \absolute {
  \key g \major
  \time 4/4
  \tempo 4 = 120

  e'4 e' fis' e' |
  fis' g' fis' fis' |
  e' c' fis' g' |
  fis' c'' b' c'' |
  b' e'' es'' e'' |
  \bar "|."
}

\score {
  \new Staff \with {
    midiInstrument = "overdriven guitar"
  } {
    \soloNotes
  }

  \layout {
    indent = #0
    ragged-right = ##f
  }

  \midi { }
}

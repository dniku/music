\version "2.24.0"

#(set-global-staff-size 18)

\paper {
  #(set-paper-size "a4")
  top-margin = 10\mm
  bottom-margin = 10\mm
  left-margin = 12\mm
  right-margin = 12\mm
  system-system-spacing.basic-distance = #18
  ragged-bottom = ##t
  oddFooterMarkup = ##f
  evenFooterMarkup = ##f
}

\header {
  title = \markup \override #'(font-name . "DejaVu Sans") \bold
    "Lost in Space"
  subtitle = \markup \override #'(font-name . "DejaVu Sans")
    "Начало соло · все длительности пока условно 1/8"
  subsubtitle = \markup \override #'(font-name . "DejaVu Sans")
    "Прослушивание: ♩ = 122"
  composer = \markup \override #'(font-name . "DejaVu Sans") "Avantasia"
  tagline = ##f
}

global = {
  \numericTimeSignature
  \time 4/4
}

% Only the pitches and octaves are transcribed. Equal eighth notes, bar lines,
% and tempo are temporary scaffolding for notation and audition.
soloNotes = \absolute {
  e'8 d'' e' cis'' e' b' e' d' |
  e' d'' e' cis'' e' b' e' b |
  fis'' a'' fis'' fis'' a'' fis'' s4 |
}

blankSystem = {
  \repeat unfold 8 { s1 | }
  \break
}

layoutMusic = {
  \global
  \soloNotes
  \repeat unfold 5 { s1 | }
  \break
  \repeat unfold 3 { \blankSystem }
  \bar "|."
}

\score {
  \new Staff {
    \layoutMusic
  }

  \layout {
    indent = #0
    ragged-right = ##f
  }
}

\score {
  \new Staff \with {
    midiInstrument = "overdriven guitar"
  } {
    \global
    \tempo 4 = 122
    \soloNotes
    \bar "|."
  }
  \midi { }
}

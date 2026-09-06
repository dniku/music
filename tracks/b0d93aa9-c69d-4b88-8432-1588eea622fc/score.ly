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

% Only the pitches, octaves, and hand split are transcribed. Equal eighth
% notes, bar lines, and tempo are temporary scaffolding.
leftHandSoloNotes = \absolute {
  e'8 d'' e' cis'' e' b' e' d' |
  e' d'' e' cis'' e' b' e' b |
  s1 |
}

rightHandSoloNotes = \absolute {
  s1 | s1 |
  fis''8 a'' fis'' fis'' a'' fis'' s4 |
}

blankSystem = {
  \repeat unfold 8 { s1 | }
  \break
}

remainingBlankGrid = {
  \repeat unfold 5 { s1 | }
  \break
  \repeat unfold 3 { \blankSystem }
  \bar "|."
}

leftHandLayoutMusic = {
  \global
  \clef treble
  \leftHandSoloNotes
  \remainingBlankGrid
}

rightHandLayoutMusic = {
  \global
  \clef treble
  \rightHandSoloNotes
  \remainingBlankGrid
}

\score {
  \new PianoStaff <<
    \new Staff \with {
      instrumentName = "П. р."
    } {
      \rightHandLayoutMusic
    }
    \new Staff \with {
      instrumentName = "Л. р."
    } {
      \leftHandLayoutMusic
    }
  >>

  \layout {
    indent = #0
    ragged-right = ##f
  }
}

\score {
  \new PianoStaff <<
    \new Staff \with {
      midiInstrument = "overdriven guitar"
    } {
      \global
      \tempo 4 = 122
      \rightHandSoloNotes
      \bar "|."
    }
    \new Staff \with {
      midiInstrument = "overdriven guitar"
    } {
      \global
      \leftHandSoloNotes
      \bar "|."
    }
  >>
  \midi { }
}

\version "2.24.0"

melody = \relative c'' {
  \clef treble
  \key e \minor
  \time 4/4
  e'4 b4 e,2 | R1 |
  e4 g8 b e2\mordent |
  g,4 b8 d~ d2\mordent |
}

harmonies = \chordmode {
  e1:m | g2 d |
  e1:m | g2 d |
}

\header {
  title = "Волки Океана"
  subtitle = "Альтернативное раннее соло с мордентами"
  composer = "Атом-76"
  tagline = ##f
}

\score {
  <<
    \new ChordNames {
      \set chordChanges = ##t
      \harmonies
    }
    \new Staff \with {
      midiInstrument = "lead 2 (sawtooth)"
    } \melody
  >>
  \layout {
    indent = #0
    \context {
      \Score
      barNumberVisibility = #all-bar-numbers-visible
      \override BarNumber.break-visibility = #end-of-line-invisible
      \override BarNumber.font-size = #-2
    }
  }
}

\score {
  \new Staff \with {
    midiInstrument = "lead 2 (sawtooth)"
  } \scaleDurations 2/1 { \melody }
  \midi { \tempo 4 = 165 }
}

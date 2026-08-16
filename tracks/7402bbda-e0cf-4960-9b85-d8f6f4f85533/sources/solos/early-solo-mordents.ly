\version "2.24.0"

melody = \relative c'' {
  \clef treble
  \key e \minor
  \time 4/4
  e'2 b | e,1 |
  R1 | R |
  r2 e2 |
  g4 b e2\mordent |
  r2 g,2 |
  b4 d d2\mordent |
}

harmonies = \chordmode {
  e1:m | e:m | g1 | d |
  e1:m | e:m | g1 | d |
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
      \override BarNumber.font-size = #-2
    }
  }
}

\score {
  \new Staff \with {
    midiInstrument = "lead 2 (sawtooth)"
  } \melody
  \midi { \tempo 4 = 165 }
}

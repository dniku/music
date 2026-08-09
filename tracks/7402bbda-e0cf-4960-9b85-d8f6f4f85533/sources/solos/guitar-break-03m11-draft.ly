\version "2.24.0"
\include "../../music.ily"

\header {
  title = "Волки Океана"
  subtitle = "Черновой гитарный проигрыш · 3:11"
  composer = "Атом-76"
  tagline = ##f
}

\score {
  \new Staff \with {
    midiInstrument = "overdriven guitar"
  } {
    \global
    \guitarBreakDraftNotes
    \bar "|."
  }
  \layout {
    indent = #0
    \context {
      \Score
      barNumberVisibility = #all-bar-numbers-visible
      \override BarNumber.font-size = #-2
    }
  }
  \midi { }
}

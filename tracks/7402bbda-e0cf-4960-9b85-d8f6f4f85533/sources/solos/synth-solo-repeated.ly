\version "2.24.0"
\include "../../music.ily"

\header {
  title = "Волки Океана"
  subtitle = "Повторяющееся синтезаторное соло"
  composer = "Атом-76"
  tagline = ##f
}

\score {
  \new Staff { \soloMusic }
  \layout {
    indent = #0
    \context {
      \Score
      barNumberVisibility = #all-bar-numbers-visible
      \override BarNumber.break-visibility = #end-of-line-invisible
      \override BarNumber.font-size = #-2
    }
  }
  \midi { }
}

\version "2.24.0"
\include "../../music.ily"

\header {
  title = "Волки Океана"
  subtitle = "Вступление 0:00.00–0:12.30 · 6 повторений"
  composer = "Атом-76"
  tagline = ##f
}

\score {
  \new Staff { \introMusic }
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
  \new Staff { \unfoldRepeats { \introMusic } }
  \midi { }
}

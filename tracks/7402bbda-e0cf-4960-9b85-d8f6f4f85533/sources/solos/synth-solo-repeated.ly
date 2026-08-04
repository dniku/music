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
  \layout { indent = #0 }
  \midi { }
}

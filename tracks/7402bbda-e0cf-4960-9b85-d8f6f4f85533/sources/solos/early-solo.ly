\version "2.24.0"
\include "../../music.ily"

\header {
  title = "Волки Океана"
  subtitle = "Раннее соло 0:58.80–1:10.80"
  composer = "Атом-76"
  tagline = ##f
}

\score {
  \new Staff { \earlySoloMusic }
  \layout { indent = #0 }
  \midi { }
}

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
    "Пустой шаблон"
  composer = \markup \override #'(font-name . "DejaVu Sans") "Avantasia"
  tagline = ##f
}

% The 4/4 grid is provisional until transcription establishes the real meter.
blankSystem = {
  \repeat unfold 8 { s1 | }
  \break
}

blankGrid = {
  \numericTimeSignature
  \time 4/4
  \repeat unfold 4 { \blankSystem }
  \bar "|."
}

\score {
  \new Staff {
    \blankGrid
  }

  \layout {
    indent = #0
    ragged-right = ##f
  }
}

\score {
  \new Staff {
    \blankGrid
  }
  \midi { }
}

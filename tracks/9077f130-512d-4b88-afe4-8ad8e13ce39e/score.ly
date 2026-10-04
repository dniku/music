\version "2.24.0"

\include "music.ily"

#(set-global-staff-size 18)

\paper {
  #(set-paper-size "a4")
  top-margin = 10\mm
  bottom-margin = 10\mm
  left-margin = 12\mm
  right-margin = 12\mm
}

\header {
  title = \markup \override #'(font-name . "DejaVu Sans") \bold "Mother Earth"
  subtitle = \markup \override #'(font-name . "DejaVu Sans")
    "Мелодия и аккорды · фрагмент"
  composer = \markup \override #'(font-name . "DejaVu Sans") "Within Temptation"
  copyright = \markup \tiny \with-url "https://ytpa.ch/en/piece?scoreId=FVbDZaUuNvQ"
    "Play-Along this score on YouTube on https://ytpa.ch"
  tagline = ##f
}

\score {
  <<
    \new ChordNames { \harmonies }
    \new Staff { \melody }
  >>
  \layout {
    indent = #0
    ragged-right = ##f
  }
}

% Play the imported chord events without inventing an accompaniment pattern.
\score {
  <<
    \new Staff = "melody" \with {
      midiInstrument = "acoustic grand"
    } { \melody }
    \new Staff = "chords" \with {
      midiInstrument = "acoustic grand"
    } {
      \time 3/4
      % Chord symbols have no register; use an octave below chordmode's default.
      \transpose c c, { \harmonies }
    }
  >>
  \midi { }
}

\version "2.24.0"
\include "piano-roll.ily"

#(set-global-staff-size 16)
\paper {
  #(set-paper-size "a4")
  top-margin = 10\mm
  bottom-margin = 10\mm
  left-margin = 12\mm
  right-margin = 12\mm
  ragged-last-bottom = ##f
}
\header {
  title = \markup \override #'(font-name . "DejaVu Sans") \bold "Lost in Space"
  subtitle = \markup \override #'(font-name . "DejaVu Sans")
    "Piano roll Alejandro Ríos · черновая транскрипция"
  subsubtitle = \markup \override #'(font-name . "DejaVu Sans")
    "Короткие нажатия и паузы сохранены буквально; педаль и динамика не восстановлены"
  composer = "Avantasia · Tobias Sammet"
  arranger = \markup \override #'(font-name . "DejaVu Sans") "Аранжировка: Alejandro Ríos"
  copyright = \markup \tiny \override #'(font-name . "DejaVu Sans")
    \with-url "https://www.youtube.com/watch?v=_-DEer9afE0"
    "Источник: YouTube _-DEer9afE0 · рамки над нотами — время в видео"
  tagline = ##f
}

pianoRollMusic = \new PianoStaff <<
  \new Staff = "right" \with { midiInstrument = "acoustic grand" } {
    \clef treble
    \numericTimeSignature
    \time 4/4
    \pianoRollTempo
    \pianoRollRight
  }
  \new Staff = "left" \with { midiInstrument = "acoustic grand" } {
    \clef bass
    \numericTimeSignature
    \time 4/4
    \pianoRollLeft
  }
>>

\score {
  \pianoRollMusic
  \layout {
    indent = #0
    ragged-right = ##f
  }
  \midi { }
}

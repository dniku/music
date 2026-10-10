\version "2.24.0"
\include "piano-roll.ily"
\include "piano-roll-lyrics.ily"

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
    "Черновая транскрипция piano roll"
  subsubtitle = \markup \override #'(font-name . "DejaVu Sans")
    \center-column {
      "Ритмическая запись упрощена; педаль и динамика не восстановлены"
      \small "Текст привязан к фразам приблизительно, не послогово"
    }
  composer = "Avantasia"
  copyright = \markup \tiny \override #'(font-name . "DejaVu Sans")
    \with-url "https://www.youtube.com/watch?v=_-DEer9afE0"
    "На основе piano roll Alejandro Ríos · рамки над нотами — время в видео"
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
  \tag #'layout \new Lyrics \with {
    alignAboveContext = "right"
    \override LyricText.font-name = "DejaVu Sans"
    \override LyricText.font-size = #-2
    \override LyricText.self-alignment-X = #LEFT
  } \pianoRollLyrics
  \new Staff = "left" \with { midiInstrument = "acoustic grand" } {
    \clef bass
    \numericTimeSignature
    \time 4/4
    \pianoRollLeft
  }
>>

\score {
  \keepWithTag #'layout \pianoRollMusic
  \layout {
    indent = #0
    ragged-right = ##f
  }
}

% Keep the existing MIDI byte-for-byte: the phrase guide is PDF-only.
\score {
  \removeWithTag #'layout \pianoRollMusic
  \midi { }
}

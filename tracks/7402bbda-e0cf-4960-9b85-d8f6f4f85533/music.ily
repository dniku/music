global = {
  \key e \minor
  \numericTimeSignature
  \time 4/4
  \tempo 4 = 165
}

introNotes = \fixed c' {
  \set countPercentRepeats = ##t
  \repeat percent 6 {
    e8 b g fis a b g fis |
  }
  e8 b g fis b g fis e~ |

  % Hold the final E through an extra half-measure before bar 8.
  \set Score.currentBarNumber = #7
  \time 2/4
  e2 |
  \time 4/4
}

introMusic = {
  \global
  \set Staff.midiInstrument = "lead 2 (sawtooth)"
  \introNotes
}

introAlignment = {
  \repeat unfold 7 { s1 | }
  s2 |
}

soloNotes = \absolute {
  \ottava #1

  e''8 d'' e'' fis'' e'' d'' e'' fis'' |
  e'' d'' e'' fis'' g'' fis'' e'' d'' |
  g''1 |
  d'' |
  \bar "||"

  g''8 fis'' g'' a'' b'' a'' g'' fis'' |
  b'' a'' g'' fis'' e'' d'' e'' fis'' |
  d''1 |
  e'' |
  \ottava #0
}

soloMusic = {
  \global
  \set Staff.midiInstrument = "lead 2 (sawtooth)"
  \soloNotes
  \bar "|."
}

earlySoloNotes = \absolute {
  e''2 b' |
  e'1 |
  r1 |
  r1 |
  r2 e'2 |
  g'4 b' e''2 |
  r2 e'2 |
  g'4 b' d''2 |
}

earlySoloMusic = {
  \global
  \set Staff.midiInstrument = "lead 2 (sawtooth)"
  \earlySoloNotes
  \bar "|."
}

guitarBreakDraftNotes = \absolute {
  \repeat unfold 2 {
    \tuplet 3/2 { e''8 g'' b'' }
    \tuplet 3/2 { e''' b'' g'' }
    \tuplet 3/2 { e'' b' g' }
    \tuplet 3/2 { e' g' b' } |
  }
  \repeat unfold 2 {
    \tuplet 3/2 { d''8 fis'' a'' }
    \tuplet 3/2 { d''' a'' fis'' }
    \tuplet 3/2 { d'' a' fis' }
    \tuplet 3/2 { d' fis' a' } |
  }
}

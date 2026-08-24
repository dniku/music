global = {
  \key e \minor
  \numericTimeSignature
  \time 4/4
  \tempo 4 = 165
}

% Synthesizer program numbers used in the score and audition MIDI files.
#(define instruments '(
    ("102" . "lead 2 (sawtooth)")
    ("463" . "pad 2 (warm)")
    ("001" . "acoustic grand")
))

#(define em-dash (string (integer->char #x2014)))

part = #(define-music-function (idx text) (string? string?) #{
  \set Staff.midiInstrument = #(cdr (assoc idx instruments))
  \textMark \markup { \box { #text \bold { #idx } } }
#})

#(define (instrument-legend) #{
  \markup \line {
    #@(map
      (lambda (entry)
        (string-append (car entry) " " em-dash " " (cdr entry) "   "))
      instruments)
  }
#})

introNotes = \fixed c' {
  \set countPercentRepeats = ##t
  \repeat percent 6 {
    e8 b g fis a b g fis |
  }
  e8 b g fis b g fis \tieDown e~ \tieNeutral |

  % Hold the final E through measure 8, a half-measure transition.
  \time 2/4
  e2 |
  \time 4/4
}

introMusic = {
  \global
  \set Staff.midiInstrument = #(cdr (assoc "102" instruments))
  \introNotes
}

introAlignment = {
  \repeat unfold 7 { s1 | }
  s2 |
}

soloNotes = \absolute {
  \set Staff.midiInstrument = #(cdr (assoc "102" instruments))
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
  \set Staff.midiInstrument = #(cdr (assoc "102" instruments))
  \soloNotes
  \bar "|."
}

earlySoloNotes = \absolute {
  \clef "treble_8"
  e'2 b | e1 |
  R1 | R |
  e2 g4 b |
  e'1 |
  g1 |
  b2 d'4 d' |
  \clef treble
}

earlySoloMusic = {
  \global
  \set Staff.midiInstrument = #(cdr (assoc "102" instruments))
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

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
  \override Fingering.direction = #UP
  \ottava #1

  e''8-2 d''-1 e''-2 fis''-3 e''-2 d''-1 e''-2 fis''-3 |
  e''-2 d''-1 e''-2 fis''-3 g''-4 fis''-3 e''-2 d''-1 |
  g''1-5 |
  d''-1 |
  \bar "||"

  g''8-2 fis''-1 g''-2 a''-3 b''-5 a''-4 g''-3 fis''-2 |
  b''-5 a''-4 g''-3 fis''-2 e''-1 d''-3 e''-4 fis''-5 |
  d''1-1 |
  e''-2 |
  \ottava #0
  \revert Fingering.direction
}

soloMusic = {
  \global
  \set Staff.midiInstrument = #(cdr (assoc "102" instruments))
  \soloNotes
  \bar "|."
}

earlySoloNotes = \absolute {
  \clef "treble_8"
  \override Fingering.direction = #UP
  e'2-5 b-2 | e1-1 |
  R1 | R |
  e2-1 g4-2 b-4 |
  e'1-5 |
  g1-1 |
  b2-2 d'4-4 d'-4 |
  \revert Fingering.direction
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

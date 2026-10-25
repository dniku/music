\version "2.24.0"

#(set-global-staff-size 18)

\paper {
  #(set-paper-size "a4")
  top-margin = 10\mm
  bottom-margin = 10\mm
  left-margin = 12\mm
  right-margin = 12\mm
  oddFooterMarkup = ##f
  evenFooterMarkup = ##f
}

\header {
  title = \markup \override #'(font-name . "DejaVu Sans") \bold "Blown Away"
  subtitle = \markup \override #'(font-name . "DejaVu Sans")
    "Соло, текст и аккорды · ♩ = 85"
  composer = \markup \override #'(font-name . "DejaVu Sans")
    "Мои Ракеты Вверх"
  tagline = ##f
}

% Promoted from the user's handwritten score and subsequent corrections,
% retained as drafts/solo-photo.ly (2026-10-25).
soloNotes = \absolute {
  \clef treble
  \key g \major
  \time 4/4
  \tempo 4 = 85
  e'4. fis'16 e'16
  \tuplet 3/2 { fis'8 g'16 } fis'8
  \tuplet 3/2 { fis'8 e'16 } c'8~ |
  \barNumberCheck #2
  \break
  c'4 fis'16 g'8. fis'4 c''8 b'16 c''16 |
  \barNumberCheck #3
  \break
  b'4. \acciaccatura dis''16 e''8 dis''4. e''8~ |
  \barNumberCheck #4
  e''1 |
  \barNumberCheck #5
  \bar "|."
}

\score {
  \new Staff \with {
    midiInstrument = "overdriven guitar"
  } <<
    \soloNotes
    { \repeat unfold 4 { s4 \bar "!" s4 \bar "!" s4 \bar "!" s4 } }
  >>

  \layout {
    indent = #0
    ragged-right = ##f
  }
}

% Chord spellings use whole notes as diagrams, not as a rhythmic transcription.
% Gm6/9 preserves the user's four pitch classes (G, A, E, Bb), omitting D.
% Gm9 and C half-diminished use suggested compact voicings.
gMinorSixNine = { <g' a' bes' e''>1^"Gm6/9" }
gMinorNine = { <g' a' bes' d'' f''>1^"Gm9" }

chordGuideSetup = {
  \clef treble
  \cadenzaOn
  \accidentalStyle forget
}

chordGuideLayout = \layout {
  indent = #0
  line-width = 110\mm
  ragged-right = ##f
  \context {
    \Staff
    \omit TimeSignature
  }
  \context {
    \Score
    \omit BarNumber
  }
  \context {
    \Voice
    \override TextScript.font-name = #"DejaVu Sans"
  }
}

\markup \override #'(font-name . "DejaVu Sans") "Куплет (по кругу):"
\score {
  \new Staff {
    \chordGuideSetup
    <e' gis' b'>1^"E" \bar "|"
    <cis' e' gis'>1^"C#m" \bar "|"
    <c' e' g'>1^"C" \bar "|."
  }
  \layout { \chordGuideLayout }
}

\markup \override #'(font-name . "DejaVu Sans") "Припев:"
\score {
  \new Staff {
    \chordGuideSetup
    \gMinorSixNine \bar "|"
    \gMinorNine \bar "|"
    \gMinorSixNine \bar "|"
    \gMinorNine \bar "|."
  }
  \layout { \chordGuideLayout }
}

\markup \override #'(font-name . "DejaVu Sans") "Бридж (чередовать):"
\score {
  \new Staff {
    \chordGuideSetup
    \gMinorNine \bar "|"
    <c' ees' ges' bes'>1^"Cø7" \bar "|."
  }
  \layout { \chordGuideLayout }
}

% Lyrics supplied by the user; preserve the wording as given.
\markup \override #'(font-name . "DejaVu Sans") \fontsize #1
\override #'(baseline-skip . 3.5) \column {
  \vspace #1
  \bold "Текст"
  "Wake me up before I hit the ground"
  "Be my smile when I got out"
  "Read my lips when we have to hide"
  "Say something in an awkward silence"

  \vspace #0.6
  "Be my hero, be my shame,"
  "My killer when the war ends"

  \vspace #0.6
  "Be my friend when we got to hide"
  "Be my mentor on the way down"
  "Be my dream when I lost you"
  "Be my guide when it comes true"

  \vspace #0.6
  "Wind has blown, my wind blows away"
  "I 's [was] just sitting and staring at it night and day"
  "Wind just passed and left me in my room"
  "I got lost my summertimes in bloom"
}

\score {
  \new Staff \with {
    midiInstrument = "overdriven guitar"
  } {
    \soloNotes
  }
  \midi { }
}

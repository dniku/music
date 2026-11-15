\version "2.24.3"
\pointAndClickOff
#(set-global-staff-size 16)

\paper {
  #(set-paper-size "a4")
  top-margin = 12\mm
  bottom-margin = 12\mm
  left-margin = 14\mm
  right-margin = 14\mm
  ragged-last-bottom = ##t
}
\header {
  title = "The Dragonborn Comes"
  subtitle = "A Skyrim bard song · Фортепиано"
  composer = "Jeremy Soule"
  arranger = "Транскрипция: Marcuste"
  tagline = \markup \override #'(font-name . "DejaVu Sans") \fontsize #-3 \column {
    \line { "Источник:" \with-url "https://musescore.com/user/8584016/scores/2238101" "https://musescore.com/user/8584016/scores/2238101" }
    \line { "С рукописными исправлениями и аппликатурой из предоставленного PDF." }
  }
}

global = { \key cis \minor }

melodyNine = {
  gis'8-5 cis'-1 e'-3 fis'8.-4 fis'16 fis'8
  dis'8.-3 cis'16-2 b8-1 cis'4.-2) |
}
melodyThirteen = {
  gis'8-5 cis'-1 e'-3 fis'8.-4 fis'16 fis'8
  dis'8.-2 e'16-3 fis'8-4 cis'4.-1) |
}
melodyEleven = {
  <cis' cis''>4 <dis' dis''>8 <e' e''>4 <e' e''>8
  <dis' dis''>8. <cis' cis''>16 <b b'>8 <cis' cis''>4.) |
}
answerRight = { gis'8-2\pp cis''2.-5\mp r2 <gis gis'>8\mp( | }
pickupRight = { r2 r2 r4 r8 gis'8-5\mf( | }

right = {
  \global
  \set fingeringOrientations = #'(up)
  \time 4/4 \tempo 4 = 75
  R1 |
  \time 3/4 R2. |
  \time 4/4 R1 |
  \time 3/4 r2 r8 gis8-1\mp( |
  \time 12/8 \tempo 4. = 50
  cis'8-2 cis' dis' e'4 fis'8 dis'8.-3 cis'16-2 b8-1 cis'4. |
  gis'8-2\pp) cis''2.-5 r2 <gis gis'>8\mp( |
  <cis' cis''>8 <cis' cis''> <dis' dis''> <e' e''>8. <e' e''>16 <fis' fis''>8
  <dis' dis''>8. <cis' cis''>16 <b b'>8 <cis' cis''>4.) |
  \pickupRight
  \barNumberCheck #9
  \melodyNine
  \answerRight \melodyEleven \pickupRight
  \melodyThirteen
  \answerRight \melodyEleven \pickupRight
  \melodyThirteen
  gis'8-2\pp cis''2.-5\mp r2 gis'8-5\mf( |
  \melodyNine
  r2. r2 cis'8-2( dis'-3 |
  \barNumberCheck #21
  \time 3/4
  e'2-4) e'8-1( fis'-2 |
  gis'2-3) gis'8-3( b'-5 |
  fis'2-2) e'8.-4( dis'16-3 |
  cis'2-2) <cis cis'>8( <dis dis'> |
  <e e'>2) <e e'>8( <fis fis'> |
  <gis gis'>2) <gis gis'>8( <b b'> |
  <cis' cis''>2) <b b'>8( <dis' dis''> |
  <cis' cis''>2) cis''8-3( dis''-4 |
  <e'-1 e''-5>4 dis''-4 cis''-3 |
  <cis'-1 b'-5>4 a'-4 gis'-3 |
  <dis'-1 fis'-2>2) e'8-2( gis'-4 |
  \barNumberCheck #32
  \pageBreak
  % The handwritten 6/8 replaces printed 3/4 through both endings (bar 41).
  \time 6/8
  <cis'-1 fis'-3>2) r8 e''16\f( dis'' |
  \repeat volta 2 {
    e''4) e''16( dis'' e''4) dis''16( e'' |
    fis''8 e'' dis'' cis''4 cis''16 b' |
    cis''4) cis''16( b' cis''4) b'16( cis'' |
    dis''8 e'' b' cis''4) <e' e''>16\ff( <dis' dis''> |
    <e' e''>8) <e' e''>8 <e' e''>16( <fis' fis''> <gis' gis''>4) <dis' dis''>16( <e' e''> |
    <fis' fis''>8) <e' e''> <dis' dis''> <cis' cis''>4 <cis' cis''>16( <b b'> |
    <cis' cis''>4) <cis' cis''>16( <b b'> <cis' cis''>4) <b b'>16( <cis' cis''> |
  }
  \alternative {
    { <dis' dis''>8) <e' e''> <b b'> <cis' cis''>4 e''16( dis'') | }
    { dis''8\f e'' b' cis''4.\mf | }
  }
  \barNumberCheck #42
  \time 5/4 R1*5/4 |
  \time 4/4 R1 |
  \time 3/4 r2 r8 gis8\mp( |
  \time 12/8
  cis'8 cis' dis' e'4 fis'8 dis'8. cis'16 b8 cis'4. |
  gis'8\pp cis''2.) r8 r4 r8 gis8( |
  cis'8 cis' dis' e'8. e'16 fis'8 dis'8. cis'16 b8 cis'4. |
  gis'8\pp cis''2.) r8 r4 r8 \clef bass <gis gis'>8\mf( |
  \barNumberCheck #49
  <gis gis'>8 <cis cis'> <e e'> <fis fis'>8. <fis fis'>16 <fis fis'>8
  <dis dis'>8. <cis cis'>16 <b, b>8 <cis cis'>4. |
  \clef treble gis'8\pp cis''2.) r8 r4 r8 gis8\mf( |
  cis'8 cis' dis' e'4 e'8 dis'8. cis'16 b8 cis'4.) |
  R1. |
  \time 4/4 R1 |
  \time 3/4 R2. |
  \time 4/4 R1 |
  \time 3/4 R2. |
  \time 4/4 R1 \bar "|."
}

introLeft = { cis8\sustainOn gis cis'4. gis8 cis gis\sustainOff | }
accompaniment = {
  cis8\sustainOn gis cis'2 b,8\sustainOff\sustainOn fis b
  cis\sustainOff\sustainOn gis cis'~ |
}
accompanimentOctaves = {
  <cis, cis>8\sustainOn gis cis'2 <b,, b,>8\sustainOff\sustainOn fis b
  <cis, cis>\sustainOff\sustainOn gis cis'~ |
}
answerLeft = { cis'4. gis8 cis gis a2.\sustainOff | }
left = {
  \global \clef bass
  \set fingeringOrientations = #'(down)
  \set Staff.pedalSustainStyle = #'bracket
  \time 4/4 <>\mf \introLeft
  \time 3/4 a2. |
  \time 4/4 <>\> \introLeft
  \time 3/4 a2.\! |
  \time 12/8
  \accompaniment \answerLeft
  \accompaniment \answerLeft
  \accompaniment \answerLeft
  \accompaniment \answerLeft
  \accompaniment \answerLeft
  \accompaniment \answerLeft
  \accompaniment \answerLeft
  \accompaniment \answerLeft
  \barNumberCheck #21
  \time 3/4
  <cis gis cis'>2.\arpeggio\sustainOn |
  <e b e'>2.\sustainOff\sustainOn |
  <cis fis b>2.\arpeggio\sustainOff\sustainOn |
  <fis, cis fis>2.\sustainOff\sustainOn |
  % Red crosses remove only the indicated note, not its chord or pedal.
  cis8\sustainOff\sustainOn gis cis'2 <>\sustainOff |
  e8\sustainOn b e'2 <>\sustainOff |
  gis,8\sustainOn dis gis2 <>\sustainOff |
  fis,8\sustainOn cis fis2 <>\sustainOff |
  <cis cis'>8.\sustainOn <cis cis'>8. <cis cis'>8~ <cis cis'> <cis cis'> <>\sustainOff |
  <a, a>8.\sustainOn <a, a>8. <a, a>8~ <a, a> <a, a> <>\sustainOff |
  <b, b>8.\sustainOn <b, b>16 <b, b>2 <>\sustainOff |
  \time 6/8
  <fis, fis>8.\sustainOn <fis, fis>16 <fis, fis>2 <>\sustainOff |
  \repeat volta 2 {
    <cis cis'>8\sustainOn <gis gis'>4 <a, a>8\sustainOff\sustainOn <e e'>4\sustainOff |
    <b, b>8\sustainOn <fis fis'>4 <fis, fis>8\sustainOff\sustainOn <cis cis'>4\sustainOff |
    <a, a>8\sustainOn <e e'>4 <fis, fis>8\sustainOff\sustainOn <b, b>4\sustainOff |
    <b, b>8\sustainOn <fis fis'>4 <cis cis'>8\sustainOff\sustainOn <gis gis'>4\sustainOff |
    cis8\sustainOn <gis cis'>4 e8\sustainOff\sustainOn <b e'>4\sustainOff |
    b,8\sustainOn <fis b>4 cis8\sustainOff\sustainOn <gis cis'>4\sustainOff |
    a,8\sustainOn <e a>4 fis,8\sustainOff\sustainOn <cis fis>4\sustainOff |
  }
  \alternative {
    { b,8\sustainOn <fis b>4 cis8\sustainOff\sustainOn <gis cis'>4\sustainOff | }
    { b,8\sustainOn fis4 cis8\sustainOff\sustainOn gis cis'~ | }
  }
  \barNumberCheck #42
  \time 5/4 cis'4 gis8 cis gis a2~\sustainOff a8 |
  \time 4/4 \introLeft
  \time 3/4 a2. |
  \time 12/8
  \accompaniment \answerLeft
  \accompanimentOctaves \answerLeft
  \accompanimentOctaves \answerLeft
  \accompanimentOctaves \answerLeft
  \barNumberCheck #53
  \time 4/4
  <cis, cis>8\mp\sustainOn gis cis'4. gis8 cis gis\sustainOff |
  \time 3/4 a2. |
  \time 4/4 <cis, cis>8\pp\sustainOn gis cis'4. gis8 cis gis\sustainOff |
  \time 3/4 <a, a>2. |
  \time 4/4 <cis, cis>1\fermata |
}

#(if (not (equal? (ly:music-length right) (ly:music-length left)))
     (ly:error "Dragonborn Comes: hand durations differ"))

piano = \new PianoStaff <<
  \new Staff \with { midiInstrument = "acoustic grand" } \right
  \new Staff \with { midiInstrument = "acoustic grand" } \left
>>
\score {
  \piano
  \layout {
    indent = #0
    \context { \Score \override Fingering.color = #red }
  }
}
\score { \unfoldRepeats \piano \midi { } }

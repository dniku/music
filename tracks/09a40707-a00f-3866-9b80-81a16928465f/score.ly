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
  page-count = 2
}
\header {
  title = "Танец маленьких лебедей"
  subtitle = "«Лебединое озеро», соч. 20 · Фортепиано"
  composer = "П. И. Чайковский"
  tagline = \markup \override #'(font-name . "DejaVu Sans") \fontsize #-3 \column {
    \line { "На основе нот с 8notes.com, с рукописными исправлениями и аппликатурой из предоставленного PDF." }
    \line { "Темп MIDI: четверть = 100 (в печатных нотах — Allegro moderato без числового темпа)." }
  }
}

global = { \key fis \minor \time 4/4 }

% Bars 2–5 recur in different octaves; later variants are written separately.
themeA = {
  r8 <fis'-2 a'-4>8-. <fis'-2 a'-4>-. <fis'-2 a'-4>-.
  <fis'-2 a'-4>8.-> gis'32-3( a'-4 <gis'-3 b'-5>8) <fis'-2 a'-4>-. |
}
themeB = {
  <eis'-1 gis'-2>8( b'-4) <gis'-2 b'-4>-. <gis'-2 b'-4>-.
  <gis'-2 b'-4>8.-> a'32-3( b'-4 <a'-3 cis''-5>8) <gis'-2 b'-4>-. |
}
themeC = {
  <fis'-1 a'-2>8( cis''-3) <a'-1 cis''-2 fis''-5>8-. <gis'-1 cis''-2 eis''-4>-.
  <eis'-1 gis'-2 cis''-5>2-> |
}
themeD = {
  r8 <fis'-1 a'-2 cis''-3>8-. <a'-1 cis''-2 fis''-5>-. <gis'-1 cis''-2 eis''-4>-.
  <eis'-1 gis'-2 cis''-5>2-> |
}
right = {
  \global
  \set fingeringOrientations = #'(up)
  \tempo "Allegro moderato" 4 = 100
  R1 |
  \themeA \themeB \break \themeC \themeD
  \transpose c c' { \themeA \themeB }
  \break
  % 8–9: printed upper-register variants.
  <fis''-1 a''-2>8-. cis'''-3-. <a''-1 cis'''-2 fis'''-5>-. <gis''-1 b''-2 eis'''-4>-.
  <eis''-1 gis''-2 cis'''-5>2-> |
  <fis''-1 a''-2 cis'''-3>8-. <fis'' a'' cis'''>-.
  <a''-1 cis'''-2 fis'''-5>-. <gis''-1 b''-2 eis'''-4>-. <eis''-1 gis''-2 cis'''-5>2-> |
  \barNumberCheck #10
  r8 <a'-1 cis''-3>8-. cis''-3-. <g'-1 cis''-3>-. cis''-3-. <fis'-1 cis''-3>-.
  fis''16-5( e''-4 d''-3 cis''-2) |
  b'8-1 cis''4-3-> d''4-4-> ais'4-2-> b'8-3~ |
  \break
  b'8 <fis'-1 b'-3>-. b'-3-. <f'-1 b'-3>-. b'-3-. <e'-1 b'-3>-.
  e''16-5( d''-4 cis''-3 b'-2 |
  a'8-1) e''-3-. gis''16-5( fis''-4 e''-3 d''-2 cis''8-1) gis''-3-.
  b''16-5( a''-4 gis''-3 fis''-2 |
  e''8-1) cis'''-3-. cis'''-3-. cis'''-3-. cis'''-3-. cis'''-3-.
  fis'''16-5( e'''-4 d'''-3 cis'''-2) |
  b''8-1 cis'''4-3-> d'''4-4-> ais''4-2-> b''8-3-> |
  \break
  \barNumberCheck #16
  b''8-3-. b''-. b''-. b''-. b''-. b''-.
  e'''16-4( d'''-3) cis'''-2-. b''-1-. |
  a''8-3-. e''-1-. cis''16-2( dis''-3 e''-1 eis''-2 fis''8-3) cis''-2-.
  a'16-1( ais'-3 b'-1 bis'-2 |
  cis''8-3) cis''-. cis''-. cis''-. cis''-. cis''-. fis''16-5( e''-4 d''-3 cis''-2) |
  \pageBreak
  b'8-1 cis''4-3-> d''4-4-> ais'4-2-> b'8-3-> |
  \barNumberCheck #20
  b'8-2-. b'-. b'-. b'-. b'-. b'-. e''16-5( d''-4 cis''-3 b'-2 |
  a'8-1) e''-3-. gis''16-5( fis''-4 e''-3 d''-2 cis''8-1) gis''-3-.
  b''16-5( a''-4 gis''-3 fis''-2 |
  e''8-1) cis'''-3-. cis'''-3-. cis'''-3-. cis'''-3-. cis'''-3-.
  fis'''16-5( e'''-4 d'''-3 cis'''-2) |
  \break
  b''8-1 cis'''4-3-> d'''4-4-> ais''4-2-> b''8-3-> |
  b''8-2-. b''-1-. b''-. b''-. b''-. b''-. e'''16-4( d'''-3 cis'''-2 b''-1 |
  a''8-3) fis''-2-. gis''16-3( a''-1 b''-2 bis''-3 cis'''8-4) cis''-1-.
  d''16-2( dis''-3 e''-1 eis''-2 |
  \break
  \barNumberCheck #26
  fis''8-3) <fis'-2 a'-4>8-. <fis' a'>-. <fis' a'>-.
  <fis' a'>8.-> gis'32-3( a'-4 b'8-5) <fis'-2 a'-4>-. |
  <eis'-1 gis'-2>8( b'-4) <gis'-2 b'-4>-. <gis' b'>-.
  <gis' b'>8.-> a'32-3( b'-4 cis''8-5) <gis'-2 b'-4>-. |
  \themeC \themeD
  \break
  r8 <fis''-2 a''-4>8-. <fis'' a''>-. <fis'' a''>-.
  <fis'' a''>8.-> gis''32-3( a''-4 b''8-5) <fis''-2 a''-4>-. |
  <eis''-1 gis''-2>8( b''-4) <gis''-2 b''-4>-. <gis'' b''>-.
  <gis'' b''>8.-> a''32-3( b''-4 cis'''8-5) b''-4-. |
  <fis''-1 a''-2>8( cis'''-3) <a''-1 cis'''-2 fis'''-5>-. <gis''-1 cis'''-2 eis'''-4>-.
  <eis''-1 gis''-2 cis'''-5>2->~ |
  \break
  <eis'' gis'' cis'''>8 <fis''-1 a''-2 cis'''-3>8-.
  <a''-1 cis'''-2 fis'''-5>-. <gis''-1 cis'''-2 eis'''-4>-. <eis''-1 gis''-2 cis'''-5>2-> |
  \barNumberCheck #34
  <fis''-1 a''-2 cis'''-3>8 <a'-1 cis''-2 fis''-5>( <gis'-1 cis''-2 eis''-4>)
  <eis'-1 b'-2 cis''-4>( <fis'-1 a'-3 cis''-4>) <a'-1 cis''-2 fis''-4>(
  <gis'-1 cis''-2 eis''-5>) <eis'-1 b'-2 cis''-4>( |
  <fis'-1 a'-3 fis''-4>8) <fis'-1 a'-2 cis''-5>4 <d'-1 eis'-2 b'-4>4
  <cis'-1 fis'-2 a'-5>4 <b-1 eis'-2 gis'-4>8( |
  \break
  <a-1 fis'-4>8) <a'-1 cis''-2 fis''-5>( <gis'-1 cis''-2 eis''-4>)
  <eis'-1 b'-2 cis''-4>( <fis'-1 a'-3 fis''-5>) <a'-1 cis''-2 fis''-5>(
  <gis'-1 cis''-2 eis''-4>) <eis'-1 b'-2 cis''-4>( |
  <fis'-1 a'-3 fis''-5>8) <fis'-1 a'-2 cis''-5>4 <d'-1 eis'-2 b'-4>4
  <cis'-1 fis'-2 a'-5>4 <b-1 eis'-2 gis'-4>8( |
  <a-1 fis'-4>8) <gis'-1 cis''-2 eis''-4> <a'-1 cis''-2 fis''-5> r r2 \bar "|."
}

% Corrected source bars are shared with the handwritten LH-only references.
leftTen = {
  fis8-5-. cis'-2-. b-3-. <cis'-2 e'-1>-. ais-3-. <cis'-2 e'-1>-.
  fis-5-. <ais-3 e'-1>-. |
}
leftTwelve = {
  b8-2-. <b-2 d'-1>-. a-3-. <b-2 d'-1>-. gis-4-. <b-2 d'-1>-.
  e-5-. <gis-3 d'-1>-. |
}
leftThirteen = {
  a8-3-. <cis'-2 e'-1>-. e-5-. <cis'-2 e'-1>-. e-5-. <cis'-2 e'-1>-.
  a-3-. <cis'-2 e'-1>-. |
}
leftFourteen = {
  gis8-3-. g-4-. fis-5-. <ais-2 cis'-1>-. cis-5-. <fis-2 ais-1>-.
  ais-1-. fis-2-. |
}
leftPulse = { fis,8-5-. cis-1-. fis,-5-. cis-1-. fis,-5-. cis-1-. fis,-5-. cis-1-. | }
leftRun = {
  fis,8-5-. cis-1-. fis,-5-. cis-1-. fis,-5-. gis-3-.
  cis'16-1( b-2 a-3 gis-4 |
}
left = {
  \global \clef bass
  \set fingeringOrientations = #'(down)
  <>\p
  \leftPulse \leftPulse \leftPulse
  \leftRun
  fis8-1) cis-2-. fis,-5-. cis-1-. fis,-5-. gis-3-. cis'16-1( b-2 a-3 gis-4 |
  fis8-1) cis-2-. fis,-5-. cis-1-. fis,-5-. cis-1-. fis,-5-. cis-1-. |
  \leftPulse \leftRun
  fis8-1) cis'-1-. fis-3-. cis'-1-. fis-3-. gis-2-. cis'16-1( b-2 a-3 gis-4) |
  \barNumberCheck #10
  \leftTen
  b,8-5-. r <g-4 b-2 cis'-1>-. r <fis-5 b-2 d'-1>-. r <fis-4 cis'-2 e'-1>-. r |
  \leftTwelve \leftThirteen \leftFourteen
  <b,-5 d-3 fis-1>8-. r <e-5 g-3 cis'-1>-. r <fis-5 b-2 d'-1>-. r <fis-5 cis'-2 e'-1>-. r |
  b8-3-. <b-3 d'-1>-. a-4-. <d'-2 f'-1>-. gis-5-. <d'-2 e'-1>-. e-5-. <gis-3 d'-1>-. |
  a8-3-. <cis'-2 e'-1>-. gis-3-. <b-2 cis'-1>-. fis-4-. cis'-1-. d-5-. <fis-3 gis-2 b-1>-. |
  \leftTen
  <b-3 d'-1>8-. r <g-4 b-2 e'-1>-. r <fis-5 b-2 d'-1>-. r <fis-5 cis'-2 e'-1>-. r |
  \barNumberCheck #20
  \leftTwelve \leftThirteen \leftFourteen
  b,8-5-. r <e-5 g-3 b-1>-. r <fis-5 b-2 d'-1>-. r <fis-5 cis'-2 e'-1>4-. |
  b8-2-. <b-2 d'-1>-. a-3-. <b-2 d'-1>-. gis-4-. <b-2 d'-1>-. e-5-. <gis-3 d'-1>-. |
  a8-3-. <cis'-2 fis'-1>-. d-5-. <fis-3 gis-2 b-1>-. cis-5-. <fis-3 a-1>-. cis-5-. <gis-2 b-1>-. |
  \barNumberCheck #26
  \leftPulse \leftPulse \leftRun
  fis8-1) cis-2-. fis,-5-. cis-1-. fis,-5-. cis-1-. fis,-5-. cis-1-. |
  \leftPulse \leftPulse \leftRun
  fis8-1) cis-2-. fis,-5-. cis-1-. fis,-5-. gis-3-. cis'16-1( b-2 a-3 gis-4 |
  \barNumberCheck #34
  fis8-1) <fis,-5 cis-1>4.~ <fis, cis>8 <fis, cis>8~ <fis, cis>4~ |
  <fis, cis>4 <fis, cis>4 <fis, cis>4 <fis, cis>4~ |
  <fis, cis>8 <fis, cis>8~ <fis, cis>4~ <fis, cis>8 <fis, cis>4.~ |
  <fis, cis>4 <fis, cis>4 <fis, cis>4 <fis, cis>4~ |
  <fis, cis>8 <cis,-5 cis-1>8 <fis,,-5 fis,-1>8 r r2 |
}

#(if (or (not (equal? (ly:music-length right) (ly:music-length left)))
         (not (equal? (ly:music-length right) (ly:make-moment 38 1))))
     (ly:error "Little Swans: expected 38 bars in each hand"))

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
\score { \piano \midi { } }

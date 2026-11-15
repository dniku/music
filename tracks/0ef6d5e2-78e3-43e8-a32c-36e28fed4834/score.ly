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
  page-count = 1
}
\header {
  title = "Hallelujah"
  subtitle = "Фортепиано"
  composer = "Leonard Cohen"
  tagline = \markup \override #'(font-name . "DejaVu Sans") \fontsize #-3 \column {
    \line { "По нотам и рукописной аппликатуре из предоставленного файла Saber." }
    \line { "Темп MIDI: пунктирная четверть = 50 (рабочий; в источнике числового темпа нет)." }
  }
}

global = { \key c \major \time 6/8 }

introC = {
  << { e'4.-3 <g-1 g'-5>4. } \\
     { r8 g-1 c'-2 r e'-3 c'-2 } >> |
}
chorusFRight = {
  <a-1 a'-5>4. <a-1 a'-5>4.~ |
  <a a'>4. <a-1 a'-5>4 g'8-4 |
}
chorusARight = {
  <c'-1 e'-2>4. <c'-1 e'-2>4.~ |
  <c' e'>4. <c'-1 e'-2>4 g'8-4 |
}

right = {
  \global
  \tempo "Moderately slow, in 2" 4. = 50
  <>\mp
  \introC
  << { e'4.-3 <a-1 g'-5>4. } \\
     { r8 a-1 c'-2 r e'-3 c'-2 } >> |
  \introC
  << { e'4.-3 <a-1 a'-5>4 a8-1 } \\
     { r8 a-1 c'-2 r e'-3 s8 } >> |
  \break
  \repeat volta 5 {
    % Source p. 57, bars 5–12. Only the two piano staves are transcribed.
    << { <e'-3 g'-5>4 g'8-5 g'4-5 g'8-5 } \\
       { s4. r8 e'-3 c'-1 } >> |
    << { a'8-5 a'-5 a'-5~ a'4 e'8-3 } \\
       { s4. c'8-2 a-1 s8 } >> |
    << { g'8-5 g'-5 g'-5~ g' g'-5 g'-5 } \\
       { s4. e'8-3 c'-1 r } >> |
    << { a'4-5 a'8-5 a'-5 g'-4 g'-4 } \\
       { s4. c'4.-1 } >> |
    << { a'8-5 a'4-5~ a'8 a'-5 a'-5 } \\
       { s4. c'4.-1 } >> |
    << { a'4-5 g'8-4 g'-4 f'-3 g'-4 } \\
       { s4. b4.-1 } >> |
    << { g'8-4 g'4-4~ g'4. } \\
       { s4. e'8-2 c'4-1 } >> |
    d'4.-2 <b-1 g'-5>4 g8-1 |
    % Source p. 58, bars 13–24.
    g'4-4 g'8-4 <e'-2 g'-4>4 g'8-4 |
    <c'-1 a'-5>4 <c'-1 a'-5>8 <d'-1 b'-5>4 g'8-3 |
    << { c''8-5 c''-5 c''-5~ c''4 a'8-3 } \\
       { e'4.-1 e'4.-1 } >> |
    c''8-4 c''-4 <f'-1 a'-2 d''-5>~ <f' a' d''>4 c''8-4 |
    <g'-1 b'-3 d''-5>8 <g' b' d''> <g' b' d''>~ <g' b' d''>4 <g' b' d''>8 |
    <g'-1 b'-2 e''-5>4 <g' b' e''>8~ <g' b' e''> e''-5 d''-4 |
    <e'-1 a'-2 d''-5>8 c''-4 <a'-2 c''-4>~ <a' c''>4.~ |
    <a' c''>4. e'4-2 g'8-4 \bar "||"
    \mark \markup "Припев"
    \chorusFRight
    \chorusARight
    % Source p. 59, bars 25–26.
    <a-1 a'-5>4. <a-1 a'-5>4.~ |
    <a a'>4. <a-1 a'-5>4 g'8-4 |
  }
  \alternative {
    \volta 1,2,3,4 {
      e'4.-3 e'8-3 f'-4 e'-3 |
      d'4.-2 <b-1 g'-5>4 c'8-2 |
      c'4.-2 e'4.-4 |
      g8-1 b-2 d'-3 g'-5 d'-3 g-1 |
    }
    \volta 5 {
      e'4.-4 e'4-4 d'8-3 |
      << { d'4.-4~ d'8 e'-5 g'-4 } \\
         { s4. a8-1 b4-2 } >> |
    }
  }
  \break
  \mark \markup "Заключительный припев"
  \chorusFRight
  \chorusARight
  \chorusFRight
  << { e'4.-4~ e'8 f'-5 e'-4 } \\
     { s4. g4.-1 } >> |
  d'4.-4_\markup \italic "rit." <b-1 g'-5>4 c'8-2 |
  c'4.-2 e'8-3 g'-5 c'-2~ |
  c'2.\fermata \bar "|."
}

% Repeated accompaniment patterns retain the source's sustained bass voice.
leftC = {
  << { r8 g-2 c'-1 s4. } \\
     { c4.-5~ c4 b,8-4 } >> |
}
leftA = {
  << { r8 e-2 a-1 r a-1 e-2 } \\
     { a,2.-5 } >> |
}
leftF = {
  << { r8 c-2 f-1 r f-1 c-2 } \\
     { f,2.-5 } >> |
}
leftCFlow = {
  << { r8 g-2 c'-1 r c'-1 g-2 } \\
     { c2.-5 } >> |
}
leftGHeld = {
  << { r8 d-2 g-1 r g4-1 } \\
     { g,2.-5 } >> |
}
left = {
  \global \clef bass
  c4.-3~ c4 b,8-4 |
  a,4.-5~ a,4 b,8-4 |
  c4.-3~ c4 b,8-4 |
  a,4.-5~ a,4 b,8-4 |
  \repeat volta 5 {
    \leftC
    << { r8 e-2 a-1 s4. } \\
       { a,4.-5~ a,4 b,8-4 } >> |
    \leftC
    << { r8 e-2 a-1 s4. } \\
       { a,2.-5 } >> |
    << { r8 c-2 f-1 s4. } \\
       { f,2.-5 } >> |
    << { r8 d-2 g-1 s4. } \\
       { g,2.-5 } >> |
    << { r8 g-2 c'-1 s4. } \\
       { c4.-5~ c8 e,-5 f,-4 } >> |
    << { r8 d-2 g-1 r g-1 d-2 } \\
       { g,2.-5 } >> |
    \leftCFlow
    << { r8 c-2 f-1 r d-2 g-1 } \\
       { f,4.-5 g,4.-5 } >> |
    \leftA
    << { r8 c-2 f-1 a-2 f-1 c-2 } \\
       { f,2.-5 } >> |
    << { r8 d-2 g-1 b-2 g-1 d-2 } \\
       { g,2.-5 } >> |
    << { r8 b,-2 e-1 g-2 e-1 b,-2 } \\
       { e,2.-5 } >> |
    << { r8 e-2 a-1 c'-2 a-1 e-2 } \\
       { a,2.-5 } >> |
    <a,-5 e-2>2. |
    \leftF \leftF \leftA \leftA \leftF
    << { r8 c-2 f-1 r f4-1 } \\
       { f,2.-5 } >> |
  }
  \alternative {
    \volta 1,2,3,4 {
      \leftCFlow \leftGHeld \leftCFlow
      g,2.-5 |
    }
    \volta 5 {
      \leftCFlow
      << { r8 d-2 g-1 s4. } \\
         { g,2.-5 } >> |
    }
  }
  \leftF \leftF \leftA \leftA \leftF \leftF
  << { r8 g,-2 c-1 s4. } \\
     { c,2.-5 } >> |
  \leftGHeld
  << { r8 g,-2 c-1~ c4. } \\
     { c,2.-5 } >> |
  <c,,-5 c,-1>2.\fermata |
}

harmonies = \chordmode {
  c2. a:m c a:m
  \repeat volta 5 {
    c a:m c a:m f g c g
    c f4. g a2.:m f g e:m a:m s
    f s a:m s f s
  }
  \alternative {
    \volta 1,2,3,4 { c g c g }
    \volta 5 { c g }
  }
  f s a:m s f s c g c s
}

#(for-each
  (lambda (music)
    (if (not (equal? (ly:music-length right) (ly:music-length music)))
        (ly:error "Hallelujah: piano/chord duration mismatch")))
  (list left harmonies))

piano = \new PianoStaff <<
  \new Staff \with { midiInstrument = "acoustic grand" } \right
  \new Staff \with { midiInstrument = "acoustic grand" } \left
>>
\score {
  <<
    \new ChordNames { \set chordChanges = ##t \harmonies }
    \piano
  >>
  \layout {
    indent = #0
    \context { \Score \override Fingering.color = #red }
  }
}
\score { \unfoldRepeats \piano \midi { } }

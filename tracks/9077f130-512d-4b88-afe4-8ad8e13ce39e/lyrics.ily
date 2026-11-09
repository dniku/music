% Lyrics supplied by the user. Phrase anchors follow the approximate section
% map in alignment.json; the simplified melody is not a syllabic vocal part.
% Parenthesized backing vocals are retained, including in the LH-only bridge.

chorusOpeningLyrics = \lyricmode {
  \skip 2. "She rules"2.*3 |
  "Until the end of time"2.*4 |
}

chorusFirstHalfLyrics = \lyricmode {
  \chorusOpeningLyrics
  "She gives and she takes"2.*8 |
}

chorusEndingLyrics = \lyricmode {
  \skip 2 "She goes her way"4 \skip 2.*3 |
}

songLyrics = \lyricmode {
  % Instrumental introduction, including both written volta endings.
  \repeat volta 2 { \skip 2.*16 }
  \repeat volta 2 { \skip 2.*14 }
  \alternative { { \skip 2.*2 } { \skip 2.*2 } }
  \skip 2.*24 |
  \barNumberCheck #89

  % Verse 1: phrase pickups follow the existing melody.
  \skip 2. "Birds and butterflies"2.*3 |
  \skip 2 "Rivers and mountains she creates"4 \skip 2.*4 |
  "But you'll never know"2.*3 |
  \skip 2 "The next move she'll make"4 \skip 2.*3 |
  \skip 2. "You can try"2.*3 |
  \skip 2 "But it is useless to ask why"4 \skip 2.*4 |
  "Cannot control her"2.*3 |
  \skip 2 "She goes her own way"4 \skip 2.*3 |
  \barNumberCheck #121

  \chorusFirstHalfLyrics
  \chorusOpeningLyrics
  \skip 2.*4 |
  \chorusEndingLyrics
  \barNumberCheck #153

  % Verse 2 uses the same approximate phrase grid as verse 1.
  \skip 2. "With every breath"2.*3 |
  \skip 2 "And all the choices that we make"4 \skip 2.*4 |
  "We are only passing through"2.*3 |
  \skip 2 "On her way"4 \skip 2.*3 |
  \skip 2. "I find my strength"2.*3 |
  \skip 2 "Believing that their soul lives on"4 \skip 2.*4 |
  "Until the end of time"2.*3 |
  \skip 2 "I'll carry them with me"4 \skip 2.*3 |
  \barNumberCheck #185

  % The repeated notes carry different words on the two passes.
  \repeat volta 2 {
    \chorusOpeningLyrics
    \markup \column {
      "1. She gives and she takes"
      "2. She goes her way"
    }2.*8 |
  }
  \skip 2.*16 |
  \barNumberCheck #233

  % Bridge: approximate anchors over the existing chord progression.
  "Once you will know, my dear"2.*6 |
  \markup \column {
    "You don't have to fear"
    "(you don't have to fear)"
  }2.*4 |
  \markup \column {
    "A new beginning"
    "(beginning)"
  }2.*4 |
  "Always starts at the end"2.*4 |
  "Once you will know, my dear"2.*4 |
  "You don't have to fear"2.*4 |
  "Until the end of time"2.*4 |
  "(Until the end of time)"2.*4 |
  "Until the end of time"2.*8 |
  "(Until the end of time)"2.*4 |
  "Until the end of time"2.*4 |
  "She goes her way"2.*4 |
  \skip 2.*16 |
  \barNumberCheck #303

  \repeat volta 2 { \skip 2.*14 }
  \alternative { { \skip 2.*2 } { \skip 2.*2 } }
  \barNumberCheck #335

  \chorusFirstHalfLyrics
  \skip 2. "She rules"2.*7 |
  % The supplied final chorus has three repetitions of this line.
  \repeat volta 3 { "Until the end of time"2.*4 }
  \chorusEndingLyrics
  \barNumberCheck #375
}

#(if (not (equal? (ly:music-length songLyrics) (ly:music-length melody)))
     (ly:error "Lyrics must span the complete written Mother Earth score"))

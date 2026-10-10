\version "2.24.0"

% Wording: corrected lyrics supplied by the user on 2026-10-10; the copied
% site's recommendation block is omitted. Phrase breaks are informed by
% reference/lyrics/Avantasia-Lost_In_Space.pdf, not its erroneous wording.
% These are editorial phrase anchors, NOT a syllable-by-syllable vocal part:
% the piano arrangement differs from the sung melody. No MIDI lyrics/notes.

pianoRollChorusLyrics = \lyricmode {
  % Fourteen-bar core; the interlude after it differs between occurrences.
  \break
  \skip 4 \markup \general-align #Y #DOWN \column { \small \bold "Припев" "How could I know," }2. |
  \skip 4 "how could I know?"2. |
  \skip 8 "That I'll get"8*7 |
  \skip 4 "lost in space"2. |
  \skip 4. "to roam"8*5 |
  \skip 4 "forever"2. |
  \skip 1*2 |
  \skip 4 "How could I know,"2. |
  \skip 4 "how could I see?"2. |
  \skip 8 "Feeling like"8*7 |
  \skip 4 "lost in space"2. |
  \skip 4. "to roam"8*5 |
  \skip 4 "forever"2. |
}

pianoRollLyrics = \lyricmode {
  \skip 1*7 |
  \break
  % Verse 1, bars 8–24. The first phrase is a pickup, before timestamp 0:21.70.
  \skip 4. \markup \general-align #Y #DOWN \column { \small \bold "Куплет 1" "Another star" }8*5 |
  \skip 2. "has fallen"4 |
  \skip 2. "without sound"4 |
  \skip 1 |
  \skip 4. "Another spark"8*5 |
  \skip 2. "has burned out"4 |
  \skip 4 "in the cold"2. |
  \skip 1 |
  \skip 4. "Another door"8*5 |
  \skip 2. "to barrens"4 |
  \skip 8 "standing open"8*7 |
  \skip 1 |
  \skip 2 "And who is there"2 |
  \skip 2. "to tell me"4 |
  \skip 4 "not to give in,"2. |
  \skip 4 "not to go?"2. |
  \skip 1 |
  \barNumberCheck #25

  \pianoRollChorusLyrics
  \skip 1 |
  \barNumberCheck #40
  \pageBreak

  % Verse 2, bars 40–56.
  \skip 4. \markup \general-align #Y #DOWN \column { \small \bold "Куплет 2" "I'm crawling down," }8*5 |
  \skip 2. "the doorway"4 |
  \skip 4 "to the badlands"2. |
  \skip 1 |
  \skip 4. "Been kicking down"8*5 |
  \skip 8*5 "all your hurdles"4. |
  \skip 4 "to the black"2. |
  \skip 1 |
  \skip 4. "And all the damage"8*5 |
  \skip 8*5 "fading in the"4. |
  \skip 4 "rear view mirror"2. |
  \skip 1 |
  \skip 2 "And the demons"2 |
  \skip 2. "are calling me,"4 |
  \skip 4 "they're dragging"2. |
  \skip 4 "me away"2. |
  \skip 1 |
  \barNumberCheck #57

  \pianoRollChorusLyrics
  \skip 1*2 |
  \barNumberCheck #73
  \pageBreak

  \markup \general-align #Y #DOWN \column { \small \bold "Бридж" "Lost in space," }1*2 |
  "lost in time"1*2 |
  "Lost in space,"1*2 |
  "lost in time"1*2 |
  "Lost in space"1*2 |
  \barNumberCheck #83
  \break
  \skip 1*4 |
  \skip 4 "How could I know,"2. |
  \skip 4 "how could I"2. |
  \barNumberCheck #89

  \pianoRollChorusLyrics
  \barNumberCheck #103
  \skip 2. "Forever"4 |
  \skip 2. "Forever"4 |
  \skip 2. "Forever"4 |
  \skip 1*2 |
  \barNumberCheck #108
}

#(if (not (equal? (ly:music-length pianoRollLyrics)
                  (ly:music-length pianoRollRight)))
     (ly:error "Piano-roll lyrics must span the complete 107-bar arrangement"))

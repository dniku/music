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
    "Соло, текст и аккорды · ♩ = 171"
  composer = \markup \override #'(font-name . "DejaVu Sans")
    "Мои Ракеты Вверх"
  tagline = ##f
}

% The pitch sequence originated in the user-supplied MusicXML. Durations were
% revised against the reference recording and promoted from rhythm candidate 2.
soloNotes = \absolute {
  \key g \major
  \time 4/4
  \tempo 4 = 171
  \partial 4.

  e'4. |
  e'4 fis'8 e' fis' g' fis'4 |
  fis'8 e' c'2. |
  fis'4 g' fis'2~ |
  fis'8 c'' b' c'' b'2~ |
  % Accepted after A/B comparison: the penultimate note is one whole note.
  b'8 e''4. es''2~ |
  es''2 e''2~ |
  e''1
}

\score {
  \new Staff \with {
    midiInstrument = "overdriven guitar"
  } {
    \soloNotes
    \bar "|."
  }

  \layout {
    indent = #0
    ragged-right = ##f
  }
}

% Lyrics and chord notes supplied by the user; preserve the wording as given.
\markup \override #'(font-name . "DejaVu Sans") \fontsize #1
\override #'(baseline-skip . 3.5) \column {
  \vspace #1
  \bold "Аккорды"
  "Куплет: E — C#m — C (по кругу)"
  "Припев: Gm6/9 — Gm9 — Gm6/9 — Gm9"
  "Gm6/9 = G A E Bb"
  "Бридж: Gm9 — Cø7 (полууменьшённый до), чередовать"

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

% Keep the 10.9-second comparison window without printing its trailing silence.
\score {
  \new Staff \with {
    midiInstrument = "overdriven guitar"
  } {
    \soloNotes
    \cadenzaOn
    r4.
  }
  \midi { }
}

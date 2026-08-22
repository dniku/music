\version "2.24.0"

#(set-global-staff-size 15)

\paper {
  #(set-paper-size "a4")
  top-margin = 6\mm
  bottom-margin = 6\mm
  left-margin = 8\mm
  right-margin = 8\mm
  system-system-spacing.basic-distance = #8
  system-system-spacing.minimum-distance = #6
  system-system-spacing.padding = #0.5
  ragged-bottom = ##t
  ragged-last-bottom = ##t
  oddFooterMarkup = ##f
  evenFooterMarkup = ##f
}

\include "music.ily"

\header {
  title = \markup \override #'(font-name . "DejaVu Sans") \bold "Волки Океана"
  subtitle = \markup \override #'(font-name . "DejaVu Sans") {
    "Нотная сетка · 4/4 · "
    \note { 4 } #1
    " = 165"
  }
  subsubtitle = \markup \override #'(font-name . "DejaVu Sans") \small {
    "Звуки: " #(instrument-legend)
  }
  composer = \markup \override #'(font-name . "DejaVu Sans") "Атом-76"
  piece = \markup \override #'(font-name . "DejaVu Sans") {
    "Левая рука всегда играет " \bold "463"
  }
  tagline = ##f
}

verseLine = {
  c'1 | c' | c' | s2. c'4 |
}

postIntroAlignment = {
  \repeat unfold 32 { s1 | }
}

introPreBassRight = {
  \part "102" "Вступление 1 / 00:00–00:12"
  \introNotes
}

introRight = {
  \part "463" "Вступление 2 / 00:12–00:36"
  \repeat unfold 8 { s1 | }

  \ottava #1
  <b'' e'''>1~ | <b'' e'''> | <g'' b''>1~ | <g'' b''> |
  <d''' g'''>1 | <des''' ges'''> | <d''' g'''> | <g'' b''> |
  \ottava #0

  \repeat unfold 8 { s1 | }

  \ottava #1
  <b'' e'''>1~ | <b'' e'''> | <g'' b''>1~ | <g'' b''> |
  <d''' g'''>1 | <des''' ges'''> | <d''' g'''> | <g'' b''> |
  \ottava #0
}

firstVerseRight = {
  \part "463" "Куплет / 00:36–00:59"
  % TODO(Codeberg): здесь есть ксилофон.
  \repeat unfold 32 { s1 | }
}

firstBridgeRight = {
  \part "102" "Проигрыш 1 / 00:59–01:11"
  \earlySoloNotes
}

secondVerseRight = {
  \part "463" "Куплет 2 / 01:11–01:59"
  % TODO(Codeberg): здесь есть ксилофон.
  \repeat unfold 32 { s1 | }
}

earlySoloCue = {
  \repeat unfold 8 { s1 | }
}

soloCueOne = {
  \mark \markup \override #'(font-name . "DejaVu Sans") \box
    "Соло 1:45.70–1:57.30"
  \repeat unfold 8 { s1 | }
}

soloCueTwo = {
  \mark \markup \override #'(font-name . "DejaVu Sans") \box
    "Соло 2:43.90–2:55.50"
  \repeat unfold 8 { s1 | }
}

soloCueThree = {
  \mark \markup \override #'(font-name . "DejaVu Sans") \box
    "Соло 5:15.20–5:26.80"
  \repeat unfold 8 { s1 | }
}

guitarBreakCue = {
  \mark \markup \override #'(font-name . "DejaVu Sans") \box \left-column {
    "Проигрыш гитары на 3:11"
    \tiny "Очень черновые ноты · требуют доработки"
  }
  \repeat unfold 4 { s1 | }
}

vocalGuide = {
  \global
  \introAlignment
  \postIntroAlignment

  \repeat unfold 8 { \verseLine }
  \earlySoloCue

  \repeat unfold 8 { \verseLine }

  \mark \markup \override #'(font-name . "DejaVu Sans") \box "Припев 1"
  \repeat unfold 16 { c'1 | }
  \soloCueOne

  \mark \markup \override #'(font-name . "DejaVu Sans") \box "Куплет 3"
  \repeat unfold 8 { \verseLine }

  \mark \markup \override #'(font-name . "DejaVu Sans") \box "Припев 2"
  \repeat unfold 16 { c'1 | }

  \mark \markup \override #'(font-name . "DejaVu Sans") \box "Бридж"
  \repeat unfold 14 { c'1 | }
  \soloCueTwo
  \guitarBreakCue

  \mark \markup \override #'(font-name . "DejaVu Sans") \box "Финал"
  \repeat unfold 8 { \verseLine }
  \soloCueThree

  \bar "|."
}

soloDisplayGuide = {
  \global
  \introPreBassRight
  \introRight
  \firstVerseRight
  \firstBridgeRight
  \secondVerseRight

  \repeat unfold 16 { s1 | } % Chorus 1
  \soloNotes

  \repeat unfold 32 { s1 | } % Verse 3
  \repeat unfold 16 { s1 | } % Chorus 2
  \repeat unfold 14 { s1 | } % Bridge
  \soloNotes
  \guitarBreakDraftNotes

  \repeat unfold 32 { s1 | } % Finale
  \soloNotes
}

lowerHandGuide = {
  \global
  \clef treble
  \introAlignment
  \postIntroAlignment
  \repeat unfold 32 { s1 | } % Verse 1
  \repeat unfold 8 { s1 | } % Early solo
  \repeat unfold 32 { s1 | } % Verse 2
  \repeat unfold 16 { s1 | } % Chorus 1
  \repeat unfold 8 { s1 | } % Solo 1
  \repeat unfold 32 { s1 | } % Verse 3
  \repeat unfold 16 { s1 | } % Chorus 2
  \repeat unfold 14 { s1 | } % Bridge
  \repeat unfold 8 { s1 | } % Solo 2
  \repeat unfold 4 { s1 | } % Guitar break
  \repeat unfold 32 { s1 | } % Finale
  \repeat unfold 8 { s1 | } % Solo 3
  \bar "|."
}

lineBreaks = {
  \introAlignment
  \break

  % Four eight-measure systems for further transcription after the intro.
  \repeat unfold 4 {
    s1 | s | s | s | s | s | s | s | \break
  }
  % Page 1 ends after verse 1.
  \repeat unfold 4 {
    s1 | s | s | s | s | s | s | s | \break
  }
  \pageBreak

  % Page 2: early solo, verse 2, chorus 1, and solo 1.
  \repeat unfold 8 {
    s1 | s | s | s | s | s | s | s | \break
  }
  \pageBreak

  % Page 3: verse 3, chorus 2, and bridge.
  \repeat unfold 6 {
    s1 | s | s | s | s | s | s | s | \break
  }
  \repeat unfold 2 {
    s1 | s | s | s | s | s | s | \break
  }
  \pageBreak

  % Page 4: solo 2, guitar break, finale, and solo 3.
  s1 | s | s | s | s | s | s | s | \break
  s1 | s | s | s | \break
  \repeat unfold 4 {
    s1 | s | s | s | s | s | s | s | \break
  }
  s1 | s | s | s | s | s | s | s | \break
}

verseHarmony = \chordmode {
  \repeat unfold 4 {
    e1:m | e:m | e:m | e:m |
    g1 | g | d | d |
  }
}

chorusHarmony = \chordmode {
  e1:m | e:m | b:7 | b:7 |
  c1 | g | c | d |
  e1:m | e:m | b:7 | b:7 |
  c1 | g | d | d |
}

bridgeHarmony = \chordmode {
  e1:m | e:m |
  c1 | c |
  g1 | d | d |
  e1:m | e:m |
  c1 | c |
  g1 | d | d |
}

soloHarmony = \chordmode {
  \repeat unfold 8 { s1 | }
}

earlyBridgeHarmony = \chordmode {
  e1:m | e:m | g | d |
  e1:m | e:m | g | d |
}

guitarBreakHarmony = \chordmode {
  \repeat unfold 4 { s1 | }
}

postIntroEmHarmony = \chordmode {
  \set chordChanges = ##f
  e1:m |
  \set chordChanges = ##t
  e1:m | e:m | e:m |
}

postIntroAlternatingProgression = \chordmode {
  g1 | fis | g | e:m |
}

postIntroHarmony = \chordmode {
  \postIntroEmHarmony
  g1 | b:m/fis | a/e | d |
  \postIntroEmHarmony
  \postIntroAlternatingProgression
  \postIntroEmHarmony
  g1 | b:m/fis | a/e | d |
  \postIntroEmHarmony
  \postIntroAlternatingProgression
}

allChords = \chordmode {
  \introAlignment
  \postIntroHarmony
  \verseHarmony
  \earlyBridgeHarmony
  \verseHarmony
  \chorusHarmony
  \soloHarmony
  \verseHarmony
  \chorusHarmony
  \bridgeHarmony
  \soloHarmony
  \guitarBreakHarmony
  \verseHarmony
  \soloHarmony
}

emFourBarVoicing = \absolute {
  \repeat unfold 3 { <e' g' b'>1~ | }
  <e' g' b'>1 |
}

emTwoBarVoicing = \absolute {
  <e' g' b'>1~ | <e' g' b'>1 |
}

gTwoBarVoicing = \absolute {
  <g' b' d''>1~ | <g' b' d''>1 |
}

dTwoBarVoicing = \absolute {
  <d' fis' a'>1~ | <d' fis' a'>1 |
}

bSevenTwoBarVoicing = \absolute {
  <b dis' fis' a'>1~ | <b dis' fis' a'>1 |
}

cTwoBarVoicing = \absolute {
  <c' e' g'>1~ | <c' e' g'>1 |
}

verseChordVoicings = {
  \repeat unfold 4 {
    \emFourBarVoicing
    \gTwoBarVoicing
    \dTwoBarVoicing
  }
}

chorusChordVoicings = \absolute {
  \emTwoBarVoicing \bSevenTwoBarVoicing
  <c' e' g'>1 | <g' b' d''> | <c' e' g'> | <d' fis' a'> |
  \emTwoBarVoicing \bSevenTwoBarVoicing
  <c' e' g'>1 | <g' b' d''> | \dTwoBarVoicing
}

bridgeChordVoicings = \absolute {
  \emTwoBarVoicing
  \cTwoBarVoicing
  <g' b' d''>1 | \dTwoBarVoicing
  \emTwoBarVoicing
  \cTwoBarVoicing
  <g' b' d''>1 | \dTwoBarVoicing
}

soloChordVoicingSpacers = {
  \repeat unfold 8 { s1 | }
}

earlyBridgeChordVoicings = \absolute {
  <e' g' b'>1~ | <e' g' b'> |
  <g' b' d''>1 | <d' fis' a'> |
  <e' g' b'>1~ | <e' g' b'> |
  <g' b' d''>1 | <d' fis' a'> |
}

guitarBreakChordVoicingSpacers = {
  \repeat unfold 4 { s1 | }
}

postIntroEmVoicing = \emFourBarVoicing

postIntroProgressionVoicings = \absolute {
  <g' b' d''>1 | <fis' b' d''> | <e' a' cis''> | <d' fis' a'> |
}

postIntroAlternatingProgressionVoicings = \absolute {
  <g' b' d''>1 | <fis' ais' cis''> | <g' b' d''> | <e' g' b'> |
}

postIntroChordVoicings = \absolute {
  \postIntroEmVoicing \postIntroProgressionVoicings
  \postIntroEmVoicing \postIntroAlternatingProgressionVoicings
  \postIntroEmVoicing \postIntroProgressionVoicings
  \postIntroEmVoicing \postIntroAlternatingProgressionVoicings
}

allChordVoicings = {
  \global
  \introAlignment
  \postIntroChordVoicings
  \verseChordVoicings
  \earlyBridgeChordVoicings
  \verseChordVoicings
  \chorusChordVoicings
  \soloChordVoicingSpacers
  \verseChordVoicings
  \chorusChordVoicings
  \bridgeChordVoicings
  \soloChordVoicingSpacers
  \guitarBreakChordVoicingSpacers
  \verseChordVoicings
  \soloChordVoicingSpacers
}

barLyrics = \lyricmode {
  "Только" "трусы перед" "бурей" "Уби"
  -- "рают" "пару" -- "са." \skip 1
  "А из" -- "бранники фор" -- "туны" "Держат"
  "путь на" "небе" -- "са." \skip 1
  "Пусть бес" -- "нуется сти" -- "хия," "Смерть хо"
  -- "хочет" "за бор" -- "том —" \skip 1
  "Наши" "головы ли" -- "хие" "Ей до"
  -- "станут" -- "ся по" -- "том." \skip 1

  "Нынче" "волки оке" -- "ана" "В путь го"
  -- "товы" "сей же" "час," \skip 1
  "Лишь бы" "был у капи" -- "тана" "Самый"
  "правиль" -- "ный ком" -- "пАс," \skip 1
  "И к со" -- "кровищам за" -- "бытым" "Чтобы"
  "курс про" -- "ложен" "был" \skip 1
  "Не по" "линиям маг" -- "нитным," "А по"
  "лини" -- "ям судь" -- "бы." \skip 1

  "В оке" -- "ане" "нет за" -- "претов"
  "И про" -- "торен" -- "ных до" -- "рог."
  "Там над" "нами" "только" "ветер,"
  "Наш шаль" -- "ной пи" -- "ратский" "бог."

  "Не най" -- "ти теперь сво" -- "боды" "На да"
  -- "лёких" "бере" -- "гах:" \skip 1
  "Каждый" "фут земли рас" -- "продан," "Под кон"
  -- "тролем" "каждый" "шаг." \skip 1
  "За фаль" -- "шивыми ре" -- "чами-" "Пусто"
  -- "та трус" -- "ливых" "душ." \skip 1
  "Вольный" "ветер оке" -- "ана -" "Не для"
  "этих" "жирных" "туш!" \skip 1

  "В оке" -- "ане" "нет за" -- "конов"
  "И жес" -- "токих" "пала" -- "чей,"
  "Наши" "име" -- "на за" -- "помнит"
  "Только" "ветер -" "страж мо" -- "рей."

  "Чёрные" "флаги -"
  "Верные" "знаки"
  "Вольных" "бунта" -- "рей."
  "Шкура в за" -- "платах -"
  "Доля пи" -- "ратов,"
  "Демо" -- "нов мо" -- "рей."

  "Кто по" -- "кой и безо" -- "пасность" "Выше"
  "счастья" "оце" -- "нил," \skip 1
  "Тот рас" -- "платится на" -- "прасно:" "Кто не"
  "дрался," "тот не" "жил." \skip 1
  "Пусть бри" -- "танская ар" -- "мада" "На фре"
  -- "гат нарвё" -- "тся" "наш -" \skip 1
  "Мы лю" -- "бой добыче" "рады." "Эй, впе"
  -- "рёд, на" "абор" -- "даж!" \skip 1
}

% Render the complete notated timeline for full-score auditions.
\score {
  \new PianoStaff <<
    \new Staff {
      \set Staff.midiInstrument = #(cdr (assoc "102" instruments))
      \unfoldRepeats \soloDisplayGuide
    }

    \new Staff {
      \set Staff.midiInstrument = #(cdr (assoc "463" instruments))
      \unfoldRepeats \allChordVoicings
    }
  >>
  \midi { }
}

\score {
  <<
    \new ChordNames {
      \set chordChanges = ##t
      \allChords
    }

    \new PianoStaff <<
      \new Staff = "rightHand" <<
        \new Voice = "lyricsGuide" {
          \voiceTwo
          \hideNotes
          \vocalGuide
        }

        \new Voice {
          \voiceOne
          \soloDisplayGuide
        }

        \new Voice {
          \lineBreaks
        }
      >>

      \new Lyrics \lyricsto "lyricsGuide" {
        \barLyrics
      }

      \new Staff = "leftHand" <<
        \new Voice {
          \lowerHandGuide
        }

        \new Voice {
          \voiceOne
          \allChordVoicings
        }
      >>
    >>
  >>

  \layout {
    \context {
      \Score
      barNumberVisibility = #all-bar-numbers-visible
      \override BarNumber.font-size = #-2
      \override RehearsalMark.self-alignment-X = #LEFT
    }
    \context {
      \Lyrics
      \override LyricText.font-name = "DejaVu Sans"
      \override LyricText.font-size = #-2
      \override LyricText.self-alignment-X = #LEFT
      \override LyricSpace.minimum-distance = #1.2
    }
    \context {
      \Staff
      \override TimeSignature.break-visibility = #end-of-line-invisible
    }
  }
}

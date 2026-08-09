\version "2.24.0"

#(set-global-staff-size 16)

\paper {
  #(set-paper-size "a4")
  top-margin = 6\mm
  bottom-margin = 6\mm
  left-margin = 8\mm
  right-margin = 8\mm
  system-system-spacing.basic-distance = #9
  system-system-spacing.minimum-distance = #7
  system-system-spacing.padding = #0.5
  ragged-bottom = ##t
  ragged-last-bottom = ##t
  oddFooterMarkup = ##f
  evenFooterMarkup = ##f
}

\header {
  title = \markup \override #'(font-name . "DejaVu Sans") \bold "Волки Океана"
  subtitle = \markup \override #'(font-name . "DejaVu Sans") {
    "Нотная сетка · 4/4 · "
    \note { 4 } #1
    " = 165"
  }
  composer = \markup \override #'(font-name . "DejaVu Sans") "Атом-76"
  tagline = ##f
}

\include "music.ily"

verseLine = {
  c'1 | c' | c' | s2. c'4 |
}

postIntroAlignment = {
  \repeat unfold 32 { s1 | }
}

earlySoloCue = {
  \mark \markup \override #'(font-name . "DejaVu Sans") \box
    "Раннее соло 0:58.80–1:10.80"
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
  \mark \markup \override #'(font-name . "DejaVu Sans") \box "Проигрыш"
  \postIntroAlignment

  \mark \markup \override #'(font-name . "DejaVu Sans") \box "Куплет 1"
  \repeat unfold 8 { \verseLine }
  \earlySoloCue

  \mark \markup \override #'(font-name . "DejaVu Sans") \box "Куплет 2"
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
  \mark \markup \override #'(font-name . "DejaVu Sans") \box
    "Вступление 0:00.00–0:12.30"
  \introNotes
  \postIntroAlignment

  \repeat unfold 32 { s1 | } % Verse 1
  \earlySoloNotes
  \repeat unfold 32 { s1 | } % Verse 2
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
  \clef bass
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
  g1 | b:m | a | d |
  \postIntroEmHarmony
  \postIntroAlternatingProgression
  \postIntroEmHarmony
  g1 | b:m | a | d |
  \postIntroEmHarmony
  \postIntroAlternatingProgression
}

allChords = \chordmode {
  \introAlignment
  \postIntroHarmony
  \verseHarmony
  \soloHarmony
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

verseChordVoicings = \absolute {
  \repeat unfold 4 {
    <e' g' b'>1 | s1 | s | s |
    <g' b' d''>1 | s1 | <d' fis' a'>1 | s1 |
  }
}

chorusChordVoicings = \absolute {
  <e' g' b'>1 | s1 | <b dis' fis' a'>1 | s1 |
  <c' e' g'>1 | <g' b' d''> | <c' e' g'> | <d' fis' a'> |
  <e' g' b'>1 | s1 | <b dis' fis' a'>1 | s1 |
  <c' e' g'>1 | <g' b' d''> | <d' fis' a'> | s1 |
}

bridgeChordVoicings = \absolute {
  <e' g' b'>1 | s1 |
  <c' e' g'>1 | s1 |
  <g' b' d''>1 | <d' fis' a'> | s1 |
  <e' g' b'>1 | s1 |
  <c' e' g'>1 | s1 |
  <g' b' d''>1 | <d' fis' a'> | s1 |
}

soloChordVoicingSpacers = {
  \repeat unfold 8 { s1 | }
}

guitarBreakChordVoicingSpacers = {
  \repeat unfold 4 { s1 | }
}

postIntroEmVoicing = \absolute {
  <e' g' b'>1 | s1 | s | s |
}

postIntroProgressionVoicings = \absolute {
  <d' g' b'>1 | <d' fis' b'> | <cis' e' a'> | <d' fis' a'> |
}

postIntroAlternatingProgressionVoicings = \absolute {
  <d' g' b'>1 | <cis' fis' ais'> | <d' g' b'> | <e' g' b'> |
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
  \soloChordVoicingSpacers
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

% Keep one useful MIDI file containing the established synthesizer parts.
\score {
  \new Staff {
    \unfoldRepeats {
      \introMusic
      \earlySoloMusic
      \soloMusic
    }
  }
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
          \allChordVoicings
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

      \new Staff = "leftHand" {
        \lowerHandGuide
      }
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
  }
}

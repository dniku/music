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

global = {
  \key e \minor
  \time 4/4
  \tempo 4 = 165
}

introMusic = \fixed c' {
  \global
  \set Staff.midiInstrument = "lead 2 (sawtooth)"
  \partial 4 e4 |
  \repeat volta 2 {
    b4 g fis a |
    b g fis e |
  }
  b4 g fis a |
  g fis e r |
  r1^\markup \override #'(font-name . "DejaVu Sans") \italic "синтезатор молчит" |
  r1 |
}

soloNotes = \absolute {
  \ottava #1

  e''8 d'' e'' fis'' e'' d'' e'' fis'' |
  e'' d'' e'' fis'' g'' fis'' e'' d'' |
  g''1 |
  d'' |
  \bar "||"

  g''8 fis'' g'' a'' b'' a'' g'' fis'' |
  b'' a'' g'' fis'' e'' d'' e'' fis'' |
  d''1 |
  e'' |
  \ottava #0
}

soloMusic = {
  \global
  \set Staff.midiInstrument = "lead 2 (sawtooth)"
  \soloNotes
  \bar "|."
}

earlySoloDraftMusic = \absolute {
  \global
  \set Staff.midiInstrument = "lead 2 (sawtooth)"
  \ottava #1

  e''2 g''4 b'' |
  e'''1 |
  g''2 b''4 d''' |
  d'''1 |
  \ottava #0
  \bar "|."
}

guitarBreakDraftMusic = \absolute {
  \global
  \set Staff.midiInstrument = "electric guitar (clean)"

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
  \bar "|."
}

verseLine = {
  c'1 | c' | c' | s2. c'4 |
}

earlySoloCue = {
  \mark \markup \override #'(font-name . "DejaVu Sans") \box
    "Раннее соло 0:58.80–1:10.80 — черновик выше"
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

vocalGuide = {
  \global

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

  \mark \markup \override #'(font-name . "DejaVu Sans") \box "Финал"
  \repeat unfold 8 { \verseLine }
  \soloCueThree

  \bar "|."
}

soloDisplayGuide = {
  \global

  \repeat unfold 32 { s1 | } % Verse 1
  \repeat unfold 8 { s1 | } % Provisional early solo
  \repeat unfold 32 { s1 | } % Verse 2
  \repeat unfold 16 { s1 | } % Chorus 1
  \soloNotes

  \repeat unfold 32 { s1 | } % Verse 3
  \repeat unfold 16 { s1 | } % Chorus 2
  \repeat unfold 14 { s1 | } % Bridge
  \soloNotes

  \repeat unfold 32 { s1 | } % Finale
  \soloNotes
}

lineBreaks = {
  % Page 1 ends with the first confirmed solo; page 2 starts with verse 3.
  \repeat unfold 12 {
    s1 | s | s | s | s | s | s | s | \break
  }
  \pageBreak
  \repeat unfold 6 {
    s1 | s | s | s | s | s | s | s | \break
  }
  % Preserve the two seven-measure halves of the bridge.
  \repeat unfold 2 {
    s1 | s | s | s | s | s | s | \break
  }
  s1 | s | s | s | s | s | s | s | \break
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

allChords = \chordmode {
  \verseHarmony
  \soloHarmony
  \verseHarmony
  \chorusHarmony
  \soloHarmony
  \verseHarmony
  \chorusHarmony
  \bridgeHarmony
  \soloHarmony
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

allChordVoicings = {
  \global
  \verseChordVoicings
  \soloChordVoicingSpacers
  \verseChordVoicings
  \chorusChordVoicings
  \soloChordVoicingSpacers
  \verseChordVoicings
  \chorusChordVoicings
  \bridgeChordVoicings
  \soloChordVoicingSpacers
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
  "лини" -- "ям судь" -- "бы." "В"

  "оке" -- "ане" "нет за" -- "претов"
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
  "этих" "жирных" "туш!" "В"

  "оке" -- "ане" "нет за" -- "конов"
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

\markup
  \override #'(font-name . "DejaVu Sans")
  \fill-line {
    \bold "Вступление — синтезатор"
    \small \italic "по пользовательской записи ABC"
  }

\score {
  \new Staff \with {
    instrumentName = \markup \override #'(font-name . "DejaVu Sans") "Синт."
  } {
    \clef treble
    \introMusic
  }
  \layout { }
}

\markup
  \override #'(font-name . "DejaVu Sans")
  \fill-line {
    \bold "Раннее соло — черновая транскрипция"
    \right-column {
      \small \italic "0:58.80–1:10.80 · гипотеза «once»: один проход"
      \small \bold "Ноты требуют доработки"
    }
  }

\score {
  \new Staff \with {
    instrumentName = \markup \override #'(font-name . "DejaVu Sans") "Синт."
  } {
    \clef treble
    \earlySoloDraftMusic
  }
  \layout { }
}

% Keep one useful MIDI file containing the established synthesizer parts;
% omit the explicitly provisional early solo.
\score {
  \new Staff {
    \unfoldRepeats {
      \introMusic
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

    \new Staff <<
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

\markup
  \override #'(font-name . "DejaVu Sans")
  \fill-line {
    \bold "Проигрыш гитары на 3:11"
    \small \bold "Очень черновые ноты · требуют доработки"
  }

\score {
  \new Staff \with {
    instrumentName = \markup \override #'(font-name . "DejaVu Sans") "Гит."
  } {
    \clef treble
    \guitarBreakDraftMusic
  }
  \layout { }
}

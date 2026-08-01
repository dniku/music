\version "2.24.0"

\paper {
  #(set-paper-size "a4")
  top-margin = 12\mm
  bottom-margin = 12\mm
  left-margin = 12\mm
  right-margin = 12\mm
  ragged-bottom = ##f
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

fourDownbeatMeasures = {
  c'1 | c' | c' | c' | \break
}

verseLine = {
  c'1 | c' | c' | s2. c'4 | \break
}

vocalGuide = {
  \global

  \mark \markup \override #'(font-name . "DejaVu Sans") \box "Куплет 1"
  \repeat unfold 8 { \verseLine }

  \mark \markup \override #'(font-name . "DejaVu Sans") \box "Куплет 2"
  \repeat unfold 8 { \verseLine }

  \mark \markup \override #'(font-name . "DejaVu Sans") \box "Припев 1"
  \repeat unfold 4 { \fourDownbeatMeasures }

  \mark \markup \override #'(font-name . "DejaVu Sans") \box "Куплет 3"
  \repeat unfold 8 { \verseLine }

  \mark \markup \override #'(font-name . "DejaVu Sans") \box "Припев 2"
  \repeat unfold 4 { \fourDownbeatMeasures }

  \mark \markup \override #'(font-name . "DejaVu Sans") \box "Чёрные флаги"
  \fourDownbeatMeasures
  c'1 | c' | c' | \break
  \fourDownbeatMeasures
  c'1 | c' | c' | \break

  \mark \markup \override #'(font-name . "DejaVu Sans") \box "Финал"
  \repeat unfold 8 { \verseLine }

  \bar "|."
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

allChords = \chordmode {
  \verseHarmony
  \verseHarmony
  \chorusHarmony
  \verseHarmony
  \chorusHarmony
  \bridgeHarmony
  \verseHarmony
}

barLyrics = \lyricmode {
  "Только" "трусы перед" "бурей" "Уби"
  "рают" "пару" "са." \skip 1
  "А из" "бранники фор" "туны" "Держат"
  "путь на" "небе" "са." \skip 1
  "Пусть бес" "нуется сти" "хия," "Смерть хо"
  "хочет" "за бор" "том -" \skip 1
  "Наши" "головы ли" "хие" "Ей до"
  "станут" "ся по" "том." \skip 1

  "Нынче" "волки оке" "ана" "В путь го"
  "товы" "сей же" "час," \skip 1
  "Лишь бы" "был у капи" "тана" "Самый"
  "правиль" "ный ком" "пАс," \skip 1
  "И к со" "кровищам за" "бытым" "Чтобы"
  "курс про" "ложен" "был" \skip 1
  "Не по" "линиям маг" "нитным," "А по"
  "лини" "ям судь" "бы." "В"

  "оке" "ане" "нет за" "претов"
  "И про" "торен" "ных до" "рог."
  "Там над" "нами" "только" "ветер,"
  "Наш шаль" "ной пи" "ратский" "бог."

  "Не най" "ти теперь сво" "боды" "На да"
  "лёких" "бере" "гах:" \skip 1
  "Каждый" "фут земли рас" "продан," "Под кон"
  "тролем" "каждый" "шаг." \skip 1
  "За фаль" "шивыми ре" "чами-" "Пусто"
  "та трус" "ливых" "душ." \skip 1
  "Вольный" "ветер оке" "ана -" "Не для"
  "этих" "жирных" "туш!" "В"

  "оке" "ане" "нет за" "конов"
  "И жес" "токих" "пала" "чей,"
  "Наши" "име" "на за" "помнит"
  "Только" "ветер -" "страж мо" "рей."

  "Чёрные" "флаги -"
  "Верные" "знаки"
  "Вольных" "бунта" "рей."
  "Шкура в за" "платах -"
  "Доля пи" "ратов,"
  "Демо" "нов мо" "рей."

  "Кто по" "кой и безо" "пасность" "Выше"
  "счастья" "оце" "нил," \skip 1
  "Тот рас" "платится на" "прасно:" "Кто не"
  "дрался," "тот не" "жил." \skip 1
  "Пусть бри" "танская ар" "мада" "На фре"
  "гат нарвё" "тся" "наш -" \skip 1
  "Мы лю" "бой добыче" "рады." "Эй, впе"
  "рёд, на" "абор" "даж!" \skip 1
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
  \midi { }
}

\markup \vspace #1

\score {
  <<
    \new ChordNames {
      \set chordChanges = ##t
      \allChords
    }

    \new Staff <<
      \new Voice = "lyricsGuide" {
        \hideNotes
        \vocalGuide
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
      \override LyricText.font-size = #-1
      \override LyricText.self-alignment-X = #LEFT
      \override LyricSpace.minimum-distance = #1.2
    }
  }
}

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
    "Звуки: " #(instrument-legend) "SplitPnt (fn 007) = 074 (=D5)"
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

fourBarAlignment = {
  \repeat unfold 4 { s1 | }
}

eightBarAlignment = {
  \repeat unfold 8 { s1 | }
}

fourteenBarAlignment = {
  \repeat unfold 14 { s1 | }
}

sixteenBarAlignment = {
  \repeat unfold 16 { s1 | }
}

thirtyTwoBarAlignment = {
  \repeat unfold 32 { s1 | }
}

introPreBassRight = {
  \part "102" "Вступление 1 / 00:00–00:12"
  \introNotes
}

introRightEmPair = \absolute {
  <b''-2 e'''-5>1~ | <b'' e'''> |
}

introRightGPair = \absolute {
  <g''-1 b''-2>1~ | <g'' b''> |
}

introRightPatternEnding = \absolute {
  <d'''-1 g'''-4>1 | <des'''-1 ges'''-4> |
  <d'''-1 g'''-4> | <g''-1 b''-2> |
}

introRightPattern = \absolute {
  \set fingeringOrientations = #'(left)
  \introRightEmPair
  \introRightGPair
  \introRightPatternEnding
}

introRight = {
  \part "463" "Вступление 2 / 00:12–00:36"
  \repeat unfold 8 { s1 | }

  \ottava #1
  \introRightPattern
  % Measures 25–26 repeat 19–20; measures 27–28 repeat 17–18.
  \introRightGPair
  \introRightEmPair
  \ottava #0

  \repeat unfold 4 { s1 | }

  \ottava #1
  \introRightGPair
  \introRightEmPair
  \introRightPatternEnding
  \ottava #0
}

firstVerseRight = {
  \part "463" "Куплет / 00:36–00:59"
  % TODO(Codeberg): здесь есть ксилофон.
  \thirtyTwoBarAlignment
}

firstBridgeRight = {
  \part "102" "Проигрыш 1 / 00:59–01:11"
  \earlySoloNotes
}

secondVerseRight = {
  \part "463" "Куплет 2 / 01:11–01:59"
  % TODO(Codeberg): здесь есть ксилофон.
  \thirtyTwoBarAlignment
}

% These dyads duplicate the upper two notes of chorusChordVoicings two octaves
% higher. Keeping the short derivation explicit is simpler than transforming
% chord events with Scheme; ottava only lowers their printed staff position.
chorusRightVoicings = \absolute {
  \set Staff.midiInstrument = #(cdr (assoc "463" instruments))
  \ottava #1
  <g''' b'''>1~ | <g''' b'''> |
  <fis''' a'''>1~ | <fis''' a'''> |
  <e''' g'''>1 | <b''' d''''> |
  <e''' g'''> | <fis''' a'''> |
  <g''' b'''>1~ | <g''' b'''> |
  <fis''' a'''>1~ | <fis''' a'''> |
  <e''' g'''>1 | <b''' d''''> |
  <fis''' a'''>1~ | <fis''' a'''> |
  \ottava #0
}

soloCueOne = {
  \mark \markup \override #'(font-name . "DejaVu Sans") \box
    "Соло 1:45.70–1:57.30"
  \eightBarAlignment
}

soloCueTwo = {
  \mark \markup \override #'(font-name . "DejaVu Sans") \box
    "Соло 2:43.90–2:55.50"
  \eightBarAlignment
}

soloCueThree = {
  \mark \markup \override #'(font-name . "DejaVu Sans") \box
    "Соло 5:15.20–5:26.80"
  \eightBarAlignment
}

guitarBreakCue = {
  \mark \markup \override #'(font-name . "DejaVu Sans") \box \left-column {
    "Проигрыш гитары на 3:11"
    \tiny "Очень черновые ноты · требуют доработки"
  }
  \fourBarAlignment
}

vocalGuide = {
  \global
  \introAlignment
  \thirtyTwoBarAlignment

  \repeat unfold 8 { \verseLine }
  \eightBarAlignment

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

  \chorusRightVoicings % Chorus 1
  \soloNotes

  \thirtyTwoBarAlignment % Verse 3
  \chorusRightVoicings % Chorus 2
  \fourteenBarAlignment % Bridge
  \soloNotes
  \guitarBreakDraftNotes

  \thirtyTwoBarAlignment % Finale
  \soloNotes
}

lowerHandGuide = {
  \global
  \clef treble
  \introAlignment
  \thirtyTwoBarAlignment % Intro 2
  \thirtyTwoBarAlignment % Verse 1
  \eightBarAlignment % Early solo
  \thirtyTwoBarAlignment % Verse 2
  \sixteenBarAlignment % Chorus 1
  \eightBarAlignment % Solo 1
  \thirtyTwoBarAlignment % Verse 3
  \sixteenBarAlignment % Chorus 2
  \fourteenBarAlignment % Bridge
  \eightBarAlignment % Solo 2
  \fourBarAlignment % Guitar break
  \thirtyTwoBarAlignment % Finale
  \eightBarAlignment % Solo 3
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

earlyBridgeHarmony = \chordmode {
  e1:m | e:m | g | d |
  e1:m | e:m | g | g2 d2 |
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
  \eightBarAlignment
  \verseHarmony
  \chorusHarmony
  \bridgeHarmony
  \eightBarAlignment
  \fourBarAlignment
  \verseHarmony
  \eightBarAlignment
}

emTwoBarVoicing = \absolute {
  <e'-5 g'-3 b'-1>1~ | <e' g' b'>1 |
}

gTwoBarVoicing = \absolute {
  <g' b' d''>1~ | <g' b' d''>1 |
}

dTwoBarVoicing = \absolute {
  <d'-5 fis'-3 a'-1>1~ | <d' fis' a'>1 |
}

bSevenTwoBarVoicing = \absolute {
  <b-5 dis'-3 fis'-2 a'-1>1~ | <b dis' fis' a'>1 |
}

cTwoBarVoicing = \absolute {
  <c'-5 e'-3 g'-1>1~ | <c' e' g'>1 |
}

verseChordVoicings = \absolute {
  \set fingeringOrientations = #'(left)
  \repeat unfold 4 {
    <e'-5 g'-3 b'-1>1~ | <e' g' b'>1~ |
    <e' g' b'>1~ | <e' g' b'>1 |
    <g'-5 b'-3 d''-1>1~ | <g' b' d''>1 |
    <d'-5 fis'-3 a'-1>1~ | <d' fis' a'>1 |
  }
}

chorusChordVoicings = \absolute {
  \set fingeringOrientations = #'(left)
  \emTwoBarVoicing \bSevenTwoBarVoicing
  <c'-5 e'-3 g'-1>1 | <g'-5 b'-3 d''-1> |
  <c'-5 e'-3 g'-1> | <d'-5 fis'-3 a'-1> |
  \emTwoBarVoicing \bSevenTwoBarVoicing
  <c'-5 e'-3 g'-1>1 | <g'-5 b'-3 d''-1> | \dTwoBarVoicing
}

bridgeChordVoicings = \absolute {
  \set fingeringOrientations = #'(left)
  \emTwoBarVoicing
  \cTwoBarVoicing
  <g'-5 b'-3 d''-1>1 | \dTwoBarVoicing
  \emTwoBarVoicing
  \cTwoBarVoicing
  <g'-5 b'-3 d''-1>1 | \dTwoBarVoicing
}

earlyBridgeChordVoicings = \absolute {
  \set fingeringOrientations = #'(left)
  <e'-5 g'-3 b'-1>1~ | <e' g' b'> |
  <g'-5 b'-3 d''-1>1 | <d'-5 fis'-3 a'-1> |
  <e'-5 g'-3 b'-1>1~ | <e' g' b'> |
  <g'-5 b'-3 d''-1>1~ | <g' b' d''>2 <d'-5 fis'-3 a'-1>2 |
}

postIntroEmVoicing = \absolute {
  \set fingeringOrientations = #'(left)
  <e'-5 g'-3 b'-1>1~ | <e' g' b'>1~ |
  <e' g' b'>1~ | <e' g' b'>1 |
}

postIntroProgressionVoicings = \absolute {
  \set fingeringOrientations = #'(left)
  <g'-4 b'-2 d''-1>1 | <fis'-5 b'-2 d''-1> |
  <e'-5 a'-2 cis''-1> | <d'-5 fis'-3 a'-1> |
}

postIntroAlternatingProgressionVoicings = \absolute {
  \set fingeringOrientations = #'(left)
  <g'-5 b'-3 d''-1>1 | <fis'-5 ais'-3 cis''-1> |
  <g'-5 b'-3 d''-1> | <e'-5 g'-3 b'-1> |
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
  \eightBarAlignment
  \verseChordVoicings
  \chorusChordVoicings
  \bridgeChordVoicings
  \eightBarAlignment
  \fourBarAlignment
  \verseChordVoicings
  \eightBarAlignment
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

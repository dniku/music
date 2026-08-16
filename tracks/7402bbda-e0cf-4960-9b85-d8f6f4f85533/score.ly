\version "2.24.0"
\paper { indent = 0 }

\layout {
    \context { \Lyrics \override
        LyricSpace.minimum-distance = #1.2
    }
    \context { \Staff \override
        TimeSignature.break-visibility = #end-of-line-invisible
    }
}

global = { \key e \minor \time 4/4 \tempo 4 = 165 }

% номер звука на синтезаторе - название midiInstrument
% https://lilypond.org/doc/v2.24/Documentation/notation/midi-instruments
#(define instruments '(
    ("001" . "lead 2 (sawtooth)")
    ("002" . "pad 2 (warm)")
    ("003" . "acoustic grand")
))

part = #(define-music-function (idx text) (string? string?) #{
   \set Staff.midiInstrument = #(cdr (assoc idx instruments))
   \textMark \markup { \box { #text \bold { #idx } } }
#})

#(define (legend) #{
    \markup { \vcenter { \column {
        #@(map
            (lambda (entry) (
                string-append (car entry) " - " (cdr entry))
            )
            instruments
        )
    }}}
#})

\header {
    title = "Волки Океана"
    composer = "Атом-76"
    piece = \markup { "Левая рука всегда играет" \bold "002" }
    opus = \markup \column { "Звуки:" \null #(legend) }
}

introAlignment = {
  \repeat unfold 7 { s1 | }
  s2 |
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

guitarBreakDraftNotes = \absolute {
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
}

verseLine = {
  c'1 | c' | c' | s2. c'4 |
}

postIntroAlignment = {
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


  \repeat unfold 8 { s1 | }
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

introPreBassRight = \fixed c' {
    \part "001" "Вступление 1 / 00:00-00:12"
    \set countPercentRepeats = ##t
    \repeat percent 6 { e8 b g fis a b g fis | }
    e8 b g fis b g fis \tieDown e~ \tieNeutral |
    \time 2/4 e2 | \time 4/4
}

introRight = {
    \clef "treble_8"
    \part "002" "Вступление 2 / 00:12-00:36"

    \repeat unfold 8 { s1 | } \break
    <b e'>1~ | <b e'> | <g b>1~ | <g b> |
    <d' g'>1 | <des' ges'> | <d' g'> | <g b> | \break

    \repeat unfold 8 { s1 | } \break

    <b e'>1~ | <b e'> | <g b>1~ | <g b> |
    <d' g'>1 | <des' ges'> | <d' g'> | <g b> |
    \clef treble
}

firstVerseRight = {
    \pageBreak
    \part "002" "Куплет / 00:36-00:59"
    % TODO здесь есть ксилофон
    \repeat unfold 4 { \repeat unfold 8 { s1 | } \break }
}

firstBridgeRight = {
    \clef "treble_8"
    \part "001" "Проигрыш 1 / 00:59-01:11"
    e'1 | b | e~ | e |
    s1 | s1 | s1 | s1 | \break
    e| g2 b | e'1~ | e' |
    g~ | g | b | d'2 d' |
    \clef treble
}

rightHandNotes = {
    \introPreBassRight
    \introRight
    \firstVerseRight
    \firstBridgeRight

    \break
    \pageBreak

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

guitarBreakChordVoicingSpacers = {
  \repeat unfold 4 { s1 | }
}

postIntroEmVoicing = \emFourBarVoicing

postIntroProgressionVoicings = \absolute {
  <d' g' b'>1 | <d' fis' b'> | <cis' e' a'> | <d' fis' a'> |
}

postIntroAlternatingProgressionVoicings = \absolute {
  <d' g' b'>1 | <cis' fis' ais'> | <d' g' b'> | <e' g' b'> |
}

introLeft = \repeat unfold 2 { \chordmode {
    e1:m~ | q~ | q~ | q | g | b:m/fis | a/e | d |
    e1:m~ | q~ | q~ | q | g | f#      | g   | e:m |
}}

% куплет 1, 2 строчки проигрыша, куплет 2
versesLeft = \repeat unfold 10 { \chordmode {
    e1:m~ | q~ | q~ | q | g~ | q | d~ | q |
}}

leftHand = {
    \global
    \repeat unfold 7 { s1 | } s2 |
    \introLeft
    \versesLeft

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

lyricsText = \lyricmode {
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

rightHand = \new Staff = "rightHand" <<
    \new Voice = "lyricsGuide" { \voiceTwo \hideNotes \vocalGuide }
    \new Voice { \rightHandNotes }
>>

\score { << \new PianoStaff <<
    \rightHand
    \new Lyrics \lyricsto "lyricsGuide" { \lyricsText }
    \new Staff = "leftHand" << \new Voice { \leftHand } >>
    \new ChordNames { \set chordChanges = ##t \allChords }
>> >> }

\version "2.24.0"
\include "drums-generated.ily"

#(set-global-staff-size 18)
\paper {
  #(set-paper-size "a4")
  top-margin = 10\mm
  bottom-margin = 10\mm
  left-margin = 12\mm
  right-margin = 12\mm
  ragged-last-bottom = ##t
}
\header {
  title = "Mother Earth — барабаны"
  subtitle = "Черновик по атакам оригинальной записи"
  composer = "Within Temptation"
  tagline = "Округление до восьмых только для PDF; MIDI и MP3 сохраняют исходные времена атак."
}
\markup \column {
  \small "Сетка: 3/4, четверть = 210, первый такт с 0:00.45. Таймкоды — начала строк."
  \small "Бочка — нижняя нота; малый — средняя; хай-хэт — крестик сверху."
  \small "Хай-хэт условно обозначает тарелки. Возможны лишние и пропущенные удары."
  \small "Паузы означают отсутствие распознанных атак, а не гарантированную тишину в оригинале."
  \small "Близкие атаки одного инструмента на одной восьмой объединены. Источник: YouTube FVbDZaUuNvQ."
}
\score {
  \new DrumStaff {
    \time 3/4
    \tempo 4 = 210
    \override Score.RehearsalMark.self-alignment-X = #LEFT
    \override Score.RehearsalMark.font-size = #-2
    \compressMMRests \drumMusic
  }
  \layout { indent = 0 }
  % Diagnostic quantized MIDI; the site keeps publishing the original attack timing.
  \midi { }
}

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
    "Текст по тактам · 6/8 · "
    \note { 4 } #1
    " = 165"
  }
  composer = \markup \override #'(font-name . "DejaVu Sans") "Атом-76"
  tagline = ##f
}

verseOne = \markup
  \override #'(font-name . "DejaVu Sans")
  \override #'(baseline-skip . 3.2)
  \column {
    \line { \bold "Куплет 1" }
    \line { "То│лько тру│сы перед бу│рей │" }
    \line { "Убира│ют па│руса│. │" }
    \line { "А│ избра│нники форту│ны  │" }
    \line { "Держат пу│ть на не│беса│. │" }
    \vspace #0.35
    \line { "Пу│сть бесну│ется стихи│я, │" }
    \line { "Смерть хохо│чет за│ борто│м — │" }
    \line { "На│ши го│ловы лихи│е │" }
    \line { "Ей доста│нутся│ пото│м. │" }
  }

verseTwo = \markup
  \override #'(font-name . "DejaVu Sans")
  \override #'(baseline-skip . 3.2)
  \column {
    \line { \bold "Куплет 2" }
    \line { "Ны│нче во│лки океа│на │" }
    \line { "В путь гото│вы се│й же ча│с, │" }
    \line { "Ли│шь бы бы│л у капита│на │" }
    \line { "Самый пра│вильны│й компА│с, │" }
    \line { "И│ к сокро│вищам забы│тым │" }
    \line { "Чтобы ку│рс проло│жен бы│л │" }
    \line { "Не│ по ли│ниям магни│тным, │" }
    \line { "А по ли│ния│м судьбы│. │" }
  }

chorusOne = \markup
  \override #'(font-name . "DejaVu Sans")
  \override #'(baseline-skip . 3.2)
  \column {
    \line { \bold "Припев 1" }
    \line { "В о│кеа│не не│т запре│тов" }
    \line { "И│ прото│ренны│х доро│г." }
    \line { "Та│м над на│ми то│лько ве│тер," }
    \line { "На│ш шально│й пира│тский бо│г." }
  }

verseThree = \markup
  \override #'(font-name . "DejaVu Sans")
  \override #'(baseline-skip . 3.2)
  \column {
    \line { \bold "Куплет 3" }
    \line { "Не│ найти│ теперь свобо│ды │" }
    \line { "На далё│ких бе│рега│х: │" }
    \line { "Ка│ждый фу│т земли распро│дан, │" }
    \line { "Под контро│лем ка│ждый ша│г. │" }
    \line { "З│а фальши│выми реча│ми — │" }
    \line { "Пустота│ трусли│вых ду│ш. │" }
    \line { "Во│льный ве│тер океа│на — │" }
    \line { "Не для э│тих жи│рных ту│ш! │" }
  }

chorusTwo = \markup
  \override #'(font-name . "DejaVu Sans")
  \override #'(baseline-skip . 3.2)
  \column {
    \line { \bold "Припев 2" }
    \line { "В о│кеа│не не│т зако│нов" }
    \line { "И│ жесто│ких па│лаче│й," }
    \line { "На│ши и│мена│ запо│мнит" }
    \line { "То│лько ве│тер — стра│ж море│й." }
  }

bridge = \markup
  \override #'(font-name . "DejaVu Sans")
  \override #'(baseline-skip . 3.2)
  \column {
    \line { \bold "Чёрные флаги" }
    \line { "Чё│рные фла│ги —" }
    \line { "Ве│рные зна│ки" }
    \line { "Во│льных бу│нтаре│й." }
    \line { "Шку│ра в запла│тах —" }
    \line { "До│ля пира│тов," }
    \line { "Де│моно│в море│й." }
  }

finalVerse = \markup
  \override #'(font-name . "DejaVu Sans")
  \override #'(baseline-skip . 3.2)
  \column {
    \line { \bold "Финал" }
    \line { "Кто│ поко│й и безопа│сность │" }
    \line { "Выше сча│стья о│цени│л, │" }
    \line { "То│т распла│тится напра│сно: │" }
    \line { "Кто не дра│лся, то│т не жи│л. │" }
    \line { "Пу│сть брита│нская арма│да │" }
    \line { "На фрега│т нарвё│тся на│ш — │" }
    \line { "Мы│ любо│й добыче ра│ды. │" }
    \line { "Эй, вперё│д, на а│борда│ж! │" }
  }

\markup
  \override #'(font-name . "DejaVu Sans")
  \fill-line {
    \column {
      \verseOne
      \vspace #0.8
      \verseTwo
      \vspace #0.8
      \chorusOne
    }
    \hspace #3
    \column {
      \verseThree
      \vspace #0.8
      \chorusTwo
      \vspace #0.8
      \bridge
      \vspace #0.8
      \finalVerse
    }
  }

\markup
  \override #'(font-name . "DejaVu Sans")
  \fill-line {
    \fontsize #-2 \italic
    "│ — начало такта по пользовательской разметке; граница может проходить внутри слова."
  }

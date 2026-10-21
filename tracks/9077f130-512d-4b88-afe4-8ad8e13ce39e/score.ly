\version "2.24.0"

% Imported from YTPA's Mother_Earth.musicxml with the pinned musicxml2ly.
% See README.md and dvc.yaml for the baseline, its hash, and exact command.
% Variable names and executable tempo were adjusted after import.
% Whole-chord octaves and selected inversions are chosen per phrase; see README.md.
% The added bass at bar 69 is corrected to a three-note C#m/E inversion.

melody = {
  \clef "treble" \time 3/4 \key e \major \tempo 4 = 220 cis''2-2 dis''4-3 | % 1
  e''2-4 dis''4-3 | % 2
  e''4-4 dis''4-3 cis''4-2 | % 3
  b'2-1 b'4-1 | % 4
  cis''2-2 dis''4-3 | % 5
  e''2-4 dis''4-3 | % 6
  fis''4-4 e''4-3 dis''4-2 | % 7
  gis''2-5 fis''4-4 | % 8
  cis''2-2 dis''4-3 | % 9

  \barNumberCheck #10
  e''2-4 dis''4-3 | % 10
  e''4-4 dis''4-3 cis''4-2 | % 11
  b'2-1 b'4-1 | % 12
  fis''4-4 e''4-3 dis''4-2 | % 13
  e''4-3 dis''4-2 cis''4-1 | % 14
  cis''2.-1 ~ | % 15
  cis''2. \bar "||" % 16
  cis''2-2 dis''4-3 | % 17
  e''2-4 dis''4-3 | % 18
  e''4-4 dis''4-3 cis''4-2 | % 19

  \barNumberCheck #20
  b'2-1 b'4-1 | % 20
  cis''2-2 dis''4-3 | % 21
  e''2-4 dis''4-3 | % 22
  fis''4-4 e''4-3 dis''4-2 | % 23
  gis''2-5 fis''4-4 | % 24
  cis''2-2 dis''4-3 | % 25
  e''2-4 dis''4-3 | % 26
  e''4-4 dis''4-3 cis''4-2 | % 27
  b'2-1 b'4-1 | % 28
  fis''4-4 e''4-3 dis''4-2 | % 29

  \barNumberCheck #30
  e''4-3 dis''4-2 cis''4-1 | % 30
  cis''2.-1 ~ | % 31
  cis''2. \bar "||" % 32
  cis''2-2 dis''4-3 | % 33
  e''2-4 dis''4-3 | % 34
  e''4-4 dis''4-3 cis''4-2 | % 35
  b'8-1 b'4-1 b'4-1 b'8-1 | % 36
  cis''2-2 dis''4-3 | % 37
  e''2-4 dis''4-3 | % 38
  gis''4-5 cis''4-2 dis''4-3 | % 39

  \barNumberCheck #40
  e''4-4 dis''4-3 b'4-1 | % 40
  cis''2-2 dis''4-3 | % 41
  e''2-4 dis''4-3 | % 42
  e''4-4 dis''4-3 cis''4-2 | % 43
  b'8-1 b'4-1 b'4-1 b'8-1 | % 44
  fis''2-4 fis''4-4 | % 45
  e''2-3 e''4-3 | % 46
  dis''2-2 dis''4-2 | % 47
  gis''2.-5 \bar "||" % 48
  cis''2-2 dis''4-3 | % 49

  \barNumberCheck #50
  e''2-4 dis''4-3 | % 50
  e''4-4 dis''4-3 cis''4-2 | % 51
  b'8-1 b'4-1 b'4-1 b'8-1 | % 52
  cis''2-2 dis''4-3 | % 53
  e''2-4 dis''4-3 | % 54
  gis''4-5 cis''4-2 dis''4-3 | % 55
  e''4-4 dis''4-3 b'4-1 | % 56
  cis''2-2 dis''4-3 | % 57
  e''2-4 dis''4-3 | % 58
  e''4-4 dis''4-3 cis''4-2 | % 59

  \barNumberCheck #60
  b'8-1 b'4-1 b'4-1 b'8-1 | % 60
  fis''2-4 fis''4-4 | % 61
  e''2-3 e''4-3 | % 62
  fisis''2-4 fisis''4-4 | % 63
  gis''2.-5 \bar "||" % 64
  a'2.-1 ~ | % 65
  a'2. | % 66
  cis''2.-2 ~ | % 67
  cis''2. | % 68
  e''2.-3 ~ | % 69

  \barNumberCheck #70
  e''2. | % 70
  gis''2.-5 ~ | % 71
  gis''2. \bar "||" % 72
  cis''2-2 dis''4-3 | % 73
  e''2-4 dis''4-3 | % 74
  e''4-4 dis''4-3 cis''4-2 | % 75
  b'2-1 b'4-1 | % 76
  cis''2-2 dis''4-3 | % 77
  e''2-4 dis''4-3 | % 78
  fis''4-4 e''4-3 dis''4-2 | % 79

  \barNumberCheck #80
  gis''2-5 fis''4-4 | % 80
  cis''2-2 dis''4-3 | % 81
  e''2-4 dis''4-3 | % 82
  e''4-4 dis''4-3 cis''4-2 | % 83
  b'2-1 b'4-1 | % 84
  fis''4-4 e''4-3 dis''4-2 | % 85
  e''4-3 dis''4-2 cis''4-1 | % 86
  cis''2.-1 ~ | % 87
  cis''2. \bar "||" % 88
  R2. | % 89

  \barNumberCheck #90
  cis''2-5 b'4-4 | % 90
  cis''4-5 b'2-4 | % 91
  cis''2.-5 | % 92
  r2 a'4-3 | % 93
  a'2-3 b'4-4 | % 94
  gis'4-2 ( fis'4-1 ) fis'4-1 | % 95
  fis'2-1 gis'4-2 | % 96
  a'4-3 ( gis'2-2 ) | % 97
  cis'2-1 dis'4-2 | % 98
  e'2-3 fis'4-4 | % 99

  \barNumberCheck #100
  gis'2-5 ( fis'4-4 ) | % 100
  r2 cis''4-5 | % 101
  cis''4-5 b'4-4 cis''4-5 | % 102
  cis''4-5 ( b'2-4 ) | % 103
  gis'2-2 ( fis'4-1 ) \bar "||" % 104
  R2. | % 105
  cis''2-5 b'4-4 | % 106
  cis''4-5 ( b'2-4 ) ( | % 107
  cis''2.-5 ) | % 108
  r2 a'4-3 | % 109

  \barNumberCheck #110
  a'2-3 b'4-4 | % 110
  gis'4-2 ( fis'4-1 ) fis'4-1 | % 111
  fis'2-1 gis'4-2 | % 112
  a'4-3 ( gis'4-2 ) cis'4-1 | % 113
  cis'2-1 dis'4-2 | % 114
  e'2-3 fis'4-4 | % 115
  gis'2-5 ( fis'4-4 ) | % 116
  r2 cis''4-5 | % 117
  cis''4-5 b'4-4 cis''4-5 | % 118
  cis''4-5 ( b'2-4 ) | % 119

  \barNumberCheck #120
  gis'2-2 ( fis'4-1 ) \bar "||" % 120
  R2. | % 121
  e''2-3 dis''4-2 | % 122
  dis''2.-2 ~ | % 123
  dis''2. | % 124
  fis''2.-4 | % 125
  dis''4-2 e''4-3 cis''4-1 ~ | % 126
  cis''2. ~ | % 127
  cis''2. | % 128
  r2 cis''4-1 | % 129

  \barNumberCheck #130
  cis''2-1 dis''4-2 | % 130
  e''2-3 cis''4-1 | % 131
  cis''2.-1 | % 132
  r2 dis''4-4 | % 133
  dis''4-4 ais'4-1 cis''4-3 | % 134
  bis'2.-2 ~ | % 135
  bis'2. \bar "||" % 136
  R2. | % 137
  e''2-3 dis''4-2 | % 138
  dis''2.-2 ~ | % 139

  \barNumberCheck #140
  dis''2. | % 140
  fis''2.-4 | % 141
  dis''4-2 e''4-3 cis''4-1 ~ | % 142
  cis''2. ~ | % 143
  cis''2. | % 144
  r2 cis''4-1 | % 145
  cis''2-1 dis''4-2 | % 146
  e''2-3 cis''4-1 | % 147
  cis''2.-1 | % 148
  r2 bis'4-2 | % 149

  \barNumberCheck #150
  bis'2-2 cis''4-3 | % 150
  cis''2.-3 ~ | % 151
  cis''2. \bar "||"
}

harmonies = \chordmode {
  cis2:m s4 | % 1
  s2 s4 | % 2
  a,4 s4 s4 | % 3
  b,2 s4 | % 4
  cis2:m s4 | % 5
  s2 s4 | % 6
  a,4 s4 s4 | % 7
  fis2:m/a s4 | % 8
  cis2:m s4 | % 9

  \barNumberCheck #10
  s2 s4 | % 10
  a,4 s4 s4 | % 11
  e2/b s4 | % 12
  fis4:m/cis s4 s4 | % 13
  gis4/bis s4 s4 | % 14
  cis2.:m | % 15
  s2. \bar "||" % 16
  cis2:m s4 | % 17
  s2 s4 | % 18
  a,4 s4 s4 | % 19

  \barNumberCheck #20
  b,2 s4 | % 20
  cis2:m s4 | % 21
  s2 s4 | % 22
  a,4 s4 s4 | % 23
  fis2:m/a s4 | % 24
  cis2:m s4 | % 25
  s2 s4 | % 26
  a,4 s4 s4 | % 27
  e2/b s4 | % 28
  fis4:m/cis s4 s4 | % 29

  \barNumberCheck #30
  gis4/bis s4 s4 | % 30
  cis2.:m | % 31
  s2. \bar "||" % 32
  cis2:m s4 | % 33
  s2 s4 | % 34
  s4 s4 s4 | % 35
  e8 s4 s4 s8 | % 36
  cis2:m s4 | % 37
  s2 s4 | % 38
  s4 s4 s4 | % 39

  \barNumberCheck #40
  e4 dis4 b,4 | % 40
  cis2:m s4 | % 41
  s2 s4 | % 42
  s4 s4 s4 | % 43
  e8 s4 s4 s8 | % 44
  fis2:m/cis s4 | % 45
  e2 s4 | % 46
  dis2 s4 | % 47
  gis,2. \bar "||" % 48
  cis2:m s4 | % 49

  \barNumberCheck #50
  s2 s4 | % 50
  s4 s4 s4 | % 51
  e8 s4 s4 s8 | % 52
  cis2:m s4 | % 53
  s2 s4 | % 54
  s4 s4 s4 | % 55
  e4 dis4 b,4 | % 56
  cis2:m s4 | % 57
  s2 s4 | % 58
  s4 s4 s4 | % 59

  \barNumberCheck #60
  e8 s4 s4 s8 | % 60
  fis2:m/cis s4 | % 61
  e2 s4 | % 62
  dis2 s4 | % 63
  gis,2. \bar "||" % 64
  a,2. | % 65
  s2. | % 66
  cis2.:m | % 67
  s2. | % 68
  % /e creates an inversion; /+e adds a fourth note. The raised root keeps
  % the inversion's bass at E3 after the staff's octave-down transposition.
  cis'2.:m/e | % 69

  \barNumberCheck #70
  s2. | % 70
  % Continue the rising bass A-C#-E-G# before returning to the main register.
  gis2. | % 71
  s2. \bar "||" % 72
  cis2:m s4 | % 73
  s2 s4 | % 74
  a,4 s4 s4 | % 75
  b,2 s4 | % 76
  cis2:m s4 | % 77
  s2 s4 | % 78
  a,4 s4 s4 | % 79

  \barNumberCheck #80
  fis2:m/a s4 | % 80
  cis2:m s4 | % 81
  s2 s4 | % 82
  a,4 s4 s4 | % 83
  e2/b s4 | % 84
  fis4:m/cis s4 s4 | % 85
  gis4/bis s4 s4 | % 86
  cis2.:m | % 87
  s2. \bar "||" % 88
  cis2.:m | % 89

  \barNumberCheck #90
  s2 s4 | % 90
  s4 s2 | % 91
  s2. | % 92
  a,2 s4 | % 93
  s2 s4 | % 94
  e4 s4 s4 | % 95
  b,2 s4 | % 96
  cis4:m s2 | % 97
  s2 s4 | % 98
  s2 s4 | % 99

  \barNumberCheck #100
  s2 s4 | % 100
  fis,2:m s4 | % 101
  s4 s4 s4 | % 102
  gis,4 s2 | % 103
  s2 s4 \bar "||" % 104
  cis2.:m | % 105
  s2 s4 | % 106
  s4 s2 | % 107
  s2. | % 108
  a,2 s4 | % 109

  \barNumberCheck #110
  s2 s4 | % 110
  e4 s4 s4 | % 111
  b,2 s4 | % 112
  cis4:m s4 s4 | % 113
  s2 s4 | % 114
  s2 s4 | % 115
  s2 s4 | % 116
  fis,2:m s4 | % 117
  s4 s4 s4 | % 118
  gis,4 s2 | % 119

  \barNumberCheck #120
  s2 s4 \bar "||" % 120
  cis2.:m | % 121
  s2 s4 | % 122
  gis,2. | % 123
  s2. | % 124
  b,2. | % 125
  s4 s4 s4 | % 126
  fis,2.:m | % 127
  s2. | % 128
  fis,2:m s4 | % 129

  \barNumberCheck #130
  s2 s4 | % 130
  cis2:m s4 | % 131
  s2. | % 132
  dis2 s4 | % 133
  s4 s4 s4 | % 134
  gis,2. | % 135
  s2. \bar "||" % 136
  cis2.:m | % 137
  s2 s4 | % 138
  gis,2. | % 139

  \barNumberCheck #140
  s2. | % 140
  b,2. | % 141
  s4 s4 s4 | % 142
  fis,2.:m | % 143
  s2. | % 144
  fis,2:m s4 | % 145
  s2 s4 | % 146
  cis2:m s4 | % 147
  s2. | % 148
  gis,2 s4 | % 149

  \barNumberCheck #150
  s2 s4 | % 150
  cis2.:m | % 151
  s2. \bar "||"
}

#(set-global-staff-size 18)

\paper {
  #(set-paper-size "a4")
  top-margin = 10\mm
  bottom-margin = 10\mm
  left-margin = 12\mm
  right-margin = 12\mm
  systems-per-page = #6
  page-count = #2
}

\header {
  title = \markup \override #'(font-name . "DejaVu Sans") \bold "Mother Earth"
  subtitle = \markup \override #'(font-name . "DejaVu Sans")
    "Мелодия и аккорды · фрагмент"
  composer = \markup \override #'(font-name . "DejaVu Sans") "Within Temptation"
  copyright = \markup \tiny \override #'(font-name . "DejaVu Sans")
    \with-url "https://ytpa.ch/en/piece?scoreId=FVbDZaUuNvQ"
    "На основе нот с ytpa.ch"
  tagline = ##f
}

% musicxml2ly uses skips between chord symbols, not accompaniment rests.
% Sum each chord's following skips, preserving every explicit chord attack.
% Split sustained chords at the 3/4 bar boundaries explicitly, so only the
% attack carries fingerings (not each continuation created by completion).
heldHarmonies = #(let ((previous #f) (chords '()))
  (for-each
    (lambda (music)
      (case (ly:music-property music 'name)
        ((EventChord)
          (set! previous (ly:music-deep-copy music))
          ;; Closed LH triads: 5-3-1; second inversions, F#m/A and B: 5-2-1.
          ;; A -> F#m/A keeps the outer fingers and moves the middle finger.
          ;; F#m/C# -> G#/B#: 5-2-1 -> 4-2-1.
          (let* ((notes (sort (event-chord-notes previous)
                         (lambda (a b)
                           (ly:pitch<? (ly:music-property a 'pitch)
                                       (ly:music-property b 'pitch)))))
                 (pitches (map (lambda (note)
                                 (ly:pitch-semitones
                                   (ly:music-property note 'pitch))) notes))
                 (pitch-classes (map (lambda (p) (modulo p 12)) pitches)))
            (if (not (= (length notes) 3))
                (ly:error "Expected a three-note accompaniment chord"))
            (for-each
              (lambda (note finger)
                (set! (ly:music-property note 'articulations)
                      (cons (make-music 'FingeringEvent 'digit finger)
                            (ly:music-property note 'articulations))))
              notes (cond
                      ((equal? pitch-classes '(0 3 8)) '(4 2 1)) ; G#/B#
                      ((or (= (- (cadr pitches) (car pitches)) 5)
                           (member pitch-classes '((9 1 6) (11 3 6))))
                       '(5 2 1)) ; Second inversions, F#m/A, B.
                      (else '(5 3 1)))))
          (set! chords (cons previous chords)))
        ((SkipEvent)
          (if (not previous)
              (ly:error "Cannot sustain a skip before the first chord"))
          (for-each
            (lambda (note)
              (set! (ly:music-property note 'duration)
                    (make-duration-of-length
                      (ly:moment-add (ly:music-length note)
                                     (ly:music-length music)))))
            (event-chord-notes previous)))))
    (extract-named-music harmonies '(EventChord SkipEvent)))
  (let ((position 0) (parts '()))
    (for-each
      (lambda (chord)
        (let loop ((remaining (ly:moment-main (ly:music-length chord)))
                   (attack #t))
          (let* ((in-bar (- position (* 3/4 (floor (/ position 3/4)))))
                 (length (min remaining (- 3/4 in-bar)))
                 (part (ly:music-deep-copy chord)))
            (for-each
              (lambda (note)
                (set! (ly:music-property note 'duration)
                      (make-duration-of-length (ly:make-moment length)))
                (if (not attack)
                    (set! (ly:music-property note 'articulations)
                          (filter (lambda (a)
                                    (not (music-is-of-type? a 'fingering-event)))
                                  (ly:music-property note 'articulations))))
                (if (> remaining length)
                    (set! (ly:music-property note 'articulations)
                          (cons (make-music 'TieEvent)
                                (ly:music-property note 'articulations)))))
              (event-chord-notes part))
            (set! parts (cons part parts))
            (set! position (+ position length))
            (if (> remaining length) (loop (- remaining length) #f)))))
      (reverse chords))
    (let ((result (make-sequential-music (reverse parts))))
      (if (not (equal? (ly:music-length result) (ly:music-length harmonies)))
          (ly:error "Expected one sequential chord-symbol stream with skips"))
      result)))

pianoMusic = \new PianoStaff <<
  \new Staff = "melody" \with {
    midiInstrument = "acoustic grand"
  } { \override Fingering.direction = #UP \melody }
  \new Staff = "chords" \with {
    midiInstrument = "acoustic grand"
  } {
    \clef bass
    \key e \major
    \time 3/4
    \set fingeringOrientations = #'(left)
    \override Fingering.font-size = #-6
    \override Fingering.padding = #0.2
    % Chord symbols have no register; use an octave below chordmode's default.
    \transpose c c, { \heldHarmonies }
  }
>>

\score {
  <<
    \new ChordNames { \harmonies }
    \pianoMusic
  >>
  \layout {
    indent = #0
    ragged-right = ##f
  }
}

\score {
  \pianoMusic
  \midi { }
}

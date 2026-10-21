\version "2.24.0"

\include "music.ily"

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
          (if (null? (event-chord-notes music))
              (ly:error "Expected explicit notes in the imported chord"))
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
                 (gis-over-bis?
                   (equal? (map (lambda (p) (modulo p 12)) pitches) '(0 3 8))))
            (if (not (= (length notes) 3))
                (ly:error "Expected a three-note accompaniment chord"))
            (for-each
              (lambda (note finger)
                (set! (ly:music-property note 'articulations)
                      (cons (make-music 'FingeringEvent 'digit finger)
                            (ly:music-property note 'articulations))))
              notes (list (if gis-over-bis? 4 5)
                      (if (or gis-over-bis?
                              (= (- (cadr pitches) (car pitches)) 5)
                              (equal? (map (lambda (p) (modulo p 12)) pitches)
                                      '(9 1 6))
                              (equal? (map (lambda (p) (modulo p 12)) pitches)
                                      '(11 3 6)))
                          2 3)
                      1)))
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
    \context {
      \Voice
      \remove Note_heads_engraver
      \consists Completion_heads_engraver
      completionFactor = #1
    }
  }
}

\score {
  \pianoMusic
  \midi { }
}

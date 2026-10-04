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
% Bar checks belong to the source grid; Completion_heads_engraver splits these
% sustained durations into canonical tied notes at the actual bar boundaries.
heldHarmonies = #(let ((previous #f) (chords '()))
  (for-each
    (lambda (music)
      (case (ly:music-property music 'name)
        ((EventChord)
          (if (null? (event-chord-notes music))
              (ly:error "Expected explicit notes in the imported chord"))
          (set! previous (ly:music-deep-copy music))
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
  (let ((result (make-sequential-music (reverse chords))))
    (if (not (equal? (ly:music-length result) (ly:music-length harmonies)))
        (ly:error "Expected one sequential chord-symbol stream with skips"))
    result))

pianoMusic = \new PianoStaff <<
  \new Staff = "melody" \with {
    midiInstrument = "acoustic grand"
  } { \melody }
  \new Staff = "chords" \with {
    midiInstrument = "acoustic grand"
  } {
    \clef bass
    \key e \major
    \time 3/4
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

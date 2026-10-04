\version "2.24.0"

\include "music.ily"

#(set-global-staff-size 18)

\paper {
  #(set-paper-size "a4")
  top-margin = 10\mm
  bottom-margin = 10\mm
  left-margin = 12\mm
  right-margin = 12\mm
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

\score {
  <<
    \new ChordNames { \harmonies }
    \new Staff { \melody }
  >>
  \layout {
    indent = #0
    ragged-right = ##f
  }
}

% musicxml2ly uses skips between chord symbols, not accompaniment rests.
% Derive MIDI-only held chords from that single source. Each skip becomes a
% tied continuation; explicit chord symbols still start a new attack.
heldHarmonies = #(let ((previous #f))
  (music-map
    (lambda (music)
      (case (ly:music-property music 'name)
        ((EventChord)
          (if (null? (event-chord-notes music))
              (ly:error "Expected explicit notes in the imported chord"))
          (set! previous music)
          music)
        ((SkipEvent)
          (if (not previous)
              (ly:error "Cannot sustain a skip before the first chord"))
          (let ((continuation (ly:music-deep-copy previous)))
            (for-each
              (lambda (note)
                (set! (ly:music-property note 'duration)
                      (ly:music-property music 'duration)))
              (event-chord-notes continuation))
            (set! (ly:music-property previous 'elements)
                  (append (ly:music-property previous 'elements)
                          (list (make-music 'TieEvent))))
            (set! previous continuation)
            continuation))
        ((SimultaneousMusic RestEvent MultiMeasureRestMusic)
          (ly:error "Expected one sequential chord-symbol stream with skips"))
        (else music)))
    (ly:music-deep-copy harmonies)))

\score {
  <<
    \new Staff = "melody" \with {
      midiInstrument = "acoustic grand"
    } { \melody }
    \new Staff = "chords" \with {
      midiInstrument = "acoustic grand"
    } {
      \time 3/4
      % Chord symbols have no register; use an octave below chordmode's default.
      \transpose c c, { \heldHarmonies }
    }
  >>
  \midi { }
}

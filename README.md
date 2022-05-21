# matlab_synthesizer
This repo contains a library made up of 3 MATLAB functions which can be used to synthesize chords via subtractive synthesis.

## Function makeNote
This is the core of the library: it produces a tone (with value normalized to 1) by low-pass filtering a PWM signal, obtained comparing a sawtooth wave and a low-frequency sinusoid.
The parameters that can be tuned to affect the note tone are: the sinusoid frequency (by modifying the 'lfo factor', i.e., the ratio between sinusoid frequency and note frequency) and the low-pass filter parameters (i.e., passband, topband and transition band)

## Function makeChord
This function receives as input the chord and the octave of the fundamental, to output the sum of each note, normalized to 1. In order to find the correct frequency, the function relates each note frequency to A4 440 Hz by multiplicative factors.

## Function makeEnvelope
Produces a desired envelope by interpolating a set of points given two vectors (amplitudes and time instants) of the same length with a cubic spline. The resulting set of points has a number of elements given by (total duration)\*(sampling frequency).

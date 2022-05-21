%% ============================= makeChord ================================
% This function creates a given chord by selecting each voice and calling
% makeNote with the right frequencies.
% The produced chords can contain up to 5 different notes (voices).
% -------------------------------------------------------------------------
% Input Parameters
% - note: string containing the fundamental (root) note of the chord 
%   (add '#' to make it sharp, 'b' to make it flat);
% - octave: integer number indicating the octave of the root note;
% - scale: string indicating the type of chord;
%       ~ ' ': major chord (major 3rd + 5th)
%       ~ 'm': minor chord (minor 3rd + 5th)
%       ~ '7': 7th chord (major 3rd + 5th + minor 7th)
%       ~ 'm7': minor 7th chord (minor 3rd + 5th + minor 7th)
%       ~ 'maj7': major 7th chord (major 3rd + 5th + major 7th)
% - T_chord: duration of the chord (in seconds);
% (Non-compulsory parameters):
% - fs: sampling frequency - default value = 44100 Hz;
% - lfo_factor: multiplicative factor used in the note generation function
%   to evaluate the frequency of the sinusoid (PWM signal generation) -
%   default value is 240;
% - passband_factor: multiplicative factor to find the passband edge
%   frequency of the low-pass filter used in note generation               
%   (f_bp = passband_factor*f_note) - default value is 1;
% - stopband_factor: multiplicative factor to find the stopband edge
%   frequency of the low-pass filter used in note generation               
%   (f_sp = stopband_factor*f_note) - default value is 16;
% -------------------------------------------------------------------------
% Output variables:
% - chord: signal contianing the chord, notmalized to an amplitude of 1;
% - f_notes: vector of frequencies making up the chord;
% - t = time axis for the produced chord; from 0 to T_chord
% =========================================================================

function [chord, f_notes, t] = makeChord(note, octave, scale, T_chord, fs,  lfo_factor, passband_factor, stopband_factor)
t = 0:1/fs:T_chord-1/fs;

if (~exist('fs', 'var'))
    fs = 44100;         % Hz
end
if (~exist('lfo_factor', 'var'))
    lfo_factor = 240;
end
if (~exist('passband_factor', 'var'))
    passband_factor = 1;
end
if (~exist('stopband_factor', 'var'))
    stopband_factor = 16;
end

freq_A4 = 440;      % Hz
ref_octave = 4;
octave_fshift = 2^(octave-ref_octave);

% Notes frequency - octave 4 (semitones)
C = struct('name', 'C', 'freq', freq_A4*2^(-9/12));

Cs = struct('name', 'C#', 'freq', freq_A4*2^(-8/12));

Df = struct('name', 'Db', 'freq', Cs.freq);

D = struct('name', 'D', 'freq', freq_A4*2^(-7/12));

Ds = struct('name', 'D#', 'freq', freq_A4*2^(-6/12));

Ef = struct('name', 'Eb', 'freq', Ds.freq);

E = struct('name', 'E', 'freq', freq_A4*2^(-5/12));

F = struct('name', 'F', 'freq', freq_A4*2^(-4/12));

Fs = struct('name', 'F#', 'freq', freq_A4*2^(-3/12));

Gf = struct('name', 'Gb', 'freq', Fs.freq);

G = struct('name', 'G', 'freq', freq_A4*2^(-2/12));

Gs = struct('name', 'G#', 'freq', freq_A4*2^(-1/12));

Af = struct('name', 'Ab', 'freq', Gs.freq);

A = struct('name', 'A', 'freq', freq_A4);

As = struct('name', 'A#', 'freq', freq_A4*2^(1/12));

Bf = struct('name', 'Bb', 'freq', As.freq);

B = struct('name', 'B', 'freq', freq_A4*2^(2/12));

NOTES = [C Cs Df D Ds Ef E F Fs Gf G Gs Af A As Bf B];

for ind=1:length(NOTES)
    if (strcmp(note, NOTES(ind).name))
        f_starting = NOTES(ind).freq;
        break
    end
end

f_notes = zeros(5, 1);      % At most 5 notes in a single chord
chordnotes = zeros(length(f_notes), T_chord*fs);

f_notes(1) = f_starting*octave_fshift;

if (strcmp(scale, ' '))       % Major chord
    f_notes(2) = f_notes(1)*2^(4/12);
    f_notes(3) = f_notes(1)*2^(7/12);
else
    if (strcmp(scale, 'm'))     % Minor chord
        f_notes(2) = f_notes(1)*2^(3/12);
        f_notes(3) = f_notes(1)*2^(7/12);
    else 
        if (strcmp(scale, 'only'))     % One note
        else
            if (strcmp(scale, '7'))    % 7
                f_notes(2) = f_notes(1)*2^(4/12);
                f_notes(3) = f_notes(1)*2^(7/12);
                f_notes(4) = f_notes(1)*2^(10/12);
            else
                if (strcmp(scale, 'm7'))    % Minor 7
                    f_notes(2) = f_notes(1)*2^(3/12);
                    f_notes(3) = f_notes(1)*2^(7/12);
                    f_notes(4) = f_notes(1)*2^(10/12);
                else
                    if (strcmp(scale, 'maj7'))      % Major 7
                        f_notes(2) = f_notes(1)*2^(4/12);
                        f_notes(3) = f_notes(1)*2^(7/12);
                        f_notes(4) = f_notes(1)*2^(11/12);
                    end
                end
            end
        end
    end
    % It is possible to implement other chords 
end

for ind = 1:length(f_notes)
    if (f_notes(ind) ~= 0)
        chordnotes(ind, :) = makeNote(f_notes(ind), T_chord, fs, lfo_factor, passband_factor*f_notes(ind), stopband_factor*f_notes(ind));
    end
end

chord = (sum(chordnotes, 1))';  % Column vector
chord = chord/(max(abs(chord)));
end
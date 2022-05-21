clear
close all
clc

addpath('library/')

fs = 44100;         % Hz
T_note = 1.25;      % s 4/4
T_1_4 = T_note*0.25;
t = 0:1/fs:T_note-1/fs;
N_notes = 7;

T_tot = 0;

%% Envelope
env_t = [0 0.25 0.4 0.75 1.25]';
env_val = [0 1 0.7 0.7 0]';

[envelope_note, env_t_cont] = makeEnvelope(env_val, env_t, T_note, fs);

figure(1), plot(env_t_cont, 'b', env_t, env_val, 'ob'), grid on

%% Progression:
% D (5)
progression = envelope_note.*makeChord('D', 4, ' ', T_note, fs);
T_tot = T_tot + T_note;

% A
progression = [progression; envelope_note.*makeChord('A', 3, ' ', T_note, fs)];
T_tot = T_tot + T_note;

% Bm
progression = [progression; envelope_note.*makeChord('B', 3, 'm', T_note, fs)];
T_tot = T_tot + T_note;

% F#m
progression = [progression; envelope_note.*makeChord('F#', 3, 'm', T_note, fs)];
T_tot = T_tot + T_note;

% G
progression = [progression; envelope_note.*makeChord('G', 3, ' ', T_note, fs)];
T_tot = T_tot + T_note;

% D (4)
progression = [progression; envelope_note.*makeChord('D', 3, ' ', T_note, fs)];
T_tot = T_tot + T_note;

% G
progression = [progression; envelope_note.*makeChord('G', 3, ' ', T_note, fs)];
T_tot = T_tot + T_note;

% A
progression = [progression; envelope_note.*makeChord('A', 3, ' ', T_note, fs)];
T_tot = T_tot + T_note;

progression = [progression; progression];
T_tot = 2*T_tot;

%% Melody
% F#
melody = envelope_note.*makeChord('F#', 6, 'only', T_note, fs);

% E
melody = [melody; envelope_note.*makeChord('E', 6, 'only', T_note, fs)];

% D
melody = [melody; envelope_note.*makeChord('D', 6, 'only', T_note, fs)];

% C#
melody = [melody; envelope_note.*makeChord('C#', 6, 'only', T_note, fs)];

% B
melody = [melody; envelope_note.*makeChord('B', 5, 'only', T_note, fs)];

% A
melody = [melody; envelope_note.*makeChord('A', 5, 'only', T_note, fs)];

% B
melody = [melody; envelope_note.*makeChord('B', 5, 'only', T_note, fs)];

% C#
melody = [melody; envelope_note.*makeChord('C#', 6, 'only', T_note, fs)];

% D
melody = [melody; envelope_note.*makeChord('D', 6, 'only', T_note, fs)];

% C#
melody = [melody; envelope_note.*makeChord('C#', 6, 'only', T_note, fs)];

% B
melody = [melody; envelope_note.*makeChord('B', 5, 'only', T_note, fs)];

% A
melody = [melody; envelope_note.*makeChord('A', 5, 'only', T_note, fs)];

% G
melody = [melody; envelope_note.*makeChord('G', 5, 'only', T_note, fs)];

% F#
melody = [melody; envelope_note.*makeChord('F#', 5, 'only', T_note, fs)];

% G
melody = [melody; envelope_note.*makeChord('G', 5, 'only', T_note, fs)];

% E
melody = [melody; envelope_note.*makeChord('E', 5, 'only', T_note, fs)];


composition = melody + progression;
composition = composition/(max(abs(composition)));

figure(2), plot(0:1/fs:T_tot-1/fs, composition, 'r'), grid on

playComposition = audioplayer(composition, fs);
playblocking(playComposition)
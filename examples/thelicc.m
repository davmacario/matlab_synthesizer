clear
close all
clc

addpath('../library/')

disp('Bear yourself')
disp('for')
disp('THE LICC')

%% Data

fs = 44100;         % Hz
T_quarter = 0.25;    % s
N_notes = 7;

T_tot = 0;

%% Envelope
env_t = [0 0.01 0.3 0.7 1]';
env_val = [0 1 0.7 0.6 0]';

envelope_1_4 = interp1(env_t*T_quarter, env_val, (0:1/fs:T_quarter-1/fs), 'pchip')';
envelope_2_4 = interp1(env_t*2*T_quarter, env_val, (0:1/fs:2*T_quarter-1/fs), 'pchip')';
envelope_4_4 = interp1(env_t*4*T_quarter, env_val, (0:1/fs:4*T_quarter-1/fs), 'pchip')';

%% Licc
% A - 1/4
licc = envelope_1_4.*makeChord('A', 4, 'only', T_quarter, fs);
T_tot = T_tot + T_quarter;

% B - 1/4
licc = [licc; envelope_1_4.*makeChord('B', 4, 'only', T_quarter, fs)];
T_tot = T_tot + T_quarter;

% C - 1/4
licc = [licc; envelope_1_4.*makeChord('C', 5, 'only', T_quarter, fs)];
T_tot = T_tot + T_quarter;

% D - 1/4
licc = [licc; envelope_1_4.*makeChord('D', 5, 'only', T_quarter, fs)];
T_tot = T_tot + T_quarter;

% B - 2/4
licc = [licc; envelope_2_4.*makeChord('B', 4, 'only', 2*T_quarter, fs)];
T_tot = T_tot + 2*T_quarter;

% G - 1/4
licc = [licc; envelope_1_4.*makeChord('G', 4, 'only', T_quarter, fs)];
T_tot = T_tot + T_quarter;

% A - 4/4
licc = [licc; envelope_4_4.*makeChord('A', 4, 'only', 4*T_quarter, fs)];
T_tot = T_tot + 4*T_quarter;

t = (0:1/fs:T_tot-1/fs)';

sound(licc, fs)

figure, plot(t, licc, 'm');
grid on

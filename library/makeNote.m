function [note, t] = makeNote(f0, T_note, fs, lfo_factor, passband_freq, stopband_freq)
t = 0:1/fs:T_note-1/fs;
saw = sawtooth(2*pi*f0*t);

% 'lfo_factor' is not comnpulsory - its default value is 240
if (~exist('lfo_factor', 'var'))
    lfo_factor = 240;
end

lfo = f0/lfo_factor;
lfo_sine = 0.7*sin(2*pi*lfo*t);

pwm_signal = 1*(lfo_sine >= saw)-1*(lfo_sine < saw);

% Low-pass filtering - FIR filter
if (~exist('passband_freq', 'var'))
    omega_p = 2*pi*f0/fs;
    
else
    omega_p = 2*pi*passband_freq/fs;
end

if (~exist('stopband_freq', 'var'))
    omega_s = 16*2*pi*f0/fs;
else
    if (stopband_freq > passband_freq)
        omega_s = 2*pi*stopband_freq/fs;
    end
end
B_T = omega_s-omega_p;
omega_c = 0.5*(omega_p + omega_s);
f_c = omega_c/(2*pi);

N = ceil(6.1*pi/B_T);
M = ceil((N-1)/2);

n = (0:N-1)';

% Bartlett window
w = zeros(N, 1);
w(1:M) = 2*n(1:M)/(N-1);
w(M+1:end) = (2-(2*n(M+1:end))/(N-1));

% Ideal IR
h_id = 2*f_c*sinc(2*f_c*(n-M));

h = w.*h_id;
h = h/sum(h);

note = filter(h, 1, pwm_signal);
end
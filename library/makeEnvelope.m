%% ========================== makeEnvelope ==========================
% Given the vectors of amplitudes 'ampl' (norm. to 1) and of time instants 
% 'times', the total duration T in s and the sampling frequency fs, the 
% function returns the envelope obtained by performing an interpolation 
% with a cubic spline of the given amplitudes at the given instants
function [env, t] = makeEnvelope(ampl, times, T, fs)
    % Detect normalization:
    if (times(end)/T ~= 1) % norm
        times = times.*T;
    end

    t = 0:1/fs:T-1/fs;

    env = interp1(times, ampl, t, 'pchip')';
end
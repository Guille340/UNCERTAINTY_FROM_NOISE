%  NOISECORRECTION_EX1 (Script)
%
%  DESCRIPTION
%  Example of computing the coverage intervals for a noise-corrected
%  signal. The data available is set of observations of the waveform of:
%   1. A noise-contaminated tone signal (SN)
%   2. Noise measured immediately tone event (N)
%
%  The voltage levels (re. 1 V) are calculated for each waveform. The 
%  mean level and expanded uncertainty level obtained for each observation of
%  SN and N (see LEVELSTATS). The noise-corrected level and the coverage
%  intervals (i.e., top and bottom limits) are then obtained from the mean
%  and expanded uncertainties of SN and N (see NOISECORRECTION). The top
%  limit of the noise-corrected signal (Sc1) is calculated as the correction
%  between the top limit of SN (SN + U_SN) and the bottom limit of N (N -
%  U_N). The bottom limit of the noise-corrected signal (Sc2) is calculated
%  as the correction between the bottom limit of SN (SN - U_SN) and the top
%  limit of N (N - U_N).
%
%  INPUT ARGUMENTS
% - xn: vector of signal plus noise levels [dB]
% - n: vector of noise levels [dB]
% 
%  OUTPUT ARGUMENTS
%  - x: vector of noise-corrected signal levels [dB]
%
%  FUNCTION CALL
%  x = NOISECORRECTION(xn,n)
%
%  FUNCTION DEPENDENCIES
%  - None
%
%  TOOLBOX DEPENDENCIES
%  - MATLAB (Core)
%
%  See also NOISEERROR, SNNR2SNR, SNR2SNNR

%  VERSION 1.0
%  Guillermo Jimenez Arranz
%  email: gjarranz@gmail.com
%  28 Jun 2021

% Input
snratio = -12; % signal to noise ratio [dB]
f = 1e3; % frequency of signal's tone [Hz]
tau = 0.1; % duration of signal and noise [s]
fs = 24000; % sampling frequency [Hz]
nTests = 5; % number of observations
statsMethod = 'energy2'; % method for stats ('level','energy1','energy2')
confid = 68; % confidence level [%]

% Signal and Noise
srms = 1; % rms amplitude of signal
nrms = srms * 10^(-snratio/20); % rms amplitude of noise
t = 0:1/fs:tau; % time vector of signal and noise waveforms [s]
nSamples = length(t); % number of samples in signal and noise waveforms
s = repmat(sqrt(2)*srms*sin(2*pi*f*t'),1,nTests); % signal waveforms
n = nrms*randn(nSamples,nTests); % noise waveforms
sn = s + n; % signal + noise waveforms
s_db = 20*log10(rms(s)); % signal levels
n_db = 20*log10(rms(n)); % noise levels
sn_db = 20*log10(rms(sn)); % signal + noise levels

% Calculate Energy Mean Levels and Expanded Uncertainties of the Mean
[sn_db_avg,usn_db_avg] = levelStats(sn_db,'Method',statsMethod,'Confidence',confid);
[n_db_avg,un_db_avg] = levelStats(n_db,'Method',statsMethod,'Confidence',confid);

% Calculate Average Value and Confidence Intervals of Corrected Level
sc_db_avg = noiseCorrection(sn_db_avg,n_db_avg); % central value
sc_db_avg1 = noiseCorrection(sn_db_avg + usn_db_avg,...
    n_db_avg - un_db_avg); % top limit
sc_db_avg2 = noiseCorrection(sn_db_avg - usn_db_avg,...
    n_db_avg + un_db_avg); % botom limit

fprintf('Signal Level (Original) = %0.3f dB\n',s_db(1))
fprintf('Signal Level (Corrected) = %0.3f dB\n',sc_db_avg)
fprintf('Signal Level (Corrected, Bottom) = %0.3f dB\n',sc_db_avg2)
fprintf('Signal Level (Corrected, Top) = %0.3f dB\n',sc_db_avg1)


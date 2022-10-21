%  x = NOISECORRECTION(xn,n)
%
%  DESCRIPTION
%  Compute the noise-corrected level (X) from a vector noise-contaminated 
%  levels (XN) and the associated vector of estimated noise levels (N).
%
%  The correction is performed on an energy scale: 1) The levels are converted
%  into energy, 2) The noise-contaminated energy is corrected, 3) The corrected
%  energy is converted back into decibels. The formula is as follows:
%   
%    X = 10*log10(10^(XN/10) - 10^(N/10))
%
%  XN and N may represent RMS or exposure levels. The correction is best 
%  applied to averaged levels from multiple observations. This type of 
%  correction is not intended for instantaneous metrics such as peak or
%  peak-to-peak levels.
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

function x = noiseCorrection(xn,n)

% Error Control
if ~isnumeric(xn)
    error('Input argument XN must be a numeric vector or matrix')
end
if ~isnumeric(n)
    error('Input argument N must be a numeric vector or matrix')
end

% Calculate Noise-Corrected Levels
x = 10*log10(10.^(xn/10) - 10.^(n/10)); % corrected signal level
x(xn < n) = -Inf; % set complex values to -Inf
  
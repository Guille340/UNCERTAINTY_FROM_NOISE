%  err = NOISEERROR(snratio,varargin)
%
%  DESCRIPTION
%  Computes the noise error ERR associated with the signal to noise ratio 
%  SNRATIO. The noise error is the difference between the sound level of a
%  signal contaminated by noise (SN) and the the sound level of the noise-
%  corrected signal (S). The noise error is related to the signal to noise 
%  ratio (SNR) by the formula 
%   
%     ERR = 10*log10(1 + 10^(-SNR/10)). 
%
%  In practice, it is the signal plus noise to noise ratio (SNNR) that is 
%  measured. The SNNR is related to the noise error by the formula
%  
%     ERR = -10*log10(1 - 10.^(-SNNR/10)). 
%  
%  For calculating the noise error ERR from SNNR values, set the variable 
%  input argument SNNRATIO to TRUE.
%
%  INPUT ARGUMENTS
% - snratio: vector of signal to noise ratios (SNR) or signal plus noise
%   to noise ratios (SNNR). See variable input argument SNNR.
% - snnr: logical value (TRUE, FALSE) or [0,1] indicating the type of
%   values in SNRATIO. If SNRATIO contains signal to noise ratios use
%   SNNR = FALSE (default); if SNRATIO contains signal plus noise to noise
%   ratios use SNNR = TRUE.
% 
%  OUTPUT ARGUMENTS
%  - err: noise error associated with each value in SNRATIO.
%
%  FUNCTION CALL
%  1. err = NOISEERROR(snratio) or err = NOISEERROR(snratio,FALSE) for SNR
%  2. err = NOISEERROR(snratio,TRUE) for SNNR
%
%  FUNCTION DEPENDENCIES
%  - None
%
%  TOOLBOX DEPENDENCIES
%  - MATLAB (Core)
%
%  See also SNR2SNNR, SNNR2SNR

%  VERSION 1.0
%  Guillermo Jimenez Arranz
%  email: gjarranz@gmail.com
%  28 Jun 2021

function err = noiseError(snratio,varargin)

narginchk(1,2)

% Variable Input Arguments
snnr = false;
if nargin == 2
    snnr = varargin{1};
end

% Error Control
if ~isnumeric(snratio)
    error('Input argument SNRATIO must be a numeric vector or matrix')
end
if length(snnr) > 1 || ~islogical(snnr) && ~ismember(snnr,[0 1])
    error('Variable input argument SNNR must be 0, 1 or logical')
end

% Calculate Noise Error
switch snnr
    case false % SNR input
        err = 10*log10(1 + 10.^(-snratio/10));    
    case true % SNNR input
        err = -10*log10(1 - 10.^(-snratio/10));  
end
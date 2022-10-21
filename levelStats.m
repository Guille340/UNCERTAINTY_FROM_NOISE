%  [x_avg,u_avg,x_std,u_std] = LEVELSTATS(x,varargin)
%
%  DESCRIPTION
%  Computes the mean, standard deviation, and respective expanded uncertainties 
%  for a vector X of sound level observations. X can be a matrix, in which
%  case each column is treated as an individual observation; this is useful 
%  for calculating the statistics and uncertainties of a set of sound level 
%  spectra. The level of confidence of the expanded uncertainties can be set 
%  with the 'Confidence' property. The method for calculating the statistics 
%  and uncertainties can be selected with the 'Method' property.
%
%  INPUT ARGUMENTS
% - x: vector or matrix of sound levels. On a vector, each element is an
%   observation; on a matrix, each column is an observation with multiple
%   variables (e.g. spectrum).
%
% - PROPERTIES (varargin): the user can input up to 2 function properties. The 
%   properties must be given in (Name,Value) pairs, separated by comma with 
%   the property name first. The available property names and the description 
%   of their values are given below:
%   ¬ 'Confidence': confidence level for the expanded uncertainty [%]. A
%      DEFAULT value of 68.269 is used, corresponding to a coverage factor
%      k = 1.
%   ¬ 'Method': method for calculating the statistics and uncertainties. 
%     Three options available:
%     # 'level': calculates the mean and standard deviation directly over
%       the input levels in X using MATLAB's MEAN and STD functions. The 
%       expanded uncertainty of the mean is calculated as described in the 
%       GUM (U_AVG = K*STD(X)/SQRT(M), with M = SIZE(X,2) being the number of 
%       observations). The expanded uncertainty of the standard deviation is 
%       calculated with the following equation for a Gaussian distribution, 
%       using MATLAB's GAMMA function.
%          
%           U_STD = STD(X) * SQRT(1 - (2/(-1))*(GAMMA(M/2)/GAMMA((M-1)/2))^2);
%
%     # 'energy1': calculates energy mean level as ten times the base-10 
%       logarithm of the energy mean. The standard deviation and the 
%       uncertainty of the mean are calculated using the "GUM Method" 
%       described in Taraldsen et al (2015).
%
%     # 'energy2': calculates energy mean level as ten times the base-10 
%       logarithm of the energy mean. The standard deviation and the 
%       uncertainty of the mean are calculated using the "Finite Difference
%       Method" described in Taraldsen et al (2015). DEFAULT
% 
%  OUTPUT ARGUMENTS
%  - x_avg: mean of input level observations [dB]
%  - u_avg: expanded uncertainty of the mean of input level observations [dB]
%  - x_std: standard deviation of input level observations [dB]
%  - u_std: expanded uncertainty of the standard deviation of input level
%    observations [dB]
%
%  NOTE: If X is a matrix, X_AVG, U_AVG, X_STD, and U_STD are vectors with 
%  SIZE(X,1) elements. If X is a vector, X_AVG, U_AVG, X_STD, and U_STD
%  are one-element vectors.
%
%  FUNCTION CALL
%  [x_avg,u_avg,x_std,u_std] = LEVELSTATS(x)
%  [x_avg,u_avg,x_std,u_std] = LEVELSTATS(...,PROPERTYNAME,PROPERTYVALUE)
%
%  If no properties are specified, their default values will be used. The list 
%  of default values is:
%
%   'Confidence' = 68.269 (corresponding to K = 1 or 1 standard deviation)
%   'Method' = 'energy2'
%
%  FUNCTION DEPENDENCIES
%  - None
%
%  TOOLBOX DEPENDENCIES
%  - MATLAB (Core)
%
%  See also ...
%
%  VERSION 1.0
%  Guillermo Jimenez Arranz
%  email: gjarranz@gmail.com
%  25 Jun 2021

function [x_avg,u_avg,x_std,u_std] = levelStats(x,varargin)

% Check Number of Input Arguments
narginchk(1,5)
nVarargin = nargin - 1;
if rem(nVarargin,2)
    error('Property and value input arguments must come in pairs')
end

% Initialise Default Parameters
confid = 68.269; % confidence level [%]
method = 'energy2'; % calculation method ('level','energy1','energy2')

% Retrieve Input Variables
for m = 1:2:nVarargin
    inputProperty = lower(varargin{m}); % case insensitive
    inputProperties = lower({'Confidence','Method'});
    if ~ismember(inputProperty,inputProperties)
        error('Invalid input property')
    else
        switch inputProperty
            case 'confidence'
                confid = varargin{m+1};
            case 'method'
                method = lower(varargin{m+1});
        end
    end
end

% Error Control
if ~isnumeric(x) || ~ismatrix(x)
    error('Input argument X must be a numeric vector or matrix.')
end
if ~isnumeric(confid) || confid <= 0 || confid > 100
    confid = 68.269;
    warning(['Input ''Confidence'' must be a numeric value between 0 and '...
        '100. The default value of 68.269 will be used.'])
end
if ~ischar(method)
    error('Input ''Method'' must be a string of characters')
end    

% Calculate Statistic and Uncertainty
nTests = size(x,2); % number of observations
k = erfinv(confid/100)*sqrt(2); % coverage factor
switch method
    case 'level' % level method
        x_avg = mean(x,2);
        x_std = std(x,0,2); % level standard deviation
        u_avg = k * x_std/sqrt(nTests); % expanded uncertainty of mean
        u_std = k * x_std * sqrt(1 - (2/(nTests-1))*(gamma(nTests/2)/...
            gamma((nTests-1)/2))^2); % expanded uncertainty of std
    case 'energy1' % energy method (GUM)
        w = 10.^(x/10); % energy values (norm. by reference)
        w_avg = mean(w,2); % energy mean (norm. by reference)
        w_std = std(w,0,2); % energy std (norm. by reference)
        x_avg = 10*log10(w_avg); % energy mean level
        x_std = 10/log(10) * w_std./w_avg;  % energy std level 
        u_avg = k*x_std/sqrt(nTests); % expanded uncertainty of mean
        u_std = NaN;
    case 'energy2' % energy method (finite difference)
        w = 10.^(x/10); % energy values (norm. by reference)
        w_avg = mean(w,2); % energy mean (norm. by reference)
        w_std = std(w,0,2); % energy std (norm. by reference)
        x_avg = 10*log10(w_avg); % energy mean level
        x_std = 10*log10(1 + w_std./w_avg); % energy std level
        u_avg = k*x_std/sqrt(nTests); % expanded uncertainty of mean
        u_std = NaN;

    otherwise
        error(['Non-supported string for ''Method'' property. The default '...
            'method ''energy1'' will be used.'])
end              

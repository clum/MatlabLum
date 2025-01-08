function [varargout] = AnalyzePoles(varargin)

%ANALYZEPOLES  Analyzes poles/eigenvalues
%
%   [WN,ZETA,TAU] = ANALYZEPOLES(LAMBDA) Computes the the natural
%   frequency, WN, damping ratio, ZETA, and time constant, TAU, of the
%   poles in the vector LAMBDA.
%
%   See also damp
%
%INPUT:     -LAMBDA:    vector of pole/eigenvalues to analyze
%
%OUTPUT:    -WN:        natural frequency (rad/s)
%           -ZETA:      damping ratio
%           -TAU:       time constant (s)
%
%Christopher Lum
%lum@uw.edu

%Version History
%xx/xx/12: Created
%04/26/12: Updated documentation
%01/07/25: Updated documentation

%----------------------OBTAIN USER PREFERENCES-----------------------------
switch nargin
    case 1
        %User supplies all inputs
        LAMBDA = varargin{1};
        
    otherwise
        error('Invalid number of inputs');
end

%-----------------------CHECKING DATA FORMAT-------------------------------
% LAMBDA
if(~isvector(LAMBDA))
    error('LAMBDA must be a vector')
end

%-------------------------BEGIN CALCULATIONS-------------------------------
WN      = [];
ZETA    = [];
TAU     = [];
for k=1:length(LAMBDA)
    lambda_current = LAMBDA(k);
    
    %What is the real and imaginary part of this pole
    sigma   = real(lambda_current);
    wd      = imag(lambda_current);
    
    if(sigma > 0)
        %unstable
        wn_curr     = NaN;
        zeta_curr   = NaN;
        tau_curr    = Inf;
        
    elseif(sigma == 0)        
        %neutrally stable
        wn_curr     = abs(lambda_current);
        zeta_curr   = 0;
        tau_curr    = Inf;
        
    else
        %stable
        wn_curr     = abs(lambda_current);
        zeta_curr   = -cos(angle(lambda_current));
        tau_curr    = 1/(zeta_curr*wn_curr);
        
    end
    
    WN(end+1,1)     = wn_curr;
    ZETA(end+1,1)   = zeta_curr;
    TAU(end+1,1)    = tau_curr;
end

%Was LAMBDA a row or col vector?
if(isrow(LAMBDA))
    %LAMBDA was a row vector, make output vectors row vectors also
    WN      = WN';
    ZETA    = ZETA';
    TAU     = TAU';
end

%Output objects
varargout{1} = WN;
varargout{2} = ZETA;
varargout{3} = TAU;
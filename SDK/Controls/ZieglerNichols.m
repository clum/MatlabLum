function [varargout] = ZieglerNichols(varargin)

%ZIEGLERNICHOLS Computes PID gains using Ziegler-Nichols
%
%   [KP, KI, KD] = ZIEGLERNICHOLS(KU, TU) Computes the KP, KI, and KD gains
%   for a PID controller using the Ziegler-Nichols method.
%
%   [...] = ZIEGLERNICHOLS(KU, TU, TYPE) does as above but for the
%   specified control TYPE.  Valid values are
%
%       'ClassicPID'
%       'P'
%       'PI'
%       'PD'
%       'PessenIntegrationRule'
%       'SomeOvershoot'
%       'NoOvershoot'
%
%   [KP, KI, KD, TI, TD] = ZIEGLERNICHOLS(KU, TU, TYPE) does as above but
%   also returns the parameters TI and TD.
%
%   For more information, see
%   https://en.wikipedia.org/wiki/Ziegler%E2%80%93Nichols_method.
%
%   For example usage see https://youtu.be/n829SwSUZ_c?t=1434.
%
%INPUT:     -KU:    Ultimate gain that leads to steady oscillations
%           -TU:    Oscillation period (seconds)
%           -TYPE:  char array denoting the type of desired control
%
%OUTPUT:    -KP:    Proporational gain
%           -KI:    Integral gain
%           -KD:    Derivative gain
%
%Christopher Lum
%lum@uw.edu

%Version History
%05/14/19: Created
%05/15/19: Continued working
%05/17/19: Removed NaNs.  Updated documentation
%05/21/19: Added reference to YouTube video.
%01/07/25: Updated documentation

%----------------------OBTAIN USER PREFERENCES-----------------------------
switch nargin
    case 3
        %User supplies all inputs
        KU      = varargin{1};
        TU      = varargin{2};
        TYPE    = varargin{3};

    case 2
        %Assume ClassicPID
        KU      = varargin{1};
        TU      = varargin{2};
        TYPE    = 'ClassicPID';

    otherwise
        error('Invalid number of inputs');
end

%-----------------------CHECKING DATA FORMAT-------------------------------
% KU

% TU
assert(TU > 0, 'TU should be a positive value')

%-------------------------BEGIN CALCULATIONS-------------------------------
if(strcmp(TYPE,'ClassicPID')==1)
    KP = 0.6*KU;
    Ti = TU/2;
    Td = TU/8;

elseif(strcmp(TYPE,'P')==1)
    KP = 0.5*KU;
    Ti = NaN;
    Td = NaN;

elseif(strcmp(TYPE,'PI')==1)
    KP = 0.45*KU;
    Ti = TU/1.2;
    Td = NaN;

elseif(strcmp(TYPE,'PD')==1)
    KP = 0.8*KU;
    Ti = NaN;
    Td = TU/8;

elseif(strcmp(TYPE,'PessenIntegrationRule')==1)
    KP = 0.7*KU;
    Ti = 2*TU/5;
    Td = 3*TU/20;

elseif(strcmp(TYPE,'SomeOvershoot')==1)
    KP = KU/3;
    Ti = TU/2;
    Td = TU/3;

elseif(strcmp(TYPE,'NoOvershoot')==1)
    KP = 0.2*KU;
    Ti = TU/2;
    Td = TU/3;

else
    error('Unsupported TYPE')

end

%Compute KI and KD based on KP, TI, and TD
KI = KP/Ti;
KD = Td*KP;

%If KI or KD are NaN, change to 0 so it is compatible with simulations
if(isnan(KI))
    KI = 0;
end

if(isnan(KD))
    KD = 0;
end

%Package outputs
varargout{1} = KP;
varargout{2} = KI;
varargout{3} = KD;
varargout{4} = Ti;
varargout{5} = Td;
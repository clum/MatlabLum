function [varargout] = ExtractPIDGainsFromSecondOrderTransferFunction(varargin)

%EXTRACTPIDGAINSFROMSECONDORDERTRANSFERFUNCTION
%
%   [KP,KI,KD,a] = EXTRACTPIDGAINSFROMSECONDORDERTRANSFERFUNCTION(SYS)
%   Extracts the PID gains KP, KI, KD and the pseudo-derivative constant,
%   a, such that the controller of the form
%
%       PID(s) = U(s)/E(s) = KP + KI*(1/s) + KD*(a*s)/(s+a)
%
%   has the same dynamics as SYS.
%
%   SYS should be have two zeros, a single real pole, and a single pole at
%   the origin.
%
%   For more information, see the YouTube video at
%   https://youtu.be/Hk6YBO_A_PU?t=2836
%
%INPUT:     -SYS:   second order transfer function
%
%OUTPUT:    -KP:    proportional gain
%           -KI:    integral gain
%           -KD:    derivative gain
%           -a:     pseudo-derivative parameter
%
%Christopher Lum
%lum@uw.edu

%Version History
%01/06/12: Created
%05/21/19: Updated documentation
%01/07/25: Updated documentation

%----------------------OBTAIN USER PREFERENCES-----------------------------
switch nargin
    case 1
        %User supplies all inputs
        sys = varargin{1};

    otherwise
        error('Invalid number of inputs');
end

%-----------------------CHECKING DATA FORMAT-------------------------------
%Obtain the coefficients of the transfer function
[num,den] = tfdata(sys,'v');

%Make sure there are two zeros and two poles
if(length(num)~=3)
    error('This transfer function does not appear to be a PID with pseudo-derivative system because the numerator is not a second order polynomial')
end

if(length(den)~=3)
    error('This transfer function does not appear to be a PID with pseudo-derivative system because the denominator is not a second order polynomial')
end

%If a2 is not 1, normalize system to make a2 equal to 1
if(den(1)~=1)
    num = num./den(1);
    den = den./den(1);
end

%Now check that a0 is zero
if(den(3) ~= 0)
    error('This transfer function does not appear to be a PID with pseudo-derivative system because the denominator constant is not 0')
end

%-------------------------BEGIN CALCULATIONS-------------------------------
%At this point, we know that this transfer function corresponds to a PID w/
%pseudo-derivative.

%Extract coefficients
b2 = num(1);
b1 = num(2);
b0 = num(3);

a2 = den(1);
a1 = den(2);
a0 = den(3);

%Compute gains
KP = (a1*b1 - b0)/a1^2;
KI = b0/a1;
KD = (b0 - a1*b1 + a1^2*b2)/(a1^3);
a = a1;

varargout{1} = KP;
varargout{2} = KI;
varargout{3} = KD;
varargout{4} = a;
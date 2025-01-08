function [varargout] = PIDTransferFunction(varargin)

%PIDTRANSFERFUNCTION  Generates a transfer function of a PID controller
%
%   [C] = PIDTRANSFERFUNCTION(KP, KI, KD) Generates a transfer function of
%   the pure PID controller defined by KP, KI, and KD.
%
%   [...] = PIDTRANSFERFUNCTION(KP, KI, KD, a) does as above but returns a
%   transfer function for a P, I, Pseudo-D controller.
%
%   For more information see https://youtu.be/Hk6YBO_A_PU?t=2367.
%
%See also ExtractPIDGainsFromSecondOrderTransferFunction
%
%INPUT:     -KP:    proportional gain
%           -KI:    integral gain
%           -KD:    derivative gain
%           -a:     break frequency of pseudo-derivative low pass filter
%
%OUTPUT:    -C:     transfer function of controller (TF object)
%
%Christopher Lum
%lum@uw.edu

%Version History
%05/21/19: Created
%01/07/25: Updated documentation

%----------------------OBTAIN USER PREFERENCES-----------------------------
switch nargin
    case 4
        %User supplies all inputs
        KP  = varargin{1};
        KI  = varargin{2};
        KD  = varargin{3};
        a   = varargin{4};

    case 3
        %Assume pure PID
        KP  = varargin{1};
        KI  = varargin{2};
        KD  = varargin{3};
        a   = NaN;

    otherwise
        error('Invalid number of inputs');
end

%-----------------------CHECKING DATA FORMAT-------------------------------

%-------------------------BEGIN CALCULATIONS-------------------------------
if(isnan(a))
    %pure PID
    C = tf([KD KP KI],[1 0]);
else
    %P, I, Pseudo-D
    C = tf([(a*KD+KP) (a*KP+KI) (a*KI)],[1 a 0]);
end

%Package outputs
varargout{1} = C;
function [varargout] = ExtractTrimPoint(varargin)

%EXTRACTTRIMPOINT  Converts an OperatingReport to Xo and Uo
%
%   [Xo, Uo] = EXTRACTTRIMPOINT(OP_TRIM) Extracts the trim state and
%   control for the planar vehicle from the OP_TRIM object.
%
%   [Xo, Uo, Yo] = EXTRACTTRIMPOINT(...) Does as above but also outputs the
%   trim outputs.
%
%INPUT:     -OP_TRIM:   OperatingReport object (typically obtained from
%                       Linear Analysis Tool)
%
%OUTPUT:    -Xo:        Trim point
%           -Uo:        Trim control
%           -Yo:        Trim outputs
%
%Created by Christopher Lum
%lum@uw.edu

%Version History
%04/28/19: Created

%----------------------OBTAIN USER PREFERENCES-----------------------------
switch nargin
    case 1
        %User supplies all inputs
        OP_TRIM = varargin{1};
        
    otherwise
        error('Invalid number of inputs');
end


%-----------------------CHECKING DATA FORMAT-------------------------------
assert(isa(OP_TRIM,'opcond.OperatingReport'), 'OP_TRIM should be an OperatingReport object')


%-------------------------BEGIN CALCULATIONS-------------------------------
States = OP_TRIM.States.x;
Xo = States;

Inputs = OP_TRIM.Inputs;
Uo = [Inputs(1).u;
    Inputs(2).u];

Outputs = OP_TRIM.Outputs;
Yo = [Outputs(1).y;
    Outputs(2).y];

%Package outputs
varargout{1} = Xo;
varargout{2} = Uo;
varargout{3} = Yo;
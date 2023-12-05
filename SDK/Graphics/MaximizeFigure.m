function [varargout] = MaximizeFigure(varargin)

%MAXIMIZEFIGURE Maximizes a figure
%
%   MAXIMIZEFIGURE() maximizes the current figure.
%
%   MAXIMIZEFIGURE(FIG) does as above but to the specified figure
%
%   MAXIMIZEFIGURE(FIG, FRACTION) does as above but allows a FRACTION of
%   maximization to be specified.  This is a value between 0 and 1 to
%   denote how much maximization to use (1 = maximum, 0.5 = half screen,
%   etc.)
%
%INPUT:     -FIG:       figure handle
%           -FACTION:   scalar denoting amount of maximization to employ
%
%OUTPUT:    -None
%
%Christopher Lum
%lum@uw.edu

%Version History
%04/21/16: Created 
%09/10/17: Changed to allow variable amount of maximization
%12/04/23: Moved to MatlabLum

%----------------------OBTAIN USER PREFERENCES-----------------------------
switch nargin
    case 2
        %User supplies all inputs
        FIG         = varargin{1};
        FRACTION    = varargin{2};
        
    case 1
        %Assume full maximization
        FIG         = varargin{1};
        FRACTION    = 1;
        
    case 0
        %Assume user wants to maximize the current figure and everything
        %above
        FIG         = -1;
        FRACTION    = 1;
        
    otherwise
        error('Invalid number of inputs');
        
end

%-----------------------CHECKING DATA FORMAT-------------------------------
% FIG

% FRACTION
assert(LumFunctionsMisc.IsObjectInRange(FRACTION, 0, 1), 'FRACTION should be in the range of [0,1]');

%-------------------------BEGIN CALCULATIONS-------------------------------
%Make the specified figure the current figure
if(FIG~=-1)
    figure(FIG);
end

set(gcf,'units','normalized','outerposition',[0 0 FRACTION FRACTION])
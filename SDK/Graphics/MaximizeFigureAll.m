function [varargout] = MaximizeFigureAll(varargin)

%MAXIMIZEFIGUREALL Maximizes all figures
%
%   MAXIMIZEFIGUREALL() maximizes all figures.
%
%   MAXIMIZEFIGUREALL(FRACTION) does as above but allows a FRACTION of
%   maximization to be specificed.  This is a value between 0 and 1 to
%   denote how much maximization to use (1 = maximum, 0.5 = half screen,
%   etc.)
%
%INPUT:     -FIG:   figure handle
%           -FACTION:   scalar denoting amount of maximization to employ
%
%OUTPUT:    -None
%
%Christopher Lum
%lum@uw.edu

%Version History
%08/15/17: Created 
%09/10/17: Added ability to chose amount of maxmization
%12/04/23: Moved to MatlabLum

%----------------------OBTAIN USER PREFERENCES-----------------------------
switch nargin
    case 1
        %User supplies all inputs
        FRACTION = varargin{1};
        
    case 0
        %Assume user wants to maximze completely
        FRACTION = 1;
        
    otherwise
        error('Invalid number of inputs');
        
end

%-----------------------CHECKING DATA FORMAT-------------------------------

%-------------------------BEGIN CALCULATIONS-------------------------------
%Get all the figure handles
figHandles = findall(0, 'Type', 'figure');

for k=1:length(figHandles)
    figHandle = figHandles(k);
    
    MaximizeFigure(figHandle, FRACTION);
end
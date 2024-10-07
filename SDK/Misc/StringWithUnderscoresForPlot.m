function [varargout] = StringWithUnderscoresForPlot(varargin)

%STRINGWITHUNDERSCORESFORPLOT   Returns a string suitable to use with plot
%
%   [S_PLOT] = STRINGWITHUNDERSCORESFORPLOT(S) converts the string S to
%   S_PLOT.  The string S may have underscores which are desired to be
%   displayed literally with functions like 'title' or 'legend'.  However,
%   these are usually used to denote a subscript.  The string S_PLOT has
%   the required backslash in front of the underscore so that the string is
%   displayed correctly.
%
%INPUT: -S:         String
%
%OUPUT: -S_PLOT:    String with backslashes preceding underscores
%
%Christopher Lum
%lum@uw.edu

%Version History
%12/03/07: Created
%10/06/24: Moved to MatlabLum.  Added support for '\'

%----------------------OBTAIN USER PREFERENCES-----------------------------
switch nargin
    case 1
        %User supplies all inputs
        S = varargin{1};

    otherwise
        error('Invalid number of inputs')
end

%-----------------------CHECKING DATA FORMAT-------------------------------
if (~isstr(S))
    error('S must be a string')
end

%------------------------BEGIN CALCULATIONS--------------------------------
S_PLOT = '';
for k=1:length(S)
    if (S(k) == '_')
        %Replace with '\_'
        S_PLOT = [S_PLOT '\_'];

    elseif(S(k) == '\')
        %Replace with '\\'
        S_PLOT = [S_PLOT '\\'];

    else
        %Insert char
        S_PLOT = [S_PLOT S(k)];
    end
end

varargout{1} = S_PLOT;
function [] = FigureToFile(varargin)

%FIGURETOFILE   Writes a figure to a file
%
%   [] = FILETOFIGURE(FILE_FORMAT,FILE_NAME) Exports the current figure to
%   a file with name FILE_NAME and FILE_FORMAT.
%
%   [] = FILETOFIGURE(FILE_FORMAT,FILE_NAME,FIGH) Does as above but with
%   the figure specified by handle FIGH.
%
%   The supported FILE_FORMATS are
%       'jpeg'
%
%
%INPUT:     -FILE_FORMAT:   string denoting the file format
%           -FILE_NAME:     string denoting the filename
%           -FIGH:          figure handle (optional)
%
%OUTPUT:    -None
%
%See also print.m, gcf.m
%
%Christopher Lum
%lum@uw.edu

%Version History
%09/14/06: Created
%05/19/24: Minor update

%----------------------OBTAIN USER PREFERENCES-----------------------------
switch nargin
    case 3
        %User supplies all inputs
        FILE_FORMAT = varargin{1};
        FILE_NAME   = varargin{2};
        FIGH        = varargin{3};
        
    case 2
        %Assume current figure
        FILE_FORMAT = varargin{1};
        FILE_NAME   = varargin{2};
        FIGH        = gcf;
        
    otherwise
        error('Invalid number of inputs');
end

%-----------------------CHECKING DATA FORMAT-------------------------------
if ~isa(FILE_FORMAT,'char')
    error('FILE_FORMAT must be a string')
end

if ~isa(FILE_NAME,'char')
    error('FILE_NAME must be a string')
end

%-------------------------BEGIN CALCULATIONS-------------------------------
%Set the desired figure to the current figure
figure(FIGH)

switch FILE_FORMAT
    case 'jpeg'
        print_string = 'print -djpeg ';
        print_string = [print_string FILE_NAME];
        
    otherwise
        error('Invalide FILE_FORMAT')
end

%Evaluate the string using the eval function
eval(print_string);
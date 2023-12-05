function [X] = SaveAllFigures(varargin)

%SAVEALLFIGURES  Saves all open figures to files
%
%   SAVEALLFIGURES(FILEPREFIX) Saves all open figures to a set of files
%   with the specified FILEPREFIX as Matlab .fig files.
%
%   SAVEALLFIGURES(FILEPREFIX, FILEEXTENSION) does as above but uses the
%   specified file type (AKA FILEEXTENSION).
%
%INPUT:     -FILEPREFIX:    string prefix of all figures
%           -FILEEXTENSION: file extension
%
%OUTPUT:    -None
%
%Created by Christopher Lum
%lum@uw.edu

%Version History
%08/15/17: Created

%----------------------OBTAIN USER PREFERENCES-----------------------------
switch nargin
    case 2
        %User supplies all inputs
        FILEPREFIX      = varargin{1};
        FILEEXTENSION   = varargin{2};
    case 1
        %Assume save Ms matlab .fig files
        FILEPREFIX      = varargin{1};
        FILEEXTENSION   = 'fig';
        
    otherwise
        error('Invalid number of inputs');
end


%-----------------------CHECKING DATA FORMAT-------------------------------
% FILEPREFIX

% FILEEXTENSION


%-------------------------BEGIN CALCULATIONS-------------------------------
%Get all the figure handles
figHandles = findall(0, 'Type', 'figure');

for k=1:length(figHandles)
    figHandle = figHandles(k);
    
    if(k<10)
        fileName = [FILEPREFIX,'_0',num2str(k),'.',FILEEXTENSION];
    else
        fileName = [FILEPREFIX,'_',num2str(k),'.',FILEEXTENSION];
    end
    saveas(figHandle, fileName, FILEEXTENSION);
end
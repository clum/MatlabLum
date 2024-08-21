function [varargout] = dir2(varargin)

%DIR2 Adds functionality to the dir command
%
%   [FILES] = DIR2(DIRNAME) returns the same as DIR(DIRNAME)
%
%   [...] = DIR2(DIRNAME, 'only_files') does as above but only returns a
%   list of file names in the directory DIRNAME. Folders names in this
%   folder are not included in the output.
%
%See also dir
%
%INPUT:     -DIRNAME:       string denoting desired directory
%           -'only_files':  input this string to return a list of file
%                           names only
%
%OUTPUT:    -FILES:         structure depends on number of inputs
%
%Christopher Lum
%lum@uw.edu

%Version History
%07/01/09: Created
%01/18/24: Moved to MatlabLum
%08/03/24: Minor update to documentation

%----------------------OBTAIN USER PREFERENCES-----------------------------
switch nargin
    case 2
        %User supplies all inputs
        DIRNAME             = varargin{1};
        ONLY_FILE_STRING    = varargin{2};

    case 1
        %Assume same
        DIRNAME             = varargin{1};
        ONLY_FILE_STRING    = 'false';

    otherwise
        error('Invalid number of inputs');
end

%-----------------------CHECKING DATA FORMAT-------------------------------
% DIRNAME
if(~isstr(DIRNAME))
    error('DIRNAME must be a string')
end

% ONLY_FILE_STRING
if(~isstr(ONLY_FILE_STRING))
    error('ONLY_FILE_STRING must be a string')
end

%-------------------------BEGIN CALCULATIONS-------------------------------
if(strcmp(ONLY_FILE_STRING, 'only_files'))
    totalFiles = dir(DIRNAME);

    FILES = {};
    innerCounter = 1;
    for k=1:length(totalFiles)
        currentFile = totalFiles(k);
        if(currentFile.isdir==0)
            FILES{innerCounter,1} = currentFile.name;
            innerCounter = innerCounter + 1;
        end
    end

    sort(FILES);

elseif(strcmp(ONLY_FILE_STRING, 'false'))
    FILES = dir(DIRNAME);

else
    error('Unknown ONLY_FILE_STRING')

end

%Output the object
varargout{1} = FILES;
function [S] = SaveVarsString(varargin)

%SAVEVARSSTRING  Generates a string that can be used to save multiple vars
%
%   [S] = SAVEVARSSTRING(FILENAMES,VARS) Generates a string that can be
%   passed to eval in order tos ave the specified VARS.
%
%   Example usage
%
%       vars = {'A','constraints'};
%       [s] = SaveVarsString('MyFile.mat','vars);
%       eval(s)
%
%   The end result is that the variables 'A' and 'constraints' are saved to
%   the feile 'MyFile.mat'.
%
%   [...] = SAVEVARSSTRING(FILENAMES,VARS,VERSION) does as above but saves
%   using the specified version (ie '-v7.3').  This is helpful if saving
%   large files/data which can fail unless you use '-v7.3'.
%
%INPUT:     -FILENAMES: filename
%           -VARS:      cell array of strings denoting vars to be saved
%           -VERSION:   desired version ('-v7.3', '-v7', etc.)
%
%OUTPUT:    -S:         string to be used with eval
%
%Christopher Lum
%lum@uw.edu

%Version History
%06/01/22: Created

%----------------------OBTAIN USER PREFERENCES-----------------------------
switch nargin
    case 3
        %User supplies all inputs
        FILENAME    = varargin{1};
        VARS        = varargin{2};
        VERSION     = varargin{3};
        
    case 2
        %Assume user only wants 1 sample
        FILENAME    = varargin{1};
        VARS        = varargin{2};
        VERSION     = [];
        
    otherwise
        error('Invalid number of inputs');
end

%-----------------------CHECKING DATA FORMAT-------------------------------
%FILENAME
assert(ischar(FILENAME),'FILENAME should be a char')

%VARS
assert(isa(VARS,'cell'),'VARS should be a cell array');

%VERSION
if(~isempty(VERSION))
    assert(ischar(VERSION),'VERSION should be a char');
end

%-------------------------BEGIN CALCULATIONS-------------------------------
varString = '';
for k=1:length(VARS)
    varString = [varString,'''',VARS{k},''','];
end

varString = varString(1:end-1);

if(isempty(VERSION))
    S = ['save(''',FILENAME,''',',varString,');'];
else
    S = ['save(''',FILENAME,''',',varString,',''',VERSION,''');'];
end
function [] = AddPathsMatlabLum()

%ADDPATHSMATLABLUM Adds paths for the MatlabLum SDK
%
%   ADDPATHSMATLABLUM() adds paths for the MatlabLum SDK.
%
%INPUT:     -None
%
%OUTPUT:    -None
%
%Christopher Lum
%lum@uw.edu

%Version History
%11/23/23: Created

[paths] = GetPathsMatlabLum();

for k=1:length(paths)
    addpath(paths{k});
end

disp('Added MatlabLum paths to Matlab path.')
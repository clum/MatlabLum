function [PATHS] = GetPathsMatlabLum()

%GETPATHSMATLABLUM Gets paths for the MatlabLum SDK
%
%   [PATHS] = GETPATHSMATLABLUM() returns paths for the MatlabLum SDK.
%
%INPUT:     -None
%
%OUTPUT:    -PATHS: cell array of paths
%
%Christopher Lum
%lum@uw.edu

%Version History
%11/23/23: Created

REPO_DIR = fileparts(mfilename('fullpath'));

PATHS = {};

%-------------------------CUSTOM TOOLBOXES----------------------------
%AIML
PATHS{end+1,1} = [REPO_DIR,'\SDK\AIML'];

%Graphics
PATHS{end+1,1} = [REPO_DIR,'\SDK\Graphics'];

%Misc
PATHS{end+1,1} = [REPO_DIR,'\SDK\Misc'];

%Probability
PATHS{end+1,1} = [REPO_DIR,'\SDK\Probability'];

%-------------------------THIRD PARTY CODE---------------------------------
%Real-time blockset
PATHS{end+1,1} = [REPO_DIR,'\ThirdPartyCode\RTBlockset'];

%UDP_toolbox
PATHS{end+1,1} = [REPO_DIR,'\ThirdPartyCode\UDP_toolbox\tcp_udp_ip_2_0_6\tcp_udp_ip'];

%Demonstrate using table
%
%Christopher Lum
%lum@uw.edu


%Version History
%11/21/24: Created

clear
clc
close all

%% Example 1
T = tableConstants.SetupTable(tableID.Vehicles01)

%Insert an undefined line
c = categorical({'High','Medium','Low','Low'})
c = categorical({'High','Medium','Low','Low',''})

disp('DONE!')
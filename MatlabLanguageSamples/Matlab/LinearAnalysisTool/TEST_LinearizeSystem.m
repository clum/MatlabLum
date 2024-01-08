%Explore how to use the Linear Analysis Tool to linearize a system.
%
%   1. Open a Simulink Model 
%   2. Select 'Analysis' > 'Control Design' > 'Linear Analysis'
%
%Note that discussion on how to obtain a trim point is found in 
%C:\dev\UWMatlab\MatlabLanguageSamples\Matlab\findop
%
%Christopher Lum
%lum@uw.edu

%Version History:
%04/28/19: Created
%05/27/19: Added case 4
%05/24/21: Updated

clear
clc
close all

%Add directories
findopDirectory = [ReturnPathStringNLevelsUp(1),'\findop'];
addpath(findopDirectory);

%Chose the trim point to linearize about
%
%   1 = heading straight in the +y direction at 15 m/s
%   2 = heading at 135 degrees at 15 m/s
%   3 = steady turn
%   4 = heading at 25 degrees at 10 m/s
%   5 = heading straight in the +y direction at 10 m/s
trimPoint = 4;

simulinkModelName = 'LinearAnalysisTool_model_SISO';       %cannot include .slx extension if you want to use the 'trim' function

vehicle = 'Boat';
[GEOMETRY, PROPULSION, SIMULATION, ENVIRONMENT, INPUTS] = PlanarVehicleLoadConstants(vehicle);

%Use the trim point we found earlier
switch trimPoint    
    case 1
        load('TrimPoint01.mat')
        
    case 2
        load('TrimPoint02.mat')
        
    case 3
        load('TrimPoint03.mat')
        
    case 4
        load('TrimPoint04.mat')
        
    case 5
        load('TrimPoint05.mat')
        
    otherwise
        error('Unknown trimCase')
end

[Xo, Uo, Yo] = ExtractTrimPoint(op_trim);

if(trimPoint==3)
    %Need to override and use the customized  trim point as the original
    %point found for point 3 using the Linear Analysis Tool (findop) did
    %not find a true equilibrium point
    load('TrimPoint03_Custom.mat')
    disp('Using a custom trim point')
end

SIMULATION.X_0 = Xo;

%open the model
uiopen(simulinkModelName, 1)

%Now manually linearize the model using the Linear Analysis Tool
disp(['Now manually linearize the ''',simulinkModelName,''''])
disp('Use Linear Analysis Tool (Analysis > Control Design > Linear Analysis...)')
disp('After linearizing the model do the following:')
disp('   1. Move linsys1 variable to Matlab workspace, rename as linsys, save as LinearSystemXX.mat.')

switch trimPoint    
    case 1
        load('LinearSystem01.mat')
        
    case 2
        load('LinearSystem02.mat')
        
    case 3
        load('LinearSystem03.mat')
        
    case 4
        load('LinearSystem04.mat')
        
    case 5
        load('LinearSystem05.mat')
        
    otherwise
        error('Unknown trimCase')
end

%Compute the transfer function
A_linsys = linsys.A;
B_linsys = linsys.B;
C_linsys = linsys.C;
D_linsys = linsys.D;

%% Linear model from Linear Analysis Tool
disp('Linearize using Linear System Analyzer')
[GV_num, GV_den] = ss2tf(A_linsys, B_linsys, C_linsys, D_linsys);
GV = minreal(tf(GV_num, GV_den))

%% Compare with linmod
disp('Linearize using linmod (SISO)')
[A_linmod, B_linmod, C_linmod, D_linmod] = linmod('linmod_model_SISO', Xo, Uo(1));

%compute the appropriate transfer function
[GV_num2, GV_den2] = ss2tf(A_linmod, B_linmod, C_linmod, D_linmod);
GV2 = minreal(tf(GV_num2, GV_den2))

%% MIMO system
disp('Linearize using linmod (MIMO)')
[A_linmod_MIMO, B_linmod_MIMO, C_linmod_MIMO, D_linmod_MIMO] = linmod('linmod_model_MIMO', Xo, Uo);

[G11_linmod_MIMO_num, G11_linmod_MIMO_den] = ...
    ss2tf(A_linmod_MIMO, B_linmod_MIMO(:,1), C_linmod_MIMO(1,:), D_linmod_MIMO(1,1));

[G12_linmod_MIMO_num, G12_linmod_MIMO_den] = ...
    ss2tf(A_linmod_MIMO, B_linmod_MIMO(:,2), C_linmod_MIMO(1,:), D_linmod_MIMO(1,2));

[G21_linmod_MIMO_num, G21_linmod_MIMO_den] = ...
    ss2tf(A_linmod_MIMO, B_linmod_MIMO(:,1), C_linmod_MIMO(2,:), D_linmod_MIMO(2,1));

[G22_linmod_MIMO_num, G22_linmod_MIMO_den] = ...
    ss2tf(A_linmod_MIMO, B_linmod_MIMO(:,2), C_linmod_MIMO(2,:), D_linmod_MIMO(2,2));

G11_linmod_MIMO = minreal(tf(G11_linmod_MIMO_num, G11_linmod_MIMO_den))
G12_linmod_MIMO = minreal(tf(G12_linmod_MIMO_num, G12_linmod_MIMO_den))
G21_linmod_MIMO = minreal(tf(G21_linmod_MIMO_num, G21_linmod_MIMO_den))
G22_linmod_MIMO = minreal(tf(G22_linmod_MIMO_num, G22_linmod_MIMO_den))

%% Clean up
rmpath(findopDirectory);

disp('DONE!')
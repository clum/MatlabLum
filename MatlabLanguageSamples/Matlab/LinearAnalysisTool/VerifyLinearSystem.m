%Verify results from the linearization process
%
%Created by Christopher Lum
%lum@uw.edu

%Version History:
%04/28/19: Created

clear
clc
close all

%Add directories
findopDirectory = [ReturnPathStringNLevelsUp(1),'\findop'];
addpath(findopDirectory);

%Chose the linear system to load
%
%   1 = heading straight in the +y direction at 15 m/s
%   2 = heading at 135 degrees at 15 m/s
%   3 = steady turn
trimPoint = 1;

simulinkModelName = 'linmod_model';         %cannot use .slx if you want to use linmod

vehicle = 'Boat';
[GEOMETRY, PROPULSION, SIMULATION, ENVIRONMENT, INPUTS] = PlanarVehicleLoadConstants(vehicle);
        
%% Linear Analysis Tool
switch trimPoint    
    case 1
        load('LinearSystem01.mat')

    case 2
        load('LinearSystem02.mat')
        
    case 3
        load('LinearSystem03.mat')
        
    otherwise
        error('Unknown trimCase')
end

%Cancel poles/zeros
GV_dirty = tf(linsys);
GV_linear_analysis_tool = minreal(GV_dirty)

%% Analytical model
switch trimPoint    
    case 1
        num_analytical = [PROPULSION.Fmax/GEOMETRY.mass];
        den_analytical = [1 ENVIRONMENT.CT/GEOMETRY.mass];
        
    case 2
        %Analytical model
        num_analytical = [PROPULSION.Fmax/GEOMETRY.mass];
        den_analytical = [1 ENVIRONMENT.CT/GEOMETRY.mass];
        
    case 3
        disp('Did not compute analytical model')
        num_analytical = [1];
        den_analytical = [1];
        
    otherwise
        error('Unknown trimCase')
end

GV_analytical = tf(num_analytical,den_analytical)

%% linmod
switch trimPoint
    case 1        
        load('TrimPoint01.mat')
        
    case 2
        load('TrimPoint02.mat')
        
    case 3
        load('TrimPoint03.mat')
        
    otherwise
        error('Unknown trimCase')
end

[Xo, Uo, Yo] = ExtractTrimPoint(op_trim);

%For some cases, need to change the trim point
if(trimPoint==3)
    load('TrimPoint03_Custom.mat')

end

SIMULATION.X_0 = Xo;
[A_linmod, B_linmod, C_linmod, D_linmod] = linmod(simulinkModelName, Xo, Uo);

switch trimPoint
    case 1
        %linmod model
        [num_linmod,den_linmod] = ss2tf(A_linmod,B_linmod(:,1),C_linmod(1,:),D_linmod(1,1));
        
    case 2
        %linmod model
        [num_linmod,den_linmod] = ss2tf(A_linmod,B_linmod(:,1),C_linmod(1,:),D_linmod(1,1));
        
    case 3
        %linmod model
        [num_linmod,den_linmod] = ss2tf(A_linmod,B_linmod(:,1),C_linmod(1,:),D_linmod(1,1));

    otherwise
        error('Unknown trimCase')
end

GV_linmod = minreal(tf(num_linmod,den_linmod))


disp('DONE!')
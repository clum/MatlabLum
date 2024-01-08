%Explore how to use the 'findop' function.  Note that 'findop' has a nice
%GUI that is accessed when you do the following:
%
%   1. Open a Simulink Model 
%   2. Select 'Analysis' > 'Control Design' > 'Linear Analysis'
%   3. In resulting GUI select 'Operating Point: ' > 'Trim Model'
%
%Created by Christopher Lum
%lum@uw.edu

%Version History:
%03/26/19: Created
%03/27/19: Changed name
%04/28/19: Continued working
%05/27/19: Added trimPoint 4
%05/28/19: Updated for new drag model

clear
clc
close all

%Chose the trim point to calculate
%
%   1 = heading straight in the +y direction at 15 m/s
%   2 = heading at 135 degrees at 15 m/s
%   3 = steady turn
%   4 = heading at 25 degrees at 10 m/s
%   5 = heading straight in the +y direction at 10 m/s
trimPoint = 5;

simulinkModelName = 'findop_model';       %cannot include .slx if you want to use the 'trim' function

vehicle = 'Boat';
[GEOMETRY, PROPULSION, SIMULATION, ENVIRONMENT, INPUTS] = PlanarVehicleLoadConstants(vehicle);

if(trimPoint==1)
    x0          = 0;
    y0          = 0;
    xDot0       = 0;
    yDot0       = 15;
    theta0      = deg2rad(90);
    thetaDot0   = 0;
    
elseif(trimPoint==2)
    x0          = 0;
    y0          = 0;
    xDot0       = -10;
    yDot0       = 10;
    theta0      = deg2rad(135);
    thetaDot0   = 0;
    
elseif(trimPoint==3)
    x0          = 0;
    y0          = 0;
    xDot0       = 10;
    yDot0       = 0;
    theta0      = 0;
    thetaDot0   = 2*pi/60;
    
elseif(trimPoint==4)
    x0          = 0;
    y0          = 0;
    xDot0       = 7;
    yDot0       = 7;
    theta0      = deg2rad(25);
    thetaDot0   = 0;
    
elseif(trimPoint==5)
    x0          = 0;
    y0          = 0;
    xDot0       = 0;
    yDot0       = 10;
    theta0      = deg2rad(90);
    thetaDot0   = 0;
    
else
    error('Unsupported trimPoint')
end

SIMULATION.X_0 = [
    x0;
    y0;
    xDot0;
    yDot0;
    theta0;
    thetaDot0];

%Determine what X_0 the model has stored (see 'trim' documentation that
%hints at how to use this)
[sizes,x0,xstr] = findop_model([],[],[],0);
assert(AreMatricesSame(x0, SIMULATION.X_0), 'model initial conditions do not appear correct')

%open the model
uiopen(simulinkModelName, 1)

%Now manually trim the model using the Linear Analysis Tool
disp(['Now manually trim the ''',simulinkModelName,''''])
disp('Use Linear Analysis Tool (Analysis > Control Design > Linear Analysis...)')
disp('After trimming model do the following:')
disp('   1. Move op_trim1 variable to Matlab workspace, rename as op_trim, save as TrimPointXX.mat.')
disp('   2. Export trim settings as opspec1 to Matlab workspace, rename as opspec, save as TrimPointXX_Input.mat.')

disp('DONE!')
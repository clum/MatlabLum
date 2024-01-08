%Verify the trim solution
%
%Created by Christopher Lum
%lum@uw.edu

%Version History:
%03/27/19: Created
%04/28/19: Updated
%05/27/19: Updated
%05/28/19: Updated
%05/24/21: Updated trim points and verified to work

clear
clc
close all

trimPoint = 3;

simulinkModel = 'VerifyTrimPoint_model.slx';
uiopen(simulinkModel,1)

vehicle = 'Boat';
scenario = 1;
[GEOMETRY, PROPULSION, SIMULATION, ENVIRONMENT, INPUTS] = PlanarVehicleLoadConstants(vehicle,scenario);

animateScenario = true;

%Use the trim point we found
switch trimPoint    
    case 1
        load('TrimPoint01.mat')
        tFinal = 10;
        
    case 2
        load('TrimPoint02.mat')
        tFinal = 10;
        
    case 3
        load('TrimPoint03.mat')
        tFinal = 200;
        
    case 4
        load('TrimPoint04.mat')
        tFinal = 10;
        
    case 5
        load('TrimPoint05.mat')
        tFinal = 10;
        
    otherwise
        error('Unknown trimCase')
end

[Xo, Uo, Yo] = ExtractTrimPoint(op_trim);

SIMULATION.X_0 = Xo;

%Run simulation to verify trim point
sim(simulinkModel);

t = simX.Time;
X = simX.Data;
U = simU.Data;
Y = simY.Data;

x           = X(:,1);
y           = X(:,2);
xDot        = X(:,3);
yDot        = X(:,4);
theta       = X(:,5);
thetaDot    = X(:,6);

u1          = U(:,1);
u2          = U(:,2);

%secondary outputs
V           = Y(:,1);

%Plot trajectory
figure
hold on
plot(x,y)
plot(x(1), y(1), 'ro')
plot(x(end), y(end), 'rx')
grid on
xlabel('x')
ylabel('y')
legend('Trajectory','Start','End')
title('Planar Trajectory')
axis('equal')

%Plot the outputs and inputs
figure
subplot(2,2,1)
plot(t, V)
grid on
legend('y_1 = V')
title('Outputs and Inputs')

subplot(2,2,2)
plot(t, thetaDot)
grid on
legend('y_2 = thetaDot')

subplot(2,2,3)
plot(t, u1)
grid on
legend('u_1')
axis([min(t) max(t) -1 1])

subplot(2,2,4)
plot(t, u2)
grid on
legend('u_2')
axis([min(t) max(t) -1 1])

%Plot the states
figure
subplot(3,2,1)
plot(t, x)
grid on
legend('x (m)')
title('States')

subplot(3,2,2)
plot(t, y)
grid on
legend('y (m)')

subplot(3,2,3)
plot(t, xDot)
grid on
legend('xDot')

subplot(3,2,4)
plot(t, yDot)
grid on
legend('yDot')

subplot(3,2,5)
plot(t, rad2deg(theta))
grid on
legend('theta (deg)')

subplot(3,2,6)
plot(t, thetaDot)
grid on
legend('thetaDot')

%Animate scenario
if(animateScenario)
    figure
    
    for k=1:length(t)
        clf
        hold on
        plot(x, y)
        plot(x(k), y(k), 'ro')
        axis([min(x) max(x) min(y) max(y)])
        axis equal
        psi = pi/2 - theta(k);
        
        scale = 4;
        DrawBoat(x(k), y(k), 0, psi, scale)
        
        grid on
        xlabel('x (m)')
        ylabel('y (m)')
        title('Animation of Scenario')
        
        pause(0.1)
    end
end

%For some cases, we need to overwrite the trim point
switch trimPoint    
    case 3
        %For this case, we need to take the state once we reach steady
        %state as the trim point
        Xo = X(end,:)';
        save('TrimPoint03_Custom.mat','Xo')
        
end

disp('DONE!')

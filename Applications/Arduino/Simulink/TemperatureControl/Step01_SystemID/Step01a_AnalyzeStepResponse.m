%Fit a model to the step response
%
%Christopher Lum
%lum@uw.edu

%Version History
%01/12/25: Created
%01/23/25: Continued working

clear
clc
close all

ChangeWorkingDirectoryToThisLocation();

tic

%% User settings
inputFile  = [ReturnPathStringNLevelsUp(1),'\Step02_OpenLoop\OpenLoopSimulinkData_ID01.mat'];   %u = 1.0
stepMagnitude = 1;

% inputFile  = [ReturnPathStringNLevelsUp(1),'\Step02_OpenLoop\OpenLoopSimulinkData_ID02.mat'];   %u = 0.8
% stepMagnitude = 0.8;

% inputFile  = [ReturnPathStringNLevelsUp(1),'\Step02_OpenLoop\OpenLoopSimulinkData_ID03.mat'];   %u = 0.6
% stepMagnitude = 0.6;

% inputFile  = [ReturnPathStringNLevelsUp(1),'\Step02_OpenLoop\OpenLoopSimulinkData_ID04.mat'];   %u = 0.4
% stepMagnitude = 0.4;

% inputFile  = [ReturnPathStringNLevelsUp(1),'\Step02_OpenLoop\OpenLoopSimulinkData_ID05.mat'];   %u = 0.2
% stepMagnitude = 0.2;

% inputFile  = [ReturnPathStringNLevelsUp(1),'\Step02_OpenLoop\OpenLoopSimulinkData_ID06.mat'];   %u = 0.0
% stepMagnitude = 0.0;

simulinkModel = 'SimulationOpenLoopModel.slx';
deltaT_s = 0.01;
stepTime_s = 5;

%Plant parameters
K           = 49;
zeta        = 1.5;
wn          = 0.03;
Tdelay_s    = 1.2;

%% Load data
temp = load(inputFile);
logsout = temp.logsout;

y = logsout.getElement('y');
u = logsout.getElement('u');

t_s = y.Values.Time;
tempCJ  = y.Values.Data(:,1);
tempTC  = y.Values.Data(:,2);

u       = u.Values.Data(:,1);

%% Simulate model
tFinal_s = t_s(end);

Tambient_C = tempTC(10);

simout = sim(simulinkModel);

u_sim               = simout.logsout.getElement('u');
temperatureTC_C_sim = simout.logsout.getElement('temperatureTC_C');

t_s_sim         = u_sim.Values.Time;
u_sim           = u_sim.Values.Data;
tempTC_C_sim    = temperatureTC_C_sim.Values.Data;

%Plot
ax = [];

figure
ax(end+1) = subplot(2,1,1);
hold on
plot(t_s,tempTC,'DisplayName',StringWithUnderscoresForPlot('tempTC'))
plot(t_s_sim,tempTC_C_sim,'DisplayName',StringWithUnderscoresForPlot('tempTC_C_sim'))
legend()
grid on
ylabel('Temp (C)')

ax(end+1) = subplot(2,1,2);
hold on
plot(t_s,u,'DisplayName',StringWithUnderscoresForPlot('u'))
plot(t_s_sim,u_sim,'DisplayName',StringWithUnderscoresForPlot('u_sim'))
legend()
grid on
ylabel('u')

linkaxes(ax,'x')

toc
disp('DONE')
%Simulation of Bang/bang with hysteresis deadband for temperature control.
%
%Christopher Lum
%lum@uw.edu

%Version History
%01/26/25: Created
%01/31/25: Updating pathing

clear
clc
close all

ChangeWorkingDirectoryToThisLocation();

%% User settings
% inputFile = 'BangBangHysteresisSimulinkData_IDXX.mat';

% inputFile = 'BangBangHysteresisSimulinkData_ID01.mat';      %bang/bang, shows chattering
% inputFile = 'BangBangHysteresisSimulinkData_ID03.mat';      %bang/bang w/ hysteresis, fixes chattering

% inputFile = 'BangBangHysteresisSimulinkData_ID07.mat';

inputFile = 'BangBangHysteresisSimulinkData_ID11.mat';  %show how additional noise can lead to chatter

%% Load data
disp(['Loading data from ',inputFile])
temp = load(inputFile);
simout = temp.simout;

%% Analyze data
u_sim               = simout.logsout.getElement('u');
temperatureTC_C_sim = simout.logsout.getElement('temperatureTC_C');
T_cmd_C_sim         = simout.logsout.getElement('T_cmd_C');

t_s_sim         = u_sim.Values.Time;
u_sim           = u_sim.Values.Data;
tempTC_C_sim    = temperatureTC_C_sim.Values.Data;
T_cmd_C_sim     = T_cmd_C_sim.Values.Data;

%Plot
ax = [];

figure
ax(end+1) = subplot(2,1,1);
hold on
plot(t_s_sim,T_cmd_C_sim,'DisplayName',StringWithUnderscoresForPlot('T_cmd_C_sim'),'LineWidth',2)
plot(t_s_sim,tempTC_C_sim,'DisplayName',StringWithUnderscoresForPlot('tempTC_C_sim'),'LineWidth',2)
legend('Location','best')
grid on
ylabel('Temp (C)')

ax(end+1) = subplot(2,1,2);
hold on
plot(t_s_sim,u_sim,'DisplayName',StringWithUnderscoresForPlot('u_sim'),'LineWidth',2)
legend('Location','best')
grid on
ylabel('u')

linkaxes(ax,'x')

disp('DONE!')

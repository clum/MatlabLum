%Simulation of Bang Bang loop model with temperature control.
%
%Christopher Lum
%lum@uw.edu

%Version History
%01/24/25: Created

clear
clc
close all

ChangeWorkingDirectoryToThisLocation();

%% User settings
simulinkModel = 'SimulationBangBangModel.slx';
deltaT_s = 0.01;
tFinal_s = 7*60;

%Plant parameters
K           = 49;
zeta        = 1.5;
wn          = 0.03;
Tdelay_s    = 1.2;
Tambient_C  = 24.1875;

%Controller parameters
u_ON = 1;   %When bang/bang controller is on, what control signal should be applied

%% Simulate model
simout = sim(simulinkModel);

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

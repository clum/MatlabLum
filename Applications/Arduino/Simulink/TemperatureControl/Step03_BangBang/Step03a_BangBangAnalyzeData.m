%Analyze data from the run.
%
%Christopher Lum
%lum@uw.edu

%Version History
%01/11/25: Created

clear
clc
close all

%% User settings
inputFile  = 'BangBangSimulinkData_ID01.mat';

%% Analyze data
temp = load(inputFile);
logsout = temp.logsout;

y       = logsout.getElement('y');
u       = logsout.getElement('u');
T_cmd_C = logsout.getElement('T_cmd_C');

t_s = y.Values.Time;
tempCJ  = y.Values.Data(:,1);
tempTC  = y.Values.Data(:,2);

u       = u.Values.Data(:,1);

T_cmd_C = T_cmd_C.Values.Data(:,1);

%Analyze
numDataPoints = length(t_s);
disp(['numDataPoints: ',num2str(numDataPoints)])
disp(['deltaT_s: ',num2str(t_s(2)-t_s(1))])

%Plot
ax = [];
figure
ax(end+1) = subplot(2,1,1);
hold on
plot(t_s,T_cmd_C,'DisplayName',StringWithUnderscoresForPlot('T_cmd_C'))
plot(t_s,tempTC,'DisplayName',StringWithUnderscoresForPlot('tempTC'))
legend()
grid on
ylabel('Temp (C)')

ax(end+1) = subplot(2,1,2);
plot(t_s,u,'DisplayName',StringWithUnderscoresForPlot('u'))
legend()
grid on
ylabel('u')

linkaxes(ax,'x')
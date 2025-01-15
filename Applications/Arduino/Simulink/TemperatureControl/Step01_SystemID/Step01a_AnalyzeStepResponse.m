%Fit a model to the step response
%
%Christopher Lum
%lum@uw.edu

%Version History
%01/12/25: Created

clear
clc
close all

%% User settings
inputFile  = 'OpenLoopSimulinkData_ID04.mat';

%% Analyze data
temp = load(inputFile);
logsout = temp.logsout;

y = logsout.getElement('y');
u = logsout.getElement('u');

t_s = y.Values.Time;
tempCJ  = y.Values.Data(:,1);
tempTC  = y.Values.Data(:,2);

u       = u.Values.Data(:,1);

%Analyze
numDataPoints = length(t_s);
disp(['numDataPoints: ',num2str(numDataPoints)])
disp(['deltaT_s: ',num2str(t_s(2)-t_s(1))])

%Plot
figure
subplot(2,1,1)
hold on
plot(t_s,tempCJ,'DisplayName',StringWithUnderscoresForPlot('tempCJ'))
plot(t_s,tempTC,'DisplayName',StringWithUnderscoresForPlot('tempTC'))
plot(t_s,tempTC,'x','DisplayName',StringWithUnderscoresForPlot('tempTC data'))
legend()
grid on
ylabel('Temp (C)')

subplot(2,1,2)
plot(t_s,u,'DisplayName',StringWithUnderscoresForPlot('u'))
legend()
grid on
ylabel('u')

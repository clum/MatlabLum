%Analyze data from the run.
%
%Christopher Lum
%lum@uw.edu

%Version History
%01/04/25: Created

clc
close all

%% User settings
inputFile  = 'MAX31856SimulinkData_IDXX.mat';

%% Analyze data
temp = load(inputFile);
logsout = temp.logsout;

y = logsout.getElement('y');
t_s = y.Values.Time;
tempCJ = y.Values.Data(:,1);
tempTC = y.Values.Data(:,2);

figure
hold on
plot(t_s,tempCJ,'DisplayName',StringWithUnderscoresForPlot('tempCJ'))
plot(t_s,tempTC,'DisplayName',StringWithUnderscoresForPlot('tempTC'))
plot(t_s,tempTC,'x','DisplayName',StringWithUnderscoresForPlot('tempTC data'))
legend()
grid on
ylabel('Temp (C)')

numDataPoints = length(t_s);
disp(['numDataPoints: ',num2str(numDataPoints)])
disp(['deltaT_s: ',num2str(t_s(2)-t_s(1))])
%Analyze data from the run
%
%Christopher Lum
%lum@uw.edu

%Version History
%12/18/24: Created

clear
clc
close all

%% User selection
inputFile = 'MAX31856OneShotData_IDXX.mat';

%% Analyze data
temp = load(inputFile);
tempCJ_vec = temp.tempCJ_vec;
tempTC_vec = temp.tempTC_vec;

iteration = [1:1:length(tempCJ_vec)];

figure
hold on
plot(iteration,tempCJ_vec,'DisplayName',StringWithUnderscoresForPlot('tempCJ_vec'))
plot(iteration,tempTC_vec,'DisplayName',StringWithUnderscoresForPlot('tempTC_vec'))
legend()
grid on
ylabel('Temp (C)')

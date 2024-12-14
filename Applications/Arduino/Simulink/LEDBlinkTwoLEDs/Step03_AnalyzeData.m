%Analyze data.
%
%Christopher Lum
%lum@uw.edu

%Version History
%12/14/24: Created

clear
clc
close all

%% User settings
inputFile = 'simData_IDXX.mat';

%% Unpack data
temp = load(inputFile);
simout = temp.simout;

t = simout.time;
y = simout.signals.values;

figure
plot(t,y)
grid on
xlabel('t (sec)')
ylabel('y')

disp('DONE!')

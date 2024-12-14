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
y_R = simout.signals.values(:,1);
y_G = simout.signals.values(:,2);
y_B = simout.signals.values(:,3);

figure
subplot(3,1,1)
plot(t,y_R)
grid on
xlabel('t (sec)')
ylabel('y_R')

subplot(3,1,2)
plot(t,y_G)
grid on
xlabel('t (sec)')
ylabel('y_G')

subplot(3,1,3)
plot(t,y_B)
grid on
xlabel('t (sec)')
ylabel('y_B')

disp('DONE!')

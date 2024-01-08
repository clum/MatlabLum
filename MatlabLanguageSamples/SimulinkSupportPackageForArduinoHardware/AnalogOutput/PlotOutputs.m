%Christopher Lum
%lum@uw.edu
%
%Plot outputs from the 'AnalogOutputs' example.

%Version History
%12/22/17: Created

clc
close all

%%Extract data
t = simout.time;
y = simout.signals.values(:,1);

figure
plot(t,y)
grid on

disp('DONE!')

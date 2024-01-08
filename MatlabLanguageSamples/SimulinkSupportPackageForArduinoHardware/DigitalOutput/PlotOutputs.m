%Christopher Lum
%lum@uw.edu
%
%Plot outputs from the 'DigitalOutput' example.

%Version History
%12/15/16: Created
%12/14/17: Updated documentation

clc
close all

%%Extract data
t = simout.time;
y = simout.signals.values(:,1);

figure
plot(t,y)
grid on

disp('DONE!')

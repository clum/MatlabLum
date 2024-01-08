%Christopher Lum
%lum@u.washington.edu
%
%Plot the outputs from the experiment (running in real time)
%
%Version History:   12/01/16: Created

clc
close all

%% Extract data
t               = sim_MA.time;
V_MA            = sim_MA.signals.values(:,1);

figure
plot(t, V_MA)

disp('DONE!')

%Christopher Lum
%lum@uw.edu
%
%Illustrate using the 'Analog Input' block from the Simulink Support
%Package for Arduino Hardware' blockset.

%Version History
%12/28/16: Created
%12/14/17: Updated documentation

clc
close all

%%Extract data
t = simout.time;
y = simout.signals.values(:,1);

figure
hold on
plot(t,y)
plot(t, (2^10 - 1)*ones(size(t)), 'r--')
plot(t, (2^12 - 1)*ones(size(t)), 'g--')
grid on
xlabel('Time (sec)')
ylabel('y - output from Analog Input block')
legend('Data','10-bit maximum','12-bit maximum')
disp('DONE!')

%Christopher Lum
%lum@uw.edu
%
%Illustrate using the 'Digital Input' block from the Simulink Support
%Package for Arduino Hardware' blockset.

%Version History
%10/23/16: Created
%12/14/17: Updated documentation and fixed bug regarding the 3rd dimension.

clc
close all

%Extract data.  Note that for some reason the sim32 struct has the data
%stored along the 3rd dimension
t = sim9.time;
u = sim9.signals.values(:,1);
y = squeeze(sim32.signals.values);

figure
subplot(2,1,1)
plot(t,u)
grid on
legend('u (pin 9)')

subplot(2,1,2)
plot(t,y)
grid on
legend('y (pin 22)')


disp('DONE!')

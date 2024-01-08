%Test difference equations derived from discrete transfer functions
%
%Christopher Lum
%lum@uw.edu

%Version History
%12/09/21: Created

clear
clc
close all

tic

%Create a noisy signal
T = 1/5;
tFinal_s = 20;
t = [0:T:tFinal_s];

w1 = 1;
phi1 = deg2rad(0);

w2 = 5;
phi2 = deg2rad(20);

w3 = 15;
phi3 = deg2rad(54);

u1 = 3.0*sin(w1*t + phi1);
u2 = 0.5*sin(w2*t + phi2);
u3 = 0.3*sin(w3*t + phi3);

u = u1 + u2 + u3;

%Filter using difference equation
y = zeros(size(u));
y(1) = 0;   %initialize filter state
for k=2:length(t)
    u_k1 = u(k-1);
    y_k1 = y(k-1);
    
    y(k) = 0.1813*u_k1 + 0.8187*y_k1;
end

%Filter using Simulink
simin_u = timeseries([u'],t');
Gz_num = [0 0.1813];
Gz_den = [1 -0.8187];

simout = sim('DifferenceEquation_model.slx');
simout_u = simout.simout_u;
simout_y = simout.simout_y;

t_simulink = simout_u.Time;
u_simulink = simout_u.Data;
y_simulink = simout_y.Data;

%% Plot results
figure
hold on
plot(t,u1)
plot(t,u);
plot(t,y);
plot(t_simulink,y_simulink)
grid on
xlabel('Time (sec)')
ylabel('signal')
legend('u clean','u noisy','y (difference equation)','y (simulink Discrete Filter)')

toc
disp('DONE!')
%Test the c2d function
%
%Christopher Lum
%lum@uw.edu

%Version History
%12/09/21: Created

clear
clc
close all

%Create a continuous time transfer function
a = 1;
G = tf([a],[1 a])

%Sample time
Hz = 5;
Ts = 1/Hz;

%Use c2d
Gz = c2d(G,Ts,'zoh')
Gf = c2d(G,Ts,'foh')
Gi = c2d(G,Ts,'impuse')
Gt = c2d(G,Ts,'tustin')
Gm = c2d(G,Ts,'matched')

%Look at response of these
figure
bode(G,Gz,Gf,Gi,Gt,Gm)
legend('continuous','zoh','foh','impulse','tustin','matched')
grid on

figure
step(G,Gz,Gf,Gi,Gt,Gm)
legend('continuous','zoh','foh','impulse','tustin','matched')
grid on

%Individually plot step responses
figure
step(G,Gz)
legend('continuous','zoh')
grid on

figure
step(G,Gf)
legend('continuous','foh')
grid on

figure
step(G,Gi)
legend('continuous','impulse')
grid on

figure
step(G,Gt)
legend('continuous','tustin')
grid on

figure
step(G,Gm)
legend('continuous','matched')
grid on

toc
disp('DONE!')
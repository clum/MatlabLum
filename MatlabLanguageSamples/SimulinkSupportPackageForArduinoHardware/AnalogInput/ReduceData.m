%Christopher Lum
%lum@uw.edu
%
%This script is used to generate plots showing the relationship between
%input voltage and the resulting output.  This is designed to generate
%plots for lecture, not for gathering real-time data.

%Version History
%12/28/16: Created
%12/14/17: Updated documentation

clear
clc
close all

%Obtain lab data
V_in_10Bit = [0.028 0.402 0.742 1.050 1.484 1.859 2.364 2.970 3.166];
y_10Bit = [4 120 225 321 455 571 727 915 976];
y_10Bit_theoretical = ((2^10 - 1)/3.3)*V_in_10Bit;
    
V_in_12Bit = [0.024 0.375 0.737 1.504 1.998 2.900 3.172];
y_12Bit = [15 451 900 1848 2461 3576 3913];
y_12Bit_theoretical = ((2^12 - 1)/3.3)*V_in_12Bit;

%Visualize
figure
subplot(2,1,1)
hold on
plot(V_in_10Bit, y_10Bit, 'rx', 'LineWidth', 2, 'MarkerSize', 15)
plot(V_in_10Bit, y_10Bit_theoretical, 'LineWidth', 2)
ylabel('y')
xlabel('V_{in} (volts)')
legend('Data','Theoretical','Location','Best')
title('Analog Input with 10-bit Resolution')
grid on

subplot(2,1,2)
hold on
plot(V_in_12Bit, y_12Bit, 'rx', 'LineWidth', 2, 'MarkerSize', 15)
plot(V_in_12Bit, y_12Bit_theoretical, 'LineWidth', 2)
ylabel('y')
xlabel('V_{in} (volts)')
legend('Data','Theoretical','Location','Best')
title('Analog Input with 12-bit Resolution')
grid on

disp('DONE!')

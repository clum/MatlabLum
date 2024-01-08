%Christopher Lum
%lum@uw.edu
%
%Test the surf function

%Version History
%02/12/17: Created
%05/31/17: Updated

clear
clc
close all

%% Example 1
disp('Example 1 (standard colormap)')
N = 45;
[X,Y,Z] = peaks(N);

figure
surf(X,Y,Z);
colorbar

%% Example 2
disp('Example 2 (using caxis to change colormap)')

%Figure out the min/max of the Z values
zMin = min(min(Z));
zMax = max(max(Z));

%Chose a min/max of the color axis
cMin = zMin/2;
cMax = zMax/2;

cMin = 2*zMin;
cMax = 1*zMax;

figure
hold on
surf(X,Y,Z);

%Plot the minimum value
surf(X,Y,cMin*ones(size(Z)))

%Plot the maximum value
surf(X,Y,cMax*ones(size(Z)))

colorbar
caxis([cMin,cMax])

disp('DONE!')
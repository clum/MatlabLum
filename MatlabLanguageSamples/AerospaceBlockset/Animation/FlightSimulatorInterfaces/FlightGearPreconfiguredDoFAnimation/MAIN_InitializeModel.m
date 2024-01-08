%Show how the 'FlightGear Preconfigured 6DoF Animation' block operates
%
%Christopher Lum
%lum@uw.edu

%Version History
%05/25/20: Created

clear
clc
close all

tic

%% Initialize variables
% lon0_deg = ConvertLatLonDegMinSecToDecimal(-122,17,46.86);  %Museum of Flight
% lat0_deg = ConvertLatLonDegMinSecToDecimal(47,31,04.37);    %Museum of Flight
% h0_m = 500;

% lon0_deg = ConvertLatLonDegMinSecToDecimal(-122,22,44.24);  %KSFO
% lat0_deg = ConvertLatLonDegMinSecToDecimal(37,37,16.73);    %KSFO
% h0_m = 500;

lon0_deg = ConvertLatLonDegMinSecToDecimal(-157,55,30.26);  %Honolulu
lat0_deg = ConvertLatLonDegMinSecToDecimal(21,19,28.25);    %Honolulu
h0_m = 500;

dt = 1/20;
t_final = 30;

simulinkModel = 'DemoModel.slx';
open_system(simulinkModel);

toc
disp('DONE!')
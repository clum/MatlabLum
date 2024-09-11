%Read from the serial port using Simulink
%
%Christopher Lum
%lum@uw.edu

%Version History
%09/10/24: Created

clear
clc
close all

tic

ChangeWorkingDirectoryToThisLocation()

%% User selections
dt_s                    = 1;
tFinal_s                = 15;
baudRate                = 9600;
serialReceive.dataSize  = [8 1];   %make this at least as large as the expected message

simulinkModel = 'SerialReader02';

%% Read serial port
open(simulinkModel)

disp('Starting read from serial port')
sim(simulinkModel)

%% Close port
%Assume that Simulink closes the port when the model completes

%Ensure that there are no ports open
findResult = serialportfind();
assert(isempty(findResult),'Serial port appears to still be open (there is a variable that still references this port)')

toc
disp('DONE!')
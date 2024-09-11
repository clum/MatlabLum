%Read from the serial port using Matlab
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
port = "COM4";
baudRate = 9600;
tag = "MatlabSerial";   %optional: create a tag that can be associated with the serial port

%% Setup port
s = serialport(port,baudRate,Tag=tag);

%Check that the port was setup.
%   serialportfind() can be used to find all ports
%   serialportfind(Tag=tag) can be used to find this specific port
findResult = serialportfind(Tag=tag);
assert(~isempty(findResult),'Serial port did not appear to be setup correctly')

%% Read serial port
disp('Starting read from serial port')
for k=1:5
    line = readline(s);
    disp(line);
    pause(1)
end

%% Close port
%When no references to the same connection exist in other variables, you
%can disconnect the serial port by clearing the workspace variables
%associated with this (in this case both s and findResult need to be
%cleared/deleted)
disp('Closing port')
clear s findResult

%Ensure that there are no ports open
findResult = serialportfind(Tag=tag);
assert(isempty(findResult),'Serial port appears to still be open (there is a variable that still references this port)')

toc
disp('DONE!')
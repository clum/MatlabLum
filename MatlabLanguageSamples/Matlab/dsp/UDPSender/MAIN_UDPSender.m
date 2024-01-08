%Explore dsp.UDPSender
%
%Christopher Lum
%lum@uw.edu

clear
clc
close all

tic

remoteIPAddress = '127.0.0.1';
remoteIPPort = 49003;
udps = dsp.UDPSender();

udps.RemoteIPAddress = remoteIPAddress;
udps.RemoteIPPort = remoteIPPort;

udps

for k=1:120
    s = ['k = ',num2str(k)];
    disp(s)
    
    %Convert the string to an integer array in order to send using udps
    udps(uint32(s))
    pause(1);
end

toc
disp('DONE!')
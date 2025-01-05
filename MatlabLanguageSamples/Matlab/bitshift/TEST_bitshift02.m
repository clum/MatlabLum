%Christopher Lum
%lum@uw.edu
%
%Test the bitshift function.
%
%Show that behavior depends on data type due to how negative numbers are
%stored.

%Version History
%12/31/24: Created

clear
clc
close all

%% User selection
selection = 2;  %1 = use int8 (DEMONSTRATES ERROR)
                %2 = use uint8 (correct behavior)

if(selection==1)
    %int8
    warning('This produces results that may be unexpected due to padding of 1s')
    tcByteH = int8(1);      %00000001
    tcByteM = int8(94);     %01011110
    tcByteL = int8(-32);    %11100000

elseif(selection==2)
    %uint8
    tcByteH = uint8(1);      %00000001
    tcByteM = uint8(94);     %01011110
    tcByteL = uint8(224);    %11100000

end
    
disp(['tcByteH = ',num2str(tcByteH)])
disp(['tcByteM = ',num2str(tcByteM)])
disp(['tcByteL = ',num2str(tcByteL)])

ret = int32(0);

ret = int32(tcByteH);               %00000000000000000000000000000001
dec2bin(ret,32)

ret = bitshift(ret,8);              %00000000000000000000000100000000
dec2bin(ret,32)

ret = bitor(ret,int32(tcByteM));    %00000000000000000000000101011110
dec2bin(ret,32)

ret = bitshift(ret,8);              %00000000000000010101111000000000
dec2bin(ret,32)

%problem here is that int32(tcByteL) has a different bit pattern depending
%on the underlying data type
% tcByteL is a int8  then it is -32 so when cast to int32 it becomes 11111111111111111111111111100000
% tcByteL is a uint8 then it is 224 so when cast to int32 it becomes 00000000000000000000000011100000
ret = bitor(ret,int32(tcByteL));
dec2bin(ret,32)

disp('DONE!')
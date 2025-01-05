%Christopher Lum
%lum@uw.edu
%
%Test the bitshift function

%Version History
%12/27/16: Created
%12/03/24: Testing negative shifts

clear
clc
close all

%% Example 1 - Simple shift (AKA << in C)
disp('Example 1 (uint8)')
X1 = uint8(7)
Y1 = bitshift(X1,2)

%% Example 2 - Shift to put 1 in the MSB but this is an unsigned data type
disp('Example 2 (uint8)')
X2 = uint8(13)
Y2 = bitshift(X2,4)

%% Example 3 - shift to put 1 in the MSB with a signed data type
disp('Example 3 (int8)')
X3 = int8(13)
Y3 = bitshift(X3,4)

%% Example 4 - same as example 3 but now with a 16 bit signed data type
disp('Example 4 (int16)')
X4 = int16(13)
Y4 = bitshift(X4,4)

%% Example 5 - shift into the next byte and put a 0 in the MSB of the signed data type
disp('Example 5 (int16)')
X5 = int16(13)
Y5 = bitshift(X5,11)

%% Example 6 - shift into the next byte and put a 1 in the MSB of the signed data type
disp('Example 6 (int16)')
X6 = int16(13)
Y6 = bitshift(X6,12)

%% Example 7 - adding two 16 bit integers
X7 = int16(13)
Y7 = bitshift(X7, 8)
Z7 = X7 + Y7

%% Example 8 - Shift to the right (AKA >> in C)
X8 = uint8(28)
Y8 = bitshift(X8,-2)

disp('DONE!')
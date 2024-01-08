%Christopher Lum
%lum@u.washington.edu
%
%Illustrate how the imshow function operates

%Version History:   11/18/15: Created

clear
clc
close all

%Load a file
A = imread('SampleImage3by3.bmp');

R = A(:,:,1);
G = A(:,:,2);
B = A(:,:,3);

figure
imshow(A)

%Create a picture using uint6 values
M = 10;
N = 12;
R16 = zeros(M,N);

for m=1:M
    for n=1:N
        R16(m,n) = (m-1)*N + n;
        G16(m,n) = (M*N) - (m-1)*N + n;
        B16(m,n) = M*N/2;
    end
end

%Scale up to a uint16 value
maxVal = max(max(R16));

R16 = R16./maxVal;
R16 = R16*(2^16 - 1);
R16 = floor(R16);
R16 = uint16(R16);

G16 = G16./maxVal;
G16 = G16*(2^16 - 1);
G16 = floor(G16);
G16 = uint16(G16);

B16 = B16./maxVal;
B16 = B16*(2^16 - 1);
B16 = floor(B16);
B16 = uint16(B16);

RGB16(:,:,1) = R16;
RGB16(:,:,2) = G16;
RGB16(:,:,3) = B16;

figure
imshow(RGB16)


disp('DONE')
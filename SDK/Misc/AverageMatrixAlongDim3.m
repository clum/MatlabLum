function [A_AVERAGE] = AverageMatrixAlongDim3(A)

%AVERAGEMATRIXALONGDIM3 Average the matrix along dim 3
%
%   [A_AVERAGE] = AVERAGEMATRIXALONGDIM3(A) Averages each element of the 3D
%   matrix along dimension 3 to result in a 2D matrix.
%
%INPUT:     -A:         3D matrix
%
%OUTPUT:    -A_AVERAGE: Average along the 3rd dimension
%
%Christopher Lum
%lum@uw.edu

%Version History
%05/06/23: Created

%-----------------------CHECKING DATA FORMAT-------------------------------

%-------------------------BEGIN CALCULATIONS-------------------------------
[M,N,P] = size(A);

A_AVERAGE = zeros(M,N);
for m=1:M
    for n=1:N
        vec = A(m,n,:);
        
        ave = sum(vec)/P;
        A_AVERAGE(m,n) = ave;
    end
end
function [Y,Y_PRIME] = ReLU(X)

%RELU Computes a ReLU function and its derivative
%
%   [Y,Y_PRIME] = RELU(X) Computes the rectified linear unit (ReLU)
%   function and its derivative.
%
%       Y = max(0,X)
%       Y_PRIME = 0 if X <= 0, 1 otherwise
%
%INPUT:     -X:         -X value or values
%
%OUTPUT:    -Y:         -output
%           -Y_PRIME:   -derivative of output
%
%Christopher Lum
%lum@uw.edu

%Version History
%03/03/23: Created
%03/26/23: Updated documentation
%05/10/23: Updated documentation

%-----------------------CHECKING DATA FORMAT-------------------------------

%----------------------OBTAIN USER PREFERENCES-----------------------------
%None

%-------------------------BEGIN CALCULATIONS-------------------------------
Y       = max(0,X);
Y_PRIME = double(logical(Y));
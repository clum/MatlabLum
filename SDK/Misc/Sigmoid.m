function [Y,Y_PRIME] = Sigmoid(X)

%SIGMOID Computes a sigmoid function and its derivative
%
%   [Y,Y_PRIME] = SIGMOID(X) Compute the sigmoid function and its
%   derivative.
%
%INPUT:     -X:         -X value or values
%
%OUTPUT:    -Y:         -output
%           -Y_PRIME:   -derivative of output
%
%Christopher Lum
%lum@uw.edu

%Version History
%08/16/05: Created
%02/26/23: Updated documentation
%03/03/23: Renamed function

%-----------------------CHECKING DATA FORMAT-------------------------------

%----------------------OBTAIN USER PREFERENCES-----------------------------
%None

%-------------------------BEGIN CALCULATIONS-------------------------------
Y       = 1./(1+exp(-X));
Y_PRIME = exp(-X)./((1+exp(-X)).^2);
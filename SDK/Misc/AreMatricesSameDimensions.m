function [YES_OR_NO] = AreMatricesSameDimensions(A,B)

%AREMATRICESSAMEDIMENSIONS Tests if two matrices or cell arrays are same dimensions
%
%   [YES_OR_NO] = AREMATRICESSAME(A,B) Tests to see if A and B have the
%   same dimensions or not.
%
%INPUT:     -A:         first matrix
%           -B:         second matrix
%
%OUTPUT:    -YES_OR_NO: true if the matrices are the same dimensions, false
%                       otherwise
%
%Christopher Lum
%lum@uw.edu

%Version History
%05/06/23: Created

%-----------------------CHECKING DATA FORMAT-------------------------------

%-------------------------BEGIN CALCULATIONS-------------------------------
[m_A,n_A] = size(A);
[m_B,n_B] = size(B);

if(m_A==m_B && n_A==n_B)
    YES_OR_NO = true;
else
    YES_OR_NO = false;
end

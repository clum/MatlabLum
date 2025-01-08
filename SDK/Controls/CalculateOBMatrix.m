function OB = CalculateOBMatrix(A,C)

%CALCULATEOBMATRIX Calculates the observability matrix.
%
%   [OB] = CALCULATEOBMATRIX(A,C) calculates the observability matrix, OB,
%   using the given A and C matrix.
%
%INPUT:     -A:     A matrix
%           -C:     C matrix
%
%OUTPUT:    -OB:    Observability matrix
%
%See also OBSV
%
%Christopher Lum
%lum@uw.edu

%Version History
%04/04/04: Created
%01/07/25: Updated documentation

%Figure out how many inputs there are
[n,m] = size(A);
[num_outputs,q] = size(C);

if n~=q
    error('A and B matrix size are not compatible')
end

if n~=m
    error('A matrix is not square')
end

for k=1:m
    %What is the current row?
    curr_row = (k-1)*num_outputs + 1;

    if k==1
        OB(1:num_outputs,:) = C;
    else
        OB(curr_row:(curr_row+num_outputs-1),:) = C*(A^(k-1));
    end
end
function Pc = CalculatePMatrix(A,B,n)

%CALCULATEPMATRIX Calculates the controllability matrix.
%
%   [Pc] = CALCULATEPMATRIX(A,B) calculates the controllability matrix, Pc,
%   using the given A and B matrix.
%
%   [Pc] = CALCULATEPMATRIX(A,B,n) calculates the matrix
%
%       Pc = [B A*B A^2*B ... A^n-1*B]
%
%   This is helpful when trying to calculate a control sequence input to
%   move an initial state vector of length m to a final state in more than
%   m steps with minimum ||u||.
%
%INPUT:     -A:     A matrix
%           -B:     B matrix
%           -n:     number of columns to calculate
%
%OUTPUT:    -Pc:    Controllability matrix
%
%See also CTRB
%
%Christopher Lum
%lum@uw.edu

%Version History
%04/23/03: Created
%04/04/04: Rewrote documentation and made compatible with multiply inputs.
%05/13/04: Added feature where can calculate up to n columns of matrix
%01/07/25: Updated documentation

%---------------------OBTAIN USER PREFERENCES-----------------------------
switch nargin
    case 2
        %Assume calculate normal Pc matrix
        n = length(A);
end

%---------------------CHECK DATA FORMAT-----------------------------
%Figure out how many inputs there are
[A_rows,A_cols] = size(A);
[B_rows,B_cols] = size(B);

if A_rows~=B_rows
    error('A and B matrix size are not compatible')
end

if A_rows~=A_cols
    error('A matrix is not square')
end

for k=1:n
    %What is the current col?
    curr_col = (k-1)*B_cols + 1;

    if k==1
        Pc(:,1:B_cols) = B;
    else
        Pc(:,curr_col:(curr_col+B_cols-1)) = A^(k-1)*B;
    end
end
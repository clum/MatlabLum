function [varargout] = RouthArray(varargin)

%ROUTHARRAY Generates the Routh array for the given polynomial
%
%   [ROUTH] = ROUTHARRAY(P) Generates the Routh array for the polynomial
%   described by the vector P.  P should be a vector of coefficients of s
%   in descending order.
%
%   For example, to represent the polynomial
%
%       3*s^3 + 2*s^2 - 3
%
%   P = [3 2 0 -3]
%
%   For more information, see
%   http://www.chem.mtu.edu/~tbco/cm416/routh.html.
%
%INPUT:     -P:     vector of coefficients of s in descending order
%
%OUTPUT:    -ROUTH: Routh array
%
%Christopher Lum
%lum@uw.edu

%Version History
%11/17/12: Created
%05/08/19: Updated documentation
%05/09/19: Updated documentation
%06/06/20: Updated documentation
%01/07/25: Updated documentation

%----------------------OBTAIN USER PREFERENCES-----------------------------
switch nargin
    case 1
        %User supplies all inputs
        P = varargin{1};

    otherwise
        error('Invalid number of inputs');
end

%-----------------------CHECKING DATA FORMAT-------------------------------
if(~isvector(P))
    error('P should be a vector')
end

if(~isreal(P))
    error('P should be a real vector')
end

%-------------------------BEGIN CALCULATIONS-------------------------------
%Step 1: Build an empty Routh array
n = length(P)-1;
h = ceil((n+1)/2);

ROUTH = zeros(n+1,h);

%Step 2: Fill in the first two rows of the Routh array
row = 1;
col = 1;
for k=1:n+1
    ROUTH(row, col) = P(k);

    if(row==2)
        col = col + 1;
    end

    if(row==1)
        row = 2;
    else
        row = 1;
    end

end

%Step 3: Build the Routh array (rows 3 to n+1)
for k=3:n+1

    %Get row x and y
    y = ROUTH(k-1,:);
    x = ROUTH(k-2,:);

    %Compute z_ki
    for i=1:h
        if(i==h)
            z_ki = 0;
        else
            z_ki = (y(1)*x(i+1) - x(1)*y(i+1)) / y(1);
        end

        ROUTH(k,i) = z_ki;
    end
end

varargout{1} = ROUTH;
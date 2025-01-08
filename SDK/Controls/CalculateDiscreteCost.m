function J = CalculateDiscreteCost(X,U,Q,R)

%CALCULATEDISCRETECOST  Calculates the discrete cost function
%
%   J = CALCULATEDISCRETECOST(X,U,Q,R) calculates the sum
%
%       J = sum(x(k)'*Q*x(k) + u(k)'*R*u(k)) from k = 1 to N
%
%   X and U should be long matrices such as
%
%       X = [  |     |    |    |  ]
%           [x1(k) x2(k) ... xn(k)]
%           [  |     |    |    |  ]
%
%
%INPUT:     -X:  Time history of states
%           -U:  Time history of inputs
%           -Q:  Penalty on states
%           -R:  Penalty on control
%
%OUTPUT:    -J:  Total cost
%
%Christopher Lum
%lum@uw.edu

%Version History
%05/08/04: Created
%01/07/25: Updated documentation

[N,n] = size(X);
[N2,m] = size(U);

if N~=N2
    error('X and U not same length')
end

for counter=1:N
    x = X(counter,:)';
    u = U(counter,:)';

    cost(counter) = x'*Q*x + u'*R*u;
end

J = sum(cost);
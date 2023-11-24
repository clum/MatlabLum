function [INDEX] = RouletteWheel(varargin)

%ROULETTEWHEEL Spins a roulette wheel where the slots sizes are
%proportional to input vector
%
%   [INDEX] = ROULETTEWHEEL(W) Spins a roulette wheel once.  The number of
%   slots is equal to length(W).  The sizes of the slots are determined by
%   the vector W.  The angular percentage (size) of slot k is given by
%
%       Angle_k = W(k)/sum(W)
%
%   Note that W does not need to represent probabilities (it does not need
%   to sum to 1) although this is the most common usage of W.
%
%   The retuned INDEX corresponds to the slot where the ball landed in.
%
%   [...] = ROULETTEWHEEL(W,N) Spins the roulette wheel N times
%
%   Example usage
%
%       %6-sided die where "one" and "six" occur with twice as frequently
%       as other numbers)
%       W = [2 1 1 1 1 2];
%       [k] = RouletteWheel(W);
%       
%
%INPUT:     -W:     vector of weights (1xp or px1)
%           -N:     number of times to spin wheel (1x1)
%
%OUTPUT:    -INDEX: vector of results (1xN)
%
%Christopher Lum
%lum@uw.edu

%Version History
%03/01/06: Created
%10/10/13: Updated documentation
%11/24/22: Minor update in preparation for public release

%----------------------OBTAIN USER PREFERENCES-----------------------------
switch nargin
    case 2
        %User supplies all inputs
        W = varargin{1};
        N = varargin{2};
        
    case 1
        %Assume user only wants 1 spin
        W = varargin{1};
        N = 1;
        
    otherwise
        error('Invalid number of inputs');
end

%-----------------------CHECKING DATA FORMAT-------------------------------
[n,m] = size(W);

if (n>1) && (m>1)
    error('Input vector of weights must be a row or column vector')
end

if (max([n m])==1)
    error('Input vector of weights must have more than 1 entry')
end

if (length(find(W<0))~=0)
    error('Input vector of weights must have all non-negative entries')
end

if (sum(imag(W))~=0)
    error('Input vector of weights must have real valued entires')
end

%-------------------------BEGIN CALCULATIONS-------------------------------
%Create bins
bin(1) = W(1);
for k=2:length(W)
   bin(1,k) = W(k) + bin(1,k-1);
end

%Generate random number in range [0,sum(w)]
x = sum(W)*rand(1,N);

for k=1:N
    INDEX(1,k) = min(find(bin>=x(k)));
end

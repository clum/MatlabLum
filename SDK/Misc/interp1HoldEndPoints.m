function [varargout] = interp1HoldEndPoints(varargin)

%interp1HoldEndPoints Similar to interp1 but allows end point to be held
%
%   [Vq] = interp1HoldEndPoints(X,V,Xq,METHOD) operates the same as interp1
%   for values of Xq that are in the range of [X(1),X(end)].  For values of
%   Xq that are outside this range Vq is returned as the corresponding end
%   point.  In other words,
%
%       if Xq < X(1) then Vq = V(1)
%       if Xq > X(end) then Vq = V(end)
%
%   Recall that X must be monotonically increasing as required by interp1.
%
%See also interp1
%
%INPUT:     -X:         see interp1 documentation
%           -V:         see interp1 documentation
%           -Xq:        see interp1 documentation
%           -METHOD:    see interp1 documentation
%
%OUTPUT:    -Vq:        see interp1 documentation
%
%Christopher Lum
%lum@uw.edu

%Version History
%08/03/24: Created

%----------------------OBTAIN USER PREFERENCES-----------------------------
switch nargin
    case 4
        %User supplies all inputs
        X       = varargin{1};
        V       = varargin{2};
        Xq      = varargin{3};
        METHOD  = varargin{4};

    otherwise
        error('Invalid number of inputs');
end

%-----------------------CHECKING DATA FORMAT-------------------------------

%-------------------------BEGIN CALCULATIONS-------------------------------
Vq = zeros(size(Xq));
for k=1:length(Xq)
    Xq_k = Xq(k);

    if(Xq_k<X(1))
        Vq_k = V(1);

    elseif(Xq_k>X(end))
        Vq_k = V(end);

    else
        [Vq_k] = interp1(X,V,Xq_k,METHOD);

    end

    Vq(k) = Vq_k;
end

%Output the object
varargout{1} = Vq;


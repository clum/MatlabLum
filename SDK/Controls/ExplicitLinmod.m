function [A, B] = ExplicitLinmod(varargin)

%EXPLICITLINMOD Linearizes non-linear equations defined in MY_FUN
%
%   [A,B] = EXPLICITLINMOD(MY_FUN,Xo,Uo) linearized the set of non-linear
%   equations defined by MY_FUN about the operating point of Xo, and Uo.
%   MY_FUN should be of the form y = F(x,u) and should have inputs and
%   outputs as shown below
%
%       [y] = MY_FUN(x,u)
%
%   where   F is a set of n equations
%           x is a n x 1 vector of the states
%           u is a m x 1 vector of the inputs
%
%   The A and B matrices are matrices of partial derivatives defined as
%
%       A(i,j) = d[F_i(x,u)]/dx_j (evaluated at Xo, and Uo)
%       B(i,j) = d[F_i(x,u)]/du_j (evaluated at Xo, and Uo)
%
%   [...] = EXPLICITLINMOD(MY_FUN,Xo,Uo,DX,DU) does as above but uses
%   custom pertubation values for each function in each direction.
%
%   DX and DU should be vectors of the following sizes
%
%       DX - 1 x n matrix.  DX(j) = dx_j used when numerically
%       calculating d[F_i(x,u)]/dx_j (for i = 1, 2, ..., n)
%
%       DU - 1 x m matrix.  DU(j) = du_j used when numerically
%       calculating d[F_i(x,u)]/du_j (for i = 1, 2, ..., n)
%
%   Alternatively, if an even finer level of control in terms of computing
%   partials is required, DXDOT, DX, and DU can be be full matrices
%   (instead of just a vector) of the following sizes
%
%       DX - n x n matrix.  DX(i,j) = dx_j used when numerically
%       calculating d[F_i(x,u)]/dx_j
%
%       DU - n x m matrix.  DU(i,j) = du_j used when numerically
%       calculating d[F_i(x,u)]/du_j
%
%   Note that if DX, and DU are matrices, this will take a
%   significantly longer amount of time to compute the matrices.
%
%   If DX and DU are not specified, a pertubation of 10e-12 is used by
%   default.
%
%   If DX and DU are vectors of size n x 1, n x 1, and m x 1,
%   respectively, this will assume the same pertubation in each input for
%   each of the functions
%
%   The standard state space representation can then be calculated using
%
%       xdot(t) = A*x(t) + B*u(t)
%
%   [...] = EXPLICITLINMOD(MY_FUN,Xo,Uo,DXDOT,DX,DU,DISPLAY_PROGRESS)
%   does as above but displays progress if DISPLAY_PROGRESS = 1.
%
%   Examples of function usage
%
%       %Use with default pertubation distances
%       [A, B] = ExplicitLinmod(@RCAM_model, Xo, Uo);
%
%
%INPUT:     -MY_FUN:            Non-linear function
%           -Xo:                Linearization point for X
%           -Uo:                Linearization point for U
%           -DX:                Vector or matrix of pertubation values for X
%           -DU:                Vector or matrix of pertubation values for U
%           -DISPLAY_PROGRESS:  set to 1 to display linearization process
%
%OUTPUT:    -A:                 Matrix of F(Xo,Uo) - sensitivity to X
%           -B:                 Matrix of F(Xo,Uo) - sensitivity to U
%
%
%Also see LINMOD, DLINMOD, LINMODV5, LINMOD2, TRIM, EXPLICITLINMOD (custom
%function)
%
%Christopher Lum
%lum@uw.edu

%Version History
%02/27/19: Created from ImplicitLinmod
%01/07/25: Updated documentation

%---------------------OBTAIN USER PREFERENCES-----------------------------
switch nargin
    case 6
        %user specifies all inputs
        MY_FUN              = varargin{1};
        Xo                  = varargin{2};
        Uo                  = varargin{3};
        DX                  = varargin{4};
        DU                  = varargin{5};
        DISPLAY_PROGRESS    = varargin{6};

    case 5
        %assume no progress
        MY_FUN              = varargin{1};
        Xo                  = varargin{2};
        Uo                  = varargin{3};
        DX                  = varargin{4};
        DU                  = varargin{5};
        DISPLAY_PROGRESS    = 0;

    case 3
        %Assume that pertubations are the same for all and everything above
        MY_FUN              = varargin{1};
        Xo                  = varargin{2};
        Uo                  = varargin{3};

        n = length(Xo);
        m = length(Uo);

        DX                  = 10e-12*ones(1,n);
        DU                  = 10e-12*ones(1,m);
        DISPLAY_PROGRESS    = 0;

    otherwise
        error('Inconsistent number of inputs')

end

%-----------------------CHECK DATA FORMAT---------------------------------
%Obtain number of states and controls
n = length(Xo);
m = length(Uo);

%Make sure that Xo and Uo are column vectors
[rows,cols] = size(Xo);
if min([rows cols]) > 1
    error('Xo must be a column vector')
else
    if cols > rows
        Xo = Xo';
    end
end

[rows,cols] = size(Uo);
if min([rows cols]) > 1
    error('XDOTo must be a column vector')
else
    if cols > rows
        Uo = Uo';
    end
end

%Check to make sure DX and DU are not too small and positive
min_dx = min(min(DX));
min_du = min(min(DU));
warning_level = 10e-13;

if min_dx < 0
    error('DX must have all positive elements');
else
    if min_dx < warning_level
        warning('WARNING:  dx may be too small.  Numerical roundoff may cause errors')
    end
end
if min_du < 0
    error('DU must have all positive elements');
else
    if min_du < warning_level
        warning('WARNING:  du may be too small.  Numerical roundoff may cause errors')
    end
end

%Check to make sure DX is a consistent size
[n_dx,m_dx] = size(DX);
if(isvector(DX))
    if((n_dx ~= 1) || (m_dx ~= n))
        error('DX should be a 1 x n vector')
    end
else
    if((n_dx ~= n) || (m_dx ~= n))
        error('DX should be a n by n matrix')
    end
end

%Check to make sure DU is a consistent size
[n_du,m_du] = size(DU);
if(isvector(DU))
    if((n_du~=1) || (m_du ~= m))
        error('DU should be a 1 x m vector')
    end
else
    if((n_du ~= n) || (m_du ~= m))
        error('DU should be a n by m matrix')
    end
end

%--------------------CALCULATE A MATRIX---------------------------------
if(DISPLAY_PROGRESS)
    disp('Now calculating A matrix')
end

%Initialize the A matrix
A = zeros(n,n);

if(isvector(DX))
    %fill in entire columns of the matrix
    for col=1:n
        %Obtain the magnitude of the pertubation to use.
        dx = DX(1,col);

        %Define pertubation vector.  The current column determines which
        %element of x we are pertubing.
        x_plus = Xo;
        x_minus = Xo;

        x_plus(col) = x_plus(col) + dx;
        x_minus(col) = x_minus(col) - dx;

        %Calculate F(x_plus,uo)
        F_plus = feval(MY_FUN,x_plus,Uo);

        %Calculate F(x_minus,uo)
        F_minus = feval(MY_FUN,x_minus,Uo);

        %Calculate A(:,col)
        A(:,col) = (F_plus - F_minus)./(2*dx);

        if(DISPLAY_PROGRESS)
            disp([num2str(100*col/n), '% complete'])
        end
    end

else
    %fill in each element of the matrix individually
    for row=1:n
        for col=1:n
            %Obtain the magnitude of the pertubation to use.
            dx = DX(row,col);

            %Define pertubation vector.  The current column determines which
            %element of x we are pertubing.
            x_plus = Xo;
            x_minus = Xo;

            x_plus(col) = x_plus(col) + dx;
            x_minus(col) = x_minus(col) - dx;

            %Calculate F(row)(x_plus,uo)
            F = feval(MY_FUN,x_plus,Uo);
            F_plus_keep = F(row);

            %Calculate F(row)(x_minus,uo)
            F = feval(MY_FUN,x_minus,Uo);
            F_minus_keep = F(row);

            %Calculate A(row,col)
            A(row,col) = (F_plus_keep - F_minus_keep)/(2*dx);
        end

        if(DISPLAY_PROGRESS)
            disp([num2str(100*row/n), '% complete'])
        end
    end

end

%--------------------CALCULATE B MATRIX---------------------------------
if(DISPLAY_PROGRESS)
    disp('Now calculating B matrix')
end

%Initialize the B matrix
B = zeros(n,m);

if(isvector(DU))
    %fill in entire columns of the matrix
    for col=1:m
        %Obtain the magnitude of the pertubation to use.
        du = DU(1,col);

        %Define pertubation vector.  The current column determines which
        %element of u we are pertubing.
        u_plus = Uo;
        u_minus = Uo;

        u_plus(col) = u_plus(col) + du;
        u_minus(col) = u_minus(col) - du;

        %Calculate F(xo,u_plus)
        F_plus = feval(MY_FUN,Xo,u_plus);

        %Calculate F(xo,u_minus)
        F_minus = feval(MY_FUN,Xo,u_minus);

        %Calculate B(:,col)
        B(:,col) = (F_plus - F_minus)./(2*du);

        if(DISPLAY_PROGRESS)
            disp([num2str(100*col/m), '% complete'])
        end
    end

else
    %fill in each element of the matrix individually
    for row=1:n
        for col=1:m
            %Obtain the magnitude of the pertubation to use.
            du = DU(row,col);

            %Define pertubation vector.  The current column determines which
            %element of u we are pertubing.
            u_plus = Uo;
            u_minus = Uo;

            u_plus(col) = u_plus(col) + du;
            u_minus(col) = u_minus(col) - du;

            %Calculate F(row)(xo,u_plus)
            F = feval(MY_FUN,Xo,u_plus);
            F_plus_keep = F(row);

            %Calculate F(row)(xo,u_minus)
            F = feval(MY_FUN,Xo,u_minus);
            F_minus_keep = F(row);

            %Calculate B(row,col)
            B(row,col) = (F_plus_keep - F_minus_keep)/(2*du);
        end

        if(DISPLAY_PROGRESS)
            disp([num2str(100*row/n), '% complete'])
        end
    end
end
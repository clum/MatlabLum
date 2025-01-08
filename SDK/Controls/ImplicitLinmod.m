function [E,A_P,B_P] = ImplicitLinmod(varargin)

%IMPLICITLINMOD Linearizes non-linear equations defined in MY_FUN
%
%   [E,A_P,B_P] = IMPLICITLINMOD(MY_FUN,XDOTo,Xo,Uo) linearized the
%   implicit set of non-linear equations defined by MY_FUN about the
%   operating point of XDOTo, Xo, and Uo.  MY_FUN should be of the form 0 =
%   F(xdot,x,u) and should have inputs and outputs as shown below
%
%       [F] = MY_FUN(xdot,x,u)
%
%   where   F is a set of n equations
%           xdot is a n x 1 vector of state derivatives
%           x is a n x 1 vector of the states
%           u is a m x 1 vector of the inputs
%
%   The E, A_P, and B_P matrices are matrices of partial derivatives
%   defined as
%
%       E(i,j) = d[F_i(xdot,x,u)]/dxdot_j (evaluated at Xdoto, Xo, and Uo)
%       A_P(i,j) = d[F_i(xdot,x,u)]/dx_j (evaluated at Xdoto, Xo, and Uo)
%       B_P(i,j) = d[F_i(xdot,x,u)]/du_j (evaluated at Xdoto, Xo, and Uo)
%
%   [...] = IMPLICITLINMOD(MY_FUN,Xdoto,Xo,Uo,DXDOT,DX,DU) does as above
%   but uses custom pertubation values for each function in each direction.
%
%   DXDOT, DX, and DU should be vectors of the following sizes
%
%       DXDOT - 1 x n matrix.  DXDOT(j) = dxdot_j used when numerically
%       calculating d[F_i(xdot,x,u)]/dxdot_j (for i = 1, 2, ..., n)
%
%       DX - 1 x n matrix.  DX(j) = dx_j used when numerically
%       calculating d[F_i(xdot,x,u)]/dx_j (for i = 1, 2, ..., n)
%
%       DU - 1 x m matrix.  DU(j) = du_j used when numerically
%       calculating d[F_i(xdot,x,u)]/du_j (for i = 1, 2, ..., n)
%
%   Alternatively, if an even finer level of control in terms of computing
%   partials is required, DXDOT, DX, and DU can be be full matrices
%   (instead of just a vector) of the following sizes
%
%       DXDOT - n x n matrix.  DXDOT(i,j) = dxdot_j used when numerically
%       calculating d[F_i(xdot,x,u)]/dxdot_j
%
%       DX - n x n matrix.  DX(i,j) = dx_j used when numerically
%       calculating d[F_i(xdot,x,u)]/dx_j
%
%       DU - n x m matrix.  DU(i,j) = du_j used when numerically
%       calculating d[F_i(xdot,x,u)]/du_j
%
%   Note that if DXDOT, DX, and DU are matrices, this will take a
%   significantly longer amount of time to compute the matrices.
%
%   If DXDOT, DX, and DU are not specified, a pertubation of 10e-12 is used
%   by default.
%
%   If DXDOT, DX, and DU are vectors of size n x 1, n x 1, and m x 1,
%   respectively, this will assume the same pertubation in each input for
%   each of the functions
%
%   The standard state space representation can then be calculated using
%
%       xdot(t) = A*x(t) + B*u(t)
%
%   where   A = -inv(E)*A_P
%           B = -inv(E)*B_P
%
%   [...] = IMPLICITLINMOD(MY_FUN,Xdoto,Xo,Uo,DXDOT,DX,DU,DISPLAY_PROGRESS)
%   does as above but displays progress if DISPLAY_PROGRESS = 1.
%
%   Examples of function usage
%
%       %Use with default pertubation distances
%       [E, Ap, Bp] = ImplicitLinmod(@RCAM_model_implicit, Xdot0, Xo, Uo);
%
%
%INPUT:     -MY_FUN:            Non-linear function
%           -XDOTo:             Linearization point for XDOT
%           -Xo:                Linearization point for X
%           -Uo:                Linearization point for U
%           -DXDOT:             Vector or matrix of pertubation values for XDOT
%           -DX:                Vector or matrix of pertubation values for X
%           -DU:                Vector or matrix of pertubation values for U
%           -DISPLAY_PROGRESS:  set to 1 to display linearization process
%
%OUTPUT:    -E:                 Matrix of F(XDOTo,Xo,Uo) - sensitivity to XDOT
%           -A_P:               Matrix of F(XDOTo,Xo,Uo) - sensitivity to X
%           -B_P:               Matrix of F(XDOTo,Xo,Uo) - sensitivity to U
%
%Also see LINMOD, DLINMOD, LINMODV5, LINMOD2, TRIM, EXPLICITLINMOD (custom
%function)
%
%Christopher Lum
%lum@uw.edu

%Version History
%11/09/04: Created
%11/12/04: Added warning if DXDOT, DX, or DU is too small.
%11/15/04: Fixed bug if user doesn't specify DXDOT, DX, or DU (added line
%          77 and 78).
%12/15/04: Added more input data format checking.
%04/06/12: Updated documentation.  Compute entire column at once.
%02/27/19: Updated documentation.
%05/16/20: Updated documentation.
%01/07/25: Updated documentation.

%---------------------OBTAIN USER PREFERENCES-----------------------------
switch nargin
    case 8
        %user specifies all inputs
        MY_FUN              = varargin{1};
        XDOTo               = varargin{2};
        Xo                  = varargin{3};
        Uo                  = varargin{4};
        DXDOT               = varargin{5};
        DX                  = varargin{6};
        DU                  = varargin{7};
        DISPLAY_PROGRESS    = varargin{8};

    case 7
        %assume no progress
        MY_FUN              = varargin{1};
        XDOTo               = varargin{2};
        Xo                  = varargin{3};
        Uo                  = varargin{4};
        DXDOT               = varargin{5};
        DX                  = varargin{6};
        DU                  = varargin{7};
        DISPLAY_PROGRESS    = 0;

    case 4
        %Assume that pertubations are the same for all and everything above
        MY_FUN              = varargin{1};
        XDOTo               = varargin{2};
        Xo                  = varargin{3};
        Uo                  = varargin{4};

        n = length(XDOTo);
        m = length(Uo);

        DXDOT               = 10e-12*ones(1,n);
        DX                  = 10e-12*ones(1,n);
        DU                  = 10e-12*ones(1,m);
        DISPLAY_PROGRESS    = 0;

    otherwise
        error('Inconsistent number of inputs')

end

%-----------------------CHECK DATA FORMAT---------------------------------
%Obtain number of states and controls
n = length(XDOTo);
m = length(Uo);

%Make sure that XDOTo, Xo, and Uo are all column vectors
[rows,cols] = size(XDOTo);
if min([rows cols]) > 1
    error('XDOTo must be a column vector')
else
    %If it is a vector, make sure it is a column vector
    if cols > rows
        %Transpose this to make it a column vector
        XDOTo = XDOTo';
    end
end

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

%Make sure that XDOTo and Xo are same length
if length(XDOTo)~=length(Xo)
    error('XDOTo and Xo must be the same length')
end

%Check to make sure DXDOT, DX, and DU are not too small and positive
min_dxdot = min(min(DXDOT));
min_dx = min(min(DX));
min_du = min(min(DU));
warning_level = 10e-13;

if min_dxdot < 0
    error('DXDOT must have all positive elements');
else
    if min_dxdot < warning_level
        warning('WARNING:  dxdot may be too small.  Numerical roundoff may cause errors')
    end
end

if min_dx < 0
    error('DX must have all positive elements');
else
    if min_dx< warning_level
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

%Check to make sure DXDOT is a consistent size
[n_dxdot,m_dxdot] = size(DXDOT);
if(isvector(DXDOT))
    if((n_dxdot~=1) || (m_dxdot ~= n))
        error('DXDOT should be a 1 x n vector')
    end
else
    if((n_dxdot ~= n) || (m_dxdot ~= n))
        error('DXDOT should be a n by n matrix')
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

%---------------------CALCULATE E MATRIX--------------------------------
if(DISPLAY_PROGRESS)
    disp('Now calculating E matrix')
end

%Initialize the E matrix
E = zeros(n,n);

if(isvector(DXDOT))
    %fill in entire columns of the matrix
    for col=1:n
        %Obtain the magnitude of the pertubation to use.
        dxdot = DXDOT(1,col);

        %Define pertubation vector.  The current column determines which
        %element of xdot we are pertubing.
        xdot_plus = XDOTo;
        xdot_minus = XDOTo;

        xdot_plus(col) = xdot_plus(col) + dxdot;
        xdot_minus(col) = xdot_minus(col) - dxdot;

        %Calculate F(xdot_plus,xo,uo)
        F_plus = feval(MY_FUN,xdot_plus,Xo,Uo);

        %Calculate F(xdot_minus,xo,uo)
        F_minus = feval(MY_FUN,xdot_minus,Xo,Uo);

        %Calculate E(:,col)
        E(:,col) = (F_plus - F_minus)./(2*dxdot);

        if(DISPLAY_PROGRESS)
            disp([num2str(100*col/n), '% complete'])
        end
    end

else
    %fill in each element of the matrix individually
    for row=1:n
        for col=1:n
            %Obtain the magnitude of the pertubation to use.
            dxdot = DXDOT(row,col);

            %Define pertubation vector.  The current column determines which
            %element of xdot we are pertubing.
            xdot_plus = XDOTo;
            xdot_minus = XDOTo;

            xdot_plus(col) = xdot_plus(col) + dxdot;
            xdot_minus(col) = xdot_minus(col) - dxdot;

            %Calculate F(row)(xdot_plus,xo,uo)
            F = feval(MY_FUN,xdot_plus,Xo,Uo);
            F_plus_keep = F(row);

            %Calculate F(row)(xdot_minus,xo,uo)
            F = feval(MY_FUN,xdot_minus,Xo,Uo);
            F_minus_keep = F(row);

            %Calculate E(row,col)
            E(row,col) = (F_plus_keep - F_minus_keep)/(2*dxdot);
        end

        if(DISPLAY_PROGRESS)
            disp([num2str(100*row/n), '% complete'])
        end
    end
end

%--------------------CALCULATE A_P MATRIX-------------------------------
if(DISPLAY_PROGRESS)
    disp('Now calculating A_P matrix')
end

%Initialize the A_P matrix
A_P = zeros(n,n);

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

        %Calculate F(xdotx,x_plus,uo)
        F_plus = feval(MY_FUN,XDOTo,x_plus,Uo);

        %Calculate F(xdoto,x_minus,uo)
        F_minus = feval(MY_FUN,XDOTo,x_minus,Uo);

        %Calculate Aprime(:,col)
        A_P(:,col) = (F_plus - F_minus)./(2*dx);

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

            %Calculate F(row)(xdoto,x_plus,uo)
            F = feval(MY_FUN,XDOTo,x_plus,Uo);
            F_plus_keep = F(row);

            %Calculate F(row)(xdoto,x_minus,uo)
            F = feval(MY_FUN,XDOTo,x_minus,Uo);
            F_minus_keep = F(row);

            %Calculate Aprime(row,col)
            A_P(row,col) = (F_plus_keep - F_minus_keep)/(2*dx);
        end

        if(DISPLAY_PROGRESS)
            disp([num2str(100*row/n), '% complete'])
        end
    end
end

%--------------------CALCULATE B_P MATRIX-------------------------------
if(DISPLAY_PROGRESS)
    disp('Now calculating B_P matrix')
end

%Initialize the B_P matrix
B_P = zeros(n,m);

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

        %Calculate F(xdoto,xo,u_plus)
        F_plus = feval(MY_FUN,XDOTo,Xo,u_plus);

        %Calculate F(xdoto,xo,u_minus)
        F_minus = feval(MY_FUN,XDOTo,Xo,u_minus);

        %Calculate Bprime(:,col)
        B_P(:,col) = (F_plus - F_minus)./(2*du);

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

            %Calculate F(row)(xdoto,xo,u_plus)
            F = feval(MY_FUN,XDOTo,Xo,u_plus);
            F_plus_keep = F(row);

            %Calculate F(row)(xdoto,xo,u_minus)
            F = feval(MY_FUN,XDOTo,Xo,u_minus);
            F_minus_keep = F(row);

            %Calculate Bprime(row,col)
            B_P(row,col) = (F_plus_keep - F_minus_keep)/(2*du);
        end

        if(DISPLAY_PROGRESS)
            disp([num2str(100*row/n), '% complete'])
        end
    end
end
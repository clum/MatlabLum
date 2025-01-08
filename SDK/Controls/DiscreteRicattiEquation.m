function [S,K] = DiscreteRicattiEquation(A,B,Q,R,H,N)

%DISCRETERICATTIEQUATION solves the discrete Ricatti Equation
%
%   DISCRETERICATTIEQUATION(A,B,Q,R,H,N) solves the discrete Ricatti
%   equation given by
%
%      S(k) = A'*M(K+1)*A + Q
%
%   where M(k+1) = S(k+1)-S(k+1)*B*inv(R+B'*S(k+1)*B)*B'*S(k+1)
%
%   This is solved backwards in time given the terminal boundary condition
%   S(N) = H.
%
%   [S,K] = DISCRETERICATTIEQUATION(...) solves the discrete Ricatti
%   Equation above and returns the matrices S(1), S(2), ... , S(N) and also
%   the time varying full state gain matrix K(1), K(2), ... , K(N-1) using
%
%       K(k) = inv(R+B'*S(k+1)*B)*B'*S(k+1)*A
%
%
%INPUT:     -A: A matrix
%           -B: B matrix
%           -Q: Q matrix (weights on states)
%           -R: R matrix (weights on controls)
%           -H: Terminal boundary condition S(N) = H
%           -N: number of steps to solve
%
%OUTPUT:    -S:  3 dimensional matrix of S(1), S(2), ... , S(N)
%
%See also LQR
%
%Christopher Lum
%lum@uw.edu

%Version History
%05/08/04: Created.  Equations from Franklin, Workman, Powell, pg.367.

%------------------CHECKING DATA FORMAT----------------------------
%Q must be positive semi-definite
if max(eig(Q))<0
    error('Q must be positive semi-definite')
end

%R must be positive definite
if max(eig(R))<=0
    error('R must be positive definite')
end

%Obtain matrix sizes
[A_rows,A_cols] = size(A);
[B_rows,B_cols] = size(B);
[Q_rows,Q_cols] = size(Q);
[R_rows,R_cols] = size(R);
[H_rows,H_cols] = size(H);

%A, Q, H, and R matrices must be square
if (A_rows~=A_cols) | (Q_rows~=Q_cols) | (H_rows~=H_cols) | (R_rows~=R_cols)
    error('A, B, H, and R must be square matrices')
end

%A, Q, and H matrices must be same
if (A_rows~=Q_rows) | (Q_rows~=H_rows) | (H_rows~=A_rows)
    error('A, B, and H must be same size')
end

%R must be compatible with size of B matrix
if (B_cols~=R_rows)
    error('B and R matrices are not compatible')
end

%-----------------------BEGIN CALCULATIONS---------------------------
%Enforce boundary condition
S(:,:,N) = H;

%Solve discrete Ricatti Equation backwards
for k=N-1:-1:1
    %Current M(k+1)
    M_k_plus_1 = S(:,:,k+1) - S(:,:,k+1)*B*inv(R + B'*S(:,:,k+1)*B)*B'*S(:,:,k+1);

    %Solve for S(k)
    S(:,:,k) = A'*M_k_plus_1*A + Q;
end

%Now solve for the gain matrix
for k=1:N-1
    K(:,:,k) = inv(R+B'*S(:,:,k+1)*B)*B'*S(:,:,k+1)*A;
end
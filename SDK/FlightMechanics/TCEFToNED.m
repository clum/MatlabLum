function X_NED = TCEFToNED(X_TCEF,phi,lambda)

%TCEFTONED  Transforms a Target-Centered-Earth-Fixed vector to a
%           North-East-Down vector
%
%   [X_NED] = TCEFToNED(X_TCEF,phi,lambda) Converts the vector in the
%   Target-Centered-Earth-Fixed (TCEF) frame to the North-East-Down (NED)
%   frame.
%
%
%INPUT:     -X_TCEF:    3x1 vector of [x_TCEF;y_TCEF;z_TCEF].  If
%                       X_TCEF is a matrix, then each TCEF vector should
%                       be a column vector (ie v1=X_TCEF(:,1),
%                       v2=X_TCEF(:,2), etc.)
%           -phi:       terrestrial latitude (radians)  If this is not a
%                       scalar, it must have the same length as X_TCEF.
%           -lambda:    terrestrial longitude (radians)  If this is not a
%                       scalar, it must have the same length as X_TCEF.
%
%OUTPUT:    -X_NED:     3x1 vector of [P_N;P_E;P_D] this is expressed in
%                       the NED frame.  If X_TCEF was a matrix, then X_NED
%                       is a matrix of the same size.
%
%For more information, see Stevens, B.L., and Lewis, F.L. "Aircraft Control
%and Simulation. 2nd Edition".  pg.37
%
%Created by Christopher Lum
%lum@uw.edu

%Version History
%11/28/05: Created
%06/09/19: Updated documentation

%-----------------------CHECKING DATA FORMAT-------------------------------
%Make sure that X_TCEF is a 3x1 vector
[n,m] = size(X_TCEF);
if (n~=3)
    error('X_TCEF must have only 3 rows')
end

[n_phi,m_phi] = size(phi);
if (n_phi>1)
    error('phi must be a row vector')
end

if (m_phi>1) && (m_phi~=m)
    error('If phi is not a scalar, it must have same number of columns as X_TCEF')
end

[n_lambda,m_lambda] = size(lambda);
if (n_lambda>1)
    error('lambda must be a row vector')
end

if (m_lambda>1) && (m_lambda~=m)
    error('If phi is not a scalar, it must have same number of columns as X_TCEF')
end

%----------------------OBTAIN USER PREFERENCES-----------------------------
switch nargin        
    case 3
        %User supplies all inputs
        
    otherwise
        error('Inconsistent number of inputs')
end

%-------------------------BEGIN CALCULATIONS-------------------------------
%Does user want to use a single static value of phi and lambda?
if (m_phi==1)
    %User wants to use a single value of phi and lambda
    C1 = [cos(phi)  0 sin(phi);
          0         1 0;
          -sin(phi) 0 cos(phi)];
      
    C2 = [ 0 0 1;
           0 1 0;
          -1 0 0];
      
    C3 = [cos(lambda)  sin(lambda) 0;
          -sin(lambda) cos(lambda) 0;
          0            0           1];
      
    C_NED_TCEF = C1*C2*C3;
    
    X_NED = C_NED_TCEF*X_TCEF;
    
else
    %User want to change phi and lambda every time
    for counter=1:m
        %What is the curret phi, lambda, and x_TCEF
        phi_curr = phi(1,counter);
        lambda_curr = lambda(1,counter);
        x_TCEF_curr = X_TCEF(:,counter);
        
        C1 = [cos(phi_curr)  0 sin(phi_curr);
              0              1 0;
              -sin(phi_curr) 0 cos(phi_curr)];
      
        C2 = [ 0 0 1;
               0 1 0;
              -1 0 0];
      
        C3 = [cos(lambda_curr)  sin(lambda_curr) 0;
              -sin(lambda_curr) cos(lambda_curr) 0;
              0                 0                1];
      
        C_NED_TCEF_curr = C1*C2*C3;
        
        X_NED(:,couter) = C_NED_TCEF_curr*x_TCEF_curr;
    end
end

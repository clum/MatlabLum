classdef Quaternion
    %A class for providing operations with quaternions.  Note that Matlab
    %provides much of this functionality natively (for example
    %'quat2angle')  so this class is mainly for understanding and verify
    %their operation.
    %
    %Christopher Lum
    %lum@uw.edu
    
    %Version History:   03/31/17: Created

    %----------------------------------------------------------------------
    %Static methods
    %----------------------------------------------------------------------
    methods(Static)
        function [C_b_NED] = QuaternionToDCM(varargin)
            %QuaternionToDCM Converts a quaternion to a DCM
            %
            %   [C_b_NED] = Quaternion.QuaternionToDCM(q) converts the
            %   quaternion, q, to the equivalent direction cosine matrix,
            %   C_b_NED.
            %
            %   
            %
            %INPUT:     q:       4x1 quarterion
            %
            %OUTPUT:    C_b_NED: 3x3 direction cosine matrix to go from
            %                    NED frame to body frame through the ZYX
            %                    sequence
            
            %Version History
            %03/31/17: Created
            %04/01/17: Fixed bugs
            
            %------------------OBTAIN USER PREFERENCES---------------------
            switch nargin
                case 1
                    %User supplies all inputs
                    q = varargin{1};
                    
                otherwise
                    error('Invalid number of inputs');
            end
            
            
            %------------------CHECKING DATA FORMAT------------------------
            assert((length(q)==4) && (isvector(q)), 'q should be a 4 element vector')
            
            
            %--------------------BEGIN CALCULATIONS------------------------
            qs = q(1);
            qx = q(2);
            qy = q(3);
            qz = q(4);
            
            C_11 = qs^2 + qx^2 - qy^2 - qz^2;
            C_12 = 2*(qx*qy + qz*qs);
            C_13 = 2*(qx*qz - qy*qs);
            
            C_21 = 2*(qx*qy - qz*qs);
            C_22 = qs^2 - qx^2 + qy^2 - qz^2;
            C_23 = 2*(qy*qz + qx*qs);
            
            C_31 = 2*(qx*qz + qy*qs);
            C_32 = 2*(qy*qz - qx*qs);
            C_33 = qs^2 - qx^2 - qy^2 + qz^2;
            
            C_b_NED = [C_11 C_12 C_13;
                C_21 C_22 C_23;
                C_31 C_32 C_33];
        end
        
        function [psi, theta, phi] = DCMToAngle(varargin)
            %DCMToAngle Converts a DCM to Euler angles.  
            %
            %   [psi, theta, phi] = Quaternion.DCMToAngle(C_b_NED) converts
            %   the direction cosine matrix, C_b_NED, to the euler angles
            %   psi, theta, phi. C_b_NED should be the rotation matrix in
            %   the order 'ZYX'.
            %
            %   Note that this Matlab provides 'dcm2angle' to perform this
            %   operation.  This funtion is merely used to undestand the
            %   underlying algorithm of converting a DCM to Euler angles.
            %
            %See also dcm2angle
            %
            %INPUT:     C_b_NED: 3x3 direction cosine matrix to go from
            %                    NED frame to body frame through the ZYX
            %                    sequence
            %
            %OUTPUT:    psi:    rotation about z (rotation 1)
            %           theta:  rotation about y (rotation 2)
            %           phi:    rotation about x (rotation 3)
            
            %Version History
            %04/01/17: Created
            
            %------------------OBTAIN USER PREFERENCES---------------------
            switch nargin
                case 1
                    %User supplies all inputs
                    C_b_NED = varargin{1};
                    
                otherwise
                    error('Invalid number of inputs');
            end
            
            
            %------------------CHECKING DATA FORMAT------------------------
            % C
            %AFSLRefactor: Could add checks that C is a unitary 3x3 matrix
            
            %--------------------BEGIN CALCULATIONS------------------------
            C_13 = C_b_NED(1,3);
            C_23 = C_b_NED(2,3);
            C_33 = C_b_NED(3,3);
            C_12 = C_b_NED(1,2);
            C_11 = C_b_NED(1,1);
            
            phi     = atan2(C_23, C_33);
            theta   = -asin(C_13);
            psi     = atan2(C_12, C_11);
        end        
        
        function [psi, theta, phi] = QuaternionToAngle(varargin)
            %QuaternionToAngle Converts a quaternion to a Euler angles
            %
            %   [psi, theta, phi] = Quaternion.QuaternionToAngle(q)
            %   converts the quaternion, q, to the equivalent Euler angles,
            %   psi, theta, phi.
            %
            %   Note that this Matlab provides 'quat2angle' to perform this
            %   operation.  This funtion is merely used to undestand the
            %   underlying algorithm of converting a quaternion to Euler
            %   angles.
            %
            %See also quat2angle
            %
            %INPUT:     q:       4x1 quarterion
            %
            %OUTPUT:    psi:    rotation about z (rotation 1)
            %           theta:  rotation about y (rotation 2)
            %           phi:    rotation about x (rotation 3)
            
            %Version History
            %04/01/17: Created
            
            %------------------OBTAIN USER PREFERENCES---------------------
            switch nargin
                case 1
                    %User supplies all inputs
                    q = varargin{1};
                    
                otherwise
                    error('Invalid number of inputs');
            end
            
            
            %------------------CHECKING DATA FORMAT------------------------
            % q
            %Checked by Quaternion.QuaternionToDCM
            
            %--------------------BEGIN CALCULATIONS------------------------
            [C_b_NED] = Quaternion.QuaternionToDCM(q);
            [psi, theta, phi] = Quaternion.DCMToAngle(C_b_NED);
        end
        
        function [q] = DCMToQuaternion(varargin)
            %DCMQuaternion Converts a DCM to a quaternion
            %
            %   [q] = Quaternion.DCMQuaternion(C) converts the direction
            %   cosine matrix (DCM) to the equivalent quaternion.
            %
            %   Note that this Matlab provides 'dcm2quat' to perform this
            %   operation.  This funtion is merely used to undestand the
            %   underlying algorithm of converting a quaternion to Euler
            %   angles.
            %
            %See also dcm2quat
            %
            %INPUT:     C:  3x3 DCM
            %
            %OUTPUT:    q:  4x1 quarterion
            
            %Version History
            %04/02/17: Created
            %04/05/20: Updated to refelect lecture notes
            
            %------------------OBTAIN USER PREFERENCES---------------------
            switch nargin
                case 1
                    %User supplies all inputs
                    C = varargin{1};
                    
                otherwise
                    error('Invalid number of inputs');
            end
            
            
            %------------------CHECKING DATA FORMAT------------------------
            % C
            [M,N] = size(C);
            assert(M==3 && N==3, 'C should be a 3x3 matrix')
            
            
            %--------------------BEGIN CALCULATIONS------------------------
            C11 = C(1,1);
            C12 = C(1,2);
            C13 = C(1,3);
            
            C21 = C(2,1);
            C22 = C(2,2);
            C23 = C(2,3);
            
            C31 = C(3,1);
            C32 = C(3,2);
            C33 = C(3,3);
            
            qsTilde = sqrt((1+C11+C22+C33)/4);
            qxTilde = sqrt((1+C11-C22-C33)/4);
            qyTilde = sqrt((1-C11+C22-C33)/4);
            qzTilde = sqrt((1-C11-C22+C33)/4);
            
            qTilde = [qsTilde;qxTilde;qyTilde;qzTilde];
            
            maxIndices = find(qTilde==max(qTilde));
            maxIndex = maxIndices(1);       %in case there are 2 maximums
            
            switch maxIndex
                case 1
                    %qs is max
                    qs = qsTilde;
                    qx = (C23 - C32)/(4*qsTilde);
                    qy = (C31 - C13)/(4*qsTilde);
                    qz = (C12 - C21)/(4*qsTilde);
                    
                case 2
                    %qx is max
                    qs = (C23 - C32)/(4*qxTilde);
                    qx = qxTilde;
                    qy = (C12 - C21)/(4*qxTilde);
                    qz = (C31 - C13)/(4*qxTilde);
                    
                case 3
                    %qy is max
                    qs = (C31 - C13)/(4*qyTilde);
                    qx = (C12 + C21)/(4*qyTilde);
                    qy = qyTilde;
                    qz = (C23 + C32)/(4*qyTilde);
                    
                case 4
                    %qz is max
                    qs = (C12 - C21)/(4*qzTilde);
                    qx = (C31 + C13)/(4*qzTilde);
                    qy = (C23 + C32)/(4*qzTilde);
                    qz = qzTilde;
                    
                otherwise
                    error('Something went wrong')
            end
            
            q = [qs;qx;qy;qz];
        end
        
        function [q] = AngleToQuaternion(varargin)
            %AngleToQuaternion Converts a Euler angle to a quaternion
            %
            %   [q] = Quaternion.AngleToQuaternion(psi, theta, phi)
            %   converts the Euler angles, psi, theta, and phi (from the
            %   ZYX) rotation to the quaternion.
            %
            %   Note that this Matlab provides 'angle2quat' to perform this
            %   operation.  This funtion is merely used to undestand the
            %   underlying algorithm of converting a quaternion to Euler
            %   angles.
            %
            %See also angle2quat
            %
            %INPUT:     psi:    rotation about z (rotation 1)
            %           theta:  rotation about y (rotation 2)
            %           phi:    rotation about x (rotation 3)
            %
            %OUTPUT:     q:       4x1 quarterion
            
            %Version History
            %04/02/17: Created
            
            %------------------OBTAIN USER PREFERENCES---------------------
            switch nargin
                case 3
                    %User supplies all inputs
                    psi     = varargin{1};
                    theta   = varargin{2};
                    phi     = varargin{3};
                    
                otherwise
                    error('Invalid number of inputs');
            end
            
            
            %------------------CHECKING DATA FORMAT------------------------
            % psi
            
            % theta
            
            % phi
            
            %--------------------BEGIN CALCULATIONS------------------------
            C = RotationMatrices.C_b_NED(UWAngle.FromRadians(phi), ...
                UWAngle.FromRadians(theta),...
                UWAngle.FromRadians(psi));
            
            %Convert direction cosine matrix to quaternion
            q = Quaternion.DCMToQuaternion(C);
        end
    end
    
end


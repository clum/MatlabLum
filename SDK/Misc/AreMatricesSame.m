function [YES_OR_NO] = AreMatricesSame(varargin)

%AREMATRICESSAME Tests to see if two matrices or cell arrays are the same
%
%   [YES_OR_NO] = AREMATRICESSAME(A, B) Tests to see if A and B have the
%   same elements or not.
%
%   [YES_OR_NO] = AREMATRICESSAME(A, B, TOLERANCE) Tests as above but
%   checks if the matrix elements are the same to a specified TOLERANCE.
%
%
%INPUT:     -A:         first matrix
%           -B:         second matrix
%           -TOLERANCE: tolerance to be considered the same.
%
%OUTPUT:    -YES_OR_NO: true if the matrices are the same to the specified
%                       tolerance, false otherwise
%
%Christopher Lum
%lum@uw.edu

%Version History
%05/22/07: Created
%03/06/08: Added support for cell arrays
%11/20/08: Fixed bug for cell arrays
%04/26/16: Changed output to be a logical
%09/03/17: Updated documentation
%11/23/23: Updated documentation

%----------------------OBTAIN USER PREFERENCES-----------------------------
switch nargin
    case 3
        %User supplies all inputs
        A           = varargin{1};
        B           = varargin{2};
        TOLERANCE   = varargin{3};
        
    case 2
        %Assume tolerance of zero
        A           = varargin{1};
        B           = varargin{2};
        TOLERANCE   = 0;
        
    otherwise
        error('Invalid number of inputs');
end

%-----------------------CHECKING DATA FORMAT-------------------------------
[m_A,n_A] = size(A);
[m_B,n_B] = size(B);
[m_TOLERANCE,n_TOLERANCE] = size(TOLERANCE);

if (TOLERANCE < 0)
    error('TOLERANCE must be non-negative')
end

%-------------------------BEGIN CALCULATIONS-------------------------------
%Assume matrices are same before running checks
YES_OR_NO = true;

%Check if one is a cell matrix and another is a standard matrix
if ((iscell(A)) && (~iscell(A)))
    YES_OR_NO = false;
    return
end

if ((~iscell(A)) && (iscell(A)))
    YES_OR_NO = false;
    return
end

%Check if one is empty and the other is not
if ((isempty(A)) && (~isempty(B)))
    YES_OR_NO = false;
    return
end

if ((~isempty(A)) && (isempty(B)))
    YES_OR_NO = false;
    return
end

%If both are empty, return
if (isempty(A))&&(isempty(B))
    return
else
    %Check if the dimensions are the same size
    if ((m_A ~= m_B) || (n_A ~= n_B))
        YES_OR_NO = false;
        return
    end
    
    %Check elements
    if (iscell(A))
        %Cell array, check each element individually
        for m=1:m_A
            for n=1:n_A
                %Get the current elements
                A_mn = A{m,n};
                B_mn = B{m,n};
                
                %Make sure elements are of the same class
                if (~strcmp(class(A_mn), class(B_mn)))
                    YES_OR_NO = false;
                    return
                else
                    %Same class of objects, make sure they are the same
                    switch class(A_mn)
                        case 'char'
                            if (~strcmp(A_mn, B_mn))
                                YES_OR_NO = false;
                                return
                            end
                            
                        case 'double'
                            if (max(max(abs(A_mn - B_mn))) > TOLERANCE)
                                YES_OR_NO = false;
                                return
                            end
                            
                        otherwise
                            %this class not supported yet
                            error(['This class of ''',class(A_mn),''' is not yet supported for comparing sameness between elements'])
                    end     %end switch class(A_mn)
                end
            end     %end for n=1:n_A
        end     %end for m=1:m_A
    else
        %Just a matrix of doubles
        if (max(max(abs(A - B))) > TOLERANCE)
            YES_OR_NO = false;
            return
        end
    end
end

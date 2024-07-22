classdef ParticleAgent
    %PARTICLEAGENT Representation of an agent as a point
    %   Detailed representation of an agent as a point (aka particle).
    %
    %Christopher Lum
    %lum@uw.edu
    
    %Version History
    %MM/DD/YY: Created
    
    %----------------------------------------------------------------------
    %Public properties/fields
    %----------------------------------------------------------------------
    properties (GetAccess='public', SetAccess='public')
        mMass;
        mDamping;
    end   
    
    %----------------------------------------------------------------------
    %Private properties/fields
    %----------------------------------------------------------------------
    properties (GetAccess='private', SetAccess='private')
        mTimeHistory;       %Time history
        mStateHistory;      %State history
    end
    
    %----------------------------------------------------------------------
    %Public Dependent properties/fields
    %----------------------------------------------------------------------
    properties (Dependent)
        %x coordinates
        X;
        
        %y coordinates
        Y;
        
        %z coordinates
        Y;
    end
    
    %----------------------------------------------------------------------
    %Private Dependent properties/fields
    %----------------------------------------------------------------------
    properties (Dependent, GetAccess='private', SetAccess='private')
        %x coordinates
        x;
        
        %y coordinates
        y;
        
        %z coordinates
        z;
    end
    
    %----------------------------------------------------------------------
    %Static properties/fields
    %----------------------------------------------------------------------
    properties (Constant)
        numStates   = 4;
        numControls = 2;
        
        xPositionStateIndex = 1;        %index of state vector corresponding to x position
        yPositionStateIndex = 3;        %index of state vector corresponding to y position        
    end

    %----------------------------------------------------------------------
    %Public methods
    %----------------------------------------------------------------------
    methods
        %Constructors
        function obj = ParticleAgent(varargin)
            %PARTICLEAGENT  Constructor for the object
            %
            %   [OBJ] = PARTICLEAGENT(MASS, DAMPING) creates an object
            %   with the specified mass and damping
            %
            %INPUT:     -MASS:      mass of the object
            %           -DAMPING:   damping coefficient of the object
            %
            %OUTPUT:    -OBJ:       ParticleAgent object
            %
            %Created by Christopher Lum
            %lum@uw.edu
            
            %Version History
            %10/12/11: Created
            
            %------------------OBTAIN USER PREFERENCES---------------------
            switch nargin
                case 3
                    %User supplies all inputs
                    mMass       = varargin{1};
                    mDamping    = varargin{2};
                    x0          = varargin{3};
                    
                case 2
                    %Assume standard inputs                    
                    mMass       = varargin{1};
                    mDamping    = varargin{2};
                    
                    x0          = zeros(obj.numStates,1);
                    
                otherwise
                    error('Invalid number of inputs for constructor');
            end

            %------------------CHECKING DATA FORMAT------------------------
            assert(mMass > 0, 'Mass should be positive')
            assert(mDamping > 0, 'Damping should be positive')
            
            %--------------------BEGIN CALCULATIONS------------------------
            obj.mMass           = mMass;
            obj.mDamping        = mDamping;
            obj.mTimeHistory    = [0];
            obj.mStateHistory   = [x0];            
        end
        
        %Destructor
        function delete(obj)
        end
        
        %Get/Set
        function obj = set.mMass(obj, mass)
            assert(mass > 0);
            obj.mMass = mass;
        end
     
        function obj = set.mDamping(obj, damping)
            assert(damping > 0);
            obj.mDamping = damping;
        end
        
        function value = get.X(obj)
            %Example of getting a dependent property
            temp = 2*length(obj.mTimeHistory);  %Do some computation
            value = temp;
        end
                
        %Class API
        function [] = display(obj)
            %DISPLAY  Define how object is displayed in the command window
            %
            %   DISPLAY() defines how the object is displayed in the
            %   command window.
            %
            %INPUT:     -None
            %
            %Created by Christopher Lum
            %lum@uw.edu
            
            %Version History
            %MM/DD/YY: Created
            disp(['mMass: ',obj.mTimeHistory])
        end
        
        function [varargout] = PropogateState(varargin)
            %PROPOGATESTATE  Propogate the state
            %
            %   [OBJ2] = PROPOGATESTATE(U, DELTA_T) propogates the state
            %   using the control input U and the time step DELTA_T
            %
            %INPUT:     -U:         control input
            %           -DELTA_T:   time step
            %
            %OUTPUT:    -None
            %
            %Created by Christopher Lum
            %lum@uw.edu
            
            %Version History
            %MM/DD/YY: Created
            
            %------------------OBTAIN USER PREFERENCES---------------------
            switch nargin
                case 3
                    %User supplies all inputs
                    obj     = varargin{1};
                    U       = varargin{2};
                    deltaT  = varargin{3};
                    
                otherwise
                    error('Invalid number of inputs');
            end
            
            
            %------------------CHECKING DATA FORMAT------------------------
            % U
                
            % deltaT
            if(~isscalar(deltaT))
                error('deltaT should be a scalar')
            end
            
            
            %--------------------BEGIN CALCULATIONS------------------------
            %Obtain the model of the system
            [A, B, C, D] = obj.calculateContinuousLinearMatrices();
            sysc = ss(A, B, C, D);
            sysd = c2d(sysc, deltaT);
            
            %Propogate the state forward in time
            xk = obj.returnCurrentState();            
            xk_plus_1 = sysd.a*xk + sysd.b*U;
            
            %Append to the state and time history
            obj.mStateHistory   = [obj.mStateHistory xk_plus_1];
            obj.mTimeHistory    = [obj.mTimeHistory obj.mTimeHistory(end)+deltaT];
            
            varargout{1} = obj;
        end
    end
    
    %----------------------------------------------------------------------
    %Private methods
    %----------------------------------------------------------------------
    methods (Access='private')
        function [varargout] = calculateContinuousLinearMatrices(varargin)
            %CALCULATECONTINUOUSLINEARMATRICES Calculates A, B, C, D matrices
            %
            %   [A,B,C,D] = CALCULATECONTINUOUSLINEARMATRICES() Calculates
            %   the continuous time A, B, C, and D matrices for the model.
            %
            %INPUT:     -none
            %
            %OUTPUT:    -A: A matrix
            %           -B: B matrix
            %           -C: C matrix
            %           -D: D matrix
            %
            %Created by Christopher Lum
            %lum@uw.edu
            
            %Version History
            %MM/DD/YY: Created
            
            %------------------OBTAIN USER PREFERENCES---------------------
            switch nargin
                case 1
                    %User supplies all inputs
                    obj = varargin{1};
                    
                otherwise
                    error('Invalid number of inputs');
            end
            
            
            %-------------------CHECKING DATA FORMAT-----------------------
            
            
            %---------------------BEGIN CALCULATIONS-----------------------
            m = obj.mMass;
            c = obj.mDamping;
            
            A = [0 1 0 0;
                0 -c/m 0 0;
                0 0 0 1;
                0 0 0 -c/m];
            
            B = [0 0;
                1/m 0;
                0 0;
                0 1/m];
            
            C = eye(4);
            
            D = zeros(4,2);

            %Package outputs
            varargout{1} = A;
            varargout{2} = B;
            varargout{3} = C;
            varargout{4} = D;            
        end
    end
    
    %----------------------------------------------------------------------
    %Static methods
    %----------------------------------------------------------------------
    methods(Static)
        function [varargout] = ReadInFromFile(varargin)
            %READINFROMFILE  Populate data members from a file
            %
            %   [OBJ2] = READINFROMFILE(FILE) creates an object from
            %   the specified FILE.
            %
            %INPUT:     -FILE:  directory and file name of data file
            %
            %OUTPUT:    -OBJ2:  object with data filled in from file
            %
            %Created by Christopher Lum
            %lum@uw.edu
            
            %Version History
            %MM/DD/YY: Created
            
            %------------------OBTAIN USER PREFERENCES---------------------
            switch nargin
                case 1
                    %User supplies all inputs
                    directoryFileString = varargin{1};
                    
                otherwise
                    error('Invalid number of inputs');
            end
                        
            %------------------CHECKING DATA FORMAT------------------------
            
            
            %--------------------BEGIN CALCULATIONS------------------------
            %Obtain the raw data from the file
            foo = 1;
        end
    end
    
    %----------------------------------------------------------------------
    %Private Static methods
    %----------------------------------------------------------------------
    methods(Static, Access='private')
        function [varargout] = myPrivateStaticFcn(varargin)
            %MYPRIVATESTATICFCN This could be a helper for this class
            %
            %   [Y] = MYPRIVATESTATICFCN(X) operate on x to create y.  This
            %   can only be called from within the class.
            %
            %INPUT:     -X:  input data
            %
            %OUTPUT:    -Y: output data
            %
            %Created by Christopher Lum
            %lum@uw.edu
            
            %Version History
            %MM/DD/YY: Created
            
            %------------------OBTAIN USER PREFERENCES---------------------
            switch nargin
                case 1
                    %User supplies all inputs
                    X = varargin{1};
                    
                otherwise
                    error('Invalid number of inputs');
            end
                        
            %------------------CHECKING DATA FORMAT------------------------
            
            
            %--------------------BEGIN CALCULATIONS------------------------
            %perform some operation
            varargout{1} = 2*X;
        end
    end
end


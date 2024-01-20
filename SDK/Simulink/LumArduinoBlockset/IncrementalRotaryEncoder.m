classdef IncrementalRotaryEncoder
    %INCREMENTALROTARYENCODER Represents an incremental rotary  encoder
    %
    %Christopher Lum
    %lum@uw.edu
    
    %Version History
    %11/28/16: Created
    %01/20/24: Updated documentation
     
    %----------------------------------------------------------------------
    %Public properties/fields
    %----------------------------------------------------------------------
    properties (GetAccess='public', SetAccess='public')
        %number of slits per revolution
        NumSlitsPerRevolution;
    end
    
    %----------------------------------------------------------------------
    %Read only properties/fields
    %----------------------------------------------------------------------
    properties (GetAccess='public', SetAccess='private')
    end
    
    %----------------------------------------------------------------------
    %Private properties/fields
    %----------------------------------------------------------------------
    properties (GetAccess='private', SetAccess='private')
    end
    
    %----------------------------------------------------------------------
    %Dependent properties/fields
    %----------------------------------------------------------------------
    properties (Dependent)
    end
    
    %----------------------------------------------------------------------
    %Static properties/fields
    %----------------------------------------------------------------------
    properties (Constant)
    end
    
    %----------------------------------------------------------------------
    %Public methods
    %----------------------------------------------------------------------
    methods
        %Constructors
        function obj = IncrementalRotaryEncoder(varargin)
            %INCREMENTALROTARYENCODER  Constructor for the object
            %
            %   [OBJ] = INCREMENTALROTARYENCODER(N) Creates a new
            %   INCREMENTALROTARYENCODER object.
            %
            %INPUT:     -N:     number of slits per revolution of encoder
            %
            %OUTPUT:    -OBJ:   IncrementalRotaryEncoder object
            %
            %Christopher Lum
            %lum@uw.edu
            
            %Version History
            %11/28/16: Created
            %01/20/24: Updated documentation
            
            %------------------OBTAIN USER PREFERENCES---------------------
            switch nargin
                case 1
                    %User supplies all inputs
                    N = varargin{1};
                    
                otherwise
                    error('Invalid number of inputs for constructor');
            end
            
            %------------------CHECKING DATA FORMAT------------------------
            % N
            assert(isinteger2(N), 'N should be an integer value')
            assert(N > 0, 'N should be greater than 0')
            
            %--------------------BEGIN CALCULATIONS------------------------
            obj.NumSlitsPerRevolution = N;
        end
        
        %Destructor
        function delete(obj)
        end
        
        %Get/Set
        
        %Class API
        function [varargout] = SampleTimeRequired(varargin)
            %SAMPLETIMEREQUIRED Computes the necessary sample time.
            %
            %   [T] = SAMPLETIMEREQUIRED(OMEGA) Computes the sample time
            %   required in order to guarantee accurate measurement of the
            %   encoder spinning at OMEGA (rad per second).
            %
            %INPUT:     -OMEGA: desired angular speed to measure (rad/sec)
            %
            %OUTPUT:    -T:     sample time required (sec)
            %
            %Christopher Lum
            %lum@uw.edu
            
            %Version History
            %11/28/16: Created
            %01/20/24: Updated documentation
            
            %------------------OBTAIN USER PREFERENCES---------------------
            switch nargin
                case 2
                    %User supplies all inputs
                    obj     = varargin{1};
                    OMEGA   = varargin{2};
                    
                otherwise
                    error('Invalid number of inputs for constructor');
            end
            
            %------------------CHECKING DATA FORMAT------------------------
            assert(OMEGA > 0, 'OMEGA should be greater than 0')
            
            %--------------------BEGIN CALCULATIONS------------------------
            T = 2*pi/(4*OMEGA*obj.NumSlitsPerRevolution);
            varargout{1} = T;
        end
        
        function [varargout] = FastestMeasurableSpeed(varargin)
            %FASTESTMEASURABLESPEED Computes the fastest speed possible
            %
            %   [OMEGA] = FASTESTMEASURABLESPEED(T) Computes the fastest
            %   speed that can be accurately be measured using the
            %   specified sample time.
            %
            %INPUT:     -T:     sample time used (sec)
            %
            %OUTPUT:    -OMEGA: fastest angular speed that can be accurately measured (rad/sec)
            %
            %Christopher Lum
            %lum@uw.edu
            
            %Version History
            %11/28/16: Created
            %01/20/24: Updated documentation
            
            %------------------OBTAIN USER PREFERENCES---------------------
            switch nargin
                case 2
                    %User supplies all inputs
                    obj     = varargin{1};
                    T       = varargin{2};
                    
                otherwise
                    error('Invalid number of inputs for constructor');
            end
            
            %------------------CHECKING DATA FORMAT------------------------
            assert(T > 0, 'T should be greater than 0')
            
            %--------------------BEGIN CALCULATIONS------------------------
            OMEGA = 2*pi/(4*T*obj.NumSlitsPerRevolution);
            varargout{1} = OMEGA;
        end
    end
    
    %----------------------------------------------------------------------
    %Private methods
    %----------------------------------------------------------------------
    methods (Access='private')
    end
    
    %----------------------------------------------------------------------
    %Static methods
    %----------------------------------------------------------------------
    methods(Static)
    end
    
    %----------------------------------------------------------------------
    %Private Static methods
    %----------------------------------------------------------------------
    methods(Static, Access='private')
    end
end


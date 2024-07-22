classdef DatetimeManipulator
    %Class for operating on datetime objects.
    %
    %Christopher Lum
    %lum@uw.edu
    
    %Version History
    %07/21/24: Created

    %----------------------------------------------------------------------
    %Public properties/fields
    %----------------------------------------------------------------------
    properties (GetAccess='public', SetAccess='public')
        datetimeobj;
    end   
    
    %----------------------------------------------------------------------
    %Private properties/fields
    %----------------------------------------------------------------------
    properties (GetAccess='private', SetAccess='private')
    end
    
    %----------------------------------------------------------------------
    %Public Dependent properties/fields
    %----------------------------------------------------------------------
    properties (Dependent)
    end

    %----------------------------------------------------------------------
    %Public methods
    %----------------------------------------------------------------------
    methods
        %Constructors
        function obj = DatetimeManipulator(varargin)
            %DatetimeManipulator  Constructor for the object
            %
            %   [OBJ] = DatetimeManipulator(datetimeobj) creates an object
            %   to manipulate the specified datetime object.
            %
            %INPUT:     -datetimeobj: datetime object
            %
            %OUTPUT:    -OBJ:   DatetimeManipulator object
            %
            %Christopher Lum
            %lum@uw.edu
            
            %Version History
            %07/21/24: Created
            
            %------------------OBTAIN USER PREFERENCES---------------------
            switch nargin
                case 1
                    %User supplies all inputs
                    datetimeobj = varargin{1};
                    
                otherwise
                    error('Invalid number of inputs for constructor');
            end

            %------------------CHECKING DATA FORMAT------------------------
            assert(isa(datetimeobj,'datetime'),'datetimeobj should be a datetime object')
            
            %--------------------BEGIN CALCULATIONS------------------------
            obj.datetimeobj = datetimeobj;
        end
        
        %Destructor
        function delete(obj)
        end
        
        %Get/Set
%         function obj = set.mMass(obj, mass)
%             assert(mass > 0);
%             obj.mMass = mass;
%         end
%      
%         function obj = set.mDamping(obj, damping)
%             assert(damping > 0);
%             obj.mDamping = damping;
%         end
                
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
%             disp(['mMass: ',obj.mTimeHistory])
        end
        
    end
    
    %----------------------------------------------------------------------
    %Static methods
    %----------------------------------------------------------------------
    methods(Static)
        function [varargout] = ConvertDateTimeArrayToLinear(varargin)
            %ConvertDateTimeArrayToLinear Converts to a linear time
            %
            %   [deltaTArray_days] =
            %   ConvertDateTimeArrayToLinear(datetimeArray,datetimeStart)
            %   converts the datetimeArray to a deltaTArray_days.  Each
            %   element of deltaTArray_days corresponds to the number of
            %   days past datetimeStart.
            %
            %INPUT:     -datetimeArray: array of datetime objects
            %           -datetimeStart: starting date (deltaT = 0)
            %
            %OUTPUT:    -deltaTArray_days: array denoting num days after datetimeStart
            %
            %Christopher Lum
            %lum@uw.edu
            
            %Version History
            %07/21/24: Created
            
            %------------------OBTAIN USER PREFERENCES---------------------
            switch nargin
                case 2
                    %User supplies all inputs
                    datetimedatetimeArray   = varargin{1};
                    datetimeStart           = varargin{2};
                    
                otherwise
                    error('Invalid number of inputs for constructor');
            end

            %------------------CHECKING DATA FORMAT------------------------
            assert(isa(datetimedatetimeArray,'datetime'),'datetimedatetimeArray should be a datetime object')
            assert(isa(datetimeStart,'datetime'),'datetimeStart should be a datetime object')
            
            %--------------------BEGIN CALCULATIONS------------------------
            deltaTArray_days = zeros(size(datetimedatetimeArray));
            for k=1:length(datetimedatetimeArray)
                d = duration(datetimedatetimeArray(k) - datetimeStart);
                deltaTArray_days(k) = days(d);
            end

            %Output objects
            varargout{1} = deltaTArray_days;
        end

    end
    
end


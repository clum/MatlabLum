classdef DatetimeManipulator
    %Class for operating on datetime objects.
    %
    %Christopher Lum
    %lum@uw.edu
    
    %Version History
    %07/21/24: Created
    %10/01/24: Added FindDatesAfter

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
                
        %Class API
       
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
            %07/31/24: Fixed odditiy in variable name
            
            %------------------OBTAIN USER PREFERENCES---------------------
            switch nargin
                case 2
                    %User supplies all inputs
                    datetimeArray = varargin{1};
                    datetimeStart = varargin{2};
                    
                otherwise
                    error('Invalid number of inputs for constructor');
            end

            %------------------CHECKING DATA FORMAT------------------------
            assert(isa(datetimeArray,'datetime'),'datetimeArray should be a datetime object')
            assert(isa(datetimeStart,'datetime'),'datetimeStart should be a datetime object')
            
            %--------------------BEGIN CALCULATIONS------------------------
            deltaTArray_days = zeros(size(datetimeArray));
            for k=1:length(datetimeArray)
                d = duration(datetimeArray(k) - datetimeStart);
                deltaTArray_days(k) = days(d);
            end

            %Output objects
            varargout{1} = deltaTArray_days;
        end

        function [varargout] = FindNearestDate(varargin)
            %FindNearestDate Finds the nearest date
            %
            %   [datetimeNearest,indexNearest] =
            %   FindNearestDate(datetimeArray,datetimeDesired) finds the
            %   datetime object in the array datetimeArray that is closest
            %   to datetimeDesired.
            %
            %INPUT:     -datetimeArray:     array of datetime objects
            %           -datetimeDesired:   desired date
            %
            %OUTPUT:    -datetimeNearest:   nearest date
            %           -indexNearest:      index where nerest date occurs
            %
            %Christopher Lum
            %lum@uw.edu
            
            %Version History
            %07/31/24: Created
            
            %------------------OBTAIN USER PREFERENCES---------------------
            switch nargin
                case 2
                    %User supplies all inputs
                    datetimeArray   = varargin{1};
                    datetimeDesired = varargin{2};
                    
                otherwise
                    error('Invalid number of inputs for constructor');
            end

            %------------------CHECKING DATA FORMAT------------------------
            assert(isa(datetimeArray,'datetime'),'datetimeArray should be a datetime object')
            assert(isa(datetimeDesired,'datetime'),'datetimeDesired should be a datetime object')
            
            %--------------------BEGIN CALCULATIONS------------------------
            datetimeNearest = [];
            indexNearest    = [];
            minDeltaT_s     = Inf;
            for k=1:length(datetimeArray)
                d = duration(datetimeArray(k) - datetimeDesired);
                DeltaT_s = abs(seconds(d));

                if(DeltaT_s < minDeltaT_s)
                    datetimeNearest = datetimeArray(k);
                    indexNearest    = k;
                    minDeltaT_s     = DeltaT_s;
                end

            end

            %Output objects
            varargout{1} = datetimeNearest;
            varargout{2} = indexNearest;
        end

        function [varargout] = FindDatesInRange(varargin)
            %FindDatesInRange Finds the dates in the specified range
            %
            %   [dates,indices] =
            %   FindDatesInRange(datetimeArray,datetimeStart,datetimeEnd)
            %   finds the indices in the datetimeArray that are in the
            %   range of [datetimeStart,datetimeEnd].
            %
            %INPUT:     -datetimeArray:     array of datetime objects
            %           -datetimeStart:     start date
            %           -datetimeEnd:       end date
            %
            %OUTPUT:    -dates:             array of dates in the range
            %           -indices:           indices
            %
            %Christopher Lum
            %lum@uw.edu
            
            %Version History
            %07/31/24: Created
            
            %------------------OBTAIN USER PREFERENCES---------------------
            switch nargin
                case 3
                    %User supplies all inputs
                    datetimeArray   = varargin{1};
                    datetimeStart   = varargin{2};
                    datetimeEnd     = varargin{3};

                otherwise
                    error('Invalid number of inputs for constructor');
            end

            %------------------CHECKING DATA FORMAT------------------------
            assert(isa(datetimeArray,'datetime'),'datetimeArray should be a datetime object')
            assert(isa(datetimeStart,'datetime'),'datetimeStart should be a datetime object')
            assert(isa(datetimeEnd,'datetime'),'datetimeEnd should be a datetime object')
            
            %--------------------BEGIN CALCULATIONS------------------------
            %Convert datetime to seconds
            dates   = [];
            indices = [];

            datetimeEndLinear_s = seconds(duration(datetimeEnd - datetimeStart));
            assert(datetimeEndLinear_s>0,'datetimeStart appears to occur after datetimeEnd');

            for k=1:length(datetimeArray)
                datetime_k = datetimeArray(k);
                d = duration(datetime_k - datetimeStart);
                t_s = seconds(d);

                if(LumFunctionsMisc.IsObjectInRange(t_s,0,datetimeEndLinear_s))
                    dates = [dates;datetime_k]; %can't concatenate using (end+1) index specification
                    indices(end+1,1) = k;
                end
            end

            %Output objects
            varargout{1} = dates;
            varargout{2} = indices;
        end

        function [varargout] = FindDatesOnOrAfter(varargin)
            %FindDatesOnOrAfter Finds dates on or after the specified date
            %
            %   [dates,indices] =
            %   FindDatesOnOrAfter(datetimeArray,datetimeStart) finds the
            %   indices in the datetimeArray that are on or after the
            %   datetimeStart.
            %
            %INPUT:     -datetimeArray:     array of datetime objects
            %           -datetimeStart:     start date
            %
            %OUTPUT:    -dates:             array of dates that match
            %           -indices:           indices
            %
            %Christopher Lum
            %lum@uw.edu
            
            %Version History
            %10/01/24: Created
            
            %--------fgvb----------OBTAIN USER PREFERENCES---------------------
            switch nargin
                case 2
                    %User supplies all inputs
                    datetimeArray   = varargin{1};
                    datetimeStart   = varargin{2};
                    
                otherwise
                    error('Invalid number of inputs for constructor');
            end

            %------------------CHECKING DATA FORMAT------------------------
            assert(isa(datetimeArray,'datetime'),'datetimeArray should be a datetime object')
            assert(isa(datetimeStart,'datetime'),'datetimeStart should be a datetime object')
            
            %--------------------BEGIN CALCULATIONS------------------------
            %Convert datetime to seconds
            dates   = [];
            indices = [];

            for k=1:length(datetimeArray)
                datetime_k = datetimeArray(k);
                d = duration(datetime_k - datetimeStart);
                t_s = seconds(d);

                if(t_s >= 0)
                    dates = [dates;datetime_k]; %can't concatenate using (end+1) index specification
                    indices(end+1,1) = k;
                end
            end

            %Output objects
            varargout{1} = dates;
            varargout{2} = indices;
        end

    end
    
end

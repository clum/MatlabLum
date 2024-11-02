classdef DatetimeManipulator
    %Class for operating on datetime objects.
    %
    %Christopher Lum
    %lum@uw.edu

    %Version History
    %07/21/24: Created
    %10/01/24: Added FindDatesAfter
    %10/23/24: Added FromExcelTime

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
        function [monthlyDates] = MonthlyDateArray(dateEarliest,dateLatest)
            %MonthlyDateArray computes monthly dates in the specified range
            %
            %   [monthlyDates] = MonthlyDateArray(dateEarliest,dateLatest)
            %   computes an array of dates that are on the first of the
            %   month between dateEarliest and dateLatest.  Note that the
            %   monthlyDates array will encompass the range
            %   [dateEarliest,dateLatest] which means that monthlyDates(1)
            %   is on or earlier than dateEarliest and monthlyDates(end) is
            %   on or later tha ndateLatest
            %
            %INPUT:     -dateEarliest: earliest date
            %           -dateLatest: latest date
            %
            %OUTPUT:    -monthlyDates:  array of datetime objects
            %
            %Christopher Lum
            %lum@uw.edu

            %Version History
            %10/23/24: Created

            %------------------CHECKING DATA FORMAT------------------------
            assert(dateLatest>=dateEarliest,'dateLatest should be after dateEarliest')

            %--------------------BEGIN CALCULATIONS------------------------
            %Find the month that is closest to the earliest date
            dateEarliestShifted = dateshift(dateEarliest,'start','month');
            dateLatestShifted = dateshift(dateLatest,'end','month') + duration(24,0,0);

            assert(dateEarliestShifted.Day==1,'Shifted date does not appear to start on first of the month')
            assert(dateLatestShifted.Day==1,'Shifted date does not appear to start on first of the month')

            monthlyDates = dateEarliestShifted;
            while(1)
                dateCurr = monthlyDates(end);

                if(dateCurr.Month==12)
                    dateNext = dateCurr;
                    dateNext.Month = 1;
                    dateNext.Year = dateCurr.Year+1;

                else
                    dateNext = dateCurr;
                    dateNext.Month = dateCurr.Month+1;

                end

                %Check termination
                if(dateNext > dateLatestShifted)
                    break
                else
                    monthlyDates(end+1,1) = dateNext;
                end
            end
        end

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

            %------------------OBTAIN USER PREFERENCES---------------------
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

        function [t] = FromExcelTime(tExcel)
            %FromExcelTime Convert an Excel time to a datetime object
            %
            %   [t] = FromExcelTime(tExcel) converts a Excel time (a number
            %   that represents the number of days that have passed since
            %   January 1, 1900).
            %
            %   See https://www.mathworks.com/help/exlink/convert-dates-between-microsoft-excel-and-matlab.html
            %
            %INPUT:     -tExcel:    number of days since Jan 1, 1900
            %
            %OUTPUT:    -t:         datetime object
            %
            %Christopher Lum
            %lum@uw.edu

            %Version History
            %10/23/24: Created

            %------------------CHECKING DATA FORMAT------------------------

            %--------------------BEGIN CALCULATIONS------------------------
            Y = 0;
            M = 0;
            D = tExcel + 693960 + 31;       %CL: I had to add 31 days to make this match

            t = datetime(Y,M,D);
        end

        function [IsMono] = IsArrayMonotonicallyIncreasing(datetimeArray)
            %IsArrayMonotonicallyIncreasing Is monotonically increasing
            %
            %   [IsMono] = IsArrayMonotonicallyIncreasing (datetimeArray)
            %   checks if the array of datatime objects in monotonically
            %   increasing or not.
            %
            %INPUT:     -datetimeArray: array of datetime objects
            %
            %OUTPUT:    -IsMono:        true if monotonically increasing
            %
            %Christopher Lum
            %lum@uw.edu

            %Version History
            %11/02/24: Created

            %------------------CHECKING DATA FORMAT------------------------
            %datetimeArray
            assert(isvector(datetimeArray),'datetimeArray must be a vector')
            assert(isa(datetimeArray,'datetime'),'datetimeArray does not appear to be a datetime object')

            %--------------------BEGIN CALCULATIONS------------------------
            datetimeStart = datetimeArray(1);
            deltaTArray_days = DatetimeManipulator.ConvertDateTimeArrayToLinear(datetimeArray,datetimeStart);

            IsMono = IsMonotonicallyIncreasing(deltaTArray_days);
        end

    end

end
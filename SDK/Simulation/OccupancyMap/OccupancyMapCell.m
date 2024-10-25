classdef OccupancyMapCell
    %OCCUPANCYMAPCELL OccupancyMapCell class
    %   
    %   Class representing a single cell in an occupancy map
    %
    %Christopher Lum
    %lum@uw.edu
    
    %Version History
    %06/12/19: Created
    
    %----------------------------------------------------------------------
    %Public properties/fields
    %----------------------------------------------------------------------
    properties (GetAccess='public', SetAccess='public')
        
    end   
    
    %----------------------------------------------------------------------
    %Private properties/fields
    %----------------------------------------------------------------------
    properties (GetAccess='private', SetAccess='private')
        rowIndex;
        colIndex;
        cellCenterX;
        cellCenterY;
        cellScore;
    end
    
    %----------------------------------------------------------------------
    %Public Dependent properties/fields
    %----------------------------------------------------------------------
    properties (Dependent)
        %Row index of the cell in the OccupancyMap
        RowIndex;
        
        %Column index of the cell in the OccupancyMap
        ColIndex;
        
        %x coordinate of the center of the cell
        CellCenterX;
        
        %y coordinate of the center of the cell
        CellCenterY;
        
        %score of this cell
        CellScore;        
    end
    
    %----------------------------------------------------------------------
    %Public methods
    %----------------------------------------------------------------------
    methods
        %Constructors
        function obj = OccupancyMapCell(varargin)
            %OCCUPANCYMAP  Constructor for the object
            %
            %   [OBJ] = OCCUPANCYMAPCELL() creates a default object.
            %
            %   [...] = OCCUPANCYMAPCELL(ROWINDEX, COLINDEX, CELLCENTERX,
            %   CELLCENTERY, CELLSCORE) creates an object from the
            %   specified values.
            %
            %INPUT:     -ROWINDEX:      See RowIndex property
            %           -COLINDEX:      See ColIndex property
            %           -CELLCENTERX:   See CellCenterX property
            %           -CELLCENTERY:   See CellCenterY property
            %           -CELLSCORE:     See CellScore property
            %
            %OUTPUT:    -OBJ:           OccupancyMapCell object
            %
            %Created by Christopher Lum
            %lum@uw.edu
            
            %Version History
            %06/12/19: Created
            
            %------------------OBTAIN USER PREFERENCES---------------------
            switch nargin
                case 5
                    %User supplies all inputs
                    ROWINDEX    = varargin{1};
                    COLINDEX    = varargin{2};
                    CELLCENTERX = varargin{3};
                    CELLCENTERY = varargin{4};
                    CELLSCORE   = varargin{5};
                    
                case 0
                    %Assume default object
                    ROWINDEX    = 1;
                    COLINDEX    = 1;
                    CELLCENTERX = 0;
                    CELLCENTERY = 0;
                    CELLSCORE   = 0;
                    
                otherwise
                    error('Invalid number of inputs for constructor');
            end

            %------------------CHECKING DATA FORMAT------------------------
            %Set via properties, error checking is done in properties
            
            %--------------------BEGIN CALCULATIONS------------------------
            %Initialize data members
            obj.RowIndex    = ROWINDEX;
            obj.ColIndex    = COLINDEX;
            obj.CellCenterX = CELLCENTERX;
            obj.CellCenterY = CELLCENTERY;
            obj.CellScore   = CELLSCORE;
        end
        
        %Destructor
        function delete(obj)
        end
        
        %Get/Set
        function value = get.RowIndex(obj)
            value = obj.rowIndex;
        end
        
        function obj = set.RowIndex(obj, value)
            assert(value > 0);
            assert(mod(value,1)==0);
            obj.rowIndex = value;
        end
        
        function value = get.ColIndex(obj)
            value = obj.colIndex;
        end
        
        function obj = set.ColIndex(obj, value)
            assert(value > 0);
            assert(mod(value,1)==0);
            obj.colIndex = value;
        end
        
        function value = get.CellCenterX(obj)
            value = obj.cellCenterX;
        end
        
        function obj = set.CellCenterX(obj, value)
            obj.cellCenterX = value;
        end
        
        function value = get.CellCenterY(obj)
            value = obj.cellCenterY;
        end
        
        function obj = set.CellCenterY(obj, value)
            obj.cellCenterY = value;
        end
        
        function value = get.CellScore(obj)
            value = obj.cellScore;
        end
        
        function obj = set.CellScore(obj, value)
            assert(UWFunctionsMisc.IsObjectInRange(value, OccupancyMap.MIN_SCORE, OccupancyMap.MAX_SCORE))
            obj.cellScore = value;
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
            %06/12/19: Created
            disp(['RowIndex:    ',num2str(obj.RowIndex)])
            disp(['ColIndex:    ',num2str(obj.ColIndex)])
            disp(['CellCenterX: ',num2str(obj.CellCenterX)])
            disp(['CellCenterY: ',num2str(obj.CellCenterY)])
            disp(['CellScore:   ',num2str(obj.CellScore)])
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


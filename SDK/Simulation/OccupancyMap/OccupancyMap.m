classdef OccupancyMap
    %OCCUPANCYMAP OccupancyMap class
    %   
    %   A map that can be used to define occupancy at different locations
    %
    %Christopher Lum
    %lum@uw.edu
    
    %Version History
    %06/07/19: Created
    %06/12/19: Updates to documentation
    
    %----------------------------------------------------------------------
    %Public properties/fields
    %----------------------------------------------------------------------
    properties (GetAccess='public', SetAccess='public')
        
    end   
    
    %----------------------------------------------------------------------
    %Private properties/fields
    %----------------------------------------------------------------------
    properties (GetAccess='private', SetAccess='private')
        cellCentersX;
        cellCentersY;
        cellScores;
        timeStamp;
    end
    
    %----------------------------------------------------------------------
    %Public Dependent properties/fields
    %----------------------------------------------------------------------
    properties (Dependent)
        %Read only property of x locations of all cell centers
        CellCentersX;
        
        %Read only property of y locations of all cell centers
        CellCentersY;
        
        %Read only property of scores of all cells
        CellScores;
        
        %A read only property which is the sum of all the cell scores
        CumulativeCellScore;
    end

    %----------------------------------------------------------------------
    %Static properties/fields
    %----------------------------------------------------------------------
    properties (Constant)
        %Minimum map score possible
        MIN_SCORE = 0;
        
        %Maximum map score possible
        MAX_SCORE = 1;
    end
    
    %----------------------------------------------------------------------
    %Public methods
    %----------------------------------------------------------------------
    methods
        %Constructors
        function obj = OccupancyMap(varargin)
            %OCCUPANCYMAP  Constructor for the object
            %
            %   [OBJ] = OCCUPANCYMAP(XMIN, XMAX, YMIN, YMAX, NX, NY)
            %   creates an object from the specified values.
            %
            %INPUT:     -XMIN:  Min x value of map
            %           -XMAX:  Max x value of map
            %           -YMIN:  Min y value of map
            %           -YMAX:  Max y value of map
            %           -NX:    number of cells in the x direction
            %           -NY:    number of cells in the y direction
            %
            %OUTPUT:    -OBJ:   OccupancyMap object
            %
            %Created by Christopher Lum
            %lum@uw.edu
            
            %Version History
            %06/09/19: Created
            
            %------------------OBTAIN USER PREFERENCES---------------------
            switch nargin
                case 6
                    %User supplies all inputs
                    XMIN    = varargin{1};
                    XMAX    = varargin{2};
                    YMIN    = varargin{3};
                    YMAX    = varargin{4};
                    NX      = varargin{5};
                    NY      = varargin{6};
                    
                otherwise
                    error('Invalid number of inputs for constructor');
            end

            %------------------CHECKING DATA FORMAT------------------------
            assert(XMAX > XMIN, 'XMAX must be greater than XMIN')
            assert(YMAX > YMIN, 'YMAX must be greater than YMIN')
            assert(NX >= 2, 'NX should be greater or equal to 2')
            assert(NY >= 2, 'NY should be greater or equal to 2')
            
            %--------------------BEGIN CALCULATIONS------------------------
            %What are the legnth of each cell?
            Lx = (XMAX - XMIN)/NX;
            Ly = (YMAX - YMIN)/NY;
            
            %Now create arrays which are the center points of each cell
            x = linspace(XMIN + Lx/2, XMAX - Lx/2, NX);
            y = linspace(YMIN + Ly/2, YMAX - Ly/2, NY);

            %Now create a 2D matrix using meshgrid
            [X, Y_flipped] = meshgrid(x, y);
            
            %Flip the Y_flipped matrix so that elements in the matrix fit
            %the spatial grid (ie so the top left of the matrix has the
            %y-value for the top left of the grid)
            Y = flipud(Y_flipped);

            %Initialize data members
            obj.cellCentersX = X;
            obj.cellCentersY = Y;
            obj.cellScores = 0.5*ones(size(X));
            obj.timeStamp = 0;
        end
        
        %Destructor
        function delete(obj)
        end
        
        %Get/Set
        function value = get.CellCentersX(obj)
            value = obj.cellCentersX;
        end
        
        function value = get.CellCentersY(obj)
            value = obj.cellCentersY;
        end
        
        function value = get.CellScores(obj)
            value = obj.cellScores;
        end
        
        function value = get.CumulativeCellScore(obj)
            value = sum(sum(obj.cellScores));
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
            %06/09/19: Created
            obj.cellScores
        end

        function [obj] = SetCellScoreAtSpecifiedRowColIndex(obj, rowIndex, colIndex, score)
            %SETCELLSCOREATSPECIFIEDROWCOLINDEX  Set score at location
            %
            %   SETCELLSCOREATSPECIFIEDROWCOLINDEX(ROWINDEX, COLINDEX,
            %   SCORE)  Set the cell score at the specified row/col index
            %   to the specified value.
            %
            %INPUT:     -ROWINDEX:  row index
            %           -COLINDEX:  column index
            %           -SCORE:     score to set
            %
            %Created by Christopher Lum
            %lum@uw.edu
            
            %Version History
            %06/09/19: Created
            
            %------------------OBTAIN USER PREFERENCES---------------------
            
            
            %------------------CHECKING DATA FORMAT------------------------
            % rowIndex
            % colIndex
            % score
            assert(UWFunctionsMisc.IsObjectInRange(score, OccupancyMap.MIN_SCORE, OccupancyMap.MAX_SCORE))
            
            %--------------------BEGIN CALCULATIONS------------------------
            
            cellScores = obj.CellScores;
            cellScores(rowIndex, colIndex) = score;
            
            obj.cellScores = cellScores;
        end
        
        
        function [] = Plot(varargin)
            %PLOT   Plots the cells and their scores of the OccupancyMap
            %       object
            %
            %   PLOT() Plots the scores.
            %
            %   PLOT(CIRCLEPLOT) does as above but draws a circle at the
            %   center of each cell.
            %
            %INPUT:     -CIRCLEPLOT:    logical denoting if circles should
            %                           be drawn
            %
            %OUTPUT:    -None
            %
            %Created by Christopher Lum
            %lum@uw.edu
            
            %Version History
            %06/12/19: Created from "D:\lum\c_cpp\projects\thesis\matlab\classes\@OccupancyMap\plot.m"
            
            %------------------OBTAIN USER PREFERENCES---------------------
            switch nargin
                case 2
                    %User specifies all inputs
                    MAP         = varargin{1};
                    CIRCLE_PLOT = varargin{2};
                    
                case 1
                    %Assume no circle plot
                    MAP         = varargin{1};
                    CIRCLE_PLOT = false;
                    
                otherwise
                    error('Invalid number of inputs')
            end
            
            %------------------CHECKING DATA FORMAT------------------------
            assert(isa(MAP, 'OccupancyMap'))
            assert(isa(CIRCLE_PLOT, 'logical'))
            
            %--------------------BEGIN CALCULATIONS------------------------
            X = MAP.CellCentersX;
            Y = MAP.CellCentersY;
            Z = MAP.CellScores;
            min_occupancy_map_score = 0;
            max_occupancy_map_score = 1;
            
            %Obtain the range of x and y values for center points of map
            x = X(1,:);
            y = Y(:,1);
            
            [num_y,num_x] = size(X);
            
            for y_counter=1:num_y
                for x_counter=1:num_x
                    %What is the current center point?
                    x_curr = x(x_counter);
                    y_curr = y(y_counter);
                    z_curr = Z(y_counter,x_counter);
                    
                    %Calculate x distance to neighboring cells
                    if (x_counter==1)
                        %Points on left side of grid
                        LX_r = x(x_counter+1) - x_curr;
                        LX_l = LX_r;
                        
                    elseif (x_counter==num_x)
                        %Points on right side of grid
                        LX_l = x_curr - x(x_counter-1);
                        LX_r = LX_l;
                    else
                        %Points in center of grid
                        LX_l = x_curr - x(x_counter-1);
                        LX_r = x(x_counter+1) - x_curr;
                    end
                    
                    %Calculate y distance to neighboring cells
                    if (y_counter==1)
                        %Points on bottom of grid
                        LY_u = y(y_counter+1) - y_curr;
                        LY_d = LY_u;
                    elseif (y_counter==num_y)
                        %Points on top of grid
                        LY_d = y_curr - y(y_counter-1);
                        LY_u = LY_d;
                    else
                        %Points in center of grid
                        LY_d = y_curr - y(y_counter-1);
                        LY_u = y(y_counter+1) - y_curr;
                    end
                    
                    %Due to the way MESHGRID works and how CREATEOCCUPANCYMAP works,
                    %the y vector may be sorted highest to lowest or lowest to highest.
                    % Therefore, we need to take the absolute value
                    LY_d = abs(LY_d);
                    LY_u = abs(LY_u);
                    
                    
                    %Calculate the corners of this cell.
                    X_corners = [(x_curr-LX_l/2) (x_curr+LX_r/2);
                        (x_curr-LX_l/2) (x_curr+LX_r/2)];
                    
                    Y_corners = [(y_curr+LY_u/2) (y_curr+LY_u/2);
                        (y_curr-LY_d/2) (y_curr-LY_d/2)];
                    
                    
                    %Where does this get placed in the matrix?
                    row_start_index = 2*y_counter-1;
                    row_stop_index = 2*y_counter;
                    
                    col_start_index = 2*x_counter-1;
                    col_end_index = 2*x_counter;
                    
                    %Put this submatrix into the larger matrix
                    X_plot(row_start_index:row_stop_index,col_start_index:col_end_index) = ...
                        X_corners;
                    
                    Y_plot(row_start_index:row_stop_index,col_start_index:col_end_index) = ...
                        Y_corners;
                    
                    Z_plot(row_start_index:row_stop_index,col_start_index:col_end_index) = ...
                        z_curr*ones(2,2);
                end
            end
            
            %Calculate the length of a cell in the x and y direction (Lx and Ly,
            %respectively)
            Lx = abs(x(2) - x(1));
            Ly = abs(y(2) - y(1));
            
            surf(X_plot,Y_plot,Z_plot)
            axis([min(x)-Lx/2 max(x)+Lx/2 min(y)-Ly/2 max(y)+Ly/2])
            hold on
            
            %Now make it so the colorbar ranges from min_occupancy_map_score to the max_occupancy_map_score
            surf(X_plot(1,1)*ones(2,2),Y_plot(1,1)*ones(2,2),max_occupancy_map_score*ones(2,2))
            surf(X_plot(1,1)*ones(2,2),Y_plot(1,1)*ones(2,2),min_occupancy_map_score*ones(2,2))
            xlabel('x')
            ylabel('y')
            zlabel('z')
            title('Occupancy Map')
            grid on
            hold on
            colorbar
            
            %Do we draw a circle at the center of each cell?
            if(strcmp(CIRCLE_PLOT,'plot_circles'))
                plot3(X,Y,Z,'ro');
            end
            
            view([0 90])

        end
    end
    
end


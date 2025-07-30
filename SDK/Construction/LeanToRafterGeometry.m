classdef LeanToRafterGeometry < handle
    %Class for computing geometry related to a lean-to rafter.
    %
    %Christopher Lum
    %lum@uw.edu

    %02/17/25: Created
    %03/09/25: Moved to MatlabLum
    %07/28/25: Changed to a class to be consistent with StairsGeometry
    
    %----------------------------------------------------------------------
    %Public properties/fields
    %----------------------------------------------------------------------
    properties (GetAccess='public', SetAccess='public')
        slope       = 2/10;     %rafter slope
        Lo          = 14;       %length of overhang on bottom side (horizontal projection)
        d           = 2;        %vertical depth of birdsmouth cut
        w           = 150;      %width of building (outside edge to outside edge)
        tR          = 9.25;     %thickness of rafter member (2x10 = 9.25")
        L           = 12*12;    %length of rafter member
        wTP         = 3.5;      %width of top plate (ie 3.5")        
    end

    %----------------------------------------------------------------------
    %Public Get but Private Set properties/fields
    %----------------------------------------------------------------------
    properties (GetAccess='public', SetAccess='private')
        rafterX     = [];
        rafterY     = [];
        theta       = [];
        rafterX_L   = [];
        rafterY_L   = [];
        e           = [];   %horizontal depth of birdsmouth cut
        LT          = [];   %length of overhang on top side (horizontal projection)
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
        function obj = LeanToRafterGeometry(slope,Lo,d,w,tR,L,wTP)
            %LeanToRafterGeometry  Constructor for the object
            %
            %   [OBJ] = LeanToRafterGeometry(...
            %
            %INPUT:     -see function
            %
            %OUTPUT:    -OBJ:   StairsGeometry object
            %
            %Christopher Lum
            %lum@uw.edu

            %Version History
            %07/29/25: Created

            arguments
                slope   (1,1) double  {mustBePositive}
                Lo      (1,1) double  {mustBePositive}
                d       (1,1) double  {mustBePositive}
                w       (1,1) double  {mustBePositive}
                tR      (1,1) double  {mustBePositive}
                L       (1,1) double  {mustBePositive}
                wTP     (1,1) double  {mustBePositive}
            end

            obj.slope   = slope;
            obj.Lo      = Lo;
            obj.d       = d;
            obj.w       = w;
            obj.tR      = tR;
            obj.L       = L;
            obj.wTP     = wTP;

            obj.UpdateDerivedParameters();
        end

        %Destructor
        function delete(obj)
        end

        %Get/Set

        %Class API
        function [] = display(obj)
            disp('Independent Parameters')
            disp('----------------------')
            disp(['slope            = ',num2str(obj.slope)])
            disp(['Lo               = ',num2str(obj.Lo)])
            disp(['d                = ',num2str(obj.d)])
            disp(['w                = ',num2str(obj.w)])
            disp(['tR               = ',num2str(obj.tR)])
            disp(['L                = ',num2str(obj.L)])
            disp(['wTP              = ',num2str(obj.wTP)])
            disp(' ')
            disp('Selected Derived Parameters')
            disp('---------------------------')
            disp(['rad2deg(theta)   = ',num2str(rad2deg(obj.theta))])
            disp(['e                = ',num2str(obj.e)])
            disp(['LT               = ',num2str(obj.LT)])
        end

        function [obj] = UpdateDerivedParameters(obj)
            %UpdateDerivedParameters Update derived parameters
            %
            %   UpdateDerivedParameters() Updates parameters that are
            %   derived based on the existing values in the public
            %   properties.
            %
            %INPUT:     -None
            %
            %OUTPUT:    -None
            %
            %Christopher Lum
            %lum@uw.edu

            %Version History
            %07/29/25: Created
            
            %% Calculations
            x1 = 0;
            y1 = 0;

            x2 = obj.Lo;
            y2 = obj.slope*obj.Lo;

            x3 = obj.Lo;
            y3 = y2 + obj.d;

            e = obj.d/obj.slope;
            x4 = obj.Lo + e;
            y4 = y3;

            assert(e<obj.wTP,'Geometry results in horizontal length of the birdsmouth exceeding the width of the top plate.  Recommend making d (vertical depth of birdsmouth) smaller')

            r5 = obj.w - obj.wTP - e;
            x5 = x4 + r5;
            y5 = y4 + obj.slope*r5;

            x6 = x5;
            y6 = y5 + obj.d;

            x7 = x6 + e;
            y7 = y6;

            theta = atan(obj.slope);
            Ltilde = sqrt(x7^2 + y7^2);
            assert(Ltilde < obj.L);
            h = obj.L-Ltilde;

            x8 = x7 + h*cos(theta);
            y8 = y7 + h*sin(theta);

            x9 = x8 - obj.tR*sin(theta);
            y9 = y8 + obj.tR*cos(theta);

            x10 = -obj.tR*sin(theta);
            y10 = obj.tR*cos(theta);


            % Check calculations
            rise = y6-y3;
            run = x5-x2;

            slopeCheck = rise/run;
            tol = 1e-10;
            assert(abs(slopeCheck - obj.slope) < tol)

            rafterX = [
                x1
                x2
                x3
                x4
                x5
                x6
                x7
                x8
                x9
                x10
                ];

            rafterY = [
                y1
                y2
                y3
                y4
                y5
                y6
                y7
                y8
                y9
                y10
                ];

            %LT
            LT = x8 - x7 - (obj.wTP - e);

            %% Rotate coordinates
            %Express coordinates in frame aligned with rough lumber (this
            %makes cutting the rafter easier)

            %Rotation matrix from cartesian frame (F_C) to lumber frame (F_L)
            C_LC = [cos(theta) sin(theta);
                -sin(theta) cos(theta)];

            coordinates_C = [rafterX';
                rafterY'];

            coordinates_L = C_LC*coordinates_C;

            rafterX_L = coordinates_L(1,:)';
            rafterY_L = coordinates_L(2,:)';

            %% Store outputs in data members
            obj.rafterX     = rafterX;
            obj.rafterY     = rafterY;            
            obj.theta       = theta;
            obj.rafterX_L   = rafterX_L;
            obj.rafterY_L   = rafterY_L;
            obj.e           = e;
            obj.LT          = LT;

            assert(obj.checkConsistency(),'Object does not appear consistent')
        end

        function [f] = PlotLeanToRafterGeometry(obj,options)
            %PlotLeanToRafterGeometry Plots the LeanToRafterGeometery
            %
            %   PlotLeanToRafterGeometry(obj) Plots LeanToRafterGeometery
            %   object.
            %
            %   PlotLeanToRafterGeometry(obj,name,val,...) Does as above
            %   but uses the specified options in name/value pairs.
            %
            %INPUT:     -See function
            %
            %OUTPUT:    -f: figure handles
            %
            %Christopher Lum
            %lum@uw.edu

            %Version History
            %07/29/25: Created
            
            arguments
                obj                         (1,1) LeanToRafterGeometry
                options.lineWidth           (1,1) double = 2
                options.markerSize          (1,1) double = 13
                options.colorRafter         (1,3) double = [153 102 0]/255;
                options.colorRafterPoints   (1,3) double = [255 0 0]/255;
            end

            fighA = figure;
            hold on
            %When drawing the full rafter, add a line segment that connects the last
            %and first point
            plot([obj.rafterX;obj.rafterX(1)],...
                [obj.rafterY;obj.rafterY(1)],...
                'LineWidth',options.lineWidth,...
                'MarkerSize',options.markerSize,...
                'Color',options.colorRafter,...
                'DisplayName','Stringer');
            plot(obj.rafterX,obj.rafterY,'o',...
                'LineWidth',options.lineWidth,...
                'MarkerSize',options.markerSize,...
                'Color',options.colorRafterPoints,...
                'DisplayName','Stringer (Points)');

            legend('Location','best','AutoUpdate','off')
            axis('equal')
            legend('Location','best')
            grid on

            %% Lumber frame
            fighB = figure;
            hold on
            plot([obj.rafterX_L;obj.rafterX_L(1)],...
                [obj.rafterY_L;obj.rafterY_L(1)],...
                'LineWidth',options.lineWidth,...
                'MarkerSize',options.markerSize,...
                'Color',options.colorRafter,...
                'DisplayName','Rafter');
            plot(obj.rafterX_L,obj.rafterY_L,'o',...
                'LineWidth',options.lineWidth,...
                'MarkerSize',options.markerSize,...
                'Color',options.colorRafterPoints,...
                'DisplayName','Rafter (Points)');
            axis('equal')
            legend('Location','best','AutoUpdate','off')
            grid on

            f = [fighA;fighB];
        end

        function [coordinatesLow,coordinatesMid] = CutMarkings(obj,options)
            arguments
                obj (1,1) LeanToRafterGeometry
                options.OutputFileCutMarkings   = 'CutMarkingsRafter.csv'
            end

            assert(obj.checkConsistency(),'Object does not appear consistent')

            xCoordinates_L = obj.rafterX_L;
            yCoordinates_L = obj.rafterY_L;

            N = length(xCoordinates_L);

            %compute low and mid
            indicesLow  = [1 2 4 5 7 8]';
            indicesMid  = [3 6]';
            indicesHigh = [9 10]';  %not needed for cuts as these are the edges of the lumber
            
            %Ensure we covered all indices and did not double count
            indicesAll = sort([indicesLow;indicesMid;indicesHigh]);
            indicesCheck = [1:1:N]';

            assert(AreMatricesSame(indicesAll,indicesCheck),'Error computing indices, missing or double counted an index');

            coordinatesLow = [xCoordinates_L(indicesLow) yCoordinates_L(indicesLow)];

            coordinatesMid = [xCoordinates_L(indicesMid) yCoordinates_L(indicesMid)];

            %Export to a csv file
            try
                fid = fopen(options.OutputFileCutMarkings,'w');

                %coordinatesLow
                [M,~] = size(coordinatesLow);
                fprintf(fid,'coordinatesLow\n');
                for m=1:M
                    fprintf(fid,'%f,%f\n',coordinatesLow(m,1),coordinatesLow(m,2));
                end
                fprintf(fid,'\n');

                %coordinatesMid
                [M,~] = size(coordinatesMid);
                fprintf(fid,'coordinatesMid\n');
                for m=1:M
                    fprintf(fid,'%f,%f\n',coordinatesMid(m,1),coordinatesMid(m,2));
                end
                fprintf(fid,'\n');

                %table for 1/16" conversion to decimal
                fprintf(fid,'1/16 fraction to decimal conversion table\n');
                for m=1:15
                    fprintf(fid,'%1.0f/16 = %1.5f\n',m,m/16);
                end
                fprintf(fid,'\n');

            catch ME
                warning(ME.message)
                fclose(fid)
            end

            fclose(fid);
            disp(['Wrote to ',options.OutputFileCutMarkings])
        end

        function [] = ExportToCsvFusion(obj,options)
            %ExportToCsvFusion Exports geometry to csv files for Fusion.
            %
            %   ExportToCsvFusion(obj) Exports various geometries to csv
            %   files that can be imported to Fusion to create objects.
            %   Note that this adds a point at the end which is the same as
            %   the first point so the resulting object can be imported as
            %   a closed profile.
            %
            %INPUT:     -See function
            %
            %OUTPUT:    -None
            %
            %Christopher Lum
            %lum@uw.edu

            %Version History
            %07/29/25: Created

            arguments
                obj (1,1) LeanToRafterGeometry
                options.OutputFileRafter = 'PointsLeanToRafter.csv'
            end

            rafterX           = obj.rafterX;
            rafterY           = obj.rafterY;
            
            %rafter
            rafter = [
                rafterX rafterY;
                rafterX(1) rafterY(1)
                ];

            writematrix(rafter,options.OutputFileRafter,'Delimiter',',');
            disp(['Wrote to ',options.OutputFileRafter])
        end
    end

    %----------------------------------------------------------------------
    %Private methods
    %----------------------------------------------------------------------
    methods (Access='private')
        function [isConsistent] = checkConsistency(obj)
            isConsistent = true;

            %TO DO: Add consistency checks
        end
    end

    %----------------------------------------------------------------------
    %Static methods
    %----------------------------------------------------------------------
    methods(Static)
    end
end
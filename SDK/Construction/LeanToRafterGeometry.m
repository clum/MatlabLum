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
        rafterX           = [];
        rafterY           = [];
        theta               = [];
        % pFMBF               = [];
        % pP                  = [];
        % pCrit               = [];
        % pM                  = [];
        % tMin                = [];
        % riserCoordinates    = [];
        % treadCoordinates    = [];
        rafterX_L         = [];
        rafterY_L         = [];
        % LR                  = [];   %vertical length of riser material
        % LT                  = [];   %horizontal length of tread material
        % LRL                 = [];   %raw lumber length
        e               = [];   %horizontal depth of birdsmouth cut
        LT              = [];   %length of overhang on top side (horizontal projection)

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

            % warning('DELETE BELOW')
            % %Intermediate variables
            % unitRise = obj.rise/obj.numSteps;
            % unitRun  = obj.run/obj.numSteps;
            % 
            % %Compute points
            % stringerX(end+1,1) = 0;
            % stringerY(end+1,1) = 0;
            % 
            % %Get the first point above the subfloor
            % stringerX(end+1,1) = 0;
            % stringerY(end+1,1) = obj.tFMBF + unitRise - obj.tT;
            % 
            % %Get the front faces of each step
            % for k=1:obj.numSteps-1
            %     stringerX(end+1,1) = stringerX(end) + unitRun;
            %     stringerY(end+1,1) = stringerY(end);
            % 
            %     stringerX(end+1,1) = stringerX(end);
            %     stringerY(end+1,1) = stringerY(end) + unitRise;
            % end
            % 
            % %Get the top right point
            % stringerX(end+1,1) = stringerX(end) + unitRun;
            % stringerY(end+1,1) = stringerY(end);
            % 
            % %Get the angle, theta, using points 2 and 4
            % x2 = stringerX(2);
            % y2 = stringerY(2);
            % 
            % x4 = stringerX(4);
            % y4 = stringerY(4);
            % 
            % theta = atan2(y4-y2,x4-x2);
            % thetaCheck = atan2(obj.rise,obj.run);
            % assert(AreMatricesSame(theta,thetaCheck,deg2rad(0.0001)));
            % 
            % %The bottom of the stringer should be slid out as much as possible to
            % 
            % %Compute the projected point
            % pTLx = stringerX(end-1);
            % pTLy = stringerY(end-1);
            % pTL = [pTLx;pTLy];
            % 
            % pTRx = stringerX(end);
            % pTRy = stringerY(end);
            % pTR = [pTRx;pTRy];
            % 
            % v1x = obj.tS*sin(theta);
            % v1y = -obj.tS*cos(theta);
            % 
            % %In some cases it is safer to use the numStep-1 point
            % pTLx_alt = stringerX(end-3);
            % pTLy_alt = stringerY(end-3);
            % pCrit = [stringerX(end-4);stringerY(end-4)];
            % 
            % pPx = pTLx_alt + v1x;
            % pPy = pTLy_alt + v1y;
            % pP = [pPx;pPy];
            % 
            % %Compute pPR.  Do this by projecting pP along the line inclined at angle
            % %theta until the x component is equal to pTRx
            % DT = -(pPx - pTRx)*sec(theta);
            % 
            % pPRx = pPx + DT*cos(theta);
            % pPRy = pPy + DT*sin(theta);
            % pPR = [pPRx;pPRy];
            % 
            % stringerX(end+1,1) = pPRx;
            % stringerY(end+1,1) = pPRy;
            % 
            % %Compute pPL.  Do this by creating a unit vector from pPR towards pP and
            % %then projecting this vector until the x component is equal to 0
            % v = [pPx-pPRx;pPy-pPRy];
            % u = v*(1/norm(v));
            % uy = u(2);
            % 
            % DB = -(pPRy/uy);
            % 
            % pPL = pPR + DB*u;
            % 
            % stringerX(end+1,1) = pPL(1);
            % stringerY(end+1,1) = pPL(2);
            % 
            % %% Compute extra parameters
            % %Minimum thickness distance and points
            % DM = unitRise*sin(theta);
            % pM = pPR + (DT+DM)*u;
            % 
            % tMin = norm(pM - pCrit);
            % 
            % %Coordinates for riser and tread materials
            % for k=1:obj.numSteps
            %     m = 2*k;
            %     xCorner = stringerX(m);
            %     yCorner = stringerY(m);
            % 
            %     %riser
            %     xMinR = xCorner-obj.tR;
            %     xMaxR = xCorner;
            % 
            %     yMinR = yCorner-unitRise+obj.tT;
            %     yMaxR = yCorner;
            %     LR = yMaxR - yMinR;
            % 
            %     xRiser = [xMinR;xMaxR;xMaxR;xMinR];
            %     yRiser = [yMinR;yMinR;yMaxR;yMaxR];
            % 
            %     riserCoordinates{k} = [xRiser yRiser];
            % 
            %     %tread
            %     xMinT = xCorner-obj.tR;
            %     xMaxT = xCorner+unitRun;
            %     LT = xMaxT - xMinT;
            % 
            %     yMinT = yCorner;
            %     yMaxT = yCorner+obj.tT;
            % 
            %     xTread = [xMinT;xMaxT;xMaxT;xMinT];
            %     yTread = [yMinT;yMinT;yMaxT;yMaxT];
            % 
            %     treadCoordinates{k} = [xTread yTread];
            % end

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
            % obj.pFMBF               = [0;obj.tFMBF];
            % obj.pP                  = [pPx;pPy];
            % obj.pCrit               = pCrit;
            % obj.pM                  = pM;
            % obj.tMin                = tMin;
            % obj.riserCoordinates    = riserCoordinates;
            % obj.treadCoordinates    = treadCoordinates;
            obj.rafterX_L   = rafterX_L;
            obj.rafterY_L   = rafterY_L;
            % obj.LRL                 = LRL;
            % obj.LR                  = LR;
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
                % options.colorFMBF           (1,3) double = [255 51 153]/255;
                % options.colorpP             (1,3) double = [0 255 0]/255;
                % options.colorpCrit          (1,3) double = [255 192 0]/255;
                % options.colorpM             (1,3) double = [255 192 0]/255;
                % options.colorRisers         (1,3) double = [112 48 160]/255;
                % options.colorTreads         (1,3) double = [146 208 80]/255;
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

            % plot(obj.pFMBF(1),obj.pFMBF(2),'^',...
            %     'LineWidth',options.lineWidth,...
            %     'MarkerSize',options.markerSize,...
            %     'Color',options.colorFMBF,...
            %     'DisplayName','pFMBF')
            % 
            % plot(obj.pP(1),obj.pP(2),'o',...
            %     'LineWidth',options.lineWidth,...
            %     'MarkerSize',options.markerSize,...
            %     'Color',options.colorpP,...
            %     'DisplayName','pP')
            % 
            % plot(obj.pCrit(1),obj.pCrit(2),'x',...
            %     'LineWidth',options.lineWidth,...
            %     'MarkerSize',options.markerSize,...
            %     'Color',options.colorpCrit,...
            %     'DisplayName','pCrit')
            % 
            % plot(obj.pM(1),obj.pM(2),'o',...
            %     'LineWidth',options.lineWidth,...
            %     'MarkerSize',options.markerSize,...
            %     'Color',options.colorpM,...
            %     'DisplayName',['pM (tMin = ',num2str(obj.tMin),')'])

            legend('Location','best','AutoUpdate','off')

            % %Plot the risers and treads.  When drawing, add a line segment that
            % %connects the last and first point
            % for k=1:obj.numSteps
            %     riserCoordinates_k = obj.riserCoordinates{k};
            %     treadCoordinates_k = obj.treadCoordinates{k};
            % 
            %     plot([riserCoordinates_k(:,1);riserCoordinates_k(1,1)],...
            %         [riserCoordinates_k(:,2);riserCoordinates_k(1,2)],'--',...
            %         'LineWidth',options.lineWidth,...
            %         'Color',options.colorRisers)
            % 
            %     plot([treadCoordinates_k(:,1);treadCoordinates_k(1,1)],...
            %         [treadCoordinates_k(:,2);treadCoordinates_k(1,2)],'--',...
            %         'LineWidth',options.lineWidth,...
            %         'Color',options.colorTreads)
            % end

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

            % %Check critical dimension calculation
            % distanceCheck = abs(norm(obj.pP - obj.pCrit) - obj.tS);
            % 
            % if(distanceCheck > obj.tS/10000)
            %     isConsisent = false;
            %     return
            % end

        end
    end

    %----------------------------------------------------------------------
    %Static methods
    %----------------------------------------------------------------------
    methods(Static)
    end
end
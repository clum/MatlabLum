classdef StairsGeometry < handle
    %Class for computing geometry related to stairs.
    %
    %Christopher Lum
    %lum@uw.edu

    %03/09/25: Created
    %04/12/25: Finished work.
    %06/24/25: Updated for riser and tread material
    %06/26/25: Continued working
    %06/27/25: Changing to output to stairStruct object.
    %06/28/25: Added rotation.  Converted to class
    %06/30/25: Changed property names
    %07/02/25: Added LR and LT (rise and tread dimensions)
    %07/03/25: Added VaryNumSteps
    %07/28/25: Documentation update

    %----------------------------------------------------------------------
    %Public properties/fields
    %----------------------------------------------------------------------
    properties (GetAccess='public', SetAccess='public')
        rise        = 8*12;
        run         = 9*12;
        numSteps    = 14;
        tR          = 7/16 + 0.35;          %thickness of riser material (ie OSB + carpet)
        tT          = 23/32 + 0.35;         %thickness of tread material (ie 2-by material + carpet)
        tFMBF       = 1 + 7/16 + 0.27;      %thickness of finished material on bottom floor (ie insulation + OSB + vinyl flooring)
        tS          = 11.25;                %thickness of stringer member (2x10 = 9.25", 2x12 = 11.25")
    end

    %----------------------------------------------------------------------
    %Public Get but Private Set properties/fields
    %----------------------------------------------------------------------
    properties (GetAccess='public', SetAccess='private')
        stringerX           = [];
        stringerY           = [];
        unitRise            = [];
        unitRun             = [];
        theta               = [];
        pFMBF               = [];
        pP                  = [];
        pCrit               = [];
        pM                  = [];
        tMin                = [];
        riserCoordinates    = [];
        treadCoordinates    = [];
        stringerX_L         = [];
        stringerY_L         = [];
        LR                  = [];   %vertical length of riser material
        LT                  = [];   %horizontal length of tread material
        LRL                 = [];   %raw lumber length
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
        function obj = StairsGeometry(rise,run,numSteps,tR,tT,tFMBF,tS)
            %StairsGeometry  Constructor for the object
            %
            %   [OBJ] = StairsGeometry(...
            %
            %INPUT:     -see function
            %
            %OUTPUT:    -OBJ:   StairsGeometry object
            %
            %Christopher Lum
            %lum@uw.edu

            %Version History
            %06/28/25: Created

            arguments
                rise        (1,1) double
                run         (1,1) double
                numSteps    (1,1) double {mustBeInteger}
                tR          (1,1) double = 0
                tT          (1,1) double = 0
                tFMBF       (1,1) double = 0
                tS          (1,1) double = 11.25
            end

            obj.rise        = rise;
            obj.run         = run;
            obj.numSteps    = numSteps;
            obj.tR          = tR;
            obj.tT          = tT;
            obj.tFMBF       = tFMBF;
            obj.tS          = tS;

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
            disp(['rise     = ',num2str(obj.rise)])
            disp(['run      = ',num2str(obj.run)])
            disp(['numSteps = ',num2str(obj.numSteps)])
            disp(['tR       = ',num2str(obj.tR)])
            disp(['tT       = ',num2str(obj.tT)])
            disp(['tFMBF    = ',num2str(obj.tFMBF)])
            disp(['tS       = ',num2str(obj.tS)])
            disp(' ')
            disp('Selected Derived Parameters')
            disp('---------------------------')
            disp(['unitRise       = ',num2str(obj.unitRise)])
            disp(['unitRun        = ',num2str(obj.unitRun)])
            disp(['rad2deg(theta) = ',num2str(rad2deg(obj.theta))])
            disp(['tMin           = ',num2str(obj.tMin)])
            disp(['LR             = ',num2str(obj.LR)])
            disp(['LT             = ',num2str(obj.LT)])
            disp(['LRL            = ',num2str(obj.LRL)])
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
            %03/09/25: Created
            %04/12/25: Finished work.
            %06/24/25: Updated for riser and tread material
            %06/26/25: Continued working
            %06/27/25: Changing to output to stairStruct object.
            %06/28/25: Added rotation.  Moved to class
            %07/02/25: Added LR and LT parameter calculation

            %% Initialize containers
            stringerX = [];
            stringerY = [];

            %% Calculations
            %Intermediate variables
            unitRise = obj.rise/obj.numSteps;
            unitRun  = obj.run/obj.numSteps;

            %Compute points
            stringerX(end+1,1) = 0;
            stringerY(end+1,1) = 0;

            %Get the first point above the subfloor
            stringerX(end+1,1) = 0;
            stringerY(end+1,1) = obj.tFMBF + unitRise - obj.tT;

            %Get the front faces of each step
            for k=1:obj.numSteps-1
                stringerX(end+1,1) = stringerX(end) + unitRun;
                stringerY(end+1,1) = stringerY(end);

                stringerX(end+1,1) = stringerX(end);
                stringerY(end+1,1) = stringerY(end) + unitRise;
            end

            %Get the top right point
            stringerX(end+1,1) = stringerX(end) + unitRun;
            stringerY(end+1,1) = stringerY(end);

            %Get the angle, theta, using points 2 and 4
            x2 = stringerX(2);
            y2 = stringerY(2);

            x4 = stringerX(4);
            y4 = stringerY(4);

            theta = atan2(y4-y2,x4-x2);
            thetaCheck = atan2(obj.rise,obj.run);
            assert(AreMatricesSame(theta,thetaCheck,deg2rad(0.0001)));

            %The bottom of the stringer should be slid out as much as possible to

            %Compute the projected point
            pTLx = stringerX(end-1);
            pTLy = stringerY(end-1);
            pTL = [pTLx;pTLy];

            pTRx = stringerX(end);
            pTRy = stringerY(end);
            pTR = [pTRx;pTRy];

            v1x = obj.tS*sin(theta);
            v1y = -obj.tS*cos(theta);

            %In some cases it is safer to use the numStep-1 point
            pTLx_alt = stringerX(end-3);
            pTLy_alt = stringerY(end-3);
            pCrit = [stringerX(end-4);stringerY(end-4)];

            pPx = pTLx_alt + v1x;
            pPy = pTLy_alt + v1y;
            pP = [pPx;pPy];

            %Compute pPR.  Do this by projecting pP along the line inclined at angle
            %theta until the x component is equal to pTRx
            DT = -(pPx - pTRx)*sec(theta);

            pPRx = pPx + DT*cos(theta);
            pPRy = pPy + DT*sin(theta);
            pPR = [pPRx;pPRy];

            stringerX(end+1,1) = pPRx;
            stringerY(end+1,1) = pPRy;

            %Compute pPL.  Do this by creating a unit vector from pPR towards pP and
            %then projecting this vector until the x component is equal to 0
            v = [pPx-pPRx;pPy-pPRy];
            u = v*(1/norm(v));
            uy = u(2);

            DB = -(pPRy/uy);

            pPL = pPR + DB*u;

            stringerX(end+1,1) = pPL(1);
            stringerY(end+1,1) = pPL(2);

            %% Compute extra parameters
            %Minimum thickness distance and points
            DM = unitRise*sin(theta);
            pM = pPR + (DT+DM)*u;

            tMin = norm(pM - pCrit);

            %Coordinates for riser and tread materials
            for k=1:obj.numSteps
                m = 2*k;
                xCorner = stringerX(m);
                yCorner = stringerY(m);

                %riser
                xMinR = xCorner-obj.tR;
                xMaxR = xCorner;

                yMinR = yCorner-unitRise+obj.tT;
                yMaxR = yCorner;
                LR = yMaxR - yMinR;

                xRiser = [xMinR;xMaxR;xMaxR;xMinR];
                yRiser = [yMinR;yMinR;yMaxR;yMaxR];

                riserCoordinates{k} = [xRiser yRiser];

                %tread
                xMinT = xCorner-obj.tR;
                xMaxT = xCorner+unitRun;
                LT = xMaxT - xMinT;

                yMinT = yCorner;
                yMaxT = yCorner+obj.tT;

                xTread = [xMinT;xMaxT;xMaxT;xMinT];
                yTread = [yMinT;yMinT;yMaxT;yMaxT];

                treadCoordinates{k} = [xTread yTread];
            end

            %% Rotate coordinates
            %Express coordinates in frame aligned with rough lumber (this makes cutting
            %the stringer easier)

            %Rotation matrix from cartesian frame (F_C) to lumber frame (F_L)
            C_LC = [cos(theta) sin(theta);
                -sin(theta) cos(theta)];

            coordinates_C = [stringerX';
                stringerY'];

            coordinates_L = C_LC*coordinates_C;

            stringerX_L = coordinates_L(1,:)';
            stringerY_L = coordinates_L(2,:)';

            %offset yCoordinates_L so it starts at 0
            stringerY_L = stringerY_L - stringerY_L(end);

            %length of raw lumber before cuts
            LRL = stringerX_L(end-2);

            %% Store outputs in data members
            obj.stringerX           = stringerX;
            obj.stringerY           = stringerY;
            obj.unitRise            = unitRise;
            obj.unitRun             = unitRun;
            obj.theta               = theta;
            obj.pFMBF               = [0;obj.tFMBF];
            obj.pP                  = [pPx;pPy];
            obj.pCrit               = pCrit;
            obj.pM                  = pM;
            obj.tMin                = tMin;
            obj.riserCoordinates    = riserCoordinates;
            obj.treadCoordinates    = treadCoordinates;
            obj.stringerX_L         = stringerX_L;
            obj.stringerY_L         = stringerY_L;
            obj.LRL                 = LRL;
            obj.LR                  = LR;
            obj.LT                  = LT;

            assert(obj.checkConsistency(),'Object does not appear consistent')
        end

        function [f] = PlotStairsGeometry(obj,options)
            %PlotStairsGeometry Plots the StairsGeometery
            %
            %   PlotStairsGeometry(obj) Plots the StairsGeometry object.
            %
            %   PlotStairsGeometry(obj,name,val,...) Does as above but uses
            %   the specified options in name/value pairs.
            %
            %INPUT:     -See function
            %
            %OUTPUT:    -f: figure handle
            %
            %Christopher Lum
            %lum@uw.edu

            %Version History
            %06/27/25: Created
            %07/03/25: Turned off autoupdate and added tMin display
            %07/29/25: Minor documentation update

            arguments
                obj                         (1,1) StairsGeometry
                options.lineWidth           (1,1) double = 2
                options.markerSize          (1,1) double = 13
                options.colorStringer       (1,3) double = [153 102 0]/255;
                options.colorStringerPoints (1,3) double = [255 0 0]/255;
                options.colorFMBF           (1,3) double = [255 51 153]/255;
                options.colorpP             (1,3) double = [0 255 0]/255;
                options.colorpCrit          (1,3) double = [255 192 0]/255;
                options.colorpM             (1,3) double = [255 192 0]/255;
                options.colorRisers         (1,3) double = [112 48 160]/255;
                options.colorTreads         (1,3) double = [146 208 80]/255;
            end

            fighA = figure;
            hold on
            %When drawing the full stinger, add a line segment that connects the last
            %and first point
            plot([obj.stringerX;obj.stringerX(1)],...
                [obj.stringerY;obj.stringerY(1)],...
                'LineWidth',options.lineWidth,...
                'MarkerSize',options.markerSize,...
                'Color',options.colorStringer,...
                'DisplayName','Stringer');
            plot(obj.stringerX,obj.stringerY,'o',...
                'LineWidth',options.lineWidth,...
                'MarkerSize',options.markerSize,...
                'Color',options.colorStringerPoints,...
                'DisplayName','Stringer (Points)');

            plot(obj.pFMBF(1),obj.pFMBF(2),'^',...
                'LineWidth',options.lineWidth,...
                'MarkerSize',options.markerSize,...
                'Color',options.colorFMBF,...
                'DisplayName','pFMBF')

            plot(obj.pP(1),obj.pP(2),'o',...
                'LineWidth',options.lineWidth,...
                'MarkerSize',options.markerSize,...
                'Color',options.colorpP,...
                'DisplayName','pP')

            plot(obj.pCrit(1),obj.pCrit(2),'x',...
                'LineWidth',options.lineWidth,...
                'MarkerSize',options.markerSize,...
                'Color',options.colorpCrit,...
                'DisplayName','pCrit')

            plot(obj.pM(1),obj.pM(2),'o',...
                'LineWidth',options.lineWidth,...
                'MarkerSize',options.markerSize,...
                'Color',options.colorpM,...
                'DisplayName',['pM (tMin = ',num2str(obj.tMin),')'])

            legend('Location','best','AutoUpdate','off')

            %Plot the risers and treads.  When drawing, add a line segment that
            %connects the last and first point
            for k=1:obj.numSteps
                riserCoordinates_k = obj.riserCoordinates{k};
                treadCoordinates_k = obj.treadCoordinates{k};

                plot([riserCoordinates_k(:,1);riserCoordinates_k(1,1)],...
                    [riserCoordinates_k(:,2);riserCoordinates_k(1,2)],'--',...
                    'LineWidth',options.lineWidth,...
                    'Color',options.colorRisers)

                plot([treadCoordinates_k(:,1);treadCoordinates_k(1,1)],...
                    [treadCoordinates_k(:,2);treadCoordinates_k(1,2)],'--',...
                    'LineWidth',options.lineWidth,...
                    'Color',options.colorTreads)
            end

            axis('equal')
            legend('Location','best')
            grid on

            %% Lumber frame
            fighB = figure;
            hold on
            plot([obj.stringerX_L;obj.stringerX_L(1)],...
                [obj.stringerY_L;obj.stringerY_L(1)],...
                'LineWidth',options.lineWidth,...
                'MarkerSize',options.markerSize,...
                'Color',options.colorStringer,...
                'DisplayName','Stringer');
            plot(obj.stringerX_L,obj.stringerY_L,'o',...
                'LineWidth',options.lineWidth,...
                'MarkerSize',options.markerSize,...
                'Color',options.colorStringerPoints,...
                'DisplayName','Stringer (Points)');
            axis('equal')
            legend('Location','best','AutoUpdate','off')
            grid on

            f = [fighA;fighB];
        end

        function [coordinatesLow,coordinatesMid,coordinatesHigh,coordinatesBottomLeft] = CutMarkings(obj,options)
            arguments
                obj (1,1) StairsGeometry
                options.OutputFileCutMarkings   = 'CutMarkings.csv'
            end

            assert(obj.checkConsistency(),'Object does not appear consistent')

            xCoordinates_L = obj.stringerX_L;
            yCoordinates_L = obj.stringerY_L;

            N = length(xCoordinates_L);

            %compute low, mid, and high indices
            indicesLow  = [N;N-1];
            indicesMid  = [];
            indicesHigh = [];
            for k=1:obj.numSteps
                indicesHigh = [indicesHigh;2*k];
                indicesMid = [indicesMid;2*k+1];
            end

            %get index of bottom left point (this is different from rest)
            indexBottomLeft = 1;

            %Ensure we covered all indices and did not double count
            indicesAll = sort([indicesLow;indicesMid;indicesHigh;indexBottomLeft]);
            indicesCheck = [1:1:N]';

            assert(AreMatricesSame(indicesAll,indicesCheck),'Error computing indices, missing or double counted an index');

            coordinatesLow = [xCoordinates_L(indicesLow) yCoordinates_L(indicesLow)];

            coordinatesMid = [xCoordinates_L(indicesMid) yCoordinates_L(indicesMid)];

            coordinatesHigh = [xCoordinates_L(indicesHigh) yCoordinates_L(indicesHigh)];

            coordinatesBottomLeft = [xCoordinates_L(indexBottomLeft) yCoordinates_L(indexBottomLeft)];

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
                
                %coordinatesHigh
                [M,~] = size(coordinatesHigh);
                fprintf(fid,'coordinatesHigh\n');
                for m=1:M
                    fprintf(fid,'%f,%f\n',coordinatesHigh(m,1),coordinatesHigh(m,2));
                end
                fprintf(fid,'\n');

                %coordinatesBottomLeft
                [M,~] = size(coordinatesBottomLeft);
                fprintf(fid,'coordinatesBottomLeft\n');
                for m=1:M
                    fprintf(fid,'%f,%f\n',coordinatesBottomLeft(m,1),coordinatesBottomLeft(m,2));
                end
                fprintf(fid,'\n');

                %table for 1/16" conversion to decimal
                fprintf(fid,'1/16 fraction to decimal conversion table\n');
                for m=1:15
                    fprintf(fid,'%1.0f/16 = %1.5f\n',m,m/16);
                end
                fprintf(fid,'\n')

            catch ME
                warning(ME.message)
                fclose(fid)
            end

            fclose(fid);
            disp(['Wrote to ',options.OutputFileCutMarkings])
        end

        function [] = VaryNumSteps(obj,numStepsVec,options)
            %VaryNumSteps Varies number of steps.
            %
            %   VaryNumSteps(obj,numStepsVec) Varies the number of steps
            %   and performs analysis to help select a suitable
            %   configuration.
            %
            %INPUT:     -See function
            %
            %OUTPUT:    -None
            %
            %See also StairsGeometry
            %
            %Christopher Lum
            %lum@uw.edu

            %Version History
            %07/02/25: Created
            %07/03/25: Updated

            arguments
                obj                                     (1,1) StairsGeometry
                numStepsVec
                options.PlotIndividualConfigurations    (1,1) logical = false
                options.lineWidth                       (1,1) double = 2
                options.markerSize                      (1,1) double = 13
            end

            %Parameters
            riserHeightMin_in = 4;
            riserHeightMax_in = 7.75;

            treadDepthMin_in = 11;

            thetaMax_rad = atan2(7,11);

            %store numSteps
            numStepsOriginal = obj.numSteps;

            %Vary numSteps and obtain
            unitRiseVec = zeros(size(numStepsVec));
            unitRunVec  = zeros(size(numStepsVec));
            thetaVec    = zeros(size(numStepsVec));
            tMinVec     = zeros(size(numStepsVec));
            LRVec       = zeros(size(numStepsVec));
            LTVec       = zeros(size(numStepsVec));
            LRLVec      = zeros(size(numStepsVec));

            for k=1:length(numStepsVec)
                obj.numSteps = numStepsVec(k);
                obj.UpdateDerivedParameters();

                unitRiseVec(k)  = obj.unitRise;
                unitRunVec(k)   = obj.unitRun;
                thetaVec(k)     = obj.theta;
                tMinVec(k)      = obj.tMin;
                LRVec(k)        = obj.LR;
                LTVec(k)        = obj.LT;
                LRLVec(k)       = obj.LRL;

                if(options.PlotIndividualConfigurations)
                    obj.PlotStairsGeometry();
                end
            end

            %Plot results
            figure
            subplot(7,1,1)
            hold on
            plot(numStepsVec,unitRiseVec,'ro',...
                'MarkerSize',options.markerSize,'LineWidth',options.lineWidth,'DisplayName','unitRise');
            plot(numStepsVec,riserHeightMin_in*ones(size(numStepsVec)),'m--',...
                'LineWidth',options.lineWidth,'DisplayName',StringWithUnderscoresForPlot(['riserHeightMin_in = ',num2str(riserHeightMin_in)]))
            plot(numStepsVec,riserHeightMax_in*ones(size(numStepsVec)),'m--',...
                'LineWidth',options.lineWidth,'DisplayName',StringWithUnderscoresForPlot(['riserHeightMax_in = ',num2str(riserHeightMax_in)]))
            grid on
            legend('Location','best')

            subplot(7,1,2)
            hold on
            plot(numStepsVec,unitRunVec,'ro',...
                'MarkerSize',options.markerSize,'LineWidth',options.lineWidth,'DisplayName','unitRun');
            plot(numStepsVec,treadDepthMin_in*ones(size(numStepsVec)),'m--',...
                'LineWidth',options.lineWidth,'DisplayName',StringWithUnderscoresForPlot(['treadDepthMin_in = ',num2str(treadDepthMin_in)]))
            grid on
            legend('Location','best')

            subplot(7,1,3)
            hold on
            plot(numStepsVec,rad2deg(thetaVec),'ro',...
                'MarkerSize',options.markerSize,'LineWidth',options.lineWidth,'DisplayName','rad2deg(theta)');
            plot(numStepsVec,rad2deg(thetaMax_rad)*ones(size(numStepsVec)),'m--',...
                'LineWidth',options.lineWidth,'DisplayName',StringWithUnderscoresForPlot(['rad2deg(thetaMax_rad) = ',num2str(rad2deg(thetaMax_rad))]))
            grid on
            legend('Location','best')

            subplot(7,1,4)
            plot(numStepsVec,tMinVec,'ro',...
                'MarkerSize',options.markerSize,'LineWidth',options.lineWidth,'DisplayName','tMin');
            grid on
            legend('Location','best')

            subplot(7,1,5)
            plot(numStepsVec,LRVec,'ro',...
                'MarkerSize',options.markerSize,'LineWidth',options.lineWidth,'DisplayName','LR');
            grid on
            legend('Location','best')

            subplot(7,1,6)
            plot(numStepsVec,LTVec,'ro',...
                'MarkerSize',options.markerSize,'LineWidth',options.lineWidth,'DisplayName','LT');
            grid on
            legend('Location','best')

            subplot(7,1,7)
            plot(numStepsVec,LRLVec,'ro',...
                'MarkerSize',options.markerSize,'LineWidth',options.lineWidth,'DisplayName','LRL');
            grid on
            legend('Location','best')
            xlabel('Number Steps')

            %Restore original numSteps
            obj.numSteps = numStepsOriginal;
            obj.UpdateDerivedParameters();
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
            %07/04/25: Created

            arguments
                obj (1,1) StairsGeometry
                options.OutputFileStringer                  = 'PointsStringer.csv'
                options.OutputFileRiserFinishedMaterial     = 'PointsRiserFinishedMaterial.csv'
                options.OutputFileTreadFinishedMaterial     = 'PointsTreadFinishedMaterial.csv'
            end

            stringerX           = obj.stringerX;
            stringerY           = obj.stringerY;
            riserCoordinates    = obj.riserCoordinates;
            treadCoordinates    = obj.treadCoordinates;

            %stringer
            stringer = [
                stringerX stringerY;
                stringerX(1) stringerY(1)
                ];

            writematrix(stringer,options.OutputFileStringer,'Delimiter',',');
            disp(['Wrote to ',options.OutputFileStringer])

            %RiserFinishedMaterial
            try
                fid2 = fopen(options.OutputFileRiserFinishedMaterial,'w');
                for k=1:length(riserCoordinates)
                    riserCoordinates_k = riserCoordinates{k};

                    for m=1:length(riserCoordinates_k)
                        fprintf(fid2,'%f,%f\n',riserCoordinates_k(m,1),riserCoordinates_k(m,2));
                    end

                    %add a point at the start to close the profile
                    fprintf(fid2,'%f,%f\n',riserCoordinates_k(1,1),riserCoordinates_k(1,2));

                    fprintf(fid2,'\n');
                end

            catch ME
                warning(ME.message)
                fclose(fid2)
            end

            fclose(fid2);
            disp(['Wrote to ',options.OutputFileRiserFinishedMaterial])

            %TreadFinishedMaterial
            try
                fid3 = fopen(options.OutputFileTreadFinishedMaterial,'w');
                for k=1:length(treadCoordinates)
                    treadCoordinates_k = treadCoordinates{k};

                    for m=1:length(treadCoordinates_k)
                        fprintf(fid3,'%f,%f\n',treadCoordinates_k(m,1),treadCoordinates_k(m,2));
                    end

                    %add a point at the start to close the profile
                    fprintf(fid3,'%f,%f\n',treadCoordinates_k(1,1),treadCoordinates_k(1,2));

                    fprintf(fid3,'\n');
                end

            catch ME
                warning(ME.message)
                fclose(fid3)
            end

            fclose(fid3);
            disp(['Wrote to ',options.OutputFileTreadFinishedMaterial])
        end
    end

    %----------------------------------------------------------------------
    %Private methods
    %----------------------------------------------------------------------
    methods (Access='private')
        function [isConsistent] = checkConsistency(obj)
            isConsistent = true;

            %Check critical dimension calculation
            distanceCheck = abs(norm(obj.pP - obj.pCrit) - obj.tS);

            if(distanceCheck > obj.tS/10000)
                isConsisent = false;
                return
            end

        end
    end

    %----------------------------------------------------------------------
    %Static methods
    %----------------------------------------------------------------------
    methods(Static)
    end

end
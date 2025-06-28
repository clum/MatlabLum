classdef StairsGeometry
    %Class for computing geometry related to stairs.
    %
    %Christopher Lum
    %lum@uw.edu

    %03/09/25: Created
    %04/12/25: Finished wvork.
    %06/24/25: Updated for riser and tread material
    %06/26/25: Continued working
    %06/27/25: Changing to output to stairStruct object.
    %06/28/25: Added rotation.  Converted to class

    %----------------------------------------------------------------------
    %Public properties/fields
    %----------------------------------------------------------------------
    properties (GetAccess='public', SetAccess='public')
        rise        = 8*12;
        run         = 9*12;
        numSteps    = 14;
        tR          = 7/16 + 0.35;       %OSB + carpet
        tT          = 23/32 + 0.35;
        tFMBF       = 1 + 7/16 + 0.27;     %insulation + OSB + vinyl flooring
        tS          = 11.25;  %2x10 = 9.25", 2x12 = 11.25"
    end

    %----------------------------------------------------------------------
    %Private properties/fields
    %----------------------------------------------------------------------
    properties (GetAccess='private', SetAccess='private')
        xCoordinates        = [];
        yCoordinates        = [];
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
        xCoordinates_L      = [];
        yCoordinates_L      = [];
        LT                  = [];
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
        end

        %Destructor
        function delete(obj)
        end

        %Get/Set

        %Class API
        function [obj] = ComputeDerivedParameters(obj)
            %computeDerivedParameters Computes derived parameters
            %
            %   computeDerivedParameters() Computes parameters that are
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

            %% Initialize containers
            xCoordinates        = [];
            yCoordinates        = [];

            %% Calculations
            %Intermediate variables
            unitRise = obj.rise/obj.numSteps;
            unitRun  = obj.run/obj.numSteps;

            %Compute points
            xCoordinates(end+1,1) = 0;
            yCoordinates(end+1,1) = 0;

            %Get the first point above the subfloor
            xCoordinates(end+1,1) = 0;
            yCoordinates(end+1,1) = obj.tFMBF + unitRise - obj.tT;

            %Get the front faces of each step
            for k=1:obj.numSteps-1
                xCoordinates(end+1,1) = xCoordinates(end) + unitRun;
                yCoordinates(end+1,1) = yCoordinates(end);

                xCoordinates(end+1,1) = xCoordinates(end);
                yCoordinates(end+1,1) = yCoordinates(end) + unitRise;
            end

            %Get the top right point
            xCoordinates(end+1,1) = xCoordinates(end) + unitRun - obj.tR;
            yCoordinates(end+1,1) = yCoordinates(end);

            %Get the angle, theta, using points 2 and 4
            x2 = xCoordinates(2);
            y2 = yCoordinates(2);

            x4 = xCoordinates(4);
            y4 = yCoordinates(4);

            theta = atan2(y4-y2,x4-x2);

            %The bottom of the stringer should be slid out as much as possible to

            %Compute the projected point
            pTLx = xCoordinates(end-1);
            pTLy = yCoordinates(end-1);
            pTL = [pTLx;pTLy];

            v1x = obj.tS*sin(theta);
            v1y = -obj.tS*cos(theta);

            pPx = pTLx + v1x;
            pPy = pTLy + v1y;
            pP = [pPx;pPy];

            distanceCheck = abs(norm([pPx;pPy]-[pTLx;pTLy]) - obj.tS);
            assert(distanceCheck < obj.tS/10000,'Error in computation, pP does not appear correct')

            %Compute pPR.  Do this by projecting pP along the line inclined at angle
            %theta until the x component is equal to pTRx
            pTRx = xCoordinates(end);
            pTRy = yCoordinates(end);
            pTR = [pTRx;pTRy];

            DT = -(pPx - pTRx)*sec(theta);

            pPRx = pPx + DT*cos(theta);
            pPRy = pPy + DT*sin(theta);
            pPR = [pPRx;pPRy];

            xCoordinates(end+1,1) = pPRx;
            yCoordinates(end+1,1) = pPRy;

            %Compute pPL.  Do this by creating a unit vector from pPR towards pP and
            %then projecting this vector until the x component is equal to 0
            v = [pPx-pPRx;pPy-pPRy];
            u = v*(1/norm(v));
            uy = u(2);

            DB = -(pPRy/uy);

            pPL = pPR + DB*u;

            xCoordinates(end+1,1) = pPL(1);
            yCoordinates(end+1,1) = pPL(2);

            %% Compute extra parameters
            %Minimum thickness distance and points
            DM = unitRise*sin(theta);
            pM = pPR + (DT+DM)*u;

            pCrit = [xCoordinates(end-4);yCoordinates(end-4)];
            tMin = norm(pM - pCrit);

            %Coordinates for riser and tread materials
            for k=1:obj.numSteps
                m = 2*k;
                xCorner = xCoordinates(m);
                yCorner = yCoordinates(m);

                %riser
                xMinR = xCorner-obj.tR;
                xMaxR = xCorner;

                yMinR = yCorner-unitRise+obj.tT;
                yMaxR = yCorner;

                xRiser = [xMinR;xMaxR;xMaxR;xMinR];
                yRiser = [yMinR;yMinR;yMaxR;yMaxR];

                riserCoordinates{k} = [xRiser yRiser];

                %tread
                xMinT = xCorner-obj.tR;
                xMaxT = xCorner+unitRun;

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

            coordinates_C = [xCoordinates';
                yCoordinates'];

            coordinates_L = C_LC*coordinates_C;

            xCoordinates_L = coordinates_L(1,:)';
            yCoordinates_L = coordinates_L(2,:)';

            %offset yCoordinates_L so it starts at 0
            yCoordinates_L = yCoordinates_L - yCoordinates_L(end);

            %length of lumber before cuts
            LT = xCoordinates_L(end-2);

            %% Store outputs in data members
            obj.xCoordinates        = xCoordinates;
            obj.yCoordinates        = yCoordinates;
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
            obj.xCoordinates_L      = xCoordinates_L;
            obj.yCoordinates_L      = yCoordinates_L;
            obj.LT                  = LT;
        end

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
            disp(['LT             = ',num2str(obj.LT)])
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

end
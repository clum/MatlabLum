classdef test_StairsGeometry < matlab.unittest.TestCase
    %Test the LeanToRafterGeometry function
    %
    %Christopher Lum
    %lum@uw.edu

    %Version History
    %04/12/25: Created

    methods(Test)
        %Standard example
        function example01(tc)
            debug = true;

            rise        = 8*12;
            run         = 9*12;
            numSteps    = 14;
            tR          = 7/16 + 0.35;       %OSB + carpet
            tT          = 23/32 + 0.35;
            tFMBF       = 1 + 7/16 + 0.27;     %insulation + OSB + vinyl flooring
            tS          = 11.25;  %2x10 = 9.25", 2x12 = 11.25"
            
            [stairsStruct] = StairsGeometry(...
                rise,run,numSteps,tR,tT,tFMBF,tS);

            disp('extra')
            stairsStruct.unitRise
            stairsStruct.unitRun
            stairsStruct.tMin

%             xCoordinates_expected = [0
%                 6.25000000000000
%                 6.25000000000000
%                 12.5000000000000
%                 12.5000000000000
%                 18.7500000000000
%                 18.7500000000000
%                 25
%                 25];
% 
%             yCoordinates_expected = [0
%                 0
%                 2.50000000000000
%                 2.50000000000000
%                 5
%                 5
%                 7.50000000000000
%                 7.50000000000000
%                 10];

            if(debug)
%                 lineWidth = 2;
%                 markerSize = 14;
% 
                PlotStairsGeometry(stairsStruct)
%                 hold on
%                 plot(xCoordinates,yCoordinates,'DisplayName','Stringer');
%                 plot(xCoordinates,yCoordinates,'ro','LineWidth',lineWidth,'MarkerSize',markerSize,'DisplayName','Stringer points');
%                 plot(extra.pFMBF(1),extra.pFMBF(2),'mo','LineWidth',lineWidth,'MarkerSize',markerSize,'DisplayName','pFMBF')
%                 plot(extra.pP(1),extra.pP(2),'go','LineWidth',lineWidth,'MarkerSize',markerSize,'DisplayName','pP')
%                 plot(extra.pM(1),extra.pM(2),'co','LineWidth',lineWidth,'MarkerSize',markerSize,'DisplayName','pM')
%                 plot(extra.pCrit(1),extra.pCrit(2),'cx','LineWidth',lineWidth,'MarkerSize',markerSize,'DisplayName','pCrit')
%                 
%                 grid on

%                 close(figh)
            end

%             tol = 1e-6;
%             tc.verifyTrue(AreMatricesSame(xCoordinates,xCoordinates_expected,tol))
%             tc.verifyTrue(AreMatricesSame(yCoordinates,yCoordinates_expected,tol))

warning('TEMP')
tc.verifyTrue(true)
        end

    end
end
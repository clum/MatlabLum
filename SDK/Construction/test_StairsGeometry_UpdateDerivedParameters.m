classdef test_StairsGeometry_ComputeDerivedParameters < matlab.unittest.TestCase
    %Test the StairsGeometry.ComputeDerivedParameters method
    %
    %Christopher Lum
    %lum@uw.edu

    %Version History
    %06/28/25: Created

    methods(Test)
        %Standard example
        function example01(tc)
            scenarioID = 1;
            [rise,run,numSteps,tR,tT,tFMBF,tS] = StairsGeometryScenarios(scenarioID);

            [stairsGeometry] = StairsGeometry(...
                rise,run,numSteps,tR,tT,tFMBF,tS);

            tc.verifyTrue(isa(stairsGeometry,'StairsGeometry'))

            %Ensure that derived parameters were updated during
            %construction of object
            unitRiseExpected    = 6.8571;
            unitRunExpected     = 7.7143;
            thetaExpected       = deg2rad(41.6335);
            tMinExpected        = 6.1249;
            LRLExpected         = 144.9235;

            actualVec = [
                stairsGeometry.unitRise;
                stairsGeometry.unitRun
                stairsGeometry.theta;
                stairsGeometry.tMin;
                stairsGeometry.LRL
                ];

            expectedVec = [
                unitRiseExpected;
                unitRunExpected;
                thetaExpected;
                tMinExpected;
                LRLExpected
                ];

            tol = 0.001;
            tc.verifyTrue(AreMatricesSame(actualVec,expectedVec,tol))
        end


    end
end
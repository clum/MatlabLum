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

            stairsGeometry = stairsGeometry.ComputeDerivedParameters;

            tc.verifyTrue(isa(stairsGeometry,'StairsGeometry'))
        end

    end
end
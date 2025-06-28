classdef test_StairsGeometry_StairsGeometry < matlab.unittest.TestCase
    %Test the StairsGeometry.StairsGeometry method
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
        end

    end
end
classdef test_LeanToRafterGeometry_LeanToRafterGeometry < matlab.unittest.TestCase
    %Test the LeanToRafterGeometry.LeanToRafterGeometry method
    %
    %Christopher Lum
    %lum@uw.edu

    %Version History
    %07/29/25: Created

    methods(Test)
        %Standard example
        function example01(tc)
            scenarioID = 1;
            [slope,Lo,d,w,tR,L,wTP] = LeanToRafterGeometryScenarios(scenarioID);

            [leanToRafterGeometry] = LeanToRafterGeometry(...
                slope,Lo,d,w,tR,L,wTP);

            tc.verifyTrue(isa(leanToRafterGeometry,'LeanToRafterGeometry'))

        end
    end
end
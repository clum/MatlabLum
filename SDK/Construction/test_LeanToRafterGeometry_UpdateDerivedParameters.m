classdef test_LeanToRafterGeometry_UpdateDerivedParameters < matlab.unittest.TestCase
    %Test the LeanToRafterGeometry.UpdateDerivedParameters method
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

            %Ensure that derived parameters were updated during
            %construction of object
            rafterXExpected = [0;17.750000000000000;17.750000000000000;21.166756756756758;1.647500000000000e+02;1.647500000000000e+02;1.681667567567568e+02;1.861926147574982e+02;1.839348050069046e+02;-2.257809750593600];
            rafterYExpected = [0;4.467687074829932;5.327687074829933;5.327687074829933;41.467687074829930;42.327687074829930;42.327687074829930;46.864807796104990;55.835024913328210;8.970217117223221];
            thetaExpected   = deg2rad(14.1279);
            eExpected       = 3.4168;
            LTExpected      = 17.9426;

            actualVec = [
                leanToRafterGeometry.rafterX;
                leanToRafterGeometry.rafterY;
                leanToRafterGeometry.theta;
                leanToRafterGeometry.e;
                leanToRafterGeometry.LT
                ];

            expectedVec = [
                rafterXExpected;
                rafterYExpected;
                thetaExpected;
                eExpected;
                LTExpected
                ];

            tol = 0.001;
            tc.verifyTrue(AreMatricesSame(actualVec,expectedVec,tol))
        end


    end
end
classdef test_LeanToRafterGeometry < matlab.unittest.TestCase
    %Test the LeanToRafterGeometry function
    %
    %Christopher Lum
    %lum@uw.edu

    %Version History
    %03/09/25: Created

    methods(Test)
        %Standard example
        function example01(tc)
            %All dimensions are in inches
            m = 37.5/146.5;     %rafter/roof slope
            Lo = 15;            %how far the roof hangs over
            d = .89;            %height of bird's mouth
            w = 146.5+3.5;      %distance between two outer walls
            f = 9.25;           %fatness of rafter
            L = 16*12;          %length of rafter
            wTP = 3.5;          %width of top plates

            [xCoordinates,yCoordinates] = LeanToRafterGeometry(m,Lo,d,w,f,L,wTP);

            xCoordinates_expected = [
                0
                15
                15
                18.4769333333333
                161.500000000000
                161.500000000000
                164.976933333333
                186.003027805580
                183.709235133863
                -2.29379267171717
                0
                ];

            yCoordinates_expected = [
                0
                3.83959044368601
                4.72959044368601
                4.72959044368601
                41.3395904436860
                42.2295904436860
                42.2295904436860
                47.6116965372646
                56.5727799081063
                8.96108337084175
                0
                ];

            tol = 1e-6;
            tc.verifyTrue(AreMatricesSame(xCoordinates,xCoordinates_expected,tol))
            tc.verifyTrue(AreMatricesSame(yCoordinates,yCoordinates_expected,tol))

        end

    end
end
classdef test_ConvertLatLonDecimalToDegMin < matlab.unittest.TestCase
    %Test the ConvertLatLonDecimalToDegMin function
    %
    %Christopher Lum
    %lum@uw.edu

    %Version History
    %08/20/24: Created

    methods(Test)
        function example01(tc)
            %Run single conversion
            tol = 1e-8;

            coordinate_deg = 48.97420;
            [deg_actual,min_actual] = ConvertLatLonDecimalToDegMin(coordinate_deg);
            deg_expected = 48;
            min_expected = 58.4520000000002;
            
            tc.verifyTrue(AreMatricesSame(deg_actual,deg_expected));
            tc.verifyTrue(AreMatricesSame(min_actual,min_expected));

            coordinate_deg = -121.08347;
            [deg_actual,min_actual] = ConvertLatLonDecimalToDegMin(coordinate_deg);
            deg_expected = -121;
            min_expected = 5.00820000000033;
            
            tc.verifyTrue(AreMatricesSame(deg_actual,deg_expected,tol));
            tc.verifyTrue(AreMatricesSame(min_actual,min_expected,tol));
        end

        function example02(tc)
            %Edge cases
            tol = 1e-8;
            
            coordinate_deg = 0.97420;
            [deg_actual,min_actual] = ConvertLatLonDecimalToDegMin(coordinate_deg);
            deg_expected = 0;
            min_expected = 58.4520000000002;
            
            tc.verifyTrue(AreMatricesSame(deg_actual,deg_expected,tol));
            tc.verifyTrue(AreMatricesSame(min_actual,min_expected,tol));

            coordinate_deg = -0.08347;
            [deg_actual,min_actual] = ConvertLatLonDecimalToDegMin(coordinate_deg);
            deg_expected = 0;
            min_expected = -5.00820000000033;
            
            tc.verifyTrue(AreMatricesSame(deg_actual,deg_expected,tol));
            tc.verifyTrue(AreMatricesSame(min_actual,min_expected,tol));

            coordinate_deg = 0;
            [deg_actual,min_actual] = ConvertLatLonDecimalToDegMin(coordinate_deg);
            deg_expected = 0;
            min_expected = 0;
            
            tc.verifyTrue(AreMatricesSame(deg_actual,deg_expected,tol));
            tc.verifyTrue(AreMatricesSame(min_actual,min_expected,tol));
        end
    end
end
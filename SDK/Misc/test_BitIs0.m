classdef test_BitIs0 < matlab.unittest.TestCase
    %Test the BitIs0 function
    %
    %Christopher Lum
    %lum@uw.edu

    %Version History
    %12/17/24: Created

    methods(Test)
        function example01(tc)
            x = 0b11010101;

            position = 0;
            actual = BitIs0(x,position);
            expected = false;
            tc.verifyEqual(actual,expected);

            position = 1;
            actual = BitIs0(x,position);
            expected = true;
            tc.verifyEqual(actual,expected);

            position = 2;
            actual = BitIs0(x,position);
            expected = false;
            tc.verifyEqual(actual,expected);

            position = 3;
            actual = BitIs0(x,position);
            expected = true;
            tc.verifyEqual(actual,expected);

            position = 4;
            actual = BitIs0(x,position);
            expected = false;
            tc.verifyEqual(actual,expected);

            position = 5;
            actual = BitIs0(x,position);
            expected = true;
            tc.verifyEqual(actual,expected);

            position = 6;
            actual = BitIs0(x,position);
            expected = false;
            tc.verifyEqual(actual,expected);

            position = 7;
            actual = BitIs0(x,position);
            expected = false;
            tc.verifyEqual(actual,expected);
        end
    end
end
classdef test_BitIs1 < matlab.unittest.TestCase
    %Test the BitIs1 function
    %
    %Christopher Lum
    %lum@uw.edu

    %Version History
    %12/17/24: Created

    methods(Test)
        function example01(tc)
            x = 0b11010101;

            position = 0;
            actual = BitIs1(x,position);
            expected = true;
            tc.verifyEqual(actual,expected);

            position = 1;
            actual = BitIs1(x,position);
            expected = false;
            tc.verifyEqual(actual,expected);

            position = 2;
            actual = BitIs1(x,position);
            expected = true;
            tc.verifyEqual(actual,expected);

            position = 3;
            actual = BitIs1(x,position);
            expected = false;
            tc.verifyEqual(actual,expected);

            position = 4;
            actual = BitIs1(x,position);
            expected = true;
            tc.verifyEqual(actual,expected);

            position = 5;
            actual = BitIs1(x,position);
            expected = false;
            tc.verifyEqual(actual,expected);

            position = 6;
            actual = BitIs1(x,position);
            expected = true;
            tc.verifyEqual(actual,expected);

            position = 7;
            actual = BitIs1(x,position);
            expected = true;
            tc.verifyEqual(actual,expected);
        end
    end
end
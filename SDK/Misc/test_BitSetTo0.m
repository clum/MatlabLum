classdef test_BitSetTo0 < matlab.unittest.TestCase
    %Test the BitSetTo0 function
    %
    %Christopher Lum
    %lum@uw.edu

    %Version History
    %12/15/24: Created

    methods(Test)
        function example01(tc)
            x = 0b11010101;

            position = 0;
            actual = BitSetTo0(x,position);
            expected = 0b11010100;
            tc.verifyEqual(actual,expected);

            position = 1;
            actual = BitSetTo0(x,position);
            expected = 0b11010101;
            tc.verifyEqual(actual,expected);

            position = 2;
            actual = BitSetTo0(x,position);
            expected = 0b11010001;
            tc.verifyEqual(actual,expected);

            position = 3;
            actual = BitSetTo0(x,position);
            expected = 0b11010101;
            tc.verifyEqual(actual,expected);

            position = 4;
            actual = BitSetTo0(x,position);
            expected = 0b11000101;
            tc.verifyEqual(actual,expected);

            position = 5;
            actual = BitSetTo0(x,position);
            expected = 0b11010101;
            tc.verifyEqual(actual,expected);

            position = 6;
            actual = BitSetTo0(x,position);
            expected = 0b10010101;
            tc.verifyEqual(actual,expected);

            position = 7;
            actual = BitSetTo0(x,position);
            expected = 0b01010101;
            tc.verifyEqual(actual,expected);
        end
    end
end
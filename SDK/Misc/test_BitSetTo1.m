classdef test_BitSetTo1 < matlab.unittest.TestCase
    %Test the BitSetTo1 function
    %
    %Christopher Lum
    %lum@uw.edu

    %Version History
    %12/15/24: Created

    methods(Test)
        function example01(tc)
            x = 0b11010101;

            position = 0;
            actual = BitSetTo1(x,position);
            expected = 0b11010101;
            tc.verifyEqual(actual,expected);

            position = 1;
            actual = BitSetTo1(x,position);
            expected = 0b11010111;
            tc.verifyEqual(actual,expected);

            position = 2;
            actual = BitSetTo1(x,position);
            expected = 0b11010101;
            tc.verifyEqual(actual,expected);

            position = 3;
            actual = BitSetTo1(x,position);
            expected = 0b11011101;
            tc.verifyEqual(actual,expected);

            position = 4;
            actual = BitSetTo1(x,position);
            expected = 0b11010101;
            tc.verifyEqual(actual,expected);

            position = 5;
            actual = BitSetTo1(x,position);
            expected = 0b11110101;
            tc.verifyEqual(actual,expected);

            position = 6;
            actual = BitSetTo1(x,position);
            expected = 0b11010101;
            tc.verifyEqual(actual,expected);

            position = 7;
            actual = BitSetTo1(x,position);
            expected = 0b11010101;
            tc.verifyEqual(actual,expected);
        end
    end
end
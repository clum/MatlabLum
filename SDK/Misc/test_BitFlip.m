classdef test_BitFlip < matlab.unittest.TestCase
    %Test the BitFlip function
    %
    %Christopher Lum
    %lum@uw.edu

    %Version History
    %12/15/24: Created

    methods(Test)
        function example01(tc)
            x = 0b11010101;

            position = 0;
            actual = BitFlip(x,position);
            expected = 0b11010100;
            tc.verifyEqual(actual,expected);

            position = 1;
            actual = BitFlip(x,position);
            expected = 0b11010111;
            tc.verifyEqual(actual,expected);

            position = 2;
            actual = BitFlip(x,position);
            expected = 0b11010001;
            tc.verifyEqual(actual,expected);

            position = 3;
            actual = BitFlip(x,position);
            expected = 0b11011101;
            tc.verifyEqual(actual,expected);

            position = 4;
            actual = BitFlip(x,position);
            expected = 0b11000101;
            tc.verifyEqual(actual,expected);

            position = 5;
            actual = BitFlip(x,position);
            expected = 0b11110101;
            tc.verifyEqual(actual,expected);

            position = 6;
            actual = BitFlip(x,position);
            expected = 0b10010101;
            tc.verifyEqual(actual,expected);

            position = 7;
            actual = BitFlip(x,position);
            expected = 0b01010101;
            tc.verifyEqual(actual,expected);
        end
    end
end
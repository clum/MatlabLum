classdef test_BitMask < matlab.unittest.TestCase
    %Test the BitMask function
    %
    %Christopher Lum
    %lum@uw.edu

    %Version History
    %12/15/24: Created

    methods(Test)
        function example01(tc)
            position = 0;
            actual = BitMask(position);
            expected = 0b00000001;
            tc.verifyEqual(actual,expected);

            position = 1;
            actual = BitMask(position);
            expected = 0b00000010;
            tc.verifyEqual(actual,expected);

            position = 2;
            actual = BitMask(position);
            expected = 0b00000100;
            tc.verifyEqual(actual,expected);

            position = 3;
            actual = BitMask(position);
            expected = 0b00001000;
            tc.verifyEqual(actual,expected);

            position = 4;
            actual = BitMask(position);
            expected = 0b00010000;
            tc.verifyEqual(actual,expected);

            position = 5;
            actual = BitMask(position);
            expected = 0b00100000;
            tc.verifyEqual(actual,expected);

            position = 6;
            actual = BitMask(position);
            expected = 0b01000000;
            tc.verifyEqual(actual,expected);

            position = 7;
            actual = BitMask(position);
            expected = 0b10000000;
            tc.verifyEqual(actual,expected);
        end
    end
end
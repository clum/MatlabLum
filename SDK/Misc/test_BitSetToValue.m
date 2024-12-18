classdef test_BitSetToValue < matlab.unittest.TestCase
    %Test the BitSetToValue function
    %
    %Christopher Lum
    %lum@uw.edu

    %Version History
    %12/15/24: Created

    methods(Test)
        function example01(tc)
            x = 0b11010101;

            position = 0;
            value = true;
            actual = BitSetToValue(x,position,value);
            expected = 0b11010101;
            tc.verifyEqual(actual,expected);

            position = 1;
            value = true;
            actual = BitSetToValue(x,position,value);
            expected = 0b11010111;
            tc.verifyEqual(actual,expected);

            position = 2;
            value = false;
            actual = BitSetToValue(x,position,value);
            expected = 0b11010001;
            tc.verifyEqual(actual,expected);

            position = 3;
            value = false;
            actual = BitSetToValue(x,position,value);
            expected = 0b11010101;
            tc.verifyEqual(actual,expected);

            position = 4;
            value = true;
            actual = BitSetToValue(x,position,value);
            expected = 0b11010101;
            tc.verifyEqual(actual,expected);

            position = 5;
            value = false;
            actual = BitSetToValue(x,position,value);
            expected = 0b11010101;
            tc.verifyEqual(actual,expected);

            position = 6;
            value = true;
            actual = BitSetToValue(x,position,value);
            expected = 0b11010101;
            tc.verifyEqual(actual,expected);

            position = 7;
            value = false;
            actual = BitSetToValue(x,position,value);
            expected = 0b01010101;
            tc.verifyEqual(actual,expected);
        end
    end
end
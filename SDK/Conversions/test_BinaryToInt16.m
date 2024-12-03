classdef test_BinaryToInt16 < matlab.unittest.TestCase
    %Test the BinaryToInt16 function
    %
    %Christopher Lum
    %lum@uw.edu

    %Version History
    %11/30/24: Created
    
    methods(Test)
        %Positive numbers (MSB = 0)
        function example01(tc)
            C1 = '1';
            actual1 = BinaryToInt16(C1);
            expected1 = int16(1);
            
            tc.verifyTrue(AreMatricesSame(actual1,expected1));

            C2 = '110';
            actual2 = BinaryToInt16(C2);
            expected2 = int16(6);
            
            tc.verifyTrue(AreMatricesSame(actual2,expected2));

            C3 = '0111111111111111';
            actual3 = BinaryToInt16(C3);
            expected3 = int16(32767);
            
            tc.verifyTrue(AreMatricesSame(actual3,expected3));
        end

        %Negative numbers (MSB = 1, needs all 16 bits)
        function example02(tc)
            C1 = '1111111110000000';
            actual1 = BinaryToInt16(C1);
            expected1 = int16(-128);
            
            tc.verifyTrue(AreMatricesSame(actual1,expected1));

            C2 = '1110011100000000';
            actual2 = BinaryToInt16(C2);
            expected2 = int16(-6400);
            
            tc.verifyTrue(AreMatricesSame(actual2,expected2));

            C3 = '1100100100000000';
            actual3 = BinaryToInt16(C3);
            expected3 = int16(-14080);
            
            tc.verifyTrue(AreMatricesSame(actual3,expected3));
        end
    end
end
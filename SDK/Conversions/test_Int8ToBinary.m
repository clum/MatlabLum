classdef test_Int8ToBinary < matlab.unittest.TestCase
    %Test the Int8ToBinary function
    %
    %Christopher Lum
    %lum@uw.edu

    %Version History
    %11/30/24: Created
    
    methods(Test)
        %Positive numbers (MSB = 0)
        function example01(tc)
            I1 = int8(0);
            actual1 = Int8ToBinary(I1);
            expected1 = '00000000';
            
            tc.verifyTrue(AreMatricesSame(actual1,expected1));

            I2 = int8(1);
            actual2 = Int8ToBinary(I2);
            expected2 = '00000001';
            
            tc.verifyTrue(AreMatricesSame(actual2,expected2));
            
            I3 = int8(45);
            actual3 = Int8ToBinary(I3);
            expected3 = '00101101';
            
            tc.verifyTrue(AreMatricesSame(actual3,expected3));

            I4 = int8(127);
            actual4 = Int8ToBinary(I4);
            expected4 = '01111111';
            
            tc.verifyTrue(AreMatricesSame(actual4,expected4));
        end

        %Negative numbers (MSB = 1)
        function example02(tc)
            I1 = int8(-1);
            actual1 = Int8ToBinary(I1);
            expected1 = '11111111';
            
            tc.verifyTrue(AreMatricesSame(actual1,expected1));

            I2 = int8(-100);
            actual2 = Int8ToBinary(I2);
            expected2 = '10011100';
            
            tc.verifyTrue(AreMatricesSame(actual2,expected2));

            I3 = int8(-128);
            actual3 = Int8ToBinary(I3);
            expected3 = '10000000';
            
            tc.verifyTrue(AreMatricesSame(actual3,expected3));
        end
    end
end
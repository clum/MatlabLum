classdef test_Int16ToBinary < matlab.unittest.TestCase
    %Test the Int16ToBinary function
    %
    %Christopher Lum
    %lum@uw.edu

    %Version History
    %11/30/24: Created
    
    methods(Test)
        %Positive numbers (MSB = 0)
        function example01(tc)
            I1 = int16(0);
            actual1 = Int16ToBinary(I1);
            expected1 = '0000000000000000';
            
            tc.verifyTrue(AreMatricesSame(actual1,expected1));

            I2 = int16(1);
            actual2 = Int16ToBinary(I2);
            expected2 = '0000000000000001';
            
            tc.verifyTrue(AreMatricesSame(actual2,expected2));
            
            I3 = int16(45);
            actual3 = Int16ToBinary(I3);
            expected3 = '0000000000101101';
            
            tc.verifyTrue(AreMatricesSame(actual3,expected3));

            I4 = int16(127);
            actual4 = Int16ToBinary(I4);
            expected4 = '0000000001111111';
            
            tc.verifyTrue(AreMatricesSame(actual4,expected4));

            I5 = int16(21845);
            actual5 = Int16ToBinary(I5);
            expected5 = '0101010101010101';
            
            tc.verifyTrue(AreMatricesSame(actual5,expected5));

            I6 = int16(32767);
            actual6 = Int16ToBinary(I6);
            expected6 = '0111111111111111';
            
            tc.verifyTrue(AreMatricesSame(actual6,expected6));
        end

        %Negative numbers (MSB = 1)
        function example02(tc)
            I1 = int16(-1);
            actual1 = Int16ToBinary(I1);
            expected1 = '1111111111111111';

            tc.verifyTrue(AreMatricesSame(actual1,expected1));

            I2 = int16(-100);
            actual2 = Int16ToBinary(I2);
            expected2 = '1111111110011100';

            tc.verifyTrue(AreMatricesSame(actual2,expected2));

            I3 = int16(-128);
            actual3 = Int16ToBinary(I3);
            expected3 = '1111111110000000';

            tc.verifyTrue(AreMatricesSame(actual3,expected3));

            I4 = int16(-21845);
            actual4 = Int16ToBinary(I4);
            expected4 = '1010101010101011';

            tc.verifyTrue(AreMatricesSame(actual4,expected4));

            I5 = int16(-32768);
            actual5 = Int16ToBinary(I5);
            expected5 = '1000000000000000';

            tc.verifyTrue(AreMatricesSame(actual5,expected5));
        end
    end
end
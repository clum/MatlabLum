classdef test_BinaryToUint8 < matlab.unittest.TestCase
    %Test the BinaryToUint8 function
    %
    %Christopher Lum
    %lum@uw.edu

    %Version History
    %11/30/24: Created
    
    methods(Test)
        %Positive numbers (MSB = 0)
        function example01(tc)
            C1 = '1';
            actual1 = BinaryToUint8(C1);
            expected1 = uint8(1);
            
            tc.verifyTrue(AreMatricesSame(actual1,expected1));

            C2 = '110';
            actual2 = BinaryToUint8(C2);
            expected2 = uint8(6);

            tc.verifyTrue(AreMatricesSame(actual2,expected2));

            C3 = '10000000';
            actual3 = BinaryToUint8(C3);
            expected3 = uint8(128);

            tc.verifyTrue(AreMatricesSame(actual3,expected3));

            C4 = '11111111';
            actual4 = BinaryToUint8(C4);
            expected4 = uint8(255);

            tc.verifyTrue(AreMatricesSame(actual4,expected4));
        end
    end
end
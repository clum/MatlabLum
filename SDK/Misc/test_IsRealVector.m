classdef test_IsRealVector < matlab.unittest.TestCase
    %Test the IsRealVector function
    %
    %Christopher Lum
    %lum@uw.edu

    %Version History
    %11/02/24: Created
    
    methods(Test)
        %Example01 - real vector
        function example01(tc)
            X = linspace(0,10,10);
            actual = IsRealVector(X);
            tc.verifyTrue(actual);
        end
        
        %Example02 - complex vector, should return false
        function example02(tc)
            X = [1 2 2+2*i];
            actual = IsRealVector(X);
            tc.verifyFalse(actual);
        end

        %Example03 - cell array, should return false
        function example03(tc)
            X = {1,2,3};
            try
                actual = IsRealVector(X);
                
                %previous should have thrown an error, if we reach here
                %fail the test
                tc.assertFail();

            catch
                
            end

            %should reach here
        end
    end
end
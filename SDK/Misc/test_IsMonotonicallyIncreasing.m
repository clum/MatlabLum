classdef test_IsMonotonicallyIncreasing < matlab.unittest.TestCase
    %Test the IsMonotonicallyIncreasing function
    %
    %Christopher Lum
    %lum@uw.edu

    %Version History
    %04/06/17: Created
    %11/02/24: Adapted to matlab.unittest.TestCase format

    methods(Test)
        %Example01 - test an increasing vector
        function example01(tc)
            X = linspace(0,10,10);
            actual = IsMonotonicallyIncreasing(X);
            tc.verifyTrue(actual);
        end
        
        %Example02 - test a decreasing vector
        function example02(tc)
            X = linspace(10,0,10);
            [actual,index] = IsMonotonicallyIncreasing(X);
            tc.verifyFalse(actual);
            tc.verifyTrue(index==2);
        end

        %Example03: Test non-monotonically decreasing vector
        function example03(tc)
            A = linspace(0,10,10);
            A(9) = 10;
            [actual,index] = IsMonotonicallyIncreasing(A);
            tc.verifyFalse(actual);
            tc.verifyTrue(index==10);
        end

        %Example04: Test static vector (same values)
        function example04(tc)
            A = linspace(10,10,10);
            actual = IsMonotonicallyIncreasing(A);
            tc.verifyFalse(actual);
        end
    end
end
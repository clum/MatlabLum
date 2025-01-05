classdef test_BitIs1 < matlab.unittest.TestCase
    %Test the BitIs1 function
    %
    %Christopher Lum
    %lum@uw.edu

    %Version History
    %12/17/24: Created
    %12/25/24: Updated with test for signed int

    methods(Test)
        %x is an uint8
        function example01(tc)
            x = 0b11010101;

            %assert that this is stored as an unsigned value by default
            assert(isa(x,'uint8'))

            position = 0;
            actual = BitIs1(x,position);
            expected = true;
            tc.verifyEqual(actual,expected);

            position = 1;
            actual = BitIs1(x,position);
            expected = false;
            tc.verifyEqual(actual,expected);

            position = 2;
            actual = BitIs1(x,position);
            expected = true;
            tc.verifyEqual(actual,expected);

            position = 3;
            actual = BitIs1(x,position);
            expected = false;
            tc.verifyEqual(actual,expected);

            position = 4;
            actual = BitIs1(x,position);
            expected = true;
            tc.verifyEqual(actual,expected);

            position = 5;
            actual = BitIs1(x,position);
            expected = false;
            tc.verifyEqual(actual,expected);

            position = 6;
            actual = BitIs1(x,position);
            expected = true;
            tc.verifyEqual(actual,expected);

            position = 7;
            actual = BitIs1(x,position);
            expected = true;
            tc.verifyEqual(actual,expected);
        end

        %x is an int8
        function example02(tc)
            x = int8(-43);

            %assert that this is stored a signed value
            assert(isa(x,'int8'))

            position = 0;
            try
                actual = BitIs1(x,position);
                tc.assertFail('Should not have reached this line');

            catch
                %previous line should have thrown and error, test passes
            end           

        end
    end
end
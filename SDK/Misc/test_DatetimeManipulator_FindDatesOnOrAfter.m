classdef test_DatetimeManipulator_FindDatesOnOrAfter < matlab.unittest.TestCase
    %Test the DatetimeManipulator.FindDatesOnOrAfter function
    %
    %Christopher Lum
    %lum@uw.edu

    %Version History
    %10/01/24: Created

    methods(Test)
        %Standard example
        function example01(tc)
            datetimeArray = [
                datetime('09/23/2024')
                datetime('10/23/2024')
                datetime('12/23/2024')
                datetime('03/23/2025')
                datetime('10/10/2024')
                ];

            datetimeStart   = datetime('10/10/2024');
            [dates,indices] = DatetimeManipulator.FindDatesOnOrAfter(datetimeArray,datetimeStart);

            indices_expected = [2;3;4;5];

            tc.verifyTrue(AreMatricesSame(indices,indices_expected))
        end

        %Show resolution of 1 second
        function example02(tc)
            datetimeArray = [
                datetime('09/23/2024')
                datetime('10/23/2024')
                datetime('12/23/2024')
                datetime('03/23/2025')
                datetime('10/10/2024')
                ];

            datetimeStart   = datetime('10/10/2024');
            
            %add 1 second to datetimeStart
            datetimeStart = datetimeStart + seconds(1);
            [dates,indices] = DatetimeManipulator.FindDatesOnOrAfter(datetimeArray,datetimeStart);

            indices_expected = [2;3;4];

            tc.verifyTrue(AreMatricesSame(indices,indices_expected))
        end
    end
end
classdef test_DatetimeManipulator_FindDatesInRange < matlab.unittest.TestCase
    %Test the DatetimeManipulator.FindDatesInRange function
    %
    %Christopher Lum
    %lum@uw.edu

    %Version History
    %07/31/24: Created
    %08/03/24: Modified documentation

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
            datetimeEnd     = datetime('12/24/2024');
            [dates,indices] = DatetimeManipulator.FindDatesInRange(datetimeArray,datetimeStart,datetimeEnd);

            indices_expected = [2;3;5];

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
            datetimeEnd     = datetime('12/24/2024');

            %add 1 second to datetimeStart
            datetimeStart = datetimeStart + seconds(1);
            [dates,indices] = DatetimeManipulator.FindDatesInRange(datetimeArray,datetimeStart,datetimeEnd);

            indices_expected = [2;3];

            tc.verifyTrue(AreMatricesSame(indices,indices_expected))
        end
    end
end
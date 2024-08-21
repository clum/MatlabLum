classdef test_DatetimeManipulator_FindNearestDate < matlab.unittest.TestCase
    %Test the DatetimeManipulator.FindNearestDate function
    %
    %Christopher Lum
    %lum@uw.edu

    %Version History
    %07/31/24: Created
    %08/03/24: Modified documentation

    methods(Test)
        function example01(tc)
            datetimeArray = [
                datetime('09/23/2024')
                datetime('10/23/2024')
                datetime('12/23/2024')
                datetime('03/23/2025')
                ];

            datetimeDesired = datetime('12/10/2024');
            [datetimeNearest,indexNearest] = DatetimeManipulator.FindNearestDate(datetimeArray,datetimeDesired);

            indexNearest_expected = 3;

            tc.verifyTrue(indexNearest==indexNearest_expected)
        end
    end
end
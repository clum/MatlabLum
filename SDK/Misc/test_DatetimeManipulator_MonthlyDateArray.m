classdef test_DatetimeManipulator_MonthlyDateArray < matlab.unittest.TestCase
    %Test the DatetimeManipulator.MonthlyDateArray function
    %
    %Christopher Lum
    %lum@uw.edu

    %Version History
    %11/01/24: Created

    methods(Test)
        function example01(tc)

            dateEarliest    = datetime('09/23/2024');
            dateLatest      = datetime('12/23/2024');

            [monthlyDates] = DatetimeManipulator.MonthlyDateArray(dateEarliest,dateLatest);

            monthlyDatesExpected = [
                datetime('09/01/2024')
                datetime('10/01/2024')
                datetime('11/01/2024')
                datetime('12/01/2024')
                datetime('01/01/2025')
                ];

            tc.verifyTrue(AreMatricesSame(monthlyDates,monthlyDatesExpected));
        end
    end
end
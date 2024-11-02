classdef test_DatetimeManipulator_IsArrayMonotonicallyIncreasing < matlab.unittest.TestCase
    %Test the DatetimeManipulator.IsArrayMonotonicallyIncreasing function
    %
    %Christopher Lum
    %lum@uw.edu

    %Version History
    %11/02/24: Created
    
    methods(Test)
        %Monotonically increasing dates
        function example01(tc)
            datetimeArray = [
                datetime('09/23/2024')
                datetime('10/23/2024')
                datetime('12/23/2024')
                ];

            [isMono] = DatetimeManipulator.IsArrayMonotonicallyIncreasing(datetimeArray);
            tc.verifyTrue(isMono)
        end
        
        %Non-monotonically increasing dates
        function example02(tc)
            datetimeArray = [
                datetime('09/23/2024')
                datetime('10/23/2024')
                datetime('12/23/2024')
                datetime('03/23/2025')
                datetime('10/10/2024')
                ];

            [isMono] = DatetimeManipulator.IsArrayMonotonicallyIncreasing(datetimeArray);
            tc.verifyFalse(isMono)
        end
    end
end
classdef test_MakeMonotonicallyIncreasing < matlab.unittest.TestCase
    %Test the MakeMonotonicallyIncreasing function
    %
    %Christopher Lum
    %lum@uw.edu

    %Version History
    %07/26/15: Created
    %11/02/24: Adapted to matlab.unittest.TestCase format

    methods(Test)
        %Example01
        function example01(tc)
            debug = false;
            LineWidth = 2;
            MarkerSize = 14;

            X = linspace(0, 10, 5);
            [XM] = MakeMonotonicallyIncreasing(X);

            tc.verifyTrue(AreMatricesSame(X,XM));

            if(debug)
                figh = figure;
                hold on
                plot([1:1:length(X)], X, 'rx', 'LineWidth', LineWidth, 'MarkerSize', MarkerSize)
                plot([1:1:length(XM)], XM, 'bo', 'LineWidth', LineWidth, 'MarkerSize', MarkerSize)
                grid on
                xlabel('Index')
                title('Example01')
                legend('Original','Modified')

                close(figh);
            end
        end
        
        %Example02
        function example02(tc)
            debug = false;
            LineWidth = 2;
            MarkerSize = 14;

            X = [1 2 3 3.1 3.2 2.5 2.2 2.1 2.5 3.2 4 6 7 4];
            [XM] = MakeMonotonicallyIncreasing(X);
            XMExpected = [1,2,3,3.100000000000000,3.200000000000000,4,6,7];

            tc.verifyTrue(AreMatricesSame(XM,XMExpected));

            if(debug)
                figh = figure;
                hold on
                plot([1:1:length(X)], X, 'rx', 'LineWidth', LineWidth, 'MarkerSize', MarkerSize)
                plot([1:1:length(XM)], XM, 'bo', 'LineWidth', LineWidth, 'MarkerSize', MarkerSize)
                grid on
                xlabel('Index')
                title('Example01')
                legend('Original','Modified')

                close(figh);
            end
        end
    end
end
classdef test_StairsGeometry < matlab.unittest.TestCase
    %Test the LeanToRafterGeometry function
    %
    %Christopher Lum
    %lum@uw.edu

    %Version History
    %04/12/25: Created

    methods(Test)
        %Standard example
        function example01(tc)
            debug = false;

            rise = 10;
            run = 25;
            numSteps = 4;

            [xCoordinates,yCoordinates] = StairsGeometry(rise,run,numSteps);

            xCoordinates_expected = [0
                6.25000000000000
                6.25000000000000
                12.5000000000000
                12.5000000000000
                18.7500000000000
                18.7500000000000
                25
                25];

            yCoordinates_expected = [0
                0
                2.50000000000000
                2.50000000000000
                5
                5
                7.50000000000000
                7.50000000000000
                10];

            if(debug)
                figh = figure;
                hold on
                plot(xCoordinates,yCoordinates);
                plot([0 run run 0 0],[0 0 rise rise 0],'r--')
                grid on

                close(figh)
            end

            tol = 1e-6;
            tc.verifyTrue(AreMatricesSame(xCoordinates,xCoordinates_expected,tol))
            tc.verifyTrue(AreMatricesSame(yCoordinates,yCoordinates_expected,tol))
        end

    end
end
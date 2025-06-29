function [rise,run,numSteps,tR,tT,tFMBF,tS] = StairsGeometryScenarios(scenarioID)

switch scenarioID
    case 1
        %2x12
        rise        = 8*12;
        run         = 9*12;
        numSteps    = 14;
        tR          = 7/16 + 0.35;      %OSB + carpet
        tT          = 23/32 + 0.35;
        tFMBF       = 1 + 7/16 + 0.27;  %insulation + OSB + vinyl flooring
        tS          = 11.25;            %2x10 = 9.25", 2x12 = 11.25"

    case 2
        %Use a 2x10 instead of a 2x12
        [rise,run,numSteps,tR,tT,tFMBF,tS] = StairsGeometryScenarios(1);
        tS = 9.25;

    otherwise
        error('Unsupported scenarioID');
end
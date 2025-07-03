function [rise,run,numSteps,tR,tT,tFMBF,tS] = StairsGeometryScenarios(scenarioID)

tCarpet = 0.35;
tInsulation = 1;
tOSB = 7/16;
tVinylFlooring = 0.27;

switch scenarioID
    case 1
        %2x12
        rise        = 8*12;
        run         = 9*12;
        numSteps    = 14;
        tR          = tOSB + tCarpet;      %OSB + carpet
        tT          = 23/32 + tCarpet;
        tFMBF       = tInsulation + tOSB + tVinylFlooring;  %insulation + OSB + vinyl flooring
        tS          = 11.25;            %2x10 = 9.25", 2x12 = 11.25"

    case 2
        %Use a 2x10 instead of a 2x12
        baseScenario = 1;
        [rise,run,numSteps,tR,tT,tFMBF,tS] = StairsGeometryScenarios(baseScenario);
        tS = 9.25;

    case 3
        %use a 2x material for the rise.  Actual dimensions of shed.
        baseScenario = 1;
        [rise,run,numSteps,tR,tT,tFMBF,tS] = StairsGeometryScenarios(baseScenario);
        
        rise = 107.5 - (tInsulation + tOSB + tVinylFlooring) + tCarpet;
        run = 107;
        tT = 1.5 + tCarpet;
    otherwise
        error('Unsupported scenarioID');
end
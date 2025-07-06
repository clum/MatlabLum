function [rise,run,numSteps,tR,tT,tFMBF,tS] = StairsGeometryScenarios(scenarioID)

tCarpet = 0.35;
tInsulation = 1;
tOSB = 7/16;
tVinylFlooring = 0.27;
t2xMaterial = 1.5;      %2x4 thickness

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
        tFMBF       = tInsulation + tOSB + tVinylFlooring;  %insulation + OSB + vinyl flooring
        
        rise = 107.25 - tFMBF + tCarpet;
        run = 105;
        numSteps = 13;
        tR = tOSB + tCarpet;
        tT = t2xMaterial + tCarpet;
        tS = 11.25;

    otherwise
        error('Unsupported scenarioID');
end
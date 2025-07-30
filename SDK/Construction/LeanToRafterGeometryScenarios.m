function [slope,Lo,d,w,tR,L,wTP] = LeanToRafterGeometryScenarios(scenarioID)

w2xMaterial = 3.5;      %2x4 width

switch scenarioID
    case 1
        %Shed dimensions
        slope   = 37/147;
        Lo      = 17.75;
        d       = 0.86;
        w       = 150.5;
        tR      = 9.25;
        L       = 16*12;
        wTP     = w2xMaterial;

    otherwise
        error('Unsupported scenarioID');
end
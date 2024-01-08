%Explore enabled subsystems
%
%Christopher Lum
%lum@uw.edu

%Version History
%04/18/19: Created
%04/19/19: Continued working.  Finished and working.

clear
clc
close all

%Chose which model to run

modelSelection = 3;     %1 = modelA, 2 = modelB, 3 = modelC

switch modelSelection
    case 1
        %% Model A - simple model showing how enabled subsystems operate
        disp('Model A')
        
        %Constants
        deltaT = 0.1;
        tFinal = 20;
        
        x0 = 50;
        
        simulinkModel = 'EnabledSubsystem_modelA.slx';
        uiopen(simulinkModel, 1)
        sim(simulinkModel)
        
        %Extract outputs
        t_R                 = simR.Time;
        r                   = simR.Data;
        
        %Enabled, held
        t_EnabledHeld           = simY_EnabledHeld.Time;
        y_EnabledHeld           = simY_EnabledHeld.Data;
        
        t_EnabledHeldInside     = simY_EnabledHeldInside.Time;
        y_EnabledHeldInside     = simY_EnabledHeldInside.Data;
        
        %Enabled, reset
        t_EnabledReset          = simY_EnabledReset.Time;
        y_EnabledReset          = simY_EnabledReset.Data;
        
        t_EnabledResetInside    = simY_EnabledResetInside.Time;
        y_EnabledResetInside    = simY_EnabledResetInside.Data;
        
        t_NotEnabled            = simY_NotEnabled.Time;
        y_NotEnabled            = simY_NotEnabled.Data;
        
        figure
        subplot(3,1,1)
        plot(t_R,r, 'rx')
        legend('r')
        grid on
        
        subplot(3,1,2)
        hold on
        plot(t_EnabledHeld, y_EnabledHeld, 'rx')
        plot(t_EnabledReset, y_EnabledReset, 'bo')
        plot(t_NotEnabled, y_NotEnabled, 'g^')
        legend('y_{enabled,held}', 'y_{enabled,reset}', 'y_{not enabled}')
        grid on
        
        subplot(3,1,3)
        hold on
        plot(t_EnabledHeldInside,y_EnabledHeldInside, 'rx')
        plot(t_EnabledResetInside,y_EnabledResetInside, 'bo')
        legend('y_{enabled,held,inside}', 'y_{enabled,reset,inside}')
        grid on
        
    case 2
        %% Model B - show supress divide by 0 by using an enabled subsystem
        disp('Model B')
        
        %Constants
        deltaT = 0.05;
        tFinal = 1;
        
        simulinkModel = 'EnabledSubsystem_modelB.slx';
        uiopen(simulinkModel, 1)
        sim(simulinkModel)
        
        %Extract outputs
        t_R                 = simR.Time;
        r                   = simR.Data;
        
        %Enabled
        t_Enabled           = simY_Enabled.Time;
        y1_Enabled          = simY_Enabled.Data(:,1);
        y2_Enabled          = simY_Enabled.Data(:,2);
        
        t_EnabledInside     = simY_EnabledInside.Time;
        y1_EnabledInside    = simY_EnabledInside.Data(:,1);
        y2_EnabledInside    = simY_EnabledInside.Data(:,2);
        
        if(any(isnan(y1_Enabled)) || any(isnan(y2_Enabled)) || ...
                any(isnan(y1_EnabledInside)) || any(isnan(y2_EnabledInside)))
            warning('y has NaN values')
            [y1_Enabled y2_Enabled]
        end
        
        if(any(isinf(y1_Enabled)) || any(isinf(y2_Enabled)) || ...
                any(isinf(y1_EnabledInside)) || any(isinf(y2_EnabledInside)))
            warning('y has Inf values')
            [y1_Enabled y2_Enabled]
        end

        figure
        subplot(3,1,1)
        plot(t_R,r, 'rx')
        legend('r')
        grid on
        
        subplot(3,1,2)
        hold on
        plot(t_Enabled, y1_Enabled, 'rx')
        plot(t_EnabledInside, y1_EnabledInside, 'bo')
        legend('y1_{enabled}', 'y1_{enabled,inside}')
        grid on
        
        subplot(3,1,3)
        hold on
        plot(t_Enabled,y2_Enabled, 'rx')
        plot(t_EnabledInside, y2_EnabledInside, 'bo')
        legend('y2_{enabled}', 'y2_{enabled,inside}')
        grid on
        
    case 3
        %% Model C - realistic alpha/beta calculation
        disp('Model C')
        
        %Constants
        deltaT = 0.05;
        tFinal = 1;
        
        V_rel_b = [0;0;0];      %releative wind expressed in body frame
        
        simulinkModel = 'EnabledSubsystem_modelC.slx';
        uiopen(simulinkModel, 1)
        sim(simulinkModel)
        
        %Extract outputs
        t_R                 = simR.Time;
        r                   = simR.Data;
        
        %Enabled
        t_Enabled           = simY_Enabled.Time;
        y1_Enabled          = simY_Enabled.Data(:,1);
        y2_Enabled          = simY_Enabled.Data(:,2);
        
        t_EnabledInside     = simY_EnabledInside.Time;
        y1_EnabledInside    = simY_EnabledInside.Data(:,1);
        y2_EnabledInside    = simY_EnabledInside.Data(:,2);
        
        if(any(isnan(y1_Enabled)) || any(isnan(y2_Enabled)) || ...
                any(isnan(y1_EnabledInside)) || any(isnan(y2_EnabledInside)))
            warning('y has NaN values')
            [y1_Enabled y2_Enabled]
        end
        
        if(any(isinf(y1_Enabled)) || any(isinf(y2_Enabled)) || ...
                any(isinf(y1_EnabledInside)) || any(isinf(y2_EnabledInside)))
            warning('y has Inf values')
            [y1_Enabled y2_Enabled]
        end

        figure
        subplot(3,1,1)
        plot(t_R,r, 'rx')
        legend('r')
        grid on
        
        subplot(3,1,2)
        hold on
        plot(t_Enabled, y1_Enabled, 'rx')
        plot(t_EnabledInside, y1_EnabledInside, 'bo')
        legend('y1_{enabled}', 'y1_{enabled,inside}')
        grid on
        
        subplot(3,1,3)
        hold on
        plot(t_Enabled,y2_Enabled, 'rx')
        plot(t_EnabledInside, y2_EnabledInside, 'bo')
        legend('y2_{enabled}', 'y2_{enabled,inside}')
        grid on
        
    otherwise
        error('Unknown modelSelection')
end

disp('DONE!')
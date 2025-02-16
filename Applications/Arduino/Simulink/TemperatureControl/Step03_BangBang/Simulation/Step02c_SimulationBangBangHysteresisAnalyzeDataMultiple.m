%Simulation of Bang/bang with hysteresis deadband for temperature control.
%
%Christopher Lum
%lum@uw.edu

%Version History
%01/26/25: Created
%01/31/25: Updating pathing

clear
clc
close all

ChangeWorkingDirectoryToThisLocation();

%% User settings
% %show how hysteresis band eliminates chattering (w/ changing set point)
% inputFiles  = {
%     'BangBangHysteresisSimulinkData_ID01.mat';
%     'BangBangHysteresisSimulinkData_ID03.mat';
%     };

% %show how hysteresis band eliminates chattering (w/ constant set point)
% inputFiles  = {
%     'BangBangHysteresisSimulinkData_ID04.mat';
%     'BangBangHysteresisSimulinkData_ID06.mat';
%     };

%show stateflow is equivalent to if/else statements
inputFiles  = {
    'BangBangHysteresisSimulinkData_ID02.mat';
    'BangBangHysteresisSimulinkData_ID03.mat';
    };

%deadbandSize study
inputFiles  = {
    'BangBangHysteresisSimulinkData_ID06.mat';      %deadbandSize_C = 2
    'BangBangHysteresisSimulinkData_ID08.mat';      %deadbandSize_C = 0.5
    'BangBangHysteresisSimulinkData_ID10.mat';      %deadbandSize_C = 0.02    
    };


%% Analyze data
figure
ax = [];
ax(end+1) = subplot(2,1,1);
ax(end+1) = subplot(2,1,2);

colorMap = hsv(length(inputFiles));

for k=1:length(inputFiles)
    inputFile = inputFiles{k};

    %% Load data
    disp(['Loading data from ',inputFile])
    temp = load(inputFile);
    simout = temp.simout;

    %% Analyze data
    u_sim               = simout.logsout.getElement('u');
    temperatureTC_C_sim = simout.logsout.getElement('temperatureTC_C');
    T_cmd_C_sim         = simout.logsout.getElement('T_cmd_C');

    t_s_sim         = u_sim.Values.Time;
    u_sim           = u_sim.Values.Data;
    tempTC_C_sim    = temperatureTC_C_sim.Values.Data;
    T_cmd_C_sim     = T_cmd_C_sim.Values.Data;

    %Plot
    subplot(2,1,1);
    hold on
    plot(t_s_sim,T_cmd_C_sim,'DisplayName',StringWithUnderscoresForPlot('T_cmd_C_sim'),'LineWidth',2,'Color',[255 117 25]/255)
    plot(t_s_sim,tempTC_C_sim,'DisplayName',StringWithUnderscoresForPlot('tempTC_C_sim'),'LineWidth',2,'Color',colorMap(k,:))
    % legend('Location','best')
    grid on
    ylabel('Temp (C)')

    subplot(2,1,2);
    hold on
    plot(t_s_sim,u_sim,'DisplayName',StringWithUnderscoresForPlot('u_sim'),'LineWidth',2,'Color',colorMap(k,:))
    % legend('Location','best')
    grid on
    ylabel('u')

    linkaxes(ax,'x')

end
disp('DONE!')

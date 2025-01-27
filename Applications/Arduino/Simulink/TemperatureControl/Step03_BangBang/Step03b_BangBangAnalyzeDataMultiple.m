%Analyze data from the run.
%
%Christopher Lum
%lum@uw.edu

%Version History
%01/23/25: Created

clear
clc
close all

%% User settings
% inputFiles  = {
%     'BangBangSimulinkData_ID03.mat';    %fan off
%     'BangBangSimulinkData_ID02.mat';    %fan on
%     };

inputFiles  = {
    'BangBangSimulinkData_ID04.mat';    %uON = 1.0
    'BangBangSimulinkData_ID05.mat';    %uON = 0.8
    'BangBangSimulinkData_ID06.mat';    %uON = 0.6
    'BangBangSimulinkData_ID07.mat';    %uON = 0.4
    'BangBangSimulinkData_ID08.mat';    %uON = 0.2
    };

%% Analyze data
figure
ax = [];
ax(end+1) = subplot(2,1,1);
ax(end+1) = subplot(2,1,2);
    
for k=1:length(inputFiles)
    inputFile = inputFiles{k};

    temp = load(inputFile);
    logsout = temp.logsout;

    y       = logsout.getElement('y');
    u       = logsout.getElement('u');
    T_cmd_C = logsout.getElement('T_cmd_C');

    t_s         = y.Values.Time;
    tempCJ_C    = y.Values.Data(:,1);
    tempTC_C    = y.Values.Data(:,2);

    u           = u.Values.Data(:,1);

    T_cmd_C     = T_cmd_C.Values.Data(:,1);

    subplot(2,1,1)
    hold on
    plot(t_s,T_cmd_C,'DisplayName',StringWithUnderscoresForPlot(inputFile),'LineWidth',2)
    plot(t_s,tempTC_C,'DisplayName',StringWithUnderscoresForPlot(inputFile),'LineWidth',2)
    
    % legend()
    grid on
    ylabel('Temperature TC (C)')

    subplot(2,1,2)
    hold on
    plot(t_s,u,'DisplayName',StringWithUnderscoresForPlot(inputFile),'LineWidth',2)
    % legend()
    grid on
    ylabel('u')

    %end temperature
    disp(['End condition:'])
    disp(['u(end) = ',num2str(u(end))])
    disp(['tempTC(end) = ',num2str(tempTC_C(end))])
    disp(' ')
    
end

linkaxes(ax,'x')
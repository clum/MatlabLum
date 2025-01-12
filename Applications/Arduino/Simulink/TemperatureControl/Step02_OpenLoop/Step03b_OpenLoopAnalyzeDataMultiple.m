%Analyze data from the run.
%
%Christopher Lum
%lum@uw.edu

%Version History
%01/11/25: Created
%01/12/25: Added final temperature output

clear
clc
close all

%% User settings
inputFiles  = {
    'OpenLoopSimulinkData_ID01.mat';
    'OpenLoopSimulinkData_ID02.mat';
    'OpenLoopSimulinkData_ID03.mat';
    'OpenLoopSimulinkData_ID04.mat';
    'OpenLoopSimulinkData_ID05.mat';
    'OpenLoopSimulinkData_ID06.mat'
    };

% inputFiles  = {
%     'OpenLoopSimulinkData_ID01.mat';
%     'OpenLoopSimulinkData_ID07.mat'
%     };

%% Analyze data
figure
    
for k=1:length(inputFiles)
    inputFile = inputFiles{k};

    temp = load(inputFile);
    logsout = temp.logsout;

    y = logsout.getElement('y');
    u = logsout.getElement('u');

    t_s         = y.Values.Time;
    tempCJ_C    = y.Values.Data(:,1);
    tempTC_C    = y.Values.Data(:,2);

    u           = u.Values.Data(:,1);

    subplot(2,1,1)
    hold on
    plot(t_s,tempTC_C,'DisplayName',StringWithUnderscoresForPlot(inputFile),'LineWidth',2)
    legend()
    grid on
    ylabel('Temperature TC (C)')

    subplot(2,1,2)
    hold on
    plot(t_s,u,'DisplayName',StringWithUnderscoresForPlot(inputFile),'LineWidth',2)
    legend()
    grid on
    ylabel('u')

    %end temperature
    disp(['End condition:'])
    disp(['u(end) = ',num2str(u(end))])
    disp(['tempTC(end) = ',num2str(tempTC_C(end))])
    disp(' ')
    
end
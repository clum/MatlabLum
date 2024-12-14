%Save data after running the model.
%
%Christopher Lum
%lum@uw.edu

%Version History
%12/14/24: Created

%% User settings
outputFile = 'simData_IDXX.mat';

%% Save data
saveVars = {
    'simout'
    'logsout'
    };

s = SaveVarsString(outputFile,saveVars);
eval(s);

disp(['Saved to ',outputFile]);

disp('DONE!')

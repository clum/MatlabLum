warning("need to updated to a unit test file")

clear
clc
close all

assetIDs = {
    'HouseMabrey'
    'HouseMabrey'
    'SavingsChase',
    'SavingsChase'
    'HouseMabrey'
    };

assetIDsCat = categorical(assetIDs,{'extraCategory','HouseMabrey','SavingsChase'});


values = [
    10.3
    12.3
    14.1
    14.0
    15.3
    ];

%%Create table

T = table(assetIDsCat,values);
tableManipulator = TableManipulator(T);

T2 = tableManipulator.RemoveUnusedCategories()


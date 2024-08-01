classdef test_TableManipulator_RemoveUnusedCategories < matlab.unittest.TestCase
    %Version History: 07/31/24: Converted to a matlab unit test

    methods(Test)
        function example01(tc)
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

            T2 = tableManipulator.RemoveUnusedCategories();

            tc.verifyTrue(length(categories(T.assetIDsCat))==3)
            tc.verifyTrue(length(categories(T2.assetIDsCat))==2)
        end
    end
end
classdef test_tableManipulator_SortBySpecifiedColumn < matlab.unittest.TestCase
    %Test the tableManipulator.SortBySpecifiedColumn method
    %
    %Christopher Lum
    %lum@uw.edu
    
    %Version History
    %01/15/25: Created
    
    methods(Test)
        function example01(tc)
            debug = false;
            
            T = tableConstants.SetupTable(tableID.Vehicles01);                        
            tableManip = tableManipulator(T);

            %Sort by Year
            TS = tableManip.SortBySpecifiedColumn('Year');
            
            expectedYear = [
                1998
                2008
                2013
                2015
                ];

            expectedMSRP = [
                15500
                28500
                22375
                45000
                ];
            
            tol = 1e-8;
            tc.verifyTrue(AreMatricesSame(TS.Year,expectedYear,tol));
            tc.verifyTrue(AreMatricesSame(TS.MSRP,expectedMSRP,tol));
            
            %Sort by MSRP
            TS = tableManip.SortBySpecifiedColumn('MSRP');
            
            expectedYear = [
                1998
                2013
                2008                
                2015
                ];

            expectedMSRP = [
                15500
                22375
                28500
                45000
                ];
            
            tol = 1e-8;
            tc.verifyTrue(AreMatricesSame(TS.Year,expectedYear,tol));
            tc.verifyTrue(AreMatricesSame(TS.MSRP,expectedMSRP,tol));
        end
    end
end
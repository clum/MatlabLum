classdef tableConstants
    %TABLECONSTANTS Generate table oebjects for testing and development
    %
    %Christopher Lum
    %lum@uw.edu
    
    %Version History
    %11/21/24: Created
    
    %----------------------------------------------------------------------
    %Public methods
    %----------------------------------------------------------------------
    methods
        %Constructors
        function obj = tableConstants(varargin)
            %TABLECONSTANTS  Constructor for the object
            %
            %   [OBJ] = TABLECONSTANTS() creates an object.
            %
            %INPUT:     -None
            %
            %OUTPUT:    -OBJ:   tableConstants object
            %
            %Christopher Lum
            %lum@uw.edu
            
            %Version History
            %11/21/24: Created
            
            %------------------OBTAIN USER PREFERENCES---------------------
            switch nargin
                case 0
                    
                otherwise
                    error('Invalid number of inputs for constructor');
            end

            %------------------CHECKING DATA FORMAT------------------------
            
            %--------------------BEGIN CALCULATIONS------------------------
            obj = [];
        end
        
        %Destructor
        function delete(obj)
        end
    end

    %----------------------------------------------------------------------
    %Static methods
    %----------------------------------------------------------------------
    methods(Static)
        function [T] = SetupTable(ID)
            %SETUPTABLE Creates a table
            %
            %   [T] = SETUPTABLE(ID) creates a table object.
            %
            %INPUT:     -ID:    tableID object
            %
            %OUTPUT:    -T:     table object
            %
            %Christopher Lum
            %lum@uw.edu
            
            %Version History
            %11/21/24: Created
            %01/06/25: Added Spending01 case
            
            switch ID
                case tableID.Vehicles01
                    Make = categorical({
                        'Ford'
                        'Nissan'
                        'Volvo'
                        'Ford'
                        });

                    Model = {
                        'Transit 350XLT'
                        'Leaf S'
                        'XC70'
                        'F150'
                        };

                    Year = [
                        2015
                        2013
                        2008
                        1998
                        ];

                    MSRP = [
                        45000
                        22375
                        28500
                        15500
                        ];

                    Comment = {
                        '15 passenger van'
                        'approx 80 miles max range'
                        'Red'
                        'Crew cab configuration'
                        };

                    T = table(Make,Model,Year,MSRP,Comment);

                case tableID.Spending01
                    seed = 0;
                    rng(seed);
                    
                    t = [0:1:50]';
                    dataA = t.^2 + 50*rand(length(t),1);
                    dataB = 3*t + 40*rand(length(t),1);
                    dataC = 300 + 30*sin(t)+30*rand(length(t),1) - 3*t;
                    
                    T = table(dataA,dataB,dataC);
                    
                    T.Properties.VariableNames = {
                        '401K'
                        'Commuting Fees'
                        'Vacations'
                        };
                    
                otherwise
                    error('Unsupported tableID')
            end
            
        end
    end
    
end
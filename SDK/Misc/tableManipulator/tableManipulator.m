classdef tableManipulator
    %Class for operating on table objects.
    %
    %Christopher Lum
    %lum@uw.edu
    
    %Version History
    %07/21/24: Created
    %11/02/24: Added ContainsSpecifiedHeader
    %11/21/24: Changing name of class

    %----------------------------------------------------------------------
    %Public properties/fields
    %----------------------------------------------------------------------
    properties (GetAccess='public', SetAccess='public')
        %table object
        T;
    end   
    
    %----------------------------------------------------------------------
    %Private properties/fields
    %----------------------------------------------------------------------
    properties (GetAccess='private', SetAccess='private')
    end
    
    %----------------------------------------------------------------------
    %Public Dependent properties/fields
    %----------------------------------------------------------------------
    properties (Dependent)
        VariableNames;
        NumRows;
        NumCols;
    end

    %----------------------------------------------------------------------
    %Public methods
    %----------------------------------------------------------------------
    methods
        %Constructors
        function obj = tableManipulator(varargin)
            %tableManipulator  Constructor for the object
            %
            %   [OBJ] = tableManipulator(T) creates an object to manipulate
            %   the specified table, T.
            %
            %INPUT:     -T: table object
            %
            %OUTPUT:    -OBJ:   tableManipulator object
            %
            %Christopher Lum
            %lum@uw.edu
            
            %Version History
            %07/21/24: Created
            %11/21/24: Updated name
            
            %------------------OBTAIN USER PREFERENCES---------------------
            switch nargin
                case 1
                    %User supplies all inputs
                    T = varargin{1};
                    
                otherwise
                    error('Invalid number of inputs for constructor');
            end

            %------------------CHECKING DATA FORMAT------------------------
            assert(isa(T,'table'),'T should be a table object')
            
            %--------------------BEGIN CALCULATIONS------------------------
            obj.T       = T;
        end
        
        %Destructor
        function delete(obj)
        end
        
        %Get/Set
        function value = get.VariableNames(obj)
            value = obj.T.Properties.VariableNames;
        end

        function value = get.NumRows(obj)
            [value,~] = size(obj.T);
        end

        function value = get.NumCols(obj)
            [~,value] = size(obj.T);
        end
                
        %Class API       
        function [varargout] = RemoveUnusedCategories(varargin)
            %RemoveUnusedCategories Removes unused categories from table
            %
            %   [T] = RemoveUnusedCategories() Cycles through all the
            %   columns of the table and for any columns that are
            %   categorical arrays this removes unused categories from the
            %   category definition.
            %
            %INPUT:     -None
            %
            %OUTPUT:    -Table with categories removed
            %
            %Christopher Lum
            %lum@uw.edu
            
            %Version History
            %07/21/24: Created
            
            %------------------OBTAIN USER PREFERENCES---------------------
            switch nargin
                case 1
                    %User supplies all inputs
                    obj     = varargin{1};
                    
                otherwise
                    error('Invalid number of inputs');
            end            
            
            %------------------CHECKING DATA FORMAT------------------------
                        
            %--------------------BEGIN CALCULATIONS------------------------
            T2 = obj.T;
            varNames = obj.VariableNames;

            for k=1:obj.NumCols
                varName = varNames{k};
                col = T2.(varName);

                if(isa(col,'categorical'))
                    col2 = removecats(col);
                    T2.(varName) = col2;

                end
            end

            varargout{1} = T2;
        end

        function [containsHeader] = ContainsSpecifiedHeader(obj,header)
            %ContainsSpecifiedHeader Checks if table has specified header 
            %
            %   [containsHeader] = ContainsSpecifiedHeader(header) Checks
            %   if table has the specified header.
            %
            %INPUT:     -header: specified header name
            %
            %OUTPUT:    -containsHeader:    true if table has header
            %
            %Christopher Lum
            %lum@uw.edu
            
            %Version History
            %11/02/24: Created
            
            %------------------OBTAIN USER PREFERENCES---------------------
            
            %------------------CHECKING DATA FORMAT------------------------
            %header
            assert(isa(header,'char'),'header should be a char')
                        
            %--------------------BEGIN CALCULATIONS------------------------
            headers = obj.VariableNames;
            containsHeader = ~isempty(find(strcmp(headers,header)==1));
        end

    end
    
    %----------------------------------------------------------------------
    %Static methods
    %----------------------------------------------------------------------
    methods(Static)
    end
    
end


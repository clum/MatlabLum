classdef LumFunctionsMisc
    %A class for providing miscellaneous operations.
    %
    %Christopher Lum
    %lum@uw.edu
    
    %Version History
    %01/05/15: Created from C# version of this struct
    %12/04/23: Renamed class

    %----------------------------------------------------------------------
    %Static methods
    %----------------------------------------------------------------------
    methods(Static)
        function [eq] = AreValuesApproximatelyEqual(varargin)
            %AreValuesApproximatelyEqual Checks if values are approx equal 
            %
            %   [eq] = UWFunctionsMisc.AreValuesApproximatelyEqual(a, b,
            %   tol) checks if a and b are equal within the specified
            %   tolerance. 
            %
            %   if tol is ommited, this assumes a tolerance of 0.
            %
            %INPUT:     a:      first value
            %           b:      second value
            %           tol:    tolerance (optional)
            %
            %OUTPUT:    eq:     1 if vals are approx equal, 0 otherwise
            %
            %Christopher Lum
            %lum@uw.edu
            
            %Version History
            %??/??/??: Created from C# version of this struct
            %03/25/19: Fixed error where NaN was not handled correctly.
            %12/04/23: Minor update to documentation
    
            switch nargin
                case 3
                    %User supplies all inputs
                    a   = varargin{1};
                    b   = varargin{2};
                    tol = varargin{3};
                    
                case 2
                    %Assume 0 tolerance
                    a   = varargin{1};
                    b   = varargin{2};
                    tol = 0;
                    
                otherwise
                    error('Invalid number of inputs');
            end
            
            if(isnan(a) && isnan(b))
                %Both are NaN
                eq = true;
                return
                
            elseif(isnan(a) && ~isnan(b))
                %1 is NaN, other is not
                eq = false;
                return
                
            elseif(~isnan(a) && isnan(b))
                %1 is NaN, other is not
                eq = false;
                return
                
            else
                %Both are not NaN values                
                if(abs(a-b) > abs(tol))
                    eq = false;
                else
                    eq = true;
                end
            end
        end
        
        function [y] = IsObjectInRange(val, valMin, valMax)
            %IsObjectInRange Checks if value is in range or not
            %
            %   [y] = UWFunctionsMisc.IsObjectInRange(val, valMin, valMax)
            %   returns true if scalar val is in the range [valMin,
            %   valMax], returns false otherwise.
            %
            %   valMin must be less than or equal to valMax. 
            %
            %INPUT:     val:        val
            %           valMin:     minimum of the range
            %           valMax:     maximum of the range
            %
            %OUTPUT:    y:          1 if val is in range, 0 otherwise
            %
            %Christopher Lum
            %lum@uw.edu
            
            %Version History
            %??/??/??: Created from C# version of this struct
            %09/10/17: Fixed output to be a logical
            %12/04/23: Minor update to documentation
            
            if(valMin > valMax)
                error('LumFunctionsMisc.IsObjectInRange: minimum value must be less than or equal to maximum value.')
            end
            
            if((val >= valMin) && (val <= valMax))
                y = true;
            else
                y = false;
            end
        end
        
        function [y] = IsObjectInRangeExclusive(val, valMin, valMax)
            %IsObjectInRangeExclusive Checks if value is in range or not
            %
            %   [y] = UWFunctionsMisc.IsObjectInRangeExclusive(val, valMin,
            %   valMax) returns true if scalar val is in the range (valMin,
            %   valMax), returns false otherwise.
            %
            %   valMin must be less than or equal to valMax.
            %
            %INPUT:     val:        val
            %           valMin:     minimum of the range
            %           valMax:     maximum of the range
            %
            %OUTPUT:    y:          1 if val is in range, 0 otherwise
            %
            %Christopher Lum
            %lum@uw.edu
            
            %Version History
            %??/??/??: Created from C# version of this struct
            %09/10/17: Fixed output to be a logical
            %12/04/23: Minor update to documentation
            
            if(valMin > valMax)
                error('LumFunctionsMisc.IsObjectInRangeExclusive: minimum value must be less than or equal to maximum value.')
            end
            
            if((val > valMin) && (val < valMax))
                y = true;
            else
                y = false;
            end
        end
    end
    
end


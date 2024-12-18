function [ret] = BitSetToValue(x,position,value)

%BitSetToValue Sets the specified bit to either 0 or 1.
%
%   [ret] = BitSetTo0(x,position) Sets the specified bit to 0.
%
%INPUT:     -x:         original value
%           -position:  0-based position in range [0,7] 
%                       (0 = 1st (LSB) bit,7 = 8th (MSB) bit)
%           -value:     true = 1, false = 0
%
%OUTPUT:    -ret:       modified value with bit at specified position set
%                       to 0 or 1
%
%Christopher Lum
%lum@uw.edu

%Version History
%12/15/24: Created

if(value)
    ret = BitSetTo1(x,position);
else
    ret = BitSetTo0(x,position);
end
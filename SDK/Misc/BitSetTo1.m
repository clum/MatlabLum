function [ret] = BitSetTo1(x,position)

%BitSetTo1 Sets the specified bit to 1.
%
%   [ret] = BitSetTo1(x,position) Sets the specified bit to 1.
%
%INPUT:     -x:         original value
%           -position:  0-based position in range [0,7] 
%                       (0 = 1st (LSB) bit,7 = 8th (MSB) bit)
%
%OUTPUT:    -ret:       modified value with bit at specified position set
%                       to 1
%
%Christopher Lum
%lum@uw.edu

%Version History
%12/15/24: Created

mask = BitMask(position);
ret = bitor(x,mask);
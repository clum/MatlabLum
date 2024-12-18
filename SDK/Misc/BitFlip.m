function [ret] = BitFlip(x,position)

%BitFlip Flips the specified bit to its opposite value.
%
%   [ret] = BitFlip(x,position) Flips the specified bit to its opposite
%   value.
%
%INPUT:     -x:         original value
%           -position:  0-based position in range [0,7] 
%                       (0 = 1st (LSB) bit,7 = 8th (MSB) bit)
%
%OUTPUT:    -ret:       modified value with bit at position flipped
%
%Christopher Lum
%lum@uw.edu

%Version History
%12/17/24: Created

mask = BitMask(position);
ret = bitxor(x,mask);
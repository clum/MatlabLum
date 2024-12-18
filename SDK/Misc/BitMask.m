function [mask] = BitMask(position)

%BitMask Create a bit mask with a 1 at the specified position.
%
%   [mask] = BitIs1(position) Create a bit mask with a 1 at the specified
%   position and 0s everywhere else.
%
%INPUT:     -position: 0-based position in range [0,7] 
%                      (0 = 1st (LSB) bit,7 = 8th (MSB) bit)
%
%OUTPUT:    -mask:     An 8 bit mask
%
%Christopher Lum
%lum@uw.edu

%Version History
%12/15/24: Created

x = 0b00000001;
mask = bitshift(x,position);
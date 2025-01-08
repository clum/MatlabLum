function zeta = CalculateDampingRatio(complex_number,imag_part)

%CALCULATEDAMPINGRATIO Calculates the damping ratio associated with the
%   complex number
%
%   [zeta] = CALCULATEDAMPINGRATIO(complex_number) calculates the damping
%   ratio associated with the complex number.
%
%   [zeta] = CALCULATEDAMPINGRATIO(real_part,imag_part) calculates
%   damping ratio if passed the real part and imaginary part of a complex
%   number.
%
%
%INPUT:     complex_number: Complex number
%
%                   or
%
%           real_part:      Real part of complex number
%           imag_part:      Imaginary part of complex number
%
%OUTPUT:    -zeta:          Damping ratio
%
%Also see DAMP
%
%Christopher Lum
%lum@uw.edu

%Version History
%05/05/03: Created
%02/28/04: Added documentation and allows calculation of zeta if passed the
%          real and imaginary parts
%11/24/04: Added check if pole was unstable
%01/07/25: Updated documentation

%---------------------OBTAIN USER PREFERENCES-----------------------------
switch nargin
    case 1
        %User give complex number
        Re = real(complex_number);
        Im = imag(complex_number);
    case 2
        %User gives real part and imaginary part
        Re = complex_number;
        Im = imag_part;
end

%---------------------CALCULATE DAMPING RATIO------------------------
%Check to make sure pole is stable
if Re>0
    %Pole is unstable
    zeta = -1;
else
    %Pole is stable
    num = -Re;
    den = (Im.^2+Re.^2).^0.5;

    zeta = num./den;
end
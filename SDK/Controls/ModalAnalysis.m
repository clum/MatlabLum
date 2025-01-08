function ModalAnalysis(A)

%MODALANALYSIS  Analyze modes of A matrix.
%
%   MODALANALYSIS(A) prints the modes, damping ratio, natural frequency,
%   and eigenvector for a specific mode in the A matrix
%
%Christopher Lum
%lum@uw.edu

%Version History
%11/2?/04: Created
%11/28/04: Added documentation
%12/01/04: Added CalculateDampingRatio function to be included with this
%          file so this function is a stand alone function and makes no
%          external function call.
%01/07/25: Updated documentation

%Eigenvalues and damping
damp(A)
[V,D] = eig(A);

%Eigenvalues
lambda = diag(D);

%Calculate the damping ratio for each lambda
for counter=1:length(lambda)
    %Damping ratio
    zeta(counter,1) = CalculateDampingRatio(lambda(counter));

    %Natural frequency
    wn(counter,1) = abs(lambda(counter));
end

%Look at the absolute values of the eigenvectors
for counter=1:length(A)
    vi = V(:,counter);

    vi_real = real(vi);
    vi_imag = imag(vi);

    vi_abs = (vi_real.^2 + vi_imag.^2).^(1/2);

    Vabs(:,counter) = vi_abs;
end

%Display the data of the eigenvalue, eigenvector, damping ratio, and
%frequency of the each mode
counter = 1;
break_flag = 0;
while break_flag~=1

    lambda_i = lambda(counter);
    vabs_i = Vabs(:,counter);
    zeta_i = zeta(counter);
    wn_i = wn(counter);

    %Check if this is an imaginary pole
    if imag(lambda_i)~=0
        %This has imaginary components.
        lambda_i_real = real(lambda_i);
        lambda_i_imag = imag(lambda_i);

        disp('---------------------------------')
        disp(['lambda = ',num2str(lambda_i_real),'+/-',num2str(lambda_i_imag),'i'])
        disp(['zeta   = ',num2str(zeta_i)])
        disp(['wn     = ',num2str(wn_i)])
        disp('Eigenvector (Absolute value)')
        vabs_i
        disp('---------------------------------')

        %Skip 2 modes since next mode is just complex conjugate
        counter = counter + 2;

    else
        %lambda_i is real
        disp('---------------------------------')
        disp(['lambda = ',num2str(lambda_i)])
        disp(['zeta   = ',num2str(zeta_i)])
        disp(['wn     = ',num2str(wn_i)])
        disp('Eigenvector (Absolute value)')
        vabs_i
        disp('---------------------------------')

        %Increment counter
        counter = counter + 1;
    end

    %Check if we can exit
    if counter > length(lambda)
        break_flag = 1;
    end
end

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
%          real and imaginary part.
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
%Check to make sure pole is stable.
if Re>0
    %Pole is unstable
    zeta = -1;
end

%Check if pole is at origin
if Re==0
    %Pole is at origin or neutrally stable
    zeta = -1;
end

if (Re<0)
    %Pole is stable
    num = -Re;
    den = (Im.^2+Re.^2).^0.5;

    zeta = num./den;
end
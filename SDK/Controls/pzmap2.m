function [P,Z] = pzmap2(G,OPTIONS,COLOR)

%PZMAP2     Pole-zero map of LTI models.
%
%   PZMAP2(G) computes the poles and zeros of the G and plots them on the
%   complex plane.  The poles are plotted as x's and the zeros are plotted
%   as o's.
%
%   PZMAP2(G,OPTIONS) computs the pole zero map as above but allows user to
%   turn off the unit circle plot if the system is discrete.
%
%   PZMAP2(G,OPTIONS,COLOR) computs the pole zero map as above but allows
%   user to specify what COLOR to use in plot.  COLOR should be a vector of
%   red, green, blue values such as that returned by JET, HSV, etc.
%
%   [P,Z] = PZMAP2(...) returns the poles and zeros of the system in vector
%   form.  No plot is drawn to the screen.
%
%
%INPUT:     -G:         System G(s) in transfer function form.
%           -OPTIONS:   Plot unit circle for discrete system
%                       (1 = yes, 0 = no)
%           -COLOR:     Color to use for x's or o's
%
%OUTPUT:    -P:         Poles of system
%           -Z:         Zeros of system
%
%Also see PZMAP, POLE, ZERO
%
%Christopher Lum
%lum@uw.edu

%Version History
%06/09/04: Created
%12/02/04: Created so that user can specify color of x's and o's.
%01/07/25: Updated documentation

%---------------------OBTAIN USER PREFERENCES-----------------------------
switch nargin
    case 2
        %Assume just a blue x's and o's
        COLOR = [0 0 1];

    case 1
        %Assume they want the unit circle drawn and every thing above
        OPTIONS = 1;
        COLOR = [0 0 1];
end

%Obtain the poles and the zeros of the system
[num,den,T] = tfdata(G,'v');

Z = roots(num);
P = roots(den);

%Obtain the real and imaginary parts
P_real = real(P);
P_imag = imag(P);

Z_real = real(Z);
Z_imag = imag(Z);

%Only plot if use does not ask for return variables
if nargout==0
    %Plot the poles and zeros on the unit circle
    hold on
    plot(P_real,P_imag,'x','Color',COLOR)
    plot(Z_real,Z_imag,'o','Color',COLOR)
    hold off

    %If this is a discrete system, plot the unit circle as well
    if (T~=0) & (OPTIONS==1)
        N = 500;
        t = linspace(0,1,N);
        circle_x = cos(2*pi*t);
        circle_y = sin(2*pi*t);

        hold on
        plot(circle_x,circle_y,'k--')
        title('Pole Zero Map of Discrete System G(z)')
    else
        title('Pole Zero Map of Continuous System G(s)')
    end
    xlabel('Real')
    ylabel('Imag')
    grid
end
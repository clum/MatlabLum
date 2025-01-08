function [Gm,Pm,Wcg,Wcp,omega,magnitude_dB,phase_deg,imag_number] = ...
    CalculateBodePlot(G,wstart,wend,N,crossing_angle,plotselection,magMinDB,magMaxDB,phaseMinRad,phaseMaxRad)

%CALCULATEBODEPLOT Bode frequency response of LTI models.
%
%   CALCULATEBODEPLOT(G) draws the Bode plot of the LTI model G
%   (created with TF only).  The frequency range and number of points are
%   preset and may need to be modified.
%
%   CALCULATEBODEPLOT(G,wstart,wend) draws the Bode plot as specified above
%   with frequencies between wstart and wend with 200 points in between.
%
%   CALCULATEBODEPLOT(G,wstart,wend,N) draws the Bode plot as specified
%   above with N point between them.
%
%   CALCULATEBODEPLOT(G,wstart,wend,N,crossing_angle) draws the Bode plot
%   as specified above and calculates the gain and phase margin using the
%   critical phase angle as crossing_angle.  If not specified, this is
%   always assumed to be -180 degrees.
%
%   CALCULATEBODEPLOT(G,wstart,wend,N,crossing_angle,plotselection) draws
%   the Bode plot as specified above and allows the plotting feature to be
%   turned off.  Specify plotselection=1 for to draw the plot and anything
%   else to suppress the plot.
%
%   CALCULATEBODEPLOT(G,wstart,wend,N,crossing_angle,plotselection, magMin,
%   magMax, phaseMin, phaseMax) does as above but allows the y-axis of the
%   magnitude and phase plots to be set to [magMinDB, magMaxDB], and
%   [phaseMinRad, phaseMaxRad], respectively.  Any of these can be set to
%   -1 to yield an automatic calculation of a reasonable value.
%
%   For discrete-time models with sample time Ts, CALCULATEBODEPLOT uses
%   the transformation z = exp(j*omega*Ts).  Frequencies up to the Nyquist
%   frequency of pi/Ts is calculated.
%
%   [Gm,Pm,Wcg,Wcp,omega,magnitude_dB,phase_deg,imag_number]
%   =CALCULATEBODEPLOT(...) draws the bode plot in any of the manners
%   described above and returns the gain and phase margin (Gm and Pm
%   respectively) and the frequencies where these occur (Wcg and Wcp
%   respectively).  This calculates up to the first two gain and phase
%   margins and their frequencies.  This also returns the array of omega
%   values used along with the magnitude in decibels and the phase in
%   degrees.  Lastly, this returns the vector or imaginary numbers used to
%   calculate the bode plot.  This may be helpful for drawing a Nyquist
%   plot if desired.
%
%INPUT:     -G:                 System G(s) in transfer function form.
%           -wstart:            Low value of omega (rad/s)
%           -wend:              High value of omega (rad/s)
%           -N:                 Number of values omega values to use
%           -crossing_angle:    Crossing angle for phase to get Gm (deg)
%           -plotselection:     Do you actually want to display the plot?
%           -magMinDB:          minimum y-axis for magnitude plot (dB)
%           -magMaxDB:          maximum y-axis for magnitude plot (dB)
%           -phaseMinRad:       minimum y-axis for phase plot (rad)
%           -phaseMaxRad:       maximum y-axis for phase plot (rad)
%
%OUTPUT:    -Gm:                Gain margins (dB)
%           -Pm:                Phase margins(degrees)
%           -Wcg:               Frequencies where gain margins occur (rad/s)
%           -Wcp:               Frequencies where phase margins occur (rad/s)
%           -omega:             Frequencies used to plot bode plot (rad/s)
%           -magnitude_dB:      Array of magnitude plot (dB)
%           -phase_deg:         Array of phase plot (deg)
%
%Also see BODE, MARGIN, ALLMARGIN
%
%Christopher Lum
%lum@uw.edu

%Version History
%05/01/03: Created
%05/04/03: Added plot supression feature
%05/06/03: Added feature so that gain margin can be calculated when the
%          phase crosses an angle other than -180 degrees.
%05/24/03: Added feature so that two phase margins are calculated
%06/09/03: Added output of magnitude in dB and phase in deg and the
%          corresponding frequencies
%01/31/04: Fixed bug that occured when there was no phase margin.  Also
%          added ability to not define crossing angle or plot selection
%          during function call.
%02/17/04: Added ability to plot discrete systems.  Also redid help file
%          and added more nargin parts for the user preferences.  Also
%          fixed phase margin bug.
%02/18/04: Added feature so automatically distinguishes between discrete
%          and continuous system. Also made automatic calculation of plot
%          range if wend and wstart are not obtained based on min and max
%          break frequencies in the transfer function.
%03/30/04: Added feature to return vector of imaginary numbers used to draw
%          bode plot.
%06/03/04:  Made it so that this doesn't automatically create a new figure.
%11/26/14: Added y-axis limits
%01/07/25: Updated documentation

%---------------------OBTAIN USER PREFERENCES-----------------------------
switch nargin
    case 10
        %user supplies all inputs

    case 6
        %Assume they want automatic y-axis calculations and everything
        %above.
        magMinDB        = -1;
        magMaxDB        = -1;
        phaseMinRad     = -1;
        phaseMaxRad     = -1;

    case 5
        %Assume they want a plot and everything above.
        plotselection   = 1;
        magMinDB        = -1;
        magMaxDB        = -1;
        phaseMinRad     = -1;
        phaseMaxRad     = -1;

    case 4
        %Assume crossing angle is -180 degrees and everything above.
        crossing_angle  = -180;
        plotselection   = 1;
        magMinDB        = -1;
        magMaxDB        = -1;
        phaseMinRad     = -1;
        phaseMaxRad     = -1;

    case 3
        %Assume 200 points and everything above.
        N               = 200;
        crossing_angle  = -180;
        plotselection   = 1;
        magMinDB        = -1;
        magMaxDB        = -1;
        phaseMinRad     = -1;
        phaseMaxRad     = -1;

    case 1
        %Assume everything above but calculate automatic frequencies.
        wstart          = -1;
        wend            = -1;
        N               = 200;
        crossing_angle  = -180;
        plotselection   = 1;
        magMinDB        = -1;
        magMaxDB        = -1;
        phaseMinRad     = -1;
        phaseMaxRad     = -1;

end

%--------------------CALCULATE MAGNITUDE AND PHASE----------------------
%Is this system discrete or continuous?
[num,den,Ts] = tfdata(G,'v');

if Ts==0
    %System is continuous
    discrete = 0;
else
    %System is discrete
    discrete = 1;
end

%If user does not specify wstart and wend, automatically calculate these
%based on the break frequencies of the poles and zeros
if wstart==-1
    min_break_frequency = min([abs(roots(num));abs(roots(den))]);
    max_break_frequency = max([abs(roots(num));abs(roots(den))]);

    %Pad these by starting a 2 decades below min_break_frequency and ending
    %2 decades above max_break_frequency
    wstart = 0.01*min_break_frequency;
    wend = 100*max_break_frequency;
end

%Calculate the omega values to use
if discrete==1
    %System is discrete, only use values up to nyquist frequency of pi/T
    %Find the max frequency
    wend = pi/Ts;

    X1 = log10(wstart);
    X2 = log10(wend);

else
    %System is continuous, so plot all specified frequencies.
    X1 = log10(wstart);
    X2 = log10(wend);
end

omega = logspace(X1,X2,N);

length_num = length(num);
length_den = length(den);

if discrete==1
    %Discrete System, so calculate imaginary number using z=exp(-j*omega*T)
    for counter=1:length(omega)
        current_omega = omega(counter);

        %Calculate numerator complex number at this omega
        for k=1:length(num)

            %Starting from the last index, what is the index number
            current_index = length(num) - k + 1;
            current_coefficient_num = num(current_index);

            %What power of z is this raised to?
            power = k - 1;

            imag_number_num(current_index) = current_coefficient_num*((exp(j*current_omega*Ts))^power);
        end

        %Calculate denominator complex number at this omega
        for m=1:length(den)
            current_index = length(den) - m + 1;
            current_coefficient_den = den(current_index);
            power = m - 1;
            imag_number_den(current_index) = current_coefficient_den*(exp(j*current_omega*Ts))^power;
        end

        %Obtain the overall imaginary number
        imag_number(counter) = sum(imag_number_num)/sum(imag_number_den);
    end

else
    %Continuous system, so calculate imaginary number using s=j*omega
    for counter=1:length(omega)
        current_omega = omega(counter);

        %Calculate numerator complex number at this omega
        for k=1:length(num)

            %Starting from the last index, what is the index number
            current_index = length(num) - k + 1;
            current_coefficient_num = num(current_index);

            %What power of s is this raised to?
            power = k - 1;

            imag_number_num(current_index) = current_coefficient_num*((j*current_omega)^power);
        end

        %Calculate denominator complex number at this omega
        for m=1:length(den)
            current_index = length(den) - m + 1;
            current_coefficient_den = den(current_index);
            power = m - 1;
            imag_number_den(current_index) = current_coefficient_den*(j*current_omega)^power;
        end

        %Obtain the overall imaginary number
        imag_number(counter) = sum(imag_number_num)/sum(imag_number_den);
    end
end

%Calculate the magnitude in decibels
magnitude = abs(imag_number);
magnitude_dB = 20*log10(magnitude);

%Calculate the phase in degrees
phase = unwrap(angle(imag_number));
phase_deg = phase*180/pi;

%If the phase is too large, we need to subtract 360 degrees
if max(phase_deg)>90;
    phase_deg = phase_deg - 360;
end

%If the phase is too small, we should add on 360 degrees
if min(phase_deg)<-360;
    phase_deg = phase_deg + 360;
end

%-----------------------FINDING GAIN MARGIN---------------------------
%Find where the phase is greater and less than the crossing angle
greater_indices = find(phase_deg > crossing_angle);
lower_indices = find(phase_deg <= crossing_angle);

for counter=1:length(phase_deg)
    %Check to see if index is an index where the phase is above crossing
    %angle
    check = find(counter==greater_indices);
    if check>0
        above_phase(counter) = phase_deg(counter);
        below_phase(counter) = 0;
    else
        above_phase(counter) = 0;
        below_phase(counter) = phase_deg(counter);
    end
end

%Check to see if plot starts below the crossing angle or above
if phase_deg(1) > crossing_angle

    %STARTS ABOVE CROSSING ANGLE
    for counter=1:length(above_phase)
        %Find where it drops below the crossing angle for the first time.
        if above_phase(counter)==0
            break
        else
        end
    end

    %check to see if it ever crossed the crossing angle
    if counter==length(above_phase)
        Wcg = 0;
        Gm = 0;
    else
        Wcg(1) = omega(counter);
        Gm(1) = -magnitude_dB(counter);
    end

    %Check to see if it now goes above the crossing angle again
    for counter2=counter:length(above_phase)
        if above_phase(counter2)~=0
            break
        else
        end
    end

    if counter2==length(above_phase)
    else
        Wcg(2) = omega(counter2);
        Gm(2) = -magnitude_dB(counter2);
    end

else
    %STARTS BELOW THE CROSSING ANGLE DEGREES
    for counter=1:length(below_phase)
        %Find where it goes above the crossing angle degrees for the first
        %time.
        if below_phase(counter)==0
            break
        else
        end
    end

    %check to see it it ever crossed the crossing angle
    if counter==length(above_phase)
        Wcg = 0;
        Gm = 0;
    else
        Wcg(1) = omega(counter);
        Gm(1) = -magnitude_dB(counter);
    end


    %Check to see if it now goes below the crossing angle again
    for counter2=counter:length(below_phase)
        if below_phase(counter2)~=0
            break
        else
        end
    end

    if counter2==length(below_phase)
    else
        Wcg(2) = omega(counter2);
        Gm(2) = -magnitude_dB(counter2);
    end
end             %end if loop checked to see if it starts above or below the crossing angle

%-----------------------FINDING PHASE MARGIN---------------------------
%First check to see where the magnitude drops below zero
if magnitude_dB(1)>0
    %STARTS ABOVE 0
    for counter=1:length(magnitude_dB)
        if magnitude_dB(counter)<0
            Wcp(1) = omega(counter);

            %Now find second crossing (if it exists)
            for counter2=counter+1:length(magnitude_dB)
                if magnitude_dB(counter2)>0
                    Wcp(2) = omega(counter2);
                    break
                else
                end
            end

            break       %break first for loop

        else
        end
    end

    if counter==length(magnitude_dB)
        Wcp = 0;
        Pm = 0;     %Never drops below 0 dB
    else
        %How many phase margins are there?
        if length(Wcp)==1
            %One phase margin
            Phase_at_phase_margin = phase_deg(counter);
            Pm = Phase_at_phase_margin - crossing_angle;
        else
            Phase_at_phase_margin(1) = phase_deg(counter);
            Phase_at_phase_margin(2) = phase_deg(counter2);

            Pm(1) = Phase_at_phase_margin(1) - crossing_angle;
            Pm(2) = Phase_at_phase_margin(2) - crossing_angle;
        end
    end

else
    %STARTS BELOW 0
    for counter=1:length(magnitude_dB)
        if magnitude_dB(counter)>0
            Wcp = omega(counter);

            %Now find second crossing (if it exists)
            for counter2=counter+1:length(magnitude_dB)
                if magnitude_dB(counter2)<0
                    Wcp(2) = omega(counter2);
                    break
                else
                end
            end

            break       %break frist for loop

        else
        end
    end

    if counter==length(magnitude_dB)
        Wcp = 0;
        Pm = 0;  %Infinite phase margin
    else
        %How many phase margins are there?
        if length(Wcp)==1
            %One phase margin
            Phase_at_phase_margin = phase_deg(counter);
            Pm = Phase_at_phase_margin - crossing_angle;
        else
            Phase_at_phase_margin(1) = phase_deg(counter);
            Phase_at_phase_margin(2) = phase_deg(counter2);

            Pm(1) = Phase_at_phase_margin(1) - crossing_angle;
            Pm(2) = Phase_at_phase_margin(2) - crossing_angle;
        end
    end
end

%------------------------PLOT THE BODE PLOT-------------------------
if plotselection==1
    zero_gain = zeros(1,length(omega));
    negative_180_phase = crossing_angle*ones(1,length(omega));

    %Magnitude Plots
    subplot(2,1,1)

    %No gain margins
    if Wcg==0
        semilogx(omega,magnitude_dB,Wcg,-Gm,'rx',omega,zero_gain,'k--')
        legend('Magnitude (dB)','Gain Margin = N/A',3)
        grid
    else
        if length(Wcg)==1

            %One gain margin
            semilogx(omega,magnitude_dB,Wcg,-Gm,'rx',omega,zero_gain,'k--')
            legend('Magnitude (dB)',...
                ['Gain Margin = ',num2str(Gm),' dB @ ',num2str(Wcg),' rad/s'],3)
            grid
        else

            %Two gain margins
            semilogx(omega,magnitude_dB,Wcg(1),-Gm(1),'rx',Wcg(2),-Gm(2),'ro',...
                omega,zero_gain,'k--')
            legend('Magnitude (dB)',...
                ['Gain Margin 1 = ',num2str(Gm(1)),' dB @ ',num2str(Wcg(1)),' rad/s'],...
                ['Gain Margin 2 = ',num2str(Gm(2)),' dB @ ',num2str(Wcg(2)),' rad/s'],3)
            grid
        end
    end

    if discrete==1
        title(['Discrete Bode Plot of Transfer Function w/ T = ',num2str(Ts)...
            ' (\omega_{Nyquist} = ',num2str(pi/Ts),' rad/s)'])
        ylabel('Magnitude (dB)')
    else
        title('Bode Plot of Transfer Function')
        ylabel('Magnitude (dB)')
    end

    %Phase Plots
    subplot(2,1,2)

    %No phase margins
    if Wcp==0
        semilogx(omega,phase_deg,Wcp,phase_deg(1),'rx',omega,negative_180_phase,'k--')
        legend('Phase (deg)','Phase Margin = N/A',3)
        xlabel('Frequency (rads/s)')
        ylabel('Phase (deg)')
        grid

    else
        if length(Wcp)==1
            %One phase margin
            semilogx(omega,phase_deg,Wcp,Phase_at_phase_margin,'rx',...
                omega,negative_180_phase,'k--')
            xlabel('Frequency (rad/s)')
            ylabel('Phase (deg)')
            grid

            if Pm==0
                legend('Phase (deg)','Phase Margin = N/A',3)
            else
                legend('Phase (deg)',...
                    ['Phase Margin = ',num2str(Pm),' deg @ ',num2str(Wcp),' rad/s'],3)
            end

        else
            %Two phase margins
            semilogx(omega,phase_deg,Wcp(1),Phase_at_phase_margin(1),'rx',...
                Wcp(2),Phase_at_phase_margin(2),'ro',...
                omega,negative_180_phase,'k--')
            xlabel('Frequency (rad/s)')
            ylabel('Phase (deg)')
            grid

            legend('Phase (deg)',...
                ['Phase Margin 1 = ',num2str(Pm(1)),' deg @ ',num2str(Wcp(1)),' rad/s'],...
                ['Phase Margin 2 = ',num2str(Pm(2)),' deg @ ',num2str(Wcp(2)),' rad/s'],3)
        end
    end

    %Fix the axis
    padding = 0.25;                 %ie pad 25% above and below max y-values

    if(magMinDB == -1)
        min_dB = min(magnitude_dB)*(1 - padding*sign(min(magnitude_dB)));
    else
        min_dB = magMinDB;
    end

    if(magMaxDB == -1)
        max_dB = max(magnitude_dB)*(1 + padding*sign(max(magnitude_dB)));
    else
        max_dB = magMaxDB;
    end

    if(phaseMinRad == -1)
        min_phase = min(phase_deg)*(1 - padding*sign(min(phase_deg)));
    else
        min_phase = radtodeg(phaseMinRad);
    end

    if(phaseMaxRad == -1)
        max_phase = max(phase_deg)*(1 + padding*sign(max(phase_deg)));
    else
        max_phase = radtodeg(phaseMaxRad);
    end

    subplot(2,1,1)
    axis([wstart wend min_dB max_dB])

    subplot(2,1,2)
    axis([wstart wend min_phase max_phase])

else
end
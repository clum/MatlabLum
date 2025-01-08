function [ts,ts_occur,ys] = CalculateSettlingTime(t,y,t_cmd,y_start,y_cmd,settling_percent,plotselection)

%CALCULATESETTLINGTIME Settling time for a signal.
%
%   CALCULATESETTLINGTIME(t,y) calculates the settling time of the signal y
%   with the associated time vector, t.  This assumes a 2% settling
%   percentage and assumes that the command signal was introduced at 0
%   seconds.
%
%   CALCULATESETTLINGTIME(t,y,t_cmd) calculates the settling time as
%   specified above but calculates the settling time assuming that the
%   command signal was introduced at t_cmd seconds.
%
%   CALCULATESETTLINGTIME(t,y,t_cmd,y_start,y_cmd) calculated the settling
%   time as specified above and calculates the 2% settling band based on
%   magnitude of step command = y_cmd - y_start.  If not specified, this
%   uses the first element of the y array as the start value and the last
%   value of the y array as the last value.
%
%   CALCULATESETTLINGTIME(t,y,t_cmd,y_start,y_cmd,settling_percent)
%   calculates the settling time as specified above with a variable
%   settling percentage.
%
%   CALCULATESETTLINGTIME(t,y,t_cmd,y_start,y_cmd,settling_percent,plot)
%   calculates the settling time as specified above and allows the plot
%   feature to be suppressed.  Enter plot = 0 to suppress the plot feature.
%
%   [ts,ts_occur,ys] = CALCULATESETTLINGTIME(...) calculates the settling
%   time as specified above and returns the settling time, ts, the time
%   when the system settles, t_occur, and the y_value when the system
%   settles (should be equal to upper or lower bound).
%
%INPUT:     -t:                 Time array
%           -y:                 Array of response
%           -t_cmd:             Time when y_cmd was introduced
%           -y_start:           Initial y value
%           -y_cmd:             Final commanded y
%           -settling_percent:  Settling percentage (%)
%           -plot:              Plot or not?  (0 = no plot)
%
%OUTPUT:    -Settling time
%           -Time when system settles
%           -y value of the settled system (should be equal to upper or
%            lower bound)
%
%Christopher Lum
%lum@uw.edu

%Version History
%05/17/03: Created
%05/18/03: Fixed problem that if signal never goes above or below the
%          bounds, then the indices_above or the indices_below array would
%          be null.
%02/28/04: Updated documentation and added automatic user parameter
%          calculation.  Also added y_cmd signal to plot.
%04/02/04: Changed it so y_cmd 'rx' was plotted at t_cmd instead of t(1).
%01/07/25: Updated documentation.  Removed extraneous else statements

%------------------CHECKING DATA FORMAT----------------------------
if (nargin==1) | (nargin==4)
    error('Number of input arguments is inconsistent')
end

%Check to make sure that the t and y arrays are in column form
[t_rows t_columns] = size(t);
[y_rows y_columns] = size(y);

if (t_columns>1 & t_rows>1) | (y_columns>1 & y_rows>1)
    error('t and y arrays must be single column or row vectors!')
end

if t_columns>1
    t = t';
end

if y_columns>1
    y = y';
end

%Check to make sure the t and y arrays are coincident
if length(y)~=length(t)
    error('t and y arrays are not the same length!')
end

%---------------------OBTAIN USER PREFERENCES-----------------------------
switch nargin
    case 6
        %Assume they want a plot and everything above
        plotselection = 1;

    case 5
        %Assume 2% settling time and everything above
        plotselection = 1;
        settling_percent = 2;

    case 3
        %Assume y_start = y(1) and y_cmd = y(end) and everything above
        plotselection = 1;
        settling_percent = 2;
        y_start = y(1);
        y_cmd = y(end);

    case 2
        %Assume t_cmd = 0 seconds and everything above
        plotselection  =1;
        settling_percent = 2;
        y_start = y(1);
        y_cmd = y(end);
        t_cmd = 0;
end

%Check to see if settling_percent is defined by user
if settling_percent==0
    warning('System will never settle to within 0%.  Calculating settling time based on 2% method')
    settling_percent = 2;
end

if (y_cmd - y_start)==0
    warning('y_cmd - y_start = 0.  Magnitude of step input is 0')
end

%-----------------------BEGIN CALCULATIONS---------------------------
%Convert the percentage
settling_percent = settling_percent/100;

%Calculate the magnitude of the step
magnitude = y_cmd - y_start;

%What are the bounds of the settled system
y_upper = y_cmd + (magnitude*settling_percent);
y_lower = y_cmd - (magnitude*settling_percent);

%Find all of the indices above and below the bounds
indices_above = find(y > y_upper);
indices_below = find(y < y_lower);

%If the signal never goes above or below the bounds, either the
%indices_above or indices_below array will be null, set this to zero if
%this occurs
if length(indices_above)==0
    indices_above = 0;
end

if length(indices_below)==0
    indices_below = 0;
end

%The maximum index in the indices_above should be where last index before
%the system settled
max_above_and_below_index = [max(indices_above) max(indices_below)];

%If the system never settled then either the max_above_index or
%max_below_index should be equal to the lenght of the y array
if max_above_and_below_index(1)==length(y) | max_above_and_below_index(2)==length(y)
    settled_or_not = 0;         %system never falls within region
    ts = 0;
    ts_occur = 0;
    ys = 0;
else
    settled_or_not = 1;         %system settles within bounds

    %System settles to within the bounds, find of at what index it does
    %this.  The max_above_and_below_index is where the system is still not
    %settled, so need to add one to the index
    settled_index = max(max_above_and_below_index) + 1;

    %Calculate the time when the system becomes settled
    ts_occur = t(settled_index);

    %Calculate the y value when the system becomes settled (should be equal
    %to either the upper or the lower bound)
    ys = y(settled_index);

    %Calculate the settling time
    ts = ts_occur - t_cmd;
end

%For the generic plot, draw a vertical line showing where the command was
%applied.
vertical_line = [y_start y_cmd];
horizontal_line = [y_cmd y_cmd];

%Does the user want a generic plot?
if plotselection==1

    y_upper_plot = y_upper*ones(length(y),1);
    y_lower_plot = y_lower*ones(length(y),1);

    if settled_or_not==1
        %System settled
        figure
        plot(t,y,...
            ts_occur,ys,'ro',...
            t,y_upper_plot,'k--',...
            t,y_lower_plot,'k--',...
            t_cmd,y_start,'rx',...
            t(length(t)),y_cmd,'rx',...
            [t_cmd t_cmd t_cmd t(end)],[vertical_line horizontal_line])
        title('Generic Plot of t vs. y Showing Settling Time and Parameters Used for Calculations')
        xlabel('Time')
        ylabel('y')
        legend('Data',...
            'Settling Point',...
            'Upper Bound',...
            'Lower Bound',...
            ['y_{start} = ',num2str(y_start)],...
            ['y_{cmd} = ',num2str(y_cmd)],...
            ['t_{cmd} = ',num2str(t_cmd)],...
            ' ',...
            ['Settling Time = ',num2str(ts)],...
            ['Settling Percentage = ',num2str(settling_percent*100),'%'],...
            ['y_{cmd} - y_{start} = ',num2str(y_cmd - y_start)])
        grid
    else
        %System never settled
        figure
        plot(t,y,...
            t,y_upper_plot,'k--',...
            t,y_lower_plot,'k--',...
            t_cmd,y_start,'rx',...
            t(length(t)),y_cmd,'rx',...
            [t_cmd t_cmd t_cmd t(end)],[vertical_line horizontal_line])
        title('Generic Plot of t vs. y Showing Settling Time and Parameters Used for Calculations')
        xlabel('Time')
        ylabel('y')
        legend('Data',...
            'Upper Bound',...
            'Lower Bound',...
            ['y_{start} = ',num2str(y_start)],...
            ['y_{cmd} = ',num2str(y_cmd)],...
            ['t_{cmd} = ',num2str(t_cmd)],...
            ' ',...
            'Settling Time = \infty',...
            ['Settling Percentage = ',num2str(settling_percent*100),'%'],...
            ['y_{cmd} - y_{start} = ',num2str(y_cmd - y_start)])
        grid
    end
end
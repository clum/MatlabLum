function [PO,t_max,y_max] = CalculatePercentOvershoot(t,y,y_start,y_cmd,t_cmd,plotselection)

%CALCULATEPERCENTOVERSHOOT Percent overshoot of a signal
%
%   CALCULATEPERCENTOVERSHOOT(t,y) calculates the percent overshoot of the
%   signal, y, with associated time vector, t.  This assumes that the
%   magnitude of the step is equal to y(end) - y(1).
%
%   CALCULATEPERCENTOVERSHOOT(t,y,y_start,y_cmd) calculates the percent
%   overshoot where the magnitude of the change is y_start - y_cmd.
%
%   CALCULATEPERCENTOVERSHOOT(t,y,y_start,y_cmd,t_cmd) calculates the
%   percent overshoot as above but only uses data that occurs after t_cmd.
%
%   CALCULATEPERCENTOVERSHOOT(t,y,y_start,y_cmd,t_cmd,plot) calculates the
%   percent overshoot as above and allows the plot feature to be
%   suppressed.  Enter plot = 0 to suppress this feature.
%
%   [PO,t_max,y_max] = CALCULATEPERCENTOVERSHOOT(...) calculates the
%   percent overshoot as above and returns the percent overshoot, PO, in
%   percent, the time where the max peak occurs, t_max, and the maximum y
%   value attained, y_max.
%
%INPUT:     -t:         Time array
%           -y:         Array of response
%           -y_start:   Initial y
%           -y_cmd:     Final command y
%           -t_cmd:     Time when step is applied
%           -plot:      Plot or not?  (1 = yes, 0 = no)
%
%OUTPUT:    -PO:        Percent overshoot (%)
%           -t_max:     Time where max peak occurs
%           -y_max:     Value of max peak
%
%Christopher Lum
%lum@uw.edu

%Version History
%05/17/03: Created
%05/18/03: Fixed logic precedence warning on line 37
%02/28/04: Updated documentation and added automatic user parameter
%          calculation.  Also added y_cmd signal to graph.
%03/05/04: Fixed documentation.  Changed line width back to 1.
%04/02/04: Added so that it will only make calculations after t_cmd
%01/07/25: Updated documentation.  Removed extraneous else statements

%------------------CHECKING DATA FORMAT----------------------------
if (nargin==1) | (nargin==3)
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
    case 5
        %Assume they want a plot
        plotselection = 1;

    case 4
        %Assume t_cmd = t(1) and everything above
        t_cmd = t(1);

    case 2
        %Assume y_start = y(1) and y_cmd = y(end) and everything above
        plotselection = 1;
        t_cmd = t(1);
        y_start = y(1);
        y_cmd = y(end);
end

%-----------------------BEGIN CALCULATIONS---------------------------
%Find valid indices
valid_indices = find(t>t_cmd);
valid_time = t(valid_indices);
valid_y = y(valid_indices);

%Find the maximum response in the valid indices
[y_max] = max(y(valid_indices));

%what index does this occur at in the total time array?
y_max_index = find(y==y_max);

%Find time when y_max occurs
t_max = t(y_max_index);

%Calculate the magnitude fo the step
magnitude = y_cmd - y_start;

%Calculate the magnitude of the response
magnitude_reponse = y_max - y_start;

%Calculate the percent overshoot in percent
PO = ((magnitude_reponse/magnitude)*100) - 100;         %percent

%For graphical checking purposes, also plot the y_start value at the
%starting time and plot the y_end value at the end time
start_time = t_cmd;
end_time = t(end);

horizontal_line = [y_cmd y_cmd];
vertical_line = [y_start y_cmd];

%Does the user want a generic plot?
if plotselection==1
    figure
    plot(t,y,t_max,y_max,'ro',start_time,y_start,'rx',...
        [t_cmd t_cmd t_cmd t(end)],[vertical_line horizontal_line])
    title('Generic Plot of t vs. y Showing Peak, Percent Overshoot & Parameters Used for Calculations')
    xlabel('Time')
    ylabel('y')
    legend('Data','Peak',...
        ['y_{start} = ',num2str(y_start)],...
        ['y_{cmd} = ',num2str(y_cmd)],...
        ['Percent Overshoot = ',num2str(PO),'%'])
    grid
end

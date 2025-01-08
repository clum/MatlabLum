function tr = CalculateRiseTime(t,y,y_start,y_cmd,t_cmd,start_percent,end_percent,plotselection)

%CALCULATERISETIME Calculate the rise time of a signal.
%
%   CALCULATERISETIME(t,y) calculates the rise time of a signal, y, with
%   the associated time vector, t.  Assumes that the a rise time is
%   measured from 10% to 90% of final value.  Assumes that initial value is
%   1st element of y array and assumes the final value is the last element
%   of the y array.
%
%   CALCULATERISETIME(t,y,y_start,y_cmd) calculates the rise time as above
%   assuming that the initial value of the signal is y_start and the final
%   value is y_cmd
%
%   CALCULATERISETIME(t,y,y_start,y_cmd,t_cmd) calculates the rise time as
%   above but only uses times that occur after t_cmd.
%
%   CALCULATERISETIME(t,y,y_start,y_cmd,t_cmd,start,end) calculates the
%   rise time as above but calculates the time from when the signal reaches
%   start percent and end percent of the magnitude of the step.
%
%   CALCULATERISETIME(t,y,y_start,y_cmd,t_cmd,start,end,plot) calculates
%   the rise time as above and allows the plot feature to be suppressed.
%   Enter plot = 0 to suppress this feature.
%
%   [Tr] = CALCULATERISETIME(...) returns the rise time.
%
%INPUT:     -t:         Time array
%           -y:         Array of response
%           -y_start:   Initial y
%           -y_cmd:     Final command y
%           -t_cmd:     Time when y_cmd is introduced
%           -start:     Start percent in %
%           -end:       End percent in %
%           -plot:      Plot or not?  (1 = yes, 0 = no)
%
%OUTPUT:    -Tr:        Rise time
%
%Christopher Lum
%lum@uw.edu

%Version History
%05/21/03: Created
%??/??/??: Fixed bug where legend displayed incorrect start and end
%          percentage (ie if settling as 10%, legend would display 0.1%)
%03/04/04: Updated documentation and allowed for automatic parameter
%          calculation.
%03/06/04: Updated documentation and automatic parameter calculate.  Also
%          added y_cmd line to plot.
%01/07/25: Updated documentation.  Removed extraneous else statements

%------------------CHECKING DATA FORMAT----------------------------
if (nargin==1) | (nargin==3) | (nargin==6)
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
    case 7
        %Assume they want a plot
        plotselection = 1;

    case 5
        %Assume start percent is 10% and end percent is 90% and everything
        %above.
        start_percent = 10;
        end_percent = 90;
        plotselection = 1;

    case 4
        %Assume that t_cmd = t(1) and everything above.
        t_cmd = t(1);
        start_percent = 10;
        end_percent = 90;
        plotselection = 1;

    case 2
        %Assume y_start = y(1) and y_cmd = y(end) and everything above.
        y_start = y(1);
        y_cmd = y(end);
        t_cmd = t(1);
        start_percent = 10;
        end_percent = 90;
        plotselection = 1;
end

%-----------------------BEGIN CALCULATIONS---------------------------
%Find the magnitude of the step
magnitude = y_cmd - y_start;

%Check to make sure the step is a positive step
if magnitude<=0
    error('Step must be positive!')
end

%Convert the percentages to fractions
start_percent = start_percent/100;
end_percent = end_percent/100;

%Find the value of the signal where the timer should start and stop
start_value = (magnitude*start_percent) + y_start;
stop_value = (magnitude*end_percent) + y_start;

%Find out the indices when these occur.  This calculate should only be done
%after the step is applied.
valid_indices = find(t>t_cmd);
valid_time = t(valid_indices);
valid_y = y(valid_indices);

%How many indicese previously are not used?
unused_indices = min(valid_indices) - 1;

%Now add back in the unused indices
start_index = min(find(valid_y>start_value));
stop_index = min(find(valid_y>stop_value));

%For the generic plot, draw a vertical line showing where the command was
%applied.
vertical_line = [y_start y_cmd];
horizontal_line = [y_cmd y_cmd];


%Check to see if the signal reaches y_cmd
if length(stop_index)==0

    %Signal did not reach end_percent
    tr = 0;

    if plotselection==1
        figure
        plot(t,y,...
            [t_cmd t_cmd t_cmd t(end)],[vertical_line horizontal_line])
        title('Generic Plot of t vs. y Showing Rise Time and Parameters Used for Calculations')
        xlabel('Time')
        ylabel('y')
        legend('Data',...
            ['t_{cmd} = ',num2str(t_cmd)],...
            'Start Time','Stop Time',' ',...
            ['y_{start} = ',num2str(y_start)],...
            ['y_{cmd} = ',num2str(y_cmd)],...
            ['Start Percent = ',num2str(start_percent*100),'%'],...
            ['Stop Percent = ',num2str(end_percent*100),'%'],...
            'Rise Time = INF')
        grid
    end

else
    %Signal reaches end_percent

    %This is in the valid_time and valid_y array, add abck in the
    %unused_indices to obtain the index where the start and stop occur in the
    %original arrays
    start_index = start_index + unused_indices;
    stop_index = stop_index + unused_indices;

    %What is the actual value present in the y array?
    start_value_actual = y(start_index);
    stop_value_actual = y(stop_index);

    %What are the actual times?
    start_time = t(start_index);
    stop_time = t(stop_index);

    %Calculate the rise time
    tr = stop_time - start_time;

    %Does the user want a generic plot?
    if plotselection==1
        figure
        plot(t,y,...
            [t_cmd t_cmd t_cmd t(end)],[vertical_line horizontal_line],...
            start_time,start_value_actual,'ro',...
            stop_time,stop_value_actual,'rx')
        title('Generic Plot of t vs. y Showing Rise Time and Parameters Used for Calculations')
        xlabel('Time')
        ylabel('y')
        legend('Data',...
            ['t_{cmd} = ',num2str(t_cmd)],...
            'Start Time','Stop Time',' ',...
            ['y_{start} = ',num2str(y_start)],...
            ['y_{cmd} = ',num2str(y_cmd)],...
            ['Start Percent = ',num2str(start_percent*100),'%'],...
            ['Stop Percent = ',num2str(end_percent*100),'%'],...
            ['Rise Time = ',num2str(tr)])
        grid
    end
end
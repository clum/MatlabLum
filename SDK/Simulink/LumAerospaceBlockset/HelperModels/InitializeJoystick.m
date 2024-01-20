function JOYSTICK_DATA = InitializeJoystick(DESIRED_AXES_MOTION)

%INITIALIZEJOYSTICK Initializes constants for Joystick interface.
%
%   JOYSTICK_DATA = INITIALIZEJOYSTICK Returns the zero-offsets for the
%   3 joystick axes.  The zero offsets are for the current location of the
%   joystick.
%
%   JOYSTICK_DATA = INITIALIZEJOYSTICK(DESIRED_AXES_MOTION) returns the
%   gains required so that by moving the joystick in the full range of
%   motion, the output will be gauranteed to reach these values.
%
%
%INPUT:     -DESIRED_AXES_MOTION:   6x1 vector of desired range of motion
%                                   for each axes (ie DESIRED_AXES_MOTION(1)
%                                   is the desired range of motion for axes
%                                   1.
%
%OUTPUT:    -JOYSTICK_DATA: Data structure of desired joystick constants
%                   .axes_offsets:  6x1 vector containing zero offsets for each
%                                   axes.
%                   .axes_gains:    6x1 vector containing gains for each
%                                   axes so that joystick
%
%Created by Christopher Lum
%lum@u.washington.edu

%Version History:   -04/24/05: Created
%                   -05/27/06: Sometimes it appears that the sim function
%                    is not working correctly unless the model is already
%                    open.  Changed to issue a warning if all the axes
%                    offsets and gains are zero.
%                   -05/28/06: Sometimes the first few data samples are
%                    zero, need to discard these
%                   -07/12/07: Added some more descriptive warning when
%                    something goes wrong.  Still having the problem where
%                    it appears that the input from the joystick appears all
%                    zero even when the model is open.


%-----------------------CHECKING DATA FORMAT-------------------------------


%----------------------OBTAIN USER PREFERENCES-----------------------------
switch nargin
    case 1
        %User wants zero offsets and gains
        axes_gains_selection = 1;
        
    case 0
        %User only wants zero offsets
        axes_gains_selection = 0;
        
    otherwise
        error('Inconsistent number of inputs')
end

%-------------------------AXES OFFSETS--------------------------------
clc
disp('Obtaining zero offsets for current joystick orientation...')
sim('InitializeJoystick_model')

%Extract data
axes_data = simAxes.signals.values;

%Check if we got any data at all
if (max(max(axes_data)) == 0)
    error('All axes data is zero.  InitializeJoystick_model did not execute correctly')
end

%Sometimes the first few data samples are zero,  need to account for these
if ((max(axes_data(1,:))==0) && (max(axes_data(end,1))~=0))
    warning('First few data samples did not record values from joystick, discarding these data points')
    
    first_non_zero_data_point_index = min(find(axes_data(:,1)>0));
    
    axes_data = axes_data(first_non_zero_data_point_index:end,:);
end

%How many samples did we obtain?
[num_samples,num_axes] = size(axes_data);

%Obtain the zero offsets
for counter=1:num_axes
    %The offset should be an integer since the output of the joystick is an
    %integer
    JOYSTICK_DATA.axes_offsets(counter,1) = round(sum(axes_data(:,counter))/num_samples);
end


%--------------------------AXES GAINS-------------------------------
%What is the max range of counts for each axes?
axes_max_counts(1,1) = 65535;
axes_max_counts(2,1) = 65535;
axes_max_counts(3,1) = 65535;
axes_max_counts(4,1) = 65535;
axes_max_counts(5,1) = 65535;
axes_max_counts(6,1) = 65535;

%What is the min range of counts for each axes?
axes_min_counts(1,1) = 0;
axes_min_counts(2,1) = 0;
axes_min_counts(3,1) = 0;
axes_min_counts(4,1) = 0;
axes_min_counts(5,1) = 0;
axes_min_counts(6,1) = 0;


%Calculate the gain so that the joystick will reach AT LEAST +/- desired
%range
if axes_gains_selection==1
    for counter=1:num_axes
        %Find positive delta_counts
        delta_counts_pos = axes_max_counts(counter) - JOYSTICK_DATA.axes_offsets(counter);
        
        %Find negative delta_c
        delta_counts_neg = axes_min_counts(counter) - JOYSTICK_DATA.axes_offsets(counter);
        
        %Which is smaller (use this in calculation)?
        delta_c = min([abs(delta_counts_neg) delta_counts_pos]);
    
        %What is the required gain?
        delta_p = abs(DESIRED_AXES_MOTION(counter));
        
        %Calculate gain
        if delta_c~=0
            JOYSTICK_DATA.axes_gains(counter,1) = delta_p/delta_c;
        else
            JOYSTICK_DATA.axes_gains(counter,1) = 0;
        end
    end
end

%Sometime this doesn't work if the model isn't open.  Issue a
%recommendation
if ((norm(JOYSTICK_DATA.axes_gains)==0) && (norm(JOYSTICK_DATA.axes_offsets)==0))
    warning('All axes offsets and gains are all zero.  Try opening InitializeJoystick_model.mdl and calling function again')
    disp(' ')
    open_model_selection = input('Would you like to open the InitializeJoystick_model.mdl now? (1 = yes): ');
    
    if (open_model_selection==1)
        open('InitializeJoystick_model')
    end
end

disp('Joystick initialization finished')
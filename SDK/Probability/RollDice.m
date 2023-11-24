function event = RollDice(n,faces)

%ROLLDICE Rolls an n-sided dice using rand
%
%   ROLLDICE rolls a 6 sixed die and returns the number which appears as a
%   double array of size 1x1.
%
%   ROLLDICE(N) rolls an N-sided die and returns the number which appears
%   as a double array of size 1x1.
%
%   ROLLDICE(N,FACES) rolls an N-sided die and return the face which
%   appears.  FACES is an array of same length as N which denotes what is
%   on each face (ie if you wanted a 4 sided dice with faces of 'a', 'b',
%   'c', and 'd' on it, then N = 4 and FACES = ['abcd']
%
%
%INPUT:     -N:         Number of sides of die
%           -FACES:     Array of faces on the die
%
%OUTPUT:    -EVENT:     Face of the die which appear (as an appropriate 1x1
%                       array)
%
%Christopher Lum
%lum@uw.edu

%Version History
%10/07/04: Created
%11/23/23: Minor update

%---------------------OBTAIN USER PREFERENCES-----------------------------
switch nargin
    case 2
        %Check to make sure lengths are consistent
        if n~=length(faces)
            error('N and lenght(FACES) are not consistent')
        end
        
    case 1
        %Assume they want numbers from 1-n on the die
        for counter=1:n
            faces(counter)=counter;
        end
        
    case 0
        %Assume they want a 6 sided die with everything above
        n = 6;
        
        for counter=1:n
            faces(counter)=counter;
        end
        
    otherwise
        error('Inconsistent number of inputs')
end

%-----------------------BEGIN CALCULATIONS---------------------------
%Use rand to obtain a random number
rand_number = rand(1);

%Calculate the window of where to assign an event (ie if n = 3, then the
%window should be 0.3333...)
window = 1/n;

%Now calculate which die side should be returned
for counter=1:n
    %What is the current window.  Special case for the first time
    if counter==1
        %Check if the number is in this window
        if (rand_number >=0) && (rand_number < window)
            %It landed in this window
            event = faces(counter);
        end
    end
    
    %Now assume that this didn't land in the first window
    if (rand_number >= (counter-1)*window) && (rand_number < counter*window)
        event = faces(counter);
    end
end
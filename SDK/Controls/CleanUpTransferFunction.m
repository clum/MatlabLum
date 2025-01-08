function cleanTF = CleanUpTransferFunction(dirtyTF,TOL_cancel,TOL_coefficient)

%CLEANUPTRANSFERFUNCTION    Cancels poles/zeros if appropriate
%
%   [cleanTF] = CLEANUPTRANSFERFUNCTION(dirtyTF) Performs pole/zero
%   cancellation if any pole or any zero satisfies
%
%       abs(z(i) - p(j))<10e-12
%
%   [cleanTF] = CLEANUPTRANSFERFUNCTION(dirtyTF,TOL_cancel) Performs pole/zero
%   cancellation as above but cancels if the absolute value of the
%   difference between a pole and a zero is less than TOL_cancel.
%
%   [cleanTF] = CLEANUPTRANSFERFUNCTION(dirtyTF,TOL_cancel,TOL_coefficient) Performs
%   pole/zero cancellation as above and then after the cancellations have
%   occured, removes coefficients in the numerator and denominator
%   which are smaller than TOL_coefficient.  Note that this may create
%   shift in the pole/zero locations and it not accurate for higher order
%   systems.
%
%INPUT:     -dirtyTF:           dirty transfer function or zpk system
%           -TOL_cancel:        tolerance for pole/zero cancellation (optional)
%           -TOL_coefficient:   tolerance for removing small coefficients
%
%OUTPUT:    -cleanTF:           clean transfer function
%
%See also MINREAL, CLEANUPMATRIX (custom function)
%
%Christopher Lum
%lum@uw.edu

%Version History
%04/24/03: Created
%??/??/??: Added automatic tolerance
%03/05/04: Updated documentation.
%03/29/04: Made compatible for discrete transfer functions.
%04/17/04: Added feature where it cancels poles/zeros at origin
%06/03/04: Added feature to cancel poles/zeros.
%11/11/04: Fixed bug on line 53.
%04/18/05: Made it so there are two seperate tolerances. One for pole/zero
%          cancellation and one for coefficient cleanup.
%04/19/05: Made it so cancels real poles before complex ones.  Also
%          removes small imaginary components in coefficients.
%12/04/07: Made cancellation tolerance smaller
%04/28/19: Updated documentation to note that 'minreal' is similar
%01/07/25: Updated documentation

%---------------------OBTAIN USER PREFERENCES-----------------------------
switch nargin
    case 2
        %Assume TOL_coefficient = 0
        TOL_coefficient = 0;

    case 1
        %Assume TOL_cancel = 10e-12 and everything above
        TOL_cancel = 10e-12;
        TOL_coefficient = 0;
end

%--------------------------BEGIN CALCULATIONS---------------------------
%Now obtain the poles and zeros
[Z,P,K,T] = zpkdata(dirtyTF,'v');

%Initialize the valid poles matrix (this is a matrix which contains the
%poles which holds all the remaining poles which haven't been cancelled).

%We need to sort the matrix so all the real poles are first.  This makes it
%so that the real poles are cancelled first, then the complex poles start
%getting cancelled. This avoids as much as possible the situation where a
%single complex pole with small imaginary part is cancelled with a real
%zero, thereby leaving one complex pole with no complex conjugate.
P_real = real(P);
P_imag = imag(P);

real_indices = find(P_imag==0);

if length(real_indices)~=0
    %There are some real poles, put these first in the sorted vector
    P_sorted_real(1:length(real_indices),1) = P(real_indices);

    %Sort these
    P_sorted_real = sort(P_sorted_real);
else
    %All the poles are imaginary
    P_sorted_real = [];
end

%Now, put the imaginary poles next
if length(P_sorted_real)~=length(P)
    %Then there are some imaginary poles
    P_sorted_imag_index = 1;

    for counter=1:length(P)
        %Check if the current pole is a real pole or not
        if length(find(real_indices==counter))~=0
            %This is a real pole so it was already included in
            %P_sorted_real
        else
            P_sorted_imag(P_sorted_imag_index,1) = P(counter);
            P_sorted_imag_index = P_sorted_imag_index + 1;
        end
    end

    %Sort these imaginary poles
    P_sorted_imag = sort(P_sorted_imag);
else
    %All the poles are real
    P_sorted_imag = [];
end

P_valid = [P_sorted_real;
    P_sorted_imag];

%There will always be more poles and zeros
z_cancel_counter = 1;
z_flag = [];
for z_counter=1:length(Z)
    %What is the current zero?
    z_curr = Z(z_counter);

    %Check to see if there are any cancellations
    cancel_index = min(find(abs(z_curr - P_valid)<TOL_cancel));

    if length(cancel_index)~=0
        %We have cancellation, we'll cancel the first pole that matches
        %this zero.  Check to see if this pole is at the beginning or end
        %of the P_valid array
        if cancel_index==1
            %The pole to be cancelled is in the beginning of the P_valid
            %array
            P_valid = P_valid(2:end);
        elseif cancel_index==length(P_valid)
            %The pole to be cancelled is at the end of the P_valid array
            P_valid = P_valid(1:end-1);

        else
            %The pole to be canceled is in the middle of the P_valid array
            P_valid = [P_valid(1:cancel_index-1);P_valid(cancel_index+1:end)];
        end

        %Flag this zero to be cancelled after we get out of the for loop
        z_flag(z_cancel_counter) = z_counter;
        z_cancel_counter = z_cancel_counter + 1;
    end
end

%Now remember to cancel the zeros
inner_counter = 1;
Z_valid = [];
for counter=1:length(Z)
    %Check if this is a zero to be cancelled
    if length(find(counter==z_flag))~=0
        %Cancel this zero
    else
        %this zero is not cancelled
        Z_valid(inner_counter) = Z(counter);
        inner_counter = inner_counter + 1;
    end
end

%With the cancelled polynomial, create a zpk system and obtain the
%numerator and denominator polynomials
sys = zpk(Z_valid,P_valid,K);
[num,den] = tfdata(sys,'v');

%Check if we want to remove small coefficients in the numerator and
%denominator polynomials
if TOL_coefficient~=0
    %Clean up the numerator coefficients
    for counter=1:length(num)
        %Clean up small real parts
        if abs(num(counter)) < TOL_coefficient
            num(counter) = 0;
        end

        %We also know that the coefficients shouldn't be complex.  However,
        %it may me possible during cancellation that a real pole/zero
        %cancelled a single complex pole/zero.  This would yield a small
        %imaginary complex coefficient.  Clean this up
        if abs(imag(num(counter))) < TOL_coefficient
            num(counter) = real(num(counter));
        end
    end

    %Clean up the denominator coefficients
    for counter=1:length(den)
        if abs(den(counter)) < TOL_coefficient
            den(counter) = 0;
        end

        if abs(imag(den(counter))) < TOL_coefficient
            den(counter) = real(den(counter));
        end
    end
end

%Now create the system model with the Z_valid, P_valid, and K matrices
if T==0
    %Continous tranfer function
    cleanTF = tf(num,den);
else
    %Discrete transfer function
    cleanTF = tf(num,den,T);
end

%Warn the user if we cancelled any zeros or poles
if length(z_flag)~=0
    warning('Pole/Zero cancellation occured while cleaning up Transfer Function.')
end
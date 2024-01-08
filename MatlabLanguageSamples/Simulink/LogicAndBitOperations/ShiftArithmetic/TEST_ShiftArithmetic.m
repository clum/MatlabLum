%Christopher Lum
%lum@u.washington.edu
%
%Test the 'Shift Arithmetic' block
%
%Version History:   12/27/16: Created

clear
clc
close all


%% User settings
%Choose a bit pattern
selection = 2;      %1 = +1234567890
                    %2 = -1234567890

%Load bit pattern
if(selection==1)
    counter = int32(+1234567890);
    byte3_bit_pattern = '01001001';
    byte2_bit_pattern = '10010110';
    byte1_bit_pattern = '00000010';
    byte0_bit_pattern = '11010010';
    
elseif(selection==2)
    counter = int32(-1234567890);
    byte3_bit_pattern = '10110110';
    byte2_bit_pattern = '01101001';
    byte1_bit_pattern = '11111101';
    byte0_bit_pattern = '00101110';
    
else
    error('Unknown selection')
end

%Store each byte temporarily as a 32 bit, signed value
byte3_int32 = int32(bin2dec(byte3_bit_pattern));
byte2_int32 = int32(bin2dec(byte2_bit_pattern));
byte1_int32 = int32(bin2dec(byte1_bit_pattern));
byte0_int32 = int32(bin2dec(byte0_bit_pattern));

modelName = 'ShiftArithemetic_model.slx';

sim(modelName);

counterReconstructed = simCounter.signals.values(1,1);

if(counterReconstructed ~= counter)
    error('Problem with algorithm')
end

disp('DONE!')

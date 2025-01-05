function [tempTC] = readThermocoupleTemperature(max31856SpiSettings,MAX31856_LTCBH_REG_READ,MAX31856_LTCBM_REG_READ,MAX31856_LTCBL_REG_READ)

%Read the thermocouple temperature by reading from the LTCBH, LTCBM, and
%LTCBL registers and performing appropriate bitshifting/conversions.
%
%Christopher Lum
%lum@uw.edu

%Version History
%12/18/24: Created
%01/04/24: Updating for negative temperatures

%read the thermocouple temperature registers (3 bytes)
tcByteH = readRegister8(max31856SpiSettings,MAX31856_LTCBH_REG_READ);
tcByteM = readRegister8(max31856SpiSettings,MAX31856_LTCBM_REG_READ);
tcByteL = readRegister8(max31856SpiSettings,MAX31856_LTCBL_REG_READ);

ret = int32(tcByteH);

ret = bitshift(ret,8);
ret = bitor(ret,int32(tcByteM));
ret = bitshift(ret,8);
ret = bitor(ret,int32(tcByteL));

temp24 = ret;

%check if value is negative or not
if(BitIs1(tcByteH,7))
    %pad the left 8 bits with 1s
    B_int32 = int32(-16777216);
    
    %-16777216 as an int32 has the bit pattern of 0xFF000000
    temp24 = bitor(temp24,B_int32);
end

%perform conversion (bottom 5 bits are unused)
temp24 = bitshift(temp24,-5);

tempTC = double(temp24)*0.0078125;
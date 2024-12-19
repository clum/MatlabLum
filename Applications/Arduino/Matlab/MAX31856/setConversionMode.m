function [] = setConversionMode(mode,max31856SpiSettings,MAX31856_CR0_REG_READ,MAX31856_CR0_REG_WRITE)

%Set conversion mode by writing to the CR0 register (bit 7 for CMODE, bit 6 for 1SHOT).
%
%Christopher Lum
%lum@uw.edu

%Version History
%12/18/24: Created

%Get current register value
t = readRegister8(max31856SpiSettings,MAX31856_CR0_REG_READ);

switch mode
    case max31856_conversionmode_t.MAX31856_CONVERSIONMODE_ONESHOT
        t = BitSetToValue(t,7,0);   %turn off automatic
        t = BitSetToValue(t,6,1);   %turn on one-shot

    case max31856_conversionmode_t.MAX31856_CONVERSIONMODE_ONESHOTNOWAIT
        error('Unsupported max31856_conversionmode_t mode');

    case max31856_conversionmode_t.MAX31856_CONVERSIONMODE_CONTINUOUS
        t = BitSetToValue(t,7,1);   %turn on automatic
        t = BitSetToValue(t,6,0);   %turn off one-shot

    otherwise
        error('Unsupported max31856_conversionmode_t mode')
end

%write value back to register
writeRegister8(max31856SpiSettings,MAX31856_CR0_REG_WRITE,t);
function [] = setAveragingMode(averagingMode,max31856SpiSettings,MAX31856_CR1_REG_READ,MAX31856_CR1_REG_WRITE)

%Set averaging by writing to the CR1 register (bits 4,5,6)
%
%Christopher Lum
%lum@uw.edu

%Version History
%12/18/24: Created

%Get current register value
t = readRegister8(max31856SpiSettings,MAX31856_CR1_REG_READ);

switch averagingMode
    case max31856_averagingmode_t.MAX31856_AVERAGINGMODE_1SAMPLES
        %000 = 1 sample
        t = BitSetToValue(t,6,0);
        t = BitSetToValue(t,5,0);
        t = BitSetToValue(t,4,0);

    case max31856_averagingmode_t.MAX31856_AVERAGINGMODE_2SAMPLES
        %001 = 2 sample
        t = BitSetToValue(t,6,0);
        t = BitSetToValue(t,5,0);
        t = BitSetToValue(t,4,1);

    case max31856_averagingmode_t.MAX31856_AVERAGINGMODE_4SAMPLES
        %010 = 4 sample
        t = BitSetToValue(t,6,0);
        t = BitSetToValue(t,5,1);
        t = BitSetToValue(t,4,0);

    case max31856_averagingmode_t.MAX31856_AVERAGINGMODE_8SAMPLES
        %011 = 8 sample
        t = BitSetToValue(t,6,0);
        t = BitSetToValue(t,5,1);
        t = BitSetToValue(t,4,1);

    case max31856_averagingmode_t.MAX31856_AVERAGINGMODE_16SAMPLES
        %1xx = 16 sample
        t = BitSetToValue(t,6,1);
        t = BitSetToValue(t,5,1);   %not important
        t = BitSetToValue(t,4,1);   %not important
   
    otherwise
        error('Unsupported max31856_averagingmode_t mode')
end

%write value back to register
writeRegister8(max31856SpiSettings,MAX31856_CR1_REG_WRITE,t);
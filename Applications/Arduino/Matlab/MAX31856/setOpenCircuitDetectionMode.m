function [] = setOpenCircuitDetectionMode(mode,max31856SpiSettings,MAX31856_CR0_REG_READ,MAX31856_CR0_REG_WRITE)

%Christopher Lum
%lum@uw.edu

%Version History
%12/15/24: Created
%12/17/24: Continued working

%Get current register value
t = readRegister8(max31856SpiSettings,MAX31856_CR0_REG_READ);

switch mode
    case max31856_opencircuitdetectionmode_t.MAX31856_OCDETECTIONMODE_DISABLED
        t = BitSetToValue(t,5,0);
        t = BitSetToValue(t,4,0);

    case max31856_opencircuitdetectionmode_t.MAX31856_OCDETECTIONMODE_ENABLEDA
        t = BitSetToValue(t,5,0);
        t = BitSetToValue(t,4,1);

    case max31856_opencircuitdetectionmode_t.MAX31856_OCDETECTIONMODE_ENABLEDB
        t = BitSetToValue(t,5,1);
        t = BitSetToValue(t,4,0);

    case max31856_opencircuitdetectionmode_t.MAX31856_OCDETECTIONMODE_ENABLEDC
        t = BitSetToValue(t,5,1);
        t = BitSetToValue(t,4,1);

    otherwise
        error('Unsupported max31856_opencircuitdetectionmode_t mode')
end

%write value back to register
writeRegister8(max31856SpiSettings,MAX31856_CR0_REG_WRITE,t);
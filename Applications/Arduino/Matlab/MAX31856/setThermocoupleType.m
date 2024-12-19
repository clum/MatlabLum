function [] = setThermocoupleType(tcType,max31856SpiSettings,MAX31856_CR1_REG_READ,MAX31856_CR1_REG_WRITE)

%Set TC type by writing to the CR1 register.
%
%Christopher Lum
%lum@uw.edu

%Version History
%12/18/24: Created

%Get current register value
t = readRegister8(max31856SpiSettings,MAX31856_CR1_REG_READ);

switch tcType
    case max31856_thermocoupletype_t.MAX31856_TCTYPE_B
        t = BitSetToValue(t,3,0);
        t = BitSetToValue(t,2,0);
        t = BitSetToValue(t,1,0);
        t = BitSetToValue(t,0,0);

    case max31856_thermocoupletype_t.MAX31856_TCTYPE_E
        t = BitSetToValue(t,3,0);
        t = BitSetToValue(t,2,0);
        t = BitSetToValue(t,1,0);
        t = BitSetToValue(t,0,1);

    case max31856_thermocoupletype_t.MAX31856_TCTYPE_J
        t = BitSetToValue(t,3,0);
        t = BitSetToValue(t,2,0);
        t = BitSetToValue(t,1,1);
        t = BitSetToValue(t,0,0);

    case max31856_thermocoupletype_t.MAX31856_TCTYPE_K
        t = BitSetToValue(t,3,0);
        t = BitSetToValue(t,2,0);
        t = BitSetToValue(t,1,1);
        t = BitSetToValue(t,0,1);

    case max31856_thermocoupletype_t.MAX31856_TCTYPE_N
        t = BitSetToValue(t,3,0);
        t = BitSetToValue(t,2,1);
        t = BitSetToValue(t,1,0);
        t = BitSetToValue(t,0,0);

    case max31856_thermocoupletype_t.MAX31856_TCTYPE_R
        t = BitSetToValue(t,3,0);
        t = BitSetToValue(t,2,1);
        t = BitSetToValue(t,1,0);
        t = BitSetToValue(t,0,1);

    case max31856_thermocoupletype_t.MAX31856_TCTYPE_S
        t = BitSetToValue(t,3,0);
        t = BitSetToValue(t,2,1);
        t = BitSetToValue(t,1,1);
        t = BitSetToValue(t,0,0);

    case max31856_thermocoupletype_t.MAX31856_TCTYPE_T
        t = BitSetToValue(t,3,0);
        t = BitSetToValue(t,2,1);
        t = BitSetToValue(t,1,1);
        t = BitSetToValue(t,0,1);

    case max31856_thermocoupletype_t.MAX31856_VMODE_G8
        t = BitSetToValue(t,3,1);
        t = BitSetToValue(t,2,0);
        t = BitSetToValue(t,1,0);   %not important
        t = BitSetToValue(t,0,0);   %not important

    case max31856_thermocoupletype_t.MAX31856_VMODE_G32
        t = BitSetToValue(t,3,1);
        t = BitSetToValue(t,2,1);
        t = BitSetToValue(t,1,0);   %not important
        t = BitSetToValue(t,0,0);   %not important

    otherwise
        error('Unsupported max31856_thermocoupletype_t mode')
end

%write value back to register
writeRegister8(max31856SpiSettings,MAX31856_CR1_REG_WRITE,t);
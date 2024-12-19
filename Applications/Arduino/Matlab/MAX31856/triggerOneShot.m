function [] = triggerOneShot(max31856SpiSettings,MAX31856_CR0_REG_READ,MAX31856_CR0_REG_WRITE)

%Turn off autoconvert and turn on one-shot mode by writing appropriate bits
%to the CR0 register.
%
%Christopher Lum
%lum@uw.edu

%Version History
%12/18/24: Created

%Get current register value
t = readRegister8(max31856SpiSettings,MAX31856_CR0_REG_READ);

disp(['MAX31856_CR0_REG_READ at triggerOneShot start: ',num2str(t)]);

t = BitSetToValue(t,7,0);   %turn off autoconvert
t = BitSetToValue(t,6,1);   %turn on one-shot

%write value back to register
writeRegister8(max31856SpiSettings,MAX31856_CR0_REG_WRITE,t);

te = readRegister8(max31856SpiSettings,MAX31856_CR0_REG_READ);
disp(['MAX31856_CR0_REG_READ at triggerOneShot end: ',num2str(te)]);
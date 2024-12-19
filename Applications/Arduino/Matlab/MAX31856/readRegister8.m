function [ret] = readRegister8(spiSettings,addr)

sendValue = 0;      %dummy send value for SPI
retFull = writeRead(spiSettings,[addr,sendValue],'uint8');

%discard first byte
ret = retFull(2);
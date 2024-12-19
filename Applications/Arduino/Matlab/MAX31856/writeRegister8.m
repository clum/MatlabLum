function [] = writeRegister8(spiSettings,addr,data)

%As a byproduct of duplex writeRead we also obtain both read bytes.  We
writeRead(spiSettings,[addr,data],'uint8');
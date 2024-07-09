function [] = SendStringOverUDP_UDPToolbox(varargin)

%SENDSTRINGOVERUDP_UDPTOOLBOX  Sends a string over UDP to a location/port
%
%   SENDSTRINGOVERUDP_UDPTOOLBOX(STR,IP_ADDRESS,PORT_NUMBER) Sends the
%   string STR to the specified IP_ADDRESS using PORT_NUMBER over a UDP
%   connection.
%
%   SENDSTRINGOVERUDP_UDPTOOLBOX(STR,IP_ADDRESS,PORT_NUMBER,DEBUG) Does as
%   above but prints messages to the screen about the status if DEBUG==1.
%
%   Example usage
%
%       SendStringOverUDP_UDPToolbox('test string', '192.168.1.112', '49003')
%
%   This requires the UDP Toolbox (downloaded from Matlab Central and
%   located at \MatlabLum\ThirdPartyCode\UDP_toolbox\tcp_udp_ip_2_0_6)
%
%INPUT:     -STR:           string of data to send
%           -IP_ADDRESS:    string of the IP address where to send data
%           -PORT_NUMBER:   string of port number to use for sending data
%           -DEBUG:         set to 1 to display messages about status
%
%OUTPUT:    -None
%
%Christopher Lum
%lum@uw.edu

%Version History
%05/04/12: Created
%08/27/15: Updated for local host operations
%06/01/20: Changed name from SendStringOverUDP to
%          SendStringOverUDP_UDPToolbox to highlight dependence on
%          UDPToolbox.  Updated documentation
%01/04/24: Minor documentation and whitespace updates

%----------------------OBTAIN USER PREFERENCES-----------------------------
switch nargin
    case 4
        %User supplies all inputs
        STR             = varargin{1};
        IP_ADDRESS      = varargin{2};
        PORT_NUMBER     = varargin{3};
        DEBUG           = varargin{4};
        
    case 3
        %Assume user does not want DEBUG messages
        STR             = varargin{1};
        IP_ADDRESS      = varargin{2};
        PORT_NUMBER     = varargin{3};
        DEBUG           = 0;
        
    otherwise
        error('Invalid number of inputs');
end

%-----------------------CHECKING DATA FORMAT-------------------------------
% STR

% IP_ADDRESS

% PORT_NUMBER

% DEBUG

%-------------------------BEGIN CALCULATIONS-------------------------------
%Setup a UDP port
if(DEBUG)
    disp(['Setting up udpsocket on port #',num2str(PORT_NUMBER),' ...'])
end

%A student claimed that for local host operations, this needs to be 'upd=pnet('udpsocket',5500);'
if(strcmp(IP_ADDRESS,'127.0.0.1'))
    udp = pnet('udpsocket',5500);
else
    udp = pnet('udpsocket',PORT_NUMBER);
end

if udp~=-1
    if(DEBUG)
        disp('   Success');
        disp(' ')
    end
    
    try
        %Write to the write buffer
        pnet(udp,'write',STR);
        
        %send data in the write buffer as a UDP packet        
        if(DEBUG)
            disp('Sending data over UDP...')
        end
        
        pnet(udp,'writepacket',IP_ADDRESS,PORT_NUMBER);
        
        if(DEBUG)
            disp('   Success');
            disp(' ')
        end
    catch exception
        if(DEBUG)
            disp(['   FAIL!!! ',exception.message])
            disp(' ')
        end
        throw(exception)
    end
    
    %Close the UDP connection
    if(DEBUG)
        disp('Closing UDP socket...')
    end
    
    pnet(udp,'close');
    
    if(DEBUG)
        disp('   Success');
        disp(' ')
    end
    
else
    error('Could not setup the UDP port')
end
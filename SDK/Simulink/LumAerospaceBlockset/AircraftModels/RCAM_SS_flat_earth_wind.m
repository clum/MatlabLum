function [YBAR] = RCAM_SS_flat_earth_wind(ZBAR)

%RCAM_SS_FLAT_EARTH_WIND Flat earth state space RCAM with steady wind
%
%   [YBAR] = RCAM_SS_FLAT_EARTH_WIND(ZBAR) returns the state derivative
%   and additional information about the RCAM model using flat earth
%   equations of motion with steady wind.  
%
%   The inputs are packaged in a vector of the form:
%
%       ZBAR = [Xbar;Ubar;v_{W/e}^n]
%
%   State vector Xbar, input vector Ubar, and wind vector v_{W/e}^2 are
%   defined as
%   
%       Xbar        = [U;V;W;P;Q;R;phi;theta;psi;p_N;p_E;p_D]
%       Ubar        = [d_A;d_T;d_R;d_th1;d_th2] 
%       v_{W/e}^n   = [W_N; W_E; W_D]
%
%   The outputs are packaged in a vector of the form:
%
%       YBAR = [XbarDot;VT;alpha;beta]
%
%   For more information, see Stevens and Lewis, Aircraft Control and
%   Simulation, 2nd Edition, pg. 107.
%
%Created by Christopher Lum
%lum@u.washington.edu

%Version History:   11/02/14: Created from old RCAM code
%                   11/03/14: Updated
%                   05/24/15: Fixed a0 term in CLwb expression to avoid
%                             discontinuity in the curve

%-----------------------CONSTANTS-------------------------------
%Nominal vehicle constants
m = 120000;                     %Aircraft total mass (kg)

cbar = 6.6;                     %Mean Aerodynamic Chord (m)
lt = 24.8;                      %Distance by AC of tail and body (m)
S = 260;                        %Wing planform area (m^2)
St = 64;                        %Tail planform area (m^2)

Xcg = 0.23*cbar;                %x position of CoG in Fm (m)
Ycg = 0;                        %y position of CoG in Fm (m)
Zcg = 0.10*cbar;                %z position of CoG in Fm (m)

Xac = 0.12*cbar;                %x position of aerodynamic center in Fm (m)
Yac = 0;                        %y position of aerodynamic center in Fm (m)
Zac = 0;                        %z position of aerodynamic center in Fm (m)

%Engine inputs
Umax  = 120000*9.81;            %maximum thrust provided by one engine (N)

Xapt1 = 0;                      %x position of engine 1 force in Fm (m)
Yapt1 = -7.94;                  %y position of engine 1 force in Fm (m)
Zapt1 = -1.9;                   %z position of engine 1 force in Fm (m)

Xapt2 = 0;                      %x position of engine 2 force in Fm (m)
Yapt2 = 7.94;                   %y position of engine 2 force in Fm (m)
Zapt2 = -1.9;                   %z position of engine 2 force in Fm (m)

%Other constants
rho = 1.225;                    %Air density (kg/m^3)
g = 9.81;                       %Gravitational acceleration (m/s^2)
depsda = 0.25;                  %Change in downwash w.r.t. alpha (rad/rad)
alpha_L0 = -11.5*pi/180;        %Zero lift angle of attack (rad)
n = 5.5;                        %Slope of linear region of lift slope
a3 = -768.5;                    %Coefficient of alpha^3
a2 = 609.2;                     %Coefficient of alpha^2
a1 = -155.2;                    %Coefficient of alpha^1
a0 = 15.212;                    %Coefficient of alpha^0 (different from RCAM document)
alpha_switch = 14.5*(pi/180);   %alpha where lift slope goes from linear to non-linear



%--------------------------STATE VECTOR----------------------------------
%Extract state vector
Xbar    = ZBAR(1:12);
Ubar    = ZBAR(13:17);
v_We_n  = ZBAR(18:20);

U           = Xbar(1);
V           = Xbar(2);
W           = Xbar(3);
P           = Xbar(4);
Q           = Xbar(5);
R           = Xbar(6);
phi         = Xbar(7);
theta       = Xbar(8);
psi         = Xbar(9);
p_N         = Xbar(10);
p_E         = Xbar(11);
p_D         = Xbar(12);

delta_A     = Ubar(1);  %aileron
delta_T     = Ubar(2);  %horizontal stabilizer
delta_R     = Ubar(3);  %rudder
delta_th1   = Ubar(4);  %throttle 1
delta_th2    = Ubar(5);  %throttle 2

W_N         = v_We_n(1);    %north wind
W_E         = v_We_n(2);    %east wind
W_D         = v_We_n(3);    %down wind

%Define the vectors 
p_CM_T_n = [p_N;p_E;p_D];
v_CM_e_b = [U;V;W];
wbe_b = [P;Q;R];
Phi = [phi;theta;psi];

%Find direction cosine matrix (Eq.2.5-1a suggests a quaternion formulation
%but we use a standard series 3 rotations)
C1v = [cos(psi) sin(psi) 0;
    -sin(psi) cos(psi) 0;
    0 0 1];

C21 = [cos(theta) 0 -sin(theta);
    0 1 0;
    sin(theta) 0 cos(theta)];

Cb2 = [1 0 0;
    0 cos(phi) sin(phi);
    0 -sin(phi) cos(phi)];

Cbv = Cb2*C21*C1v;
Cvb = Cbv';

%Evalulate two of the four state equations immediately
Cnb = Cvb;      %flat earth assumes that navigation frame and NED frame are same
x10to12dot  = Cnb*v_CM_e_b;

%Calculate phidot,thetadot, and psidot    
H_phi = [1 sin(phi)*tan(theta) cos(phi)*tan(theta);
         0 cos(phi) -sin(phi);
         0 sin(phi)/cos(theta) cos(phi)/cos(theta)];
    
x7to9dot = H_phi*wbe_b;



%------STEADY WIND----------
v_W_e_n = [W_N;W_E;W_D];        %wind vector V_{W/e}^n

Cbn = Cnb';
v_rel_b = v_CM_e_b - Cbn*v_W_e_n;

Uprime = v_rel_b(1);
Vprime = v_rel_b(2);
Wprime = v_rel_b(3);

%-------INTERMEDIATE VARIABLES----------
VT = norm(v_rel_b);

%Calculate dynamic pressure
Qbar = 0.5*rho*VT^2;

alpha = atan2(Wprime, Uprime);
beta = asin(Vprime/VT);

%Could calculate Mach number

%----------AIRCRAFT SPCIFIC CALCULATIONS-------------------

%---------------AERODYNAMIC FORCE COEFFICIENTS----------------
%Calculate the CL_wb
if alpha<=alpha_switch
    CL_wb = n*(alpha - alpha_L0);
else
    CL_wb = a3*alpha^3 + a2*alpha^2 + a1*alpha + a0;
end

%Calculate CL_t
epsilon = depsda*(alpha - alpha_L0);
alpha_t = alpha - epsilon + delta_T + 1.3*Q*lt/VT;
CL_t = 3.1*(St/S)*alpha_t;

%Total lift force
CL = CL_wb + CL_t;

%Total drag force (neglecting tail)
CD =  0.13 + 0.07*(5.5*alpha + 0.654)^2;

%Calculate sideforce
CY = -1.6*beta + 0.24*delta_R;



%--------------DIMENSIONAL AERODYNAMIC FORCES---------------------
%Calculate the actual dimensional forces.  These are in F_s (stability axis)
FA_s = [-CD*Qbar*S;
         CY*Qbar*S;
        -CL*Qbar*S];
    
%Rotate these forces to F_b (body axis)
C_bs = [cos(alpha) 0 -sin(alpha);
        0 1 0;
        sin(alpha) 0 cos(alpha)];
    
FA_b = C_bs*FA_s;



%--------------AERODYNAMIC MOMENT ABOUT AC-------------------
%Calculate the moments in Fb.  Define eta, dCMdx and dCMdu
eta11 = -1.4*beta;
eta21 = -0.59 - (3.1*(St*lt)/(S*cbar))*(alpha - epsilon);
eta31 = (1 - alpha*(180/(15*pi)))*beta;

eta = [eta11;
       eta21;
       eta31];

dCMdx = (cbar/VT)*[-11 0 5;
                    0 (-4.03*(St*lt^2)/(S*cbar^2)) 0;
                    1.7 0 -11.5];
              
dCMdu = [-0.6 0 0.22;
          0 (-3.1*(St*lt)/(S*cbar)) 0;
          0 0 -0.63];

%Now calculate CM = [Cl;Cm;Cn] about Aerodynamic center in Fb
CMac_b = eta + dCMdx*wbe_b + dCMdu*[delta_A;delta_T;delta_R];

% %Normalize to an aerodynamic moment
% MAac_b = CMac_b*Qbar*S*cbar;


%OPTIONAL: Covert this to stability axis
C_sb = C_bs';
Mac_b = CMac_b*Qbar*S*cbar;
Mac_s = C_sb*Mac_b;
% CMac_s = Mac_s./(Qbar*S*cbar);
% CMac_s = C_sb*CMac_b;


%--------------AERODYNAMIC MOMENT ABOUT CG-------------------
%Transfer moment to cg
rcg_b = [Xcg;Ycg;Zcg];
rac_b = [Xac;Yac;Zac];
MAcg_b = C_bs*Mac_s + cross(FA_b,rcg_b - rac_b);




%-----------------ENGINE FORCE & MOMENT----------------------------
%Now effect of engine.  First, calculate the thrust of each engine
F1 = delta_th1*Umax;
F2 = delta_th2*Umax;

%Assuming that engine thrust is aligned with Fb, we have
FE1_b = [F1;0;0];
FE2_b = [F2;0;0];

FE_b = FE1_b + FE2_b;
  
%Now engine moment due to offset of engine thrust from CoG.
mew1 = [Xcg - Xapt1;
        Yapt1 - Ycg;
        Zcg - Zapt1];
        
mew2 = [Xcg - Xapt2;
        Yapt2 - Ycg;
        Zcg - Zapt2];

        
MEcg1_b = cross(mew1,FE1_b);
MEcg2_b = cross(mew2,FE2_b);

MEcg_b = MEcg1_b + MEcg2_b;


%--------------------GRAVITY EFFECTS--------------------------------
%Calculate gravitational forces in the body frame.  This causes no moment
%about CoG.
g_b = [-g*sin(theta);
        g*cos(theta)*sin(phi);
        g*cos(theta)*cos(phi)];
  
Fg_b = m*g_b;



%-------------------STATE DERIVATIVES------------------------------
%Inertia matrix
Ib = m*[40.07 0 -2.0923;
        0 64 0;
        -2.0923 0 99.92];
    
%Inverse of inertia matrix 
invIb = (1/m)*[0.0249836 0 0.000523151;
               0 0.015625 0;
               0.000523151 0 0.010019];

%Form F_b (all the forces in Fb) and calculate udot, vdot, wdot
F_b = Fg_b + FE_b + FA_b;
x1to3dot = (1/m)*F_b - cross(wbe_b,v_CM_e_b);

%Form Mcg_b (all moments about CoG in Fb) and calculate pdot, qdot, rdot.
Mcg_b = MAcg_b + MEcg_b;
x4to6dot = invIb*(Mcg_b - cross(wbe_b,Ib*wbe_b));






%Place in first order form
XDOT = [x1to3dot
        x4to6dot
        x7to9dot
        x10to12dot];
    
%Also output intermediate variables
YBAR = [XDOT;
    VT;
    alpha;
    beta];
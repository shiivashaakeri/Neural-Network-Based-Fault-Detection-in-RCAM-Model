function XDOT = IcingEffect(X, U)


%-------- STATE AND CONTROL VECTORS --------%

% extract state vector
x1 = X(1); %u
x2 = X(2); %v
x3 = X(3); %w
x4 = X(4); %p
x5 = X(5); %q
x6 = X(6); %r
x7 = X(7); %phi
x8 = X(8); %theta
x9 = X(9); %psi

icingSeverity = calculateIcingSeverity(X, U);
U(1:3) = U(1:3) * (1 - control_effectiveness_degrade);
% extract control input vector
u1 = U(1); %d_A (aileron)
u2 = U(2); %d_T (stabilizer)
u3 = U(3); %d_R (rudder)
u4 = U(4); %d_th1 (throttle 1)
u5 = U(5); %d_th2 (throttle 2)

%-------- CONSTANTS --------%
% Nominal vehicle constants
m = 120000; %kg

cbar = 6.6;     %Mean Aerodynamic Chord (m)
It = 24.8;      %Distance by AC of tail and body (m)
S = 260;        %Wing planform area (m^2)
St = 64;        %Tail planform area (m^2)

Xcg = 0.23*cbar;        %x position of CoG in Fm (m)
Ycg = 0;                %y position of CoG in Fm (m)
Zcg = 0.10*cbar;        %z position of CoG in Fm (m)

Xac = 0.12*cbar;        %x position of aerodynamic center in Fm (m)
Yac = 0;                %y position of aerodynamic center in Fm (m)
Zac = 0;                %z position of aerodynamic center in Fm (m)

% Engine Constants

Xapt1 = 0;              %x position of engine 1 force in Fm (m)
Yapt1 = -7.94;          %y position of engine 1 force in Fm (m)
Zapt1 = -1.9;           %z position of engine 1 force in Fm (m)

Xapt2 = 0;              %x position of engine 2 force in Fm (m)
Yapt2 = -7.94;          %y position of engine 2 force in Fm (m)
Zapt2 = -1.9;           %z position of engine 2 force in Fm (m)

% Other Constants
rho = 1.225;                %Air density (kg/m^3)
g = 9.81;                   %Gravitational accleration (m/s^2)
depsda = 0.25;              %Change in downwash w.r.t alpha
alpha_L0 = -11.5*pi/180;  %Zero lift angle of attach (rad)
n = 5.5;                    %Slope of linear region of lift slope
a3 = -768.5;                %Coeff of alpha^3
a2 = 609.2;                %Coeff of alpha^2
a1 = -155.2;                %Coeff of alpha^1
a0 = 15.212;                %Coeff of alpha^0
alpha_switch = 14.5*(pi/180);% alpha where lift slope goes from linear to non-linear

%-------- 1. CONTROL LIMITS/SATURATION --------%
u1min = -25*pi/180;
u1max = 25*pi/180;

u2min = -25*pi/180;
u2max = 10*pi/180;

u3min = -30*pi/180;
u3max = 30*pi/180;

u4min = 0.5*pi/180;
u4max = 10*pi/180;

u5min = 0.5*pi/180;
u5max = 10*pi/180;

if(u1>u1max)
    u1 = u1max;
elseif(u1<u1min)
    u1 = u1min;
end

if(u2>u2max)
    u2 = u2max;
elseif(u2<u2min)
    u2 = u2min;
end

if(u3>u3max)
    u3 = u3max;
elseif(u3<u3min)
    u3 = u3min;
end

if(u4>u4max)
    u4 = u4max;
elseif(u4<u4min)
    u4 = u4min;
end

if(u5>u5max)
    u5 = u5max;
elseif(u5<u5min)
    u5 = u5min;
end

%-------- 2. INTERMEDIATE VARIABLES --------%

Va = sqrt(x1^2 + x2^2 + x3^2); %Calculate airspeed as Eq (4)

alpha = atan2(x3, x1);         % Calculate alpha as Eq (5)
beta = asin(x2/Va);            % Calculate beta as Eq (6)

Q = 0.5*rho*Va^2;              % Calculate dynamic pressure as Eq (7)

wbe_b = [x4;x5;x6];            % Define wbe_b as Eq (8)
V_b = [x1;x2;x3];              % Define V_b as Eq (9)

%-------- 3. AERODYNAMIC FORCE COEFFICIENTS --------%

%calculate the CL_wb as Eq (10)
if alpha<=alpha_switch 
    CL_wb = n*(alpha - alpha_L0);
else
    CL_wb = a3*alpha^3 + a2*alpha^2 + a1*alpha + a0;
end

%calculate the CL_t
epsilon = depsda * (alpha - alpha_L0);
alpha_t = alpha - epsilon + u2 + 1.3*x5*It/Va;
CL_t = 3.1* (St/S)*alpha_t; % Eq (12)

% Example adjustments (simplified for demonstration)
CL = 0.1 * icingSeverity; % Decrease in lift coefficient
CD = 0.05 * icingSeverity; % Increase in drag coefficient

% Calculate sideforce
CY = -1.6*beta + 0.24*u3; %Eq (14)

%-------- 4. DIMENSIONAL AERODYNAMIC FORCES --------%
% Calculating actual dimensional forces in F_s 
FA_s = [-CD*Q*S; CY*Q*S; -CL*Q*S]; %Eq (16)

%Rotation matrix to F_b 
C_bs = [cos(alpha) 0 -sin(alpha);
    0 1 0;
    sin(alpha) 0 cos(alpha)];
FA_b = C_bs*FA_s; %Eq (17)

%-------- 5. AERODYNAMIC MOMENT COEFF ABOUT AC --------%
% Calculate moments in F_b.
eta11 = -1.4*beta;
eta21 = -0.59 - (3.1*(St*It)/(S*cbar))*(alpha - epsilon);
eta31 = (1 - alpha* (180/(15*pi)))*beta;

eta = [eta11;
       eta21;
       eta31];

dCMdx = (cbar/Va) * [-11 0 5;   
                    0 (-4.03*(St*It^2)/(S*cbar^2)) 0;
                    1.7 0 -11.5];
dCMdu = [-0.6 0 0.22;
        0 (-3.1*(St*It)/(S*cbar)) 0;
        0 0 -0.63];

% Calculating CM = [Cl;CmlCn] about Aerodynamic center in F_b
CMac_b = eta + dCMdx*wbe_b + dCMdu*[u1;u2;u3];

%-------- 6. AERODYNAMIC MOMENT ABOUT AC --------%
% Normalize to an aerodynamic moment
MAac_b = CMac_b*Q*S*cbar;

%-------- 7. AERODYNAMIC MOMENT ABOUT CG --------%
% Transfer moment to CG
rcg_b = [Xcg; Ycg; Zcg];
rac_b = [Xac; Yac; Zac];
MAcg_b = MAac_b + cross(FA_b, rcg_b - rac_b); %Eq (20)



%-------- 8. ENGINE FORCE AND MOMENT --------%
% thrust of each engine
F1 = u4*m*g; % Eq(24)
F2 = u5*m*g; % Eq(25)

% engine thrust aligned with F_b:
FE1_b = [F1; 0 ;0];
FE2_b = [F2; 0 ;0];

FE_b = FE1_b + FE2_b;

% engine moment due to offset of engine thrust from CoG
mew1 = [Xcg - Xapt1;
        Yapt1 - Ycg;
        Zcg - Zapt1];
mew2 = [Xcg - Xapt2;
        Yapt2 - Ycg;
        Zcg - Zapt2];
% Eq (26)
MEcg1_b = cross(mew1, FE1_b);
MEcg2_b = cross(mew2, FE2_b);

MEcg_b = MEcg1_b + MEcg2_b;

%-------- 9. GRAVITY EFEFCTS --------%
% calculate gravitational forces in the body frame. this causes no moment
% about CoG
g_b = [-g*sin(x8);
        g*cos(x8)*sin(x7);
        g*cos(x8)*cos(x7)];
Fg_b = m*g_b; % Eq(29)



%-------- 10. STATE DERIVATION --------%
%Inertia matrix
Ib = m*[40.07 0 -2.0923;
        0 64 0;
        -2.0923 0 99.92];

% Inverse of Inertia matrix
InvIb = (1/m)* [0.0249836 0 0.000523151;
        0 0.015625 0;
        0.000523151 0 0.010019];

% Form F_b and calculate udot, vdot, wdot
F_b = Fg_b + FE_b + FA_b;
x1to3dot = (1/m)*F_b - cross(wbe_b, V_b);

% Form Mcg_b and calculate pdot, qdot, rdot.
Mcg_b = MAcg_b + MEcg_b;
x4to6dot = InvIb * (Mcg_b - cross(wbe_b, Ib*wbe_b));

% Calculate phidot, thetadot, psidot
H_phi = [1 sin(x7)*tan(x8) cos(x7)*tan(x8);
        0 cos(x7) -sin(x7);
        0 sin(x7)/cos(x8) cos(x7)/cos(x8)];

x7to9dot = H_phi*wbe_b;

% Place in first order form
XDOT = [x1to3dot
        x4to6dot
        x7to9dot];

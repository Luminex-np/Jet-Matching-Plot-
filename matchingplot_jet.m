clc;
clear;
close all;


hc = 12192; % Cruising altitude in meters
rhosl = 1.225; % Density at sea level in kg/m^3
CD0 = 0.0175; % Zero-lift drag coefficient of aircraft
AR = 10; % Aspect ratio
e = 0.9; % Oswald efficiency factor
PI = 3.1416; 
K = 1 / (AR * e * PI); % Induced drag factor

% Density at cruising altitude
rhoc = rhosl * exp(-0.000114 * hc); % Corrected to use rhosl instead of rhos1
sigma = rhoc/rhosl;
Vs = 77.1; % Stall speed in m/s
CLmax = 1.5; % Maximum lift coefficient

Vc = 250; % Cruise velocity in m/s
Vmax = 1.15 * Vc; % Maximum velocity in m/s



%take off ko lagi chaine constants
g = 9.81;%acceleration due to gravity
mu = 0.04;%asphalt ground
STO = 1100;%runway length in meter
C_lc=0.3;
Cl_flap=0.55;
CD0_lg=0.009;
CD0_HLD=0.0055;
Cd0to = CD0+CD0_lg+CD0_HLD;
Clto= C_lc+Cl_flap;
Cdto= Cd0to + K*(Clto^2);
CDG = Cdto-mu*Clto;
CLR=CLmax/(1.1^2);



%roc ko lagi conditions
LDmax= 22.65;
roc=325.9; %2000 ft/min


%service ceiling ko lagi
ac=16764;%absolute ceiling 60000ft
sigma_ac=0.119593265;
roc_ac=42;%200ft/min
rho_ac= rhosl * exp(-0.000114 * ac);

% Stall speed
WS = 1 / 2 * rhosl * Vs^2 * CLmax;
figure;
x1 = WS; 
x2 = WS; 
y1 = -4000; 
y2 = 5000; 
plot([x1, x2], [y1, y2], '-black','LineWidth', 2)
text(8000, -1.5, 'Stall speed')
axis([-2000 10000 -2 5])
xlabel('W/S')
ylabel('T/W')
grid on
hold on

% Maximum speed
WSms = 0:1:10000; %wing loading range
a =  rhosl * CD0;
b = 2 * K / (rhoc * sigma);
TWvmax = (a * Vmax^2) ./ WSms + (b / Vmax^2) * WSms;
plot(WSms,TWvmax, 'r','LineWidth', 2); text(6000,4,'Maximum speed'); 

%take off run
WSsto = 1:1:10000;
a_sto = (mu - (mu + CDG / CLR)); % Ensure mu and CLR are defined
b_sto = exp(0.6 * rhoc * g * CDG * STO ./ WSsto);

TWsto = a_sto * b_sto ./ (1 - b_sto);
%TWsto = a_sto .* exp(111.1983371 ./ WSsto) ./ (1 - exp(111.1983371 ./ WSsto));
%plot(TWsto, WSsto, 'b--o','LineWidth', 2 );text(5,1.2,'Take-off run') 
plot(WSsto, TWsto,'LineWidth', 2);text(1000,0.2,'Take-off run');

%roc
WS_roc= 0:1:10000;
sqrt_term = sqrt(2 .* WS_roc ./ (rhoc .* sqrt(CD0 ./ K)));
a_roc = roc ./ sqrt_term;
b_roc = 1/(LDmax);
TWroc =a_roc+ b_roc;
plot(WS_roc, TWroc, 'Color', [0.5, 0, 0.5], 'LineWidth', 2);
text(800,2.5,'Rate of climb'); 

%service ceiling
WS_ac= 0:1:10000;
sqrt_term_ac = sqrt(2 .* WS_ac ./ (rho_ac .* sqrt(CD0 ./ K)));
a_ac = roc_ac ./ (sigma_ac*sqrt_term_ac);
b_ac = 1/(sigma_ac*LDmax);
TWac =a_ac+ b_ac;
plot(WS_ac, TWac, 'Color', [0, 0, 1], 'LineWidth', 2);
text(9000,1,'Ceiling'); 


%design point


plot([4500, 4500], [0, 2.36], '-black','LineWidth', 0.5);
plot([0, 4500], [2.36,2.36]);

legend({'Stall speed', 'Maximum speed', 'Take-off run', 'Rate of climb', 'Ceiling','Design Point', 'Design Point',}, ...
       'Location', 'best', 'FontSize', 10);

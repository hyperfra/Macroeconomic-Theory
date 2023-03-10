%----------------------------------------------------------------
% THE NKM Model in DYNARE
%----------------------------------------------------------------

%   1 2 3  4 5 6 7 8     9   10    11   12  13    14 
var c i dp z n r y omega mu  yn  ytilde rn   v pstar_p;
    

varexo eps_v eps_z eps_p; 

parameters alpha beta rho sigma phi phi_pi  lambda theta Big_theta;
parameters epsilon mu_ss psi_yz
psi_y kappa phi_y rho_v;

%----------------------------------------------------------------
% Calibration 
%----------------------------------------------------------------

alpha     = 1/4; 
beta      = 0.99;
rho       = 0.9;
sigma     = 1;
phi       = 5;
phi_pi    = 1.5;
theta     = 3/4;
epsilon   = 9;
Mk        = epsilon/(epsilon-1);
mu_ss     = log(Mk);
Big_theta = (1-alpha)/(1-alpha+alpha*epsilon);
lambda    = (1-theta)*(1-beta*theta)/theta*Big_theta;
psi_yz    = (1+phi)/(sigma*(1-alpha) + phi + alpha);
psi_y     =  - (1-alpha)*(mu_ss-log(1-alpha))/(sigma*(1-alpha)+phi+alpha);
kappa     = lambda*(sigma+(phi+alpha)/(1-alpha));
phi_y     = 0.5/4;
rho_v     = 0.5;


%----------------------------------------------------------------
% Model
%----------------------------------------------------------------

model(linear);

    omega = sigma*c + phi*n;                                   %1

    c     = c(+1) - 1/sigma*(i + log(beta) - dp(+1)) ;         %2

    y     = z + n*(1-alpha);                                   %3

    mu    = -omega + z -alpha*n + log(1-alpha);                %4

    r     = i - dp(+1);                                        %5

    y     = c;                                                 %6
    
    i     = -log(beta) +phi_pi*dp + phi_y*ytilde +v ;          %7

    z     =  rho*z(-1)  +eps_z;                                %8

    yn    = psi_yz*z + psi_y;                                  %9
    
    ytilde = y - yn;                                          %10

    dp   = (1-theta)*pstar_p;                                 %11

    rn   = -log(beta) - sigma*(1-rho)*psi_yz*z;               %12

    v = rho_v*v(-1) +eps_v ;                                  %13

    pstar_p = -(1-beta*theta)*Big_theta*(mu - mu_ss) + dp + beta*theta*pstar_p(+1)  + eps_p; %14
    
     
end;


 

%----------------------------------------------------------------
%  shocks
%---------------------------------------------------------------

shocks;
var eps_v; stderr 1;
var eps_p; stderr 1;
var eps_z; stderr 1;

end;

%----------------------------------------------------------------
%  Initial Values for steady state
%---------------------------------------------------------------

steady_state_model;
r=-log(beta);
dp=0;
y = psi_y;
n = y/(1-alpha);
i=r;
c=y;
mu = mu_ss;
yn = y;
ytilde = 0;
z =0;
rn = -log(beta);
omega = sigma*c + phi*n;
v =0;
pstar_p=0;
end;


%steady;
check;

%----------------------------------------------------------------
% Solution
%----------------------------------------------------------------

stoch_simul(irf=8,order=1,nomoments) y yn ytilde n dp i r omega;
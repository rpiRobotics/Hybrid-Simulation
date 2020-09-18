% H infinity stabilization hybrid simulation

clear variables; close all; clc

% Generate  and display weight
wc = 2*pi*100; % cutoff frequency in rad/s

s = tf('s');

W = wc/(s+wc);
figure(1)
bodeopts = bodeoptions('cstprefs');
%bodeopts.PhaseMatching='on'; 
%bodeopts.PhaseMatchingValue = -180;
bode(W,bodeopts);

% approximate time delay
taum = 0.108;
pade_order = 2;
dt_con = 0.002;

[num_TD,den_TD] = pade(taum,pade_order);
TD_approx = tf(num_TD,den_TD);
figure(2)
pade(taum,pade_order); % plot pade approximation to check bandwidth


% Define model
b = 131.4; % Contact damping
k = 11691; % Contact spring
m = 500; % Object mass

% Add error (scales = 1 means no error)
% k, b, taum used in controller design. 
% k*k_error_scale, b*b_error_scale, taum*taum_error_scale used in
% simulation (actual model parameters)
k_error_scale = 1;
b_error_scale = 1;
taum_error_scale = 1;

% Set simulation parameters
T = 100;
dtmax = 0.001;
input_type = 3; % 1: step, 2: ramp, 3: sinusoid
stepval = 0.1;
rampslope = 0.1;
sineamp = 0.1;
sinefreq = pi/2;

% generate Pweighted
PW = [-W*(k/s+b)/(m*s), W*TD_approx*(1 + (k/s+b)/(m*s));0, TD_approx;...
    (k/s+b)/(m*s), TD_approx*(-(k/s+b)/(m*s))];

% Convert to state-space and generate generalized ss representation
Pss = minreal(ss(PW)); % minimum realization in order to find K

% complete loop shaping
opts = hinfsynOptions('Display','on');
[K,CL,gamma,info] = hinfsyn(Pss,2,1,opts);

C1 = balreal(K(1,2));
C2 = balreal(-inv(C1)*K(1,1));

% Add error (if any)
k = k*k_error_scale; % 1.2
b = b*b_error_scale; % 1.15
taum = taum*taum_error_scale; % 1.1

% simulate 
tic
sim('Hinf_sim.slx')
toc

feedback_xm_err = abs(xm-xmdes);

figure(1)
plot(tout,xm,'b','LineWidth',2)
hold on
plot(tout,xmdes,'r--','LineWidth',2)
xlabel('Time (s)')
ylabel('Position (m)')
title('Feedback')
legend('xm','xmdes')

figure(2)
plot(tout,xb,'b','LineWidth',2)
hold on
plot(tout,xm,'r--','LineWidth',2)
xlabel('Time (s)')
ylabel('Position (m)')
title('Feedback')
legend('xb','xm')


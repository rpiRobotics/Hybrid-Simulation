% Adaptive Control Stabilization Hybrid Simulation

clear variables; close all; clc


% model parameters
taum = 0.108; % Time Delay
b = 131.4; % Contact damping
bhat = 100; % Initial guess contact damping
k = 11691; % Contact Spring
khat = 11000; % Initial guess contact spring
m = 500; % Object Mass
Kb = 40; % Weighting Coefficients
KK = 40; 
fe_dz = 15; % Deadzone 

taumreal = 1*taum; % Scale to include time delay error


% Set simulation parameters
T = 100;
dt = 0.002;
dtmax = 0.001;
input_type = 3; % 1: step, 2: ramp, 3: sinusoid
stepval = 0.1;
rampslope = 0.1;
sineamp = 0.1;
sinefreq = pi/2;

% simulate 
tic
sim('adaptive_control_sim.slx')
toc

figure(1)
plot(tout,xmdot_ideal,'b','LineWidth',2)
hold on
plot(tout,xmdot,'r--','LineWidth',2)
xlabel('Time (s)')
ylabel('Speed (m/s)')
legend('Ideal','Actual')

figure(2)
plot(tout,b_model,'b','LineWidth',2)
hold on
plot([tout(1),tout(end)],[b,b],'k--','LineWidth',2)
xlabel('Time (s)')
ylabel('Parameter Estimate, b')


figure(3)
plot(tout,k_model,'b','LineWidth',2)
hold on
plot([tout(1),tout(end)],[k,k],'k--','LineWidth',2)
xlabel('Time (s)')
ylabel('Parameter Estimate, k')

figure(4)
plot(tout,fe,'b','LineWidth',2)
xlabel('Time (s)')
ylabel('Force Error (N)')

figure(5)
plot(tout,xm_ideal,'b','LineWidth',2)
hold on
plot(tout,xm,'r--','LineWidth',2)
legend('Ideal','Actual')
ylabel('Pos (m)')
xlabel('Time (s)')

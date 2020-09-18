% Passivity - velocity modification

clear variables; close all; clc

% Define model
taum = 0.108; % Time delay
dt = 0.002; % Timestep
dtmax = dt; % Max Simulation timestep
b = 131.4; % Contact damping
k = 11691; % Contact spring
m = 500; % Object mass

% Sim parameters
T = 100;
input_type = 3; % 1: step, 2: ramp, 3: sinusoid
stepval = 0.1;
rampslope = 0.1;
sineamp = 0.1;
sinefreq = pi/2;

% Run Simulation
tic
sim('passivity_ideal_sim.slx');
toc

figure(1)
plot(tout,xb,'b','LineWidth',2)
hold on
plot(tout,xm,'r--','LineWidth',2)
xlabel('Time (s)')
ylabel('Pos (m)')
legend('xb','xm')

figure(2)
plot(tout,xm_ideal,'b','LineWidth',2)
hold on
plot(tout,xm,'r--','LineWidth',2)
xlabel('Time (s)')
ylabel('Pos (m)')
legend('xm ideal','xm')

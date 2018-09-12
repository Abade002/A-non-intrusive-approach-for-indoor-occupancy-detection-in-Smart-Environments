%% Noise Data Analysis %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% == Part 0: 
%%Load Data ============================================================ %%

clear all, close all, clc;
addpath(genpath('functions'))
addpath(genpath('data'))
load('data0_noise.mat');
timedecimal=linspace(0,24,1440);

%% == Part 1: 
%%Plot Noise Data W/WO ================================================= %%

figure();
plot(timedecimal, noise_wo, timedecimal, noise_wi);
legend('WithoutOcc', 'WithOcc')
xlabel('Hours (h)');
ylabel('Noise (dB)');
grid on;

%% == Part 2: 
%%Plot Noise Data with a low-pass filter =============================== %%

figure();
plot(timedecimal, lowfilter(noise_wi,0.05), ...
    timedecimal, lowfilter(noise_wo,0.05));
legend('WithPerson', 'WithoutPerson')
xlabel('Hours (h)');
ylabel('Noise (dB)');
grid on;

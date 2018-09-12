%% Lux Data Analysis %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% == Part 0: 
%%Load Data ============================================================ %%

clear all, close all, clc;
addpath(genpath('functions'))
addpath(genpath('data'))
load('data0_lux.mat');
timedecimal=linspace(0,24,1440);

%% == Part 1: 
%%Plot Lux Data W/WO =================================================== %%

figure();
plot(timedecimal, lux_wo, timedecimal, lux_wi);
legend('WithoutOcc', 'WithOcc')
xlabel('Hours (h)');
ylabel('Lux');
grid on;

%% == Part 2:
%%Plot Lux Data with Low-Pass Filter =================================== %%

figure();
plot(timedecimal, lux_wi, timedecimal, lowfilter(lux_wi,0.15));
legend('WithoutFilter', 'WithFilter')
xlabel('Hours (h)');
ylabel('Lux');
grid on;





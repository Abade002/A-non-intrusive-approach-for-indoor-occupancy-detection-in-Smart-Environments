%% Carbon Dioxide Data Analysis %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% == Part 0: 
%%Load Data ============================================================ %%

clear all; close all; clc;
addpath(genpath('functions'))
addpath(genpath('data'))
load('data0_co2.mat');
timedecimal=linspace(0,24,1440);

%% == Part 1: 
%%Plot Co2 Data W/WO =================================================== %%

figure();
plot(timedecimal, co_0, timedecimal, co_1, timedecimal, co_2);
xlabel('Hours (h)');
ylabel('eCo2 (ppm)');
legend('WithoutOcc', 'With1Occ', 'WithMultiOcc')
grid on;

%% == Part 2: 
%%Plot Co2 W/WO with low-pass filter =================================== %%

figure();
plot(timedecimal, co_2, ...
    timedecimal, lowfilter(co_2,0.15));
legend('WithFilter', 'WithoutFilter')
xlabel('Hours (h)');
ylabel('eCo2 (ppm)');
grid on;

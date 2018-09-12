%% Temperature Data Analysis %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%% == Part 0: 
%%Load Data ============================================================ %%

clear all; close all; clc;
addpath(genpath('functions'))
addpath(genpath('data'))
load('data0_temp.mat');
timedecimal = linspace(0,24,1440);

%% == Part 1: 
%%Plot Temperature Data  =============================================== %%

figure();
plot(timedecimal, tempwi(:,1), timedecimal, tempwi(:,2));
xlabel('Hours (h)');
ylabel('Temperature (ºC)');
legend('TemperatureIN', 'TemperatureOut');
xlabel('Hours (h)');
ylabel('Temperature (ºC)');
grid on;


%% == Part 2: 
%%Plot the difference between the indoor temperature and the outdoor
%%temperature with and without persons ================================= %%

tempdiffwo = tempwo(:,1) - tempwo(:,2);
tempdiffwi = tempwi(:,1) - tempwi(:,2);

figure();
plot(timedecimal, tempdiffwo, timedecimal, tempdiffwi);
xlabel('Hours (h)');
ylabel('Temperature (ºC)');
legend('WithoutOcc', 'WithOcc');
xlabel('Hours (h)');
ylabel('Temperature (ºC)');
grid on;

%% == Part 3: 
%%Plot the difference between the indoor temperature and the outdoor
%%temperature with Low-Pass Filter ===================================== %%

tempdiffwif = lowfilter(tempdiffwi, 0.5);

figure();
plot(timedecimal, tempdiffwi, timedecimal, tempdiffwif);
xlabel('Hours (h)');
ylabel('Temperature (ºC)');
legend('WithoutFilter', 'WithFilter');
xlabel('Hours (h)');
ylabel('Temperature (ºC)');
grid on;


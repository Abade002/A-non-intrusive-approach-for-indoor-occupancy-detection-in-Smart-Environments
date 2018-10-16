%% Machine Learning applied to Multi-Classification problem %%%%%%%%%%%%%%%

%% == Part 0.1: Load Data ============================================== %%
clear all, close all, clc; 
addpath(genpath('functions'))
addpath(genpath('data'))
% Data to load: 'datatemp', 'datadioxide', 'datalight', 'datanoise'
load('data', 'datatemp')
data = datatemp;

%% == Part 0.2: Configuration ========================================== %%
% Option: 
%  Logistic Regression: 'lr'
%  Neural Network: 'nn'
%  Support Vector Machine: 'svm'  
option = 'nn';

% Number of Classes
num_labels = 6;

% Configuration
if(strcmp(option,'lr'))
    lambda = 0; % Regularization Parameter Default: 0
    threshold = 0.5; %Default 0.5
elseif(strcmp(option,'nn'))
    lambda = 0; % Regularization Parameter Default: 0
    hidden_layer_size = 1; % Hidden Layers Units Default: 1
elseif(strcmp(option,'svm'))
    C=1; % Penalization Cost Default: 1
    G=0; % Regularization Parameter Default: 0 
end

% Low-Pass Filter Smoothing Factor
alpha = 0.15;

% Number of Group training: 1, 5, 10, 15, 20,...
u = 1;

% K-Fold
k = 5;

%% == Part 1: Group Data =============================================== %%
data(:,1) = lowfilter(data(:,1), alpha);
data(:,1) = avgdata(data(:,1), u, 4);
data(:,2) = avgdata(data(:,2), u, 0);

% Output to multi-class problem
dtemp = data(:,2);
dtemp(find(dtemp>=5)) = 5;
dtemp(find(dtemp==0)) = 6;
data(:,2) = dtemp;
clearvars dtemp;

%% == Part 2: Plotting Data ============================================ %%
plotDataOneVsAll(data(:,1), data(:,2));
pause();

%% == Part 3: Train Classifier ========================================= %%
% SEED
rng(1)
[Xtrain, ytrain, Xtest, ytest] = dataSplit(data, 0.7);

if (~strcmp(option, 'nn'))
    Xtrain = [ones(size(Xtrain, 1), 1) Xtrain];
    Xtest = [ones(size(Xtest, 1), 1) Xtest];
end

tic
switch option
    case 'lr'
        theta = trainOneVsAll(Xtrain, ytrain, lambda, num_labels);
    case 'nn' 
        [Theta1, Theta2, cost] = trainNN(Xtrain, ytrain, lambda, ...
            hidden_layer_size, num_labels);
    case 'svm'
        svmoptions = ['-s 0 -t 2 -c ', num2str(C), ' -g ', num2str(G)];
        model = svmtrain(ytrain, Xtrain, svmoptions);
end
toc
pause();

%% == Part 4: Predict ================================================== %%
switch option
    case 'lr'
        p = predictOneVsAll(theta, Xtest);
    case 'nn'
        p = predictNN(Theta1, Theta2, Xtest);
    case 'svm'
        p = svmpredict(ytest, Xtest, model);
        %theta = [model.rho model.SVs(:,2)'*model.sv_coef]';
end

yy1 = size(find(ytrain==1),1);
yy2 = size(find(ytrain==2),1);
yy3 = size(find(ytrain==3),1);
yy4 = size(find(ytrain==4),1);
yy5 = size(find(ytrain==5),1);
yy6 = size(find(ytrain==6),1);
yy1t = size(find(ytest==1),1);
yy2t = size(find(ytest==2),1);
yy3t = size(find(ytest==3),1);
yy4t = size(find(ytest==4),1);
yy5t = size(find(ytest==5),1);
yy6t = size(find(ytest==6),1);

fprintf('Samples in training set: %d\n', length(Xtrain(:,1)));
fprintf('Number of Y=1: %d\n', yy1);
fprintf('Number of Y=2: %d\n', yy2);
fprintf('Number of Y=3: %d\n', yy3);
fprintf('Number of Y=4: %d\n', yy4);
fprintf('Number of Y=5: %d\n', yy5);
fprintf('Number of Y=6: %d\n', yy6);
fprintf('Samples in test set: %d\n', length(Xtest(:,1)));
fprintf('Number of Y=1: %d\n', yy1t);
fprintf('Number of Y=2: %d\n', yy2t);
fprintf('Number of Y=3: %d\n', yy3t);
fprintf('Number of Y=4: %d\n', yy4t);
fprintf('Number of Y=5: %d\n', yy5t);
fprintf('Number of Y=6: %d\n', yy6t);

fprintf('Train Accuracy: %f\n', mean(double(p == ytest)) * 100);
fprintf('Train F1 Score (micro): %f\n', f1score(ytest, p, num_labels, ...
    'micro')*100);
fprintf('Train F1 Score (macro): %f\n', f1score(ytest, p, num_labels, ...
    'macro')*100);
fprintf('Train MCC Score (micro): %f\n', MCC(ytest, p, num_labels, ...
    'micro')*100);
fprintf('Train MCC Score (macro): %f\n', MCC(ytest, p, num_labels, ...
    'macro')*100);
pause();

%% == Part 5: Tweaked   =============================================== %%
%  Test various values of lambda and polynomial degrees on validation set
tic;
switch option
    case 'lr'
        lvec = [0 0.01 0.1 1 10 100]';
        dvec = 1:3';
        [lambda, pd, score, score_vec] = ...
            performOneVsAll(Xtrain(:,2:end), ytrain, lvec, dvec, k);
        fprintf('lambda     degree      threshold       score\n');
        disp([lambda pd' threshold'  score']);
    case 'nn'
        lvec = [0 0.1 1 10]';
        dvec = 1:3';
        hvec = [1 2 3]';
        [lambda, pd, hd, score, score_vec] = ...
            performNN(Xtrain, ytrain, lvec, dvec, hvec, k);
        fprintf('lambda     degree      hidden       score\n');
        disp([lambda pd' hd'  score']);
    case 'svm'
        gvec = [0 0.01 0.1 1 10]';
        dvec = 1;
        cvec = [0.1 1 10]';
        [gamma, pd, c, score, score_vec] = ...
            performSVM(Xtrain(:,2:end), ytrain, gvec, dvec, cvec, k);
        fprintf('gamma     degree      c       score\n');
        disp([gamma pd' c'  score']);
end
toc;
pause();

%% == Part 6: Tweaked Train Classifier  ================================ %%
if (~strcmp(option, 'nn'))
    Xtrain = polyFeatures(Xtrain(:,2:end), pd);
    Xtrain = featureNormalize(Xtrain);
    Xtest = polyFeatures(Xtest(:,2:end), pd);
    Xtest = featureNormalize(Xtest); 
else
    Xtrain = polyFeatures(Xtrain, pd);
    Xtrain = featureNormalize(Xtrain);
    Xtest = polyFeatures(Xtest, pd);
    Xtest = featureNormalize(Xtest); 
end

switch option
    case 'lr'
        Xtrain = [ones(size(Xtrain, 1), 1) Xtrain];
        Xtest = [ones(size(Xtest, 1), 1) Xtest];
        theta = trainOneVsAll(Xtrain, ytrain, lambda, num_labels);
        p = predictOneVsAll(theta, Xtest);        
    case 'nn' 
        [Theta1, Theta2, cost] = trainNN(Xtrain, ytrain, lambda, ...
            hd, num_labels);
        p = predictNN(Theta1, Theta2, Xtest);
    case 'svm' 
        Xtrain = [ones(size(Xtrain, 1), 1) Xtrain];
        Xtest = [ones(size(Xtest, 1), 1) Xtest];
        svmoptions = ['-s 0 -t 2 -c ', num2str(c), ' -g ', num2str(gamma)];
        model = svmtrain(ytrain, Xtrain, svmoptions);
        p = svmpredict(ytest, Xtest, model);
end
fprintf('Train F1 Score (macro): %f\n', f1score(ytest, p, num_labels, ...
    'macro')*100);
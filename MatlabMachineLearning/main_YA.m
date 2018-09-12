%% Machine Learning applied to Multi-Classification problem %%%%%%%%%%%%%%%

%% == Part 0: Load Data ================================================ %%
clear all, close all, clc;
addpath(genpath('functions'))
addpath(genpath('data'))
%Data to load: 'data_temp.mat', 'data_noise.mat', 'data_light.mat', 
% 'data_dioxide.mat'
load('data_temp.mat')

%% == Part 0.2: Configuration ========================================== %%
% Option: 
%  Logistic Regression: 'lr'
%  Neural Network: 'nn'
%  Support Vector Machine: 'svm'  
option = 'lr';

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

% Polynomial Degree Default: 1
d = 1;

% Low-Pass Filter Smoothing Factor
alpha = 0.15;

% Number of Group training: 1, 5, 10, 15, 20,...
u = 1;

%% == Part 1: Group Data =============================================== %%
% Input X1
Xtrain = lowfilter(xtrain, alpha);
Xtest = lowfilter(xtest, alpha);
Xtrain = avgdata(Xtrain, u, 4);
Xtest = avgdata(Xtest, u, 4);

% Output y
ytrain = avgdata(ytrain, u, 0);
ytest = avgdata(ytest, u, 0);
ytrain(find(ytrain>=5))=5;
ytest(find(ytest>=5))=5;
ytrain(find(ytrain==0))=6;
ytest(find(ytest==0))=6;

% Number of examples
m = length(ytrain);
mtest = length(ytest);

%% == Part 2: Plotting Data ============================================ %%
plotDataOneVsAll(Xtrain,ytrain);
plotDataOneVsAll(Xtest, ytest);

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
pause();

%% == Part 3: Polynomial Features and Feature Scaling ================== %%
Xn = polyFeatures(Xtrain, d);
Xtestn = polyFeatures(Xtest, d);

Xn = featureNormalize(Xn); 
Xtestn = featureNormalize(Xtestn); 

if (~strcmp(option, 'nn'))
    Xn = [ones(size(Xn, 1), 1) Xn];
    Xtestn = [ones(size(Xtestn, 1), 1) Xtestn];
end

%% == Part 3: Train Classifier ========================================= %%
tic;
switch option
    case 'lr'
        [theta] = trainOneVsAll(Xn, ytrain, num_labels, lambda);
    case 'nn' 
        [Theta1, Theta2, cost] = trainNN(Xn, ytrain, lambda, ...
            hidden_layer_size, num_labels);
    case 'svm'
        svmoptions = ['-s 0 -t 2 -c ', num2str(C), ' -g ', num2str(G)];
        model = svmtrain(ytrain, Xn, svmoptions);
end
toc;
pause();

%% == Part 4: Predict ================================================== %%
% Compute the training set accuracy
switch option
    case 'lr'
        p = predictOneVsAll(theta, Xtestn);
    case 'nn'
        p = predictNN(Theta1, Theta2, Xtestn);
    case 'svm'
        p = svmpredict(ytest, Xtestn, model);
end

fprintf('Samples in training set: %d\n', m);
fprintf('Number of Y=1: %d\n', yy1);
fprintf('Number of Y=2: %d\n', yy2);
fprintf('Number of Y=3: %d\n', yy3);
fprintf('Number of Y=4: %d\n', yy4);
fprintf('Number of Y=5: %d\n', yy5);
fprintf('Number of Y=6: %d\n', yy6);
fprintf('Samples in test set: %d\n', mtest);
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

%% == Part 4: Feature Mapping with Learning Curve   ==================== %%
%  Test various values of lambda and polynomial degrees on validation set

switch option
    case 'lr'
        lvec = [0 0.001 0.003 0.01 0.03 0.1 0.3 1 3 10 30 100]';
        dvec = 1:10';
        tvec = 0.5;
        [lambda, pd, threshold, score, score_vec] = ...
            performOneVsAll(Xtrain, ytrain, Xtest, ytest, lvec, dvec, ...
            tvec);
        fprintf('lambda     degree      threshold       score\n');
        disp([lambda pd' threshold'  score']);
    case 'nn'
        lvec = [0 0.01 0.1 1 10]';
        dvec = 1:5';
        hvec = [1 2 3 5]';
        [lambda, pd, hd, score, score_vec] = ...
            performNN(Xtrain, ytrain, Xtestn, ytest, lvec, dvec, ...
            hvec);
        fprintf('lambda     degree      hidden       score\n');
        disp([lambda pd' hd'  score']);
    case 'svm'
        gvec = [0 0.001 0.003 0.01 0.03 0.1 0.3 1 3 10 30 100]';
        dvec = 1;
        cvec = [0.1 0.3 1 3 10]';
        [gamma, pd, c, score, score_vec] = ...
            performSVM(Xtrain, ytrain, Xtest, ytest, gvec, dvec, cvec);
        fprintf('gamma     degree      c       score\n');
        disp([gamma pd' c'  score']);
end

%% Machine Learning applied to Binary problem %%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% == Part 0.1: Load Data ============================================== %%
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

% Number of classes
num_labels = 2;

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

% Low-Pass Filter Smoothing Factor Default: 0.15
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

% Output to binary problem
ytrain(find(ytrain>=1))=1;
ytest(find(ytest>=1))=1;

% IF Y==0, Y=2
if(strcmp(option,'nn'))   
    ytrain(find(ytrain==0)) = 2;
    ytest(find(ytest==0)) = 2;  
end

% Number of examples
m = length(ytrain);
mtest = length(ytest);

%% == Part 2: Plotting Data ============================================ %%
plotData(Xtrain, ytrain, option);
plotData(Xtest, ytest, option);

switch option
    case {'lr' , 'svm'}
        pos = size(find(ytrain==1),1);
        neg = size(find(ytrain==0),1);
        postest = size(find(ytest==1),1);
        negtest = size(find(ytest==0),1);
    case 'nn'
        pos = size(find(ytrain==1),1);
        neg = size(find(ytrain==2),1);
        postest = size(find(ytest==1),1);
        negtest = size(find(ytest==2),1);
end
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
tic
switch option
    case 'lr'
        [theta, cost] = trainLR(Xn, ytrain, lambda);
    case 'nn' 
        [Theta1, Theta2, cost] = trainNN(Xn, ytrain, lambda, ...
            hidden_layer_size, num_labels);
    case 'svm'
        svmoptions = ['-s 0 -t 2 -c ', num2str(C), ' -g ', num2str(G)];
        model = svmtrain(ytrain, Xn, svmoptions);
end
toc
pause();

%% == Part 4: Predict ================================================== %%
% Compute the training set accuracy

switch option
    case 'lr'
        p = predictLR(theta, Xtestn, threshold);
    case 'nn'
        p = predictNN(Theta1, Theta2, Xtestn);
    case 'svm'
        p = svmpredict(ytest, Xtestn, model);
        %theta = [model.rho model.SVs(:,2)'*model.sv_coef]';
end

fprintf('Samples in training set: %d\n', m);
fprintf('Number of positives in training set: %d\n', pos);
fprintf('Number of negatives in training set: %d\n', neg);
fprintf('Samples in test set: %d\n', mtest);
fprintf('Number of positives in test set: %d\n', postest);
fprintf('Number of negatives in test set: %d\n', negtest);

fprintf('Train Accuracy: %f\n', mean(double(p == ytest)) * 100);
fprintf('Train F1 Score: %f\n', f1score(ytest,p,num_labels)*100);
fprintf('Train MCC: %f\n', MCC(ytest,p,num_labels)*100);

pause();
 
%% == Part 4: Feature Mapping with Learning Curve   ==================== %%
%  Test various values of lambda and polynomial degrees on validation set

switch option
    case 'lr'
        lvec = [0 0.001 0.003 0.01 0.03 0.1 0.3 1 3 10 30 100]';
        dvec = 1:10';
        %tvec = 0:0.05:1;
        tvec = 0.5;
        [lambda, pd, threshold, score, score_vec] = ...
            performLR(Xtrain, ytrain, Xtest, ytest, lvec, dvec, tvec);
        fprintf('lambda     degree      threshold       score\n');
        disp([lambda pd' threshold'  score']);
    case 'nn'
        lvec = [0 0.01 0.1 1 10]';
        dvec = 1:5';
        hvec = [1 2 3 5]';
        [lambda, pd, hd, score, score_vec] = ...
            performNN(Xtrain, ytrain, Xtest, ytest, lvec, dvec, hvec);
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


function [theta_o, score] = kfoldLR(k, X, y, lambda)
%kfoldLR: Performs K-Fold to a Linear regression given a dataset (X, y)
% SEED
rng(1)

indx = crossvalind('Kfold',X(:,1) ,k);
theta_o = [];
score = [];

for i = 1:k
    test = (indx == i); 
    train = ~test;
    [theta, cost] = trainLR(X(train,:), y(train), lambda);
    theta_o = [theta_o theta];
    p = predictLR(theta, X(test,:), 0.5);
    scorev = f1score(y(test), p, 1)*100;
    score = [score, scorev];
end
score = mean(score);
theta_o = mean(theta_o, 2);

%TRAINLR: Trains linear regression given a dataset (X, y) and a
%regularization parameter lambda

function [theta, cost] = trainLR(X, y, lambda)

% Initialize Theta
initial_theta = zeros(size(X, 2), 1); 

% Create "short hand" for the cost function to be minimized
costFunction = @(t) lrCostFunction(X, y, t, lambda);

options = optimset('MaxIter', 1000, 'GradObj', 'on');

% Minimize using fmincg
[theta, cost] = fmincg(costFunction, initial_theta, options);

end

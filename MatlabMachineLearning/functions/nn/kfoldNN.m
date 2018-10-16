function [score] = kfoldNN(k, X, y, lambda, hu, num_labels)
%kfoldNN: Performs K-Fold to a Neural Network given a dataset (X, y)
% SEED
rng(1)

indx = crossvalind('Kfold',X(:,1) ,k);
score = [];

for i = 1:k
    test = (indx == i); 
    train = ~test;            
    [Theta1, Theta2] = trainNN(X(train), y(train), lambda, hu, num_labels);
    p = predictNN(Theta1, Theta2, X(test));
    scoreaux = f1score(y(test), p, num_labels)*100;
    score = [score, scoreaux];
end
score = mean(score);

function [score] = kfoldSVM(k, X, y, g, c, num_labels)
%kfoldSVM: Performs K-Fold to a Support Vector Machine given a 
%dataset (X, y)
% SEED
rng(1)

svmoptions = ['-s 0 -t 2 -c ', num2str(c), ' -g ', ...
num2str(g)];
indx = crossvalind('Kfold',X(:,1) ,k);
score = [];

for i = 1:k
    test = (indx == i); 
    train = ~test;
    model = svmtrain(y(train), X(train,:), svmoptions);
    p = svmpredict(y(test), X(test,:), model);
    scoreaux = f1score(y(test), p, num_labels)*100;
    score = [score, scoreaux];
end
score = mean(score);
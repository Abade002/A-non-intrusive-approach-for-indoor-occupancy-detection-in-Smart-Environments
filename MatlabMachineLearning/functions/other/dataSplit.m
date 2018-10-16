function [xtrain, ytrain, xtest, ytest] = dataSplit(A, P)
%DATASPLIT: Split dataset A into a training dataset
% and a training dataset

[m,n] = size(A);
idx = randperm(m);
A(:,1:end-1) = featureNormalize(A(:,1:end-1));

data_training = A(idx(1:round(P*m)),:) ; 
data_testing = A(idx(round(P*m)+1:end),:);

xtrain = data_training(:, 1:end-1);
ytrain = data_training(:, end);

xtest = data_testing(:, 1:end-1);
ytest = data_testing(:, end);

end
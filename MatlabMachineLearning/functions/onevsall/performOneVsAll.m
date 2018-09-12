%PERFORMONEVSALL: Calculates some classifiers combinations and calculate 
%their performance, returning the best choices to ONEVSALL.
%Output: lambda (regularization parameter), pdeg (polynomial degree),
%   threshold, score, score_vec (matrix of all scores)
%Input: X0,y (training dataset), Xval0,yval (testing dataset), 
%   lambda_vec,d_vec,threshold_vec (parameters to combine and test)
function [lambda, pdeg, threshold, score, score_vec] = ...
    performOneVsAll(X0, y, Xval0, yval, lambda_vec, d_vec, threshold_vec)

num_labels = length(unique([y; yval]));

errorv = zeros(length(lambda_vec), length(d_vec), length(threshold_vec));

for d = 1:length(d_vec)
    X = polyFeatures(X0, d);
    X = featureNormalize(X); 
    X = [ones(size(X, 1), 1) X];
    Xval = polyFeatures(Xval0, d);
    Xval = featureNormalize(Xval);
    Xval = [ones(size(Xval, 1), 1) Xval];

    for l = 1:length(lambda_vec)
        lambda = lambda_vec(l);
        for t = 1:length(threshold_vec)
            [theta] = trainOneVsAll(X, y, num_labels, lambda);
            p = predictOneVsAll(theta, Xval);
            score_vec(l,d,t) = f1score(yval,p,num_labels)*100;
        end
    end
end

[score, id] = max(round(score_vec(:),2));
[lid, did, tid] = ind2sub(size(score_vec), id);
lambda = lambda_vec(lid);
pdeg = d_vec(did);
threshold = threshold_vec(tid);

end
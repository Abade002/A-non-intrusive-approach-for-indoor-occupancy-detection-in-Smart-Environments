%PERFORMLR: Calculates some classifiers combinations and calculate their 
%performance, returning the best choices to logistic regression.
%Output: lambda (regularization parameter), pdeg (polynomial degree),
%   threshold, score, score_vec (matrix of all scores)
%Input: X0,y (training dataset), Xval0,yval (testing dataset), 
%   lambda_vec,d_vec,threshold_vec (parameters to combine and test), 
%   option (1-binary , 2-multiclass)
function [lambda, pdeg, score, score_vec] = ...
    performLR(X0, y, lambda_vec, d_vec, k)

score_vec = zeros(length(lambda_vec), length(d_vec));
theta_vec = [];

for d = 1:length(d_vec)
    X = polyFeatures(X0, d);
    X = featureNormalize(X); 
    X = [ones(size(X, 1), 1) X];

    for l = 1:length(lambda_vec)
        [dumb score_vec(l,d)] = kfoldLR(k, X, y, lambda_vec(l));
    end
end

[score, id] = max(round(score_vec(:),2));
[lid, did] = ind2sub(size(score_vec), id);
lambda = lambda_vec(lid);
pdeg = d_vec(did);

end
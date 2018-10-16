%PERFORMSVM: Calculates some classifiers combinations and calculate their 
%performance, returning the best choices to svm.
%Output: gamma(regularization parameter), pdeg (polynomial degree),
%   c (penalization cost), score, scorev (matrix of all scores)
%Input: X0,y (training dataset), Xval0,yval (testing dataset), 
%   gamma_vec,d_vec,c_vec (parameters to combine and test), 
%   option (1-binary , 2-multiclass)
function [gamma, pdeg, c, score, score_vec] = ...
    performSVM(X0, y, gamma_vec, d_vec, c_vec, k)

num_labels = length(unique(y));

score_vec = zeros(length(gamma_vec), length(d_vec), length(c_vec));

for d = 1:length(d_vec)
    X = polyFeatures(X0, d);
    X = featureNormalize(X); 
    X = [ones(size(X, 1), 1) X];

    for g = 1:length(gamma_vec)
        gamma = gamma_vec(g);
        for c = 1:length(c_vec)
            [score_vec(g,d,c)] = kfoldSVM(k, X, y, gamma_vec(g), ...
                c_vec(c), num_labels);
       end
    end
end


[score, id] = max(round(score_vec(:),2));
[gid, did, cid] = ind2sub(size(score_vec), id);
gamma = gamma_vec(gid);
pdeg = d_vec(did);
c = c_vec(cid);

end
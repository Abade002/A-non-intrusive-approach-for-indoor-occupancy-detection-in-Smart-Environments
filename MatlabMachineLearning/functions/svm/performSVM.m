%PERFORMSVM: Calculates some classifiers combinations and calculate their 
%performance, returning the best choices to svm.
%Output: gamma(regularization parameter), pdeg (polynomial degree),
%   c (penalization cost), score, scorev (matrix of all scores)
%Input: X0,y (training dataset), Xval0,yval (testing dataset), 
%   gamma_vec,d_vec,c_vec (parameters to combine and test), 
%   option (1-binary , 2-multiclass)
function [gamma, pdeg, c, score, scorev] = ...
    performSVM(X0, y, Xval0, yval, gamma_vec, d_vec, c_vec)

num_labels = length(unique([y; yval]));

scorev = zeros(length(gamma_vec), length(d_vec), length(c_vec));

for d = 1:length(d_vec)
    X = polyFeatures(X0, d);
    X = featureNormalize(X); 
    Xval = polyFeatures(Xval0, d);
    Xval = featureNormalize(Xval);


    for g = 1:length(gamma_vec)
        gamma = gamma_vec(g);
        for c = 1:length(c_vec)
        svmoptions = ['-s 0 -t 2 -c ', num2str(c_vec(c)), ' -g ', ...
            num2str(gamma_vec(g))];
        model = svmtrain(y, X, svmoptions);
        p = svmpredict(yval, Xval, model);
        scorev(g,d,c) = f1score(yval, p, num_labels)*100;
       end
    end
end

[score, id] = max(round(scorev(:),2));
[gid, did, cid] = ind2sub(size(scorev), id);
gamma = gamma_vec(gid);
pdeg = d_vec(did);
c = c_vec(cid);

end
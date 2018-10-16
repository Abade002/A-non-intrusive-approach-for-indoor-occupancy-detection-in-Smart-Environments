%PERFORMNN: Calculates some classifiers combinations and calculate their 
%performance

function [lambda, pdeg, hiddenlayerunits, error, errorv] = ...
    performNN(X0, y, lambda_vec, d_vec, hiddenu_vec, k)

num_labels = length(unique(y));

errorv = zeros(length(lambda_vec), length(d_vec), length(hiddenu_vec));

for d = 1:length(d_vec)
    X = polyFeatures(X0, d);
    X = featureNormalize(X); 

    for l = 1:length(lambda_vec)
        for hd = 1:length(hiddenu_vec)
            errorv(l,d,hd) = kfoldNN(k, X, y, lambda_vec(l), ...
                hiddenu_vec(hd), num_labels);
       end
    end

end

[error, id] = max(round(errorv(:),2));
[lid, did, hid] = ind2sub(size(errorv), id);
lambda = lambda_vec(lid);
pdeg = d_vec(did);
hiddenlayerunits = hiddenu_vec(hid);

end

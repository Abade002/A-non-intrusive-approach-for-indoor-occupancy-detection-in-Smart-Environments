%PERFORMNN: Calculates some classifiers combinations and calculate their 
%performance

function [lambda, pdeg, hiddenlayerunits, error, errorv] = ...
    performNN(X0, y, Xval0, yval, lambda_vec, d_vec, hiddenu_vec)

num_labels = length(unique([y; yval]));

errorv = zeros(length(lambda_vec), length(d_vec), length(hiddenu_vec));

for d = 1:length(d_vec)
    X = polyFeatures(X0, d);
    X = featureNormalize(X); 
    Xval = polyFeatures(Xval0, d);
    Xval = featureNormalize(Xval);


    for l = 1:length(lambda_vec)
        lambda = lambda_vec(l);

        for hd = 1:length(hiddenu_vec)
            [Theta1, Theta2] = trainNN(X, y, lambda, ...
            hiddenu_vec(hd), num_labels);
            p = predictNN(Theta1, Theta2, Xval);
            errorv(l,d,hd) = f1score(yval,p,num_labels)*100;
       end
    end

end

[error, id] = max(round(errorv(:),2));
[lid, did, hid] = ind2sub(size(errorv), id);
lambda = lambda_vec(lid);
pdeg = d_vec(did);
hiddenlayerunits = hiddenu_vec(hid);

end

%POLYFEATURES: Takes a data matrix X (size m x 1) and
%maps each example into its polynomial features where
%X_poly(i, :) = [X(i) X(i).^2 X(i).^3 ...  X(i).^p];
function [X_poly] = polyFeatures(X, p)
if(p <= 1)
    X_poly = X;
else
    X_poly = zeros(numel(X), p);

    for i = 1:p
        X_poly(:,i) = X.^i;
    end
end

end

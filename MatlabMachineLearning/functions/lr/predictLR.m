%PREDICTLR: Predicts whether the label is 0 or 1 using learned logistic 
%regression parameters (theta), dataset (X) and a threshold
function p = predictLR(theta, X, threshold)

if(nargin ~= 3)
    threshold = 0.5;
end

m = size(X, 1);
p = zeros(m, 1);

for i = 1:size(X,1)
    if(sigmoid(X(i,:)*theta)>=threshold)
       p(i) = 1;
    else
       p(i) = 0;
    end
end

end

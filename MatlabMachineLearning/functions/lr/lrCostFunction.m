%LRCOSTFUNCTION Compute cost (J) and gradient (grad) for logistic 
%regression with regularization given a dataset (X, y), a
%regularization parameter (lambda) and regression parameters (theta)
function [J, grad] = lrCostFunction(X, y, theta, lambda)

m = length(y);
 
J = 0;
grad = zeros(size(theta));
theta_temp = theta;
theta_temp(1) = 0;
h = sigmoid(X*theta);
J = (sum(-y.*log(h)-(1-y).*log(1-h)) + ((lambda/2)*sum(theta_temp.^2)))./m;
grad = (X'*(h - y) + lambda.*theta_temp)./m;
grad = grad(:);

end

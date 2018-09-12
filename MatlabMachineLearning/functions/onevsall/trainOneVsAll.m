%TRAINONEVSALL: Trains num_labels logistic regression classifiers and
%returns each of these classifiers in a matrix all_theta, where the i-th
%row of all_theta corresponds to the classifier for label i
function [all_theta] = trainOneVsAll(X, y, num_labels, lambda)

m = size(X, 1);
n = size(X, 2);
all_theta = zeros(num_labels, n);

for c = 1:num_labels
    initial_theta = zeros(n, 1);
    options = optimset('GradObj', 'on', 'MaxIter', 1000);
    [theta] = fmincg (@(t)(lrCostFunction(X, (y == c), t, lambda)),...
        initial_theta, options);
    all_theta(c,:) = theta;
end

end

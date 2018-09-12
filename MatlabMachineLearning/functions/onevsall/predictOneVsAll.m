%PREDICTONEVSALL: Predicts the label for a trained one-vs-all classifier.
function p = predictOneVsAll(all_theta, X)

m = size(X, 1);
num_labels = size(all_theta, 1);

p = zeros(m, 1);
predict = sigmoid(X*all_theta');
[predict_max, index_max] = max(predict, [], 2);
p = index_max;
end

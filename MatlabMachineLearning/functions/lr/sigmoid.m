%SIGMOID: Computes the sigmoid of z.
function g = sigmoid(z)
g = zeros(size(z));
g = 1.0 ./ (1.0 + exp(-z));
end

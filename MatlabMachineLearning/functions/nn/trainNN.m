%TRAINNN: Trains NN classifier with one hidden layer
function [Theta1, Theta2, cost] = trainNN(X, y, lambda, ...
    hidden_layer_size, num_labels)

n = size(X, 2);
input_layer_size  = n;

initial_Theta1 = randInitializeWeights(input_layer_size,...
    hidden_layer_size);
initial_Theta2 = randInitializeWeights(hidden_layer_size, num_labels);

% Unroll parameters
initial_nn_params = [initial_Theta1(:) ; initial_Theta2(:)];

options = optimset('MaxIter',1000);

costFunction = @(p) nnCostFunction(p, ...
                                   input_layer_size, ...
                                   hidden_layer_size, ...
                                   num_labels, X, y, lambda);

[nn_params, cost] = fmincg(costFunction, initial_nn_params, options);

% Obtain Theta1 and Theta2 back from nn_params
Theta1 = reshape(nn_params(1:hidden_layer_size * ...
    (input_layer_size + 1)), hidden_layer_size, (input_layer_size + 1));

Theta2 = reshape(nn_params((1 + (hidden_layer_size * ...
    (input_layer_size + 1))):end), num_labels, (hidden_layer_size + 1));
end
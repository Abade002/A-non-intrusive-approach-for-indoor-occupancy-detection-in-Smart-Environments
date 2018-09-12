%NNCOSTFUNCTION: Implements the neural network cost function with one 
%hidden layer
function [J grad] = nnCostFunction(nn_params, ...
                                   input_layer_size, ...
                                   hidden_layer_size, ...
                                   num_labels, ...
                                   X, y, lambda)


Theta1 = reshape(nn_params(1:hidden_layer_size * ...
    (input_layer_size + 1)), hidden_layer_size, (input_layer_size + 1));

Theta2 = reshape(nn_params((1 + (hidden_layer_size * ...
    (input_layer_size + 1))):end), num_labels, (hidden_layer_size + 1));

m = size(X, 1);
         
J = 0;
Theta1_grad = zeros(size(Theta1));
Theta2_grad = zeros(size(Theta2));

% Part 1: Feedforward the neural network and return the cost in the
% variable J.
    a1 = [ones(m,1) X];
    z2 = a1*Theta1';
    a2 = [ones(size(z2,1),1) sigmoid(z2)];
    z3 = a2*Theta2';
    a3 = sigmoid(z3);
    h = a3;
    
    Y = zeros(m, num_labels);
    Y = bsxfun(@eq, y, 1:num_labels);
    
    Jnoregul = (1/m)*sum(sum((-Y).*log(h) - (1-Y).*log(1-h), 2));
    
    Theta1_aux = Theta1;
    Theta2_aux = Theta2;
    Theta1_aux(:,1) = 0;
    Theta2_aux(:,1) = 0;
    regul = lambda/(2*m) * (sum(sum(Theta1_aux.^2,2)) + sum(sum(Theta2_aux.^2,2)));
    J = Jnoregul + regul;
    
% Part 2: Implement the backpropagation algorithm to compute the gradients
% Theta1_grad and Theta2_grad. 
    d3 = a3  - Y;
    d2 = d3*Theta2.*sigmoidGradient([ones(size(z2,1),1) z2]);
    d2 = d2(:, 2:end);
    D1 = d2'*a1;
    D2 = d3'*a2;
 
    Theta1_grad = D1./m + lambda/m * Theta1_aux;
    Theta2_grad = D2./m + lambda/m * Theta2_aux;

% Unroll gradients
grad = [Theta1_grad(:) ; Theta2_grad(:)];

end

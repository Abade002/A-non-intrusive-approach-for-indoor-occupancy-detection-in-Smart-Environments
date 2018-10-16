%RANDINITIALIZEWEIGHTS: Randomly initialize the weights of a layer with 
%L_in incoming connections and L_out outgoing connections
function W = randInitializeWeights(L_in, L_out)
rng(1)
W = zeros(L_out, 1 + L_in);

% Randomly initialize the weights to small values
epsilon_init = sqrt(6)/(sqrt(L_in+L_out));
W = rand(L_out, 1 + L_in) * 2 * epsilon_init - epsilon_init;

end

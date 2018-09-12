%CONFUSIONMATRIX: Calculates True Positives, False Positives, 
%True Negatives and False Negatives for two matrices
function [TP, FP, TN, FN] = confusionMatrix(actual, predicted)
adder = actual + predicted;
TP = length(find(adder == 2));
TN = length(find(adder == 0));
subtr = actual - predicted;
FP = length(find(subtr == -1));
FN = length(find(subtr == 1));
end
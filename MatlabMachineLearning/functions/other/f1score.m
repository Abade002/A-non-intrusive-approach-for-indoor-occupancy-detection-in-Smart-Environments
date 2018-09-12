%F1SCORE: Calculates the f1score given a actual output (y), a predicted
%output (p), a num_labels and a option (string 'micro' or 'macro')
function F1 = f1score(y,p, num_labels, option)
if(nargin == 3)
    if(num_labels<=2)
        option = 'micro';
        num_labels = 1;
    else
        option = 'macro';
    end
end

for i = 1:num_labels
    ytemp = y;
    ptemp = p;
    ytemp(ytemp~=i) = 0;
    ytemp(ytemp==i) = 1;
    ptemp(ptemp~=i) = 0;
    ptemp(ptemp==i) = 1;
    [TP(i), FP(i), TN(i), FN(i)] = confusionMatrix(ytemp,ptemp);
end

if(option == 'micro')
    P = sum(TP)/(sum(TP)+sum(FP));
    R = sum(TP)/(sum(TP)+sum(FN));
elseif(option == 'macro')
    P = TP./(TP+FP);
    R = TP./(TP+FN);
    P(isnan(P)) = 0;
    R(isnan(R)) = 0;
    P = sum(P)/num_labels;
    R = sum(R)/num_labels;
end

F1 = 2*((P*R)/(P+R));
F1(isnan(F1))=0;

end

   
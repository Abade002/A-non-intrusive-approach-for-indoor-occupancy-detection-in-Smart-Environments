%MCC: Calculates the mcc given a actual output (y), a predicted
%output (p), a num_labels and a option (string 'micro' or 'macro')
function mcc = MCC(y, p, num_labels, option)

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
    TP = sum(TP);
    FP = sum(FP);
    TN = sum(TN);
    FN = sum(FN);
    mcc = (TP*TN-FP*FN)/sqrt((TP+FP)*(TP+FN)*(TN+FP)*(TN+FN));
elseif(option == 'macro')
    mcc = (TP.*TN-FP.*FN)./sqrt((TP+FP).*(TP+FN).*(TN+FP).*(TN+FN));
    mcc(isnan(mcc)) = 0;
    mcc = mean(mcc);
end
   
mcc(isnan(mcc)) = 0;
end



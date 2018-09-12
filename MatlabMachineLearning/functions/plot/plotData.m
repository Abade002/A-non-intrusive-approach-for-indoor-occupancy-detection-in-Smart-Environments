%PLOTDATA: Plots the data points with + for the positive examples and o 
%negative examples
function plotData(X, y, option)

switch option 
    case {'lr','svm'}
        y0 = find(y==0);
        y1 = find(y==1);
    case 'nn'
        y1 = find(y==1);
        y0 = find(y==2);
end

figure(); 
subplot(2,2,1:2)
hold on;
plot(y0, X(y0), 'ro', 'MarkerFaceColor', 'r');
plot(y1, X(y1), 'g+', 'MarkerSize', 7);
ylabel('SampleValues')
xlabel('Samples')
legend('y=0', 'y=1')  
hold off;

subplot(2,2,3);
hist(X);
title('X values');
xlabel('SampleValues')
ylabel('Samples')

subplot(2,2,4);
hist(y,2);
title('Positive/negative samples');
ylabel('Samples')
xlabel('Y');

end

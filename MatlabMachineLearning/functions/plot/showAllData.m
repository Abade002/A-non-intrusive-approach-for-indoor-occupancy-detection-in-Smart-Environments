%SHOWALLDATA: Plots the graphics given a dataset, a label (string) and
%a smoothing factor (a)

function  [] = showAllData(data, label, a)
figure();
plot(data, 'b');
hold on;
plot(lowfilter(data,a), 'r');
legend('Raw Data (without outliers)', ...
    strcat('Filtered Data a=',num2str(a)));
xlabel('Training Examples');
ylabel(label);
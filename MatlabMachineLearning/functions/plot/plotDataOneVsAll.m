%PLOTDATA: Plots the data points for all class examples
function plotDataOneVsAll(X, y)
y0 = find(y==6);
y1 = find(y==1);
y2 = find(y==2);
y3 = find(y==3);
y4 = find(y==4);
y5 = find(y==5);

figure();

subplot(2,2,1:2);
hold on;
plot(y0,X(y0), 'ro');
plot(y1,X(y1), 'g+');
plot(y2,X(y2), 'bx');
plot(y3,X(y3), 'ks');
plot(y4,X(y4), 'm^');
plot(y5,X(y5), 'cV');
xlabel('Samples')
ylabel('Temperature (ºC)')
legend('y=0', 'y=1', 'y=2', 'y=3', 'y=4', 'y=5')  
hold off;

subplot(2,2,3);
hist(X);
title('X values');
ylabel('Samples (u)');
xlabel('Temperature (ºC)');

subplot(2,2,4);
hist(y,6);
xlim([1 6])
title('Positive/negative samples');
ylabel('Samples (u)');
xlabel('Y');

end

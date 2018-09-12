%SHOWDATA: Plots the graphics by date (integer eg. 14) given a dataset
function [] = showData(data, date)
subgraph = length(data)/1440;
figure();
for i=1:subgraph
    subplot(subgraph/2,2,i)
    temp = data(1 +(1440*(i-1)) : 1440*(i));
    plot(linspace(0,24,1440),temp)
    title(date)
    date = date + 1;
end

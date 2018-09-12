%AVGDATA: Given a dataset (data), a numavg (average number), and a decimal
%return a vector with the data grouped by the 'numavg' with 'decimal' point
function [avgd] = avgdata(data, numavg, decimal)

if(nargin == 2)
    decimal = 6;
end

avgd = zeros(floor(length(data)/numavg),1);

for i = 1:length(avgd)
    liminf = 1+(numavg*(i-1)); limsup = numavg*i;
    avgd(i) = mean(data(liminf:limsup));
end

avgd = round(avgd,decimal);
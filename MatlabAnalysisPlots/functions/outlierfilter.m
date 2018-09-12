%OUTLIERFILTER: Implements a outlier filter
%Input: data (data to filter), thresh (threshold to filter)
%Output: dataf (data filtered), num (number of filtered data)

function [dataf, num] = outlierfilter(data, thresh)

if(nargin == 1)
    thresh = 1;
end

num = 0;
dataf = zeros(size(data));

dataf(1) = data(1);

for i = 2:length(dataf)
    if 1-thresh < data(i)/dataf(i-1) && data(i)/dataf(i-1) < 1+thresh
        dataf(i) = data(i);
    else
        %y(i) = (y(i-1)+temp(i+1))/2;
        dataf(i) = dataf(i-1);
        num = num + 1;
    end
end

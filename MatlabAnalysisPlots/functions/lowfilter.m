%LOWFILTER: Implements a low-pass filter
%Input: data (data to filter), a (smoothing factor)
%Output: dataf (data filtered)

function [dataf] = lowfilter(data, a)

if(nargin == 1)
    a = 1;
end
    
dataf = zeros(size(data));

dataf(1) = data(1);

for i = 2:length(data)
    dataf(i) = dataf(i-1)*(1-a) + a*data(i);
end

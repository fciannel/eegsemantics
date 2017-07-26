function [ data_cwt ] = commonCWTTrans( data, fs )
%COMMONCWTTRANS Summary of this function goes here
%   Detailed explanation goes here

ndata = length(data);
data_cwt = cell(1,ndata);

for i=1:ndata
    data_cwt{i} = cwt_transform(data{i}(:,1:end-1), fs);
    data_cwt{i} = horzcat(data_cwt{i}, data{i}(:,end))
end


end


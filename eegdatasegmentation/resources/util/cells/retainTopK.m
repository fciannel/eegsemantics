function [ out ] = retainTopK( C , k)
%RETAINTOPK Summary of this function goes here
%   Detailed explanation goes here

out = C;
for i=1:length(C)
    for j=1:length(C{i})
        out{i}{j} = out{i}{j}(:,1:k);
    end
end

end


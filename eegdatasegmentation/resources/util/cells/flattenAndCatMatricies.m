function [ out ] = flattenAndCatMatricies( C )
%FLATTENANDCATMATRIX Summary of this function goes here
%   Detailed explanation goes here

out = zeros(0,numel(C{1}{1}));

for i=1:size(C, 1)
    for j=1:size(C,2)
        out = vertcat(out, C{i}{j}(:)');
    end
end

end


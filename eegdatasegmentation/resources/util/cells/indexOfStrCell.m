function [ inds ] = indexOfStrCell( to_find_cell, str_cell )
%INDEXOFSTRCELL Summary of this function goes here
%   Detailed explanation goes here

n_to_find = length(to_find_cell);
inds = -1*ones(1, n_to_find);

for i=1:n_to_find
    for j=1:length(str_cell)
        if strcmp(to_find_cell{i}, str_cell{j}) == 1
            inds(i) = j;
            break;
        end
    end
end



end


function [ i ] = index_of_str( string_cell, string )
%INDEX_OF_STR returns the index of the cell which is equal to string

for i=1:length(string_cell)
    if strcmp(string_cell{i}, string)
        return
    end
end

i=-1;


end


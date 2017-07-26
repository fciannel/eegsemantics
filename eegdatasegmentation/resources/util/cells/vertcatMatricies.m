function [ out ] = vertcatMatricies( C )
%VERTCATMATRICIES Summary of this function goes here
%   Detailed explanation goes here

out = cell(1,length(C));


for i=1:length(C)
    out{i} = zeros(0, size(C{1}{1}, 2));
    for j=1:length(C{i})
        out{i} = vertcat(out{i}, C{i}{j});
    end
end

end


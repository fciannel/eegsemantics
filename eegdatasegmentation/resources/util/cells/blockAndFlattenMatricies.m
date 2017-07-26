function [ out, label ] = blockAndFlattenMatricies( C, block_length)
%BLOCKANDFLATTENMATRICIES Summary of this function goes here
%   Detailed explanation goes here

out = zeros(0, block_length * size(C{1}{1}, 2));
label = zeros(0,1);


for i=1:length(C)
    for j=1:length(C{i})
        start = 1;
        stop = start + block_length -1;
        while( stop <= size(C{i}{j},1))
            tmp = C{i}{j}(start:stop,:);
            out = vertcat(out, tmp(:)');
            label = vertcat(label, i);
            start = stop + 1;
            stop = start + block_length -1;
        end
    end
end


end


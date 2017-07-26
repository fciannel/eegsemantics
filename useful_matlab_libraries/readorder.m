function order = readorder(x)
fileID = fopen(x, 'r');
formatSpec = '%d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d';
order = (fscanf(fileID, formatSpec, [20 inf]))';
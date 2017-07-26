function [ data, chans ] = abm_to_common_mult( folder, ids, begin_marker)
%ABM_TO_COMMON_MULT Summary of this function goes here
%   Detailed explanation goes here

ndata = length(ids);

data_cell = cell(1,ndata);
events_cell = cell(1,ndata);


for i=1:ndata    
    disp(['Full participant ID: ' ids]);
    data_cell{i} = abm_read_edf_file(folder, [ids{i} '.edf']); % EEG signals
    events_cell{i} = abm_read_markers([folder '/' ids{i} '_third_party_data.bin'],begin_marker); % Event markers
end

chans = data_cell{i}.VHeader.Names(1:44);

[data,~] = abm_to_common(data_cell,events_cell, chans);

end


function extract_multiple( pname,first_dname,total_songs_trial,num_trials,num_sets )
%EXTRACT_MULTIPLE File extraction for experiments requiring multiple EEG
%   data sets. Concatenates the sets and stores it into one dataset.
%   Concatenate: data, order, response
%   Don't concatenate: chans

MATLABBASEDIR = 'C:\Users\Francesco Ciannella\Box Sync\Documents\Homeworks\NC-15686\NCProject\MusicEEGResearch\MATLAB';

% generate storage path for data.mat
outf = [MATLABBASEDIR '\DataFiles\data\' pname];
fprintf(['STORING data.mat to folder: ' outf '\n']);

%convert data ID to an int so we can increment through all IDs
first_dnum = str2double(first_dname);
inf = [MATLABBASEDIR '\DataFiles\data_raw\'  first_dname '_1'] ;

    %loop through every set of EEG data
    for set_index = 1:num_sets
    
        %increment ID
        dnum = first_dnum + (set_index - 1);
        dname = int2str(dnum);
        set_index_string = int2str(set_index);
    
        %generate file names for extraction
        params = {['0' dname '01201']};
        stim = ['stim_' pname set_index_string '.txt'];
        resp = ['ratings_' pname set_index_string '.txt'];
        
        %generate file path for edf and event code file extraction
        fprintf(['      extracting from file: ' inf '\' params{1} '\n']);
        
        %generate file path for ratings and stim file extraction
        stimf = [outf '\stims_' pname '\' stim];
        respf = [outf '\ratings_' pname '\' resp];
        
        %now actually extract these files        
        %if we are working with the first file, initialize the out matrices
        if(set_index == 1) 
            order = read_song_order(stimf, total_songs_trial, num_trials);
            response = read_answer_file(respf);
            [data, chans] = abm_to_common_mult(inf, params, 1); 
            data = data{1};
        else
            order_addon = read_song_order(stimf, total_songs_trial, num_trials);
            order = [order, order_addon];
            
            response_addon = read_answer_file(respf);
            response = [response, response_addon];
            
            [data_addon, chans] = abm_to_common_mult(inf, params, 1); 
            data = [data; data_addon{1}];
        end  
    end
    
    save([outf '\data.mat'], 'data', 'chans', 'order', 'response');
    
end
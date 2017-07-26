function extract_raw_data( subject_name )
%Extracts EEG data, channels, order, and participant's manual responses
%   Based off Yeji's code file "extract_raw.m"

% -----------------------------------------------------------------------
% Please manually input all new participants and their EEG ID # here:
% ----------------------------------------------------------------------- 
% num_trials: number of trials in a set
% set: one "block" of trials. A full experiment of 400 songs can be split
%   into 4 sets of 100 songs.
% ----------------------------------------------------------------------- 
    pset = {'fciannel'};
    dset = {'0610'}; 
   % total_songs_trial = {20,20,20,20,20, 20};  
    total_concepts_seen = {510};
    num_trials = {1};
    num_sets = {1}; 
% -----------------------------------------------------------------------


    
% -----------------------------------------------------------------------
% Find the desired subject in the entire set of participants.
% If can't find subject, return a warning.
% -----------------------------------------------------------------------
    for ob = 1:numel(pset)
        if strcmp(pset{ob}, subject_name)
            break
        end
    end

    if ~strcmp(pset{ob}, subject_name)
        disp(['NO SUBJECT NAMED ' subject_name])
        return
    end
% -----------------------------------------------------------------------

    
    
% -----------------------------------------------------------------------
% Construct datapaths to access sequence and data files for the given 
% participant. 
% ID must end in "..01201.edf"
% -----------------------------------------------------------------------
    if(num_sets{ob} == 1) %there is only one EEG file for this participant
        extract_single(pset{ob},dset{ob},total_concepts_seen{ob}, num_trials{ob},num_sets{ob});
    else %multiple EEG files must be concatenated
        extract_multiple(pset{ob},dset{ob},total_songs_trial{ob}, num_trials{ob},num_sets{ob});
    end
% -----------------------------------------------------------------------

end


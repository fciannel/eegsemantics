function result=classify_songs(out, validation_type, leaveOut, portion, features)


% -----------------------------------------------------------------------
% PARAMETERS
%
%  MODE: pick a training set
%   subj: use the participant's ratings for training and testing
%   randall: use Randall's musical/nonmusical classifications for the clips
%   both: use a combination of subj and randall by only using clips where
%       subj and randall's ratings match
%  USEFEATS: pick a feature set to use
%   all: use all the features and their bands
%   jessica: use only important bands from jessica's experiment
%       fp1,fp2,f3,f4,f7,f8,fz, t3, c3, fp1/2 f3/4 f7/8 t3/4
%   right: use right hemisphere electrodes f4, f8, fc4, ft8
% -----------------------------------------------------------------------
mode = 'randall';
usefeats = 'all';








% -----------------------------------------------------------------------
% INITIALIZATION
%   determine if running classification on song clip or reflection portion
% -----------------------------------------------------------------------
if(strcmp(portion,'song'))
    load([out '/data_processed_diff.mat']);
    overlap = 0.625;
    sizebin = 1.5;
    timePerSong = 5;
    nBins = (timePerSong-sizebin)/(sizebin-overlap)+1;
    % assuming each clip is 5 seconds long with wavelet of 1s window and 0.5s overlap
elseif(strcmp(portion,'refl'))
    load([out '/data_processed_diff_refl.mat']);
    overlap = 0.75;
    %overlap = 0.625; %TEMP
    sizebin = 1.5;
    reflTime = 3;
    %reflTime = 5; %TEMP
    nBins = (reflTime-sizebin)/(sizebin-overlap)+1;
    % assuming each refl is 3 seconds long with wavelet of 1s window and 0.5s overlap
else
    disp('input the correct portion to run the code on: "song" or "refl"');
    return;
end


% -----------------------------------------------------------------------
% FEATURE SELECTION
%   determine if running classification on song clip or reflection portion
% -----------------------------------------------------------------------

fp1     =     1:12;
f3      =     13:24;
f7      =     25:36;
t3      =     37:48;
c3      =     49:60;
t5      =     61:72;
p3      =     73:84;
o1      =     85:96;
fp2     =     97:108;
f4      =     109:120;
f8      =     121:132;
t4      =     133:144;
c4      =     145:156;
t6      =     157:168;
p4      =     169:180;
o2      =     181:192;
fz      =     193:204;
cz      =     205:216;
pz      =     217:228;
oz      =     229:240;
fp1_2   =     241:252;
f3_4    =     253:264;
f7_8    =     265:276;
t3_4    =     277:288;
c3_4    =     289:300;
t5_6    =     301:312;
p3_4    =     313:324;
o1_2    =     325:336;

if (strcmp(usefeats,'all'))
    frontal = [fp1 fp2 f3 f4 f7 f8 fz];
    temporal = [t3 t4 t5 t6];
    central = [c3 c4 cz];
    parietal = [p3 p4 pz];
    occipital = [o1 o2 oz];
    diff = [fp1_2 f3_4 f7_8 t3_4 c3_4 t5_6 p3_4 o1_2]; 
elseif (strcmp(usefeats, 'jessica'))
    %TEMP: using jessica's 
    frontal = [fp1 fp2 f3 f4 f7 f8 fz];
    temporal = t3;
    central = c3;
    diff = [fp1_2 f3_4 f7_8 t3_4 c3_4];
    parietal = [];
    occipital = [];
elseif (strcmp(usefeats,'right'))
    %electrodes f4, f8, fc4, ft8
    frontal = [f4 f8];
    central = c4;
    temporal = t4;
    diff = [];
    parietal = [];
    occipital = [];
else
    disp('please use a proper usefeat');
    return;
end

%{
if (strcmp(usefeats,'all'))
    %frontal = [1:12 13:24 25:36 97:108 109:120 121:132 193:204]
    frontal = [1:36 97:132 193:204]; % columns corresponding to fp1,fp2,f3,f4,f7,f8,fz
    temporal = [37:48 61:72 133:144 157:168]; % t3,t4,t5,t6
    central = [49:60 145:156 205:216]; % c3 c4 cz
    parietal = [73:84 169:180 229:240]; % p3 p4 pz
    occipital = [85:96 181:192 325:336]; % o1 o2 oz 
    diff = [241:336]; 
elseif (strcmp(usefeats, 'jessica'))
    %TEMP: using jessica's 
    frontal = [1:36 97:132 193:204]; % columns corresponding to fp1,fp2,f3,f4,f7,f8,fz
    temporal = [37:48]; %t3
    central = [49:60]; %c3
    diff = [241:312];
    parietal = [];
    occipital = [];
elseif (strcmp(usefeats,'right'))
    %electrodes f4, f8, fc4, ft8
    frontal = [97:108 121:132];
    central = [145:156];
    temporal = [61:72];
    diff = [];
    parietal = [];
    occipital = [];
else
    disp('please use a proper usefeat');
    return;
end
%}


if(strcmp(features,'all'))
    usedFeats = 1:336;
elseif(strcmp(features,'allused'))
    usedFeats = cat(2,frontal,temporal,central,parietal,occipital,diff);
elseif(strcmp(features,'front'))
    usedFeats = frontal;
elseif(strcmp(features,'temp'))
    usedFeats = temporal;
elseif(strcmp(features,'cent'))
    usedFeats = central;
elseif(strcmp(features,'par'))
    usedFeats = parietal;
elseif(strcmp(features,'occ'))
    usedFeats = occipital;
elseif(strcmp(features,'diff'))
    usedFeats = diff;
else
    disp('input the correct subset of features to use');
    return;
end
% usedFeats = get_impt_feats(out, 50) % get 50 most important features
nUsedFeats = length(usedFeats);

% -----------------------------------------------------------------------
% BIN SELECTION
%   
% -----------------------------------------------------------------------
nUsedBins = nBins-1;
nClips = 20;
%nRepeats = 20; % num repeats of each clip (for regular experiments)
%nRepeats = 15; % TEMP for xingyu
dp_dim = size(data_processed);
nRepeats = dp_dim(3);
%binDatax = datax; % take data at bin level
nFeats = 336;
vecsPerClip = nRepeats*nUsedBins; % num feat vectors we get from one playthrough of a clip
totalBins = nRepeats*nUsedBins*nClips;
% transfer feature vectors from data_processed to our training/test set
datax = zeros(nUsedFeats, nRepeats*nClips*nUsedBins);
index = 0;
for rpt = 1:nRepeats
    for bin = (nBins-nUsedBins+1):nBins
        for r = 1:nClips
            index = index+1;
            datax(:,index) = data_processed(usedFeats,bin,rpt,r); % transfer only used features over
        end
    end
end
datax = datax'; % now datax is ((nClips*nRepeatsxnUsedBins) x nUsedFeats)

% normalization to range [0,1] using feature scaling
hi1 = max(datax);
lo1 = min(datax);
datax = (datax-repmat(lo1,size(datax,1),1))./repmat(hi1-lo1,size(datax,1),1);
binDatax = datax;












% -----------------------------------------------------------------------
% CROSS VALIDATION
%   
% -----------------------------------------------------------------------
result = zeros(1,2);

% dimension reduction
% method = 'PCA';
% no_dims = round(intrinsic_dim(binDatax,'MLE')); % estimate dimensionality using MLE - max likelihood estimator
% fprintf('Reducing dimensions to %d using %s\n',no_dims,method);
% binDatax = compute_mapping(binDatax,method,no_dims); 

% seqDatax = zeros(nClips*nRepeats,nBins*nFeats); % take data at sequence level
% for repeat = 1:(nRepeats*nClips)
%     seqRow = [];
%     for bin = 1:nBins
%         seqRow = [seqRow datax(bin,:)];
%     end
%     seqDatax(repeat,:) = seqRow;
% end

% define our labels
% clipNames = [D100 D14 D15 D17 D19 D26 D29 D33 D45 D51 D59 D6 D61 D7 D82 D84 D88 D91 D93 D99];
sortedRandallClipLabels = [1 -1 -1 -1 -1 1 1 -1 1 1 -1 1 1 -1 1 -1 1 1 -1 -1]; 
RandallBinLabel = kron(sortedRandallClipLabels,ones(1,nUsedBins*nRepeats));
% RandallSeqLabel = kron(sortedRandallClipLabels,ones(1,20));
% RandallSeqLabel = RandallSeqLabel';
subjBinLabel = kron(sortedResponse,ones(1,nUsedBins));
subjBinLabel = subjBinLabel';
RandallBinLabel = RandallBinLabel';

if(strcmp(mode,'subj'))
    RandallBinLabel = subjBinLabel; %TEMP
elseif(strcmp(mode,'both'))
    
    % Get a matrix of 0 and 1s, where 1s mark matching bin labels
    match_matrix_locations = subjBinLabel == RandallBinLabel;
    
    % Get a matrix of only where subj and Randall labels match, with
    %   zeros where they don't
    bothBinLabel = subjBinLabel.*match_matrix_locations;
    
    % Get a matrix of the EEG data where the labels match, with zeros
    % elsewhere
    binDatax = binDatax .* repmat(match_matrix_locations,1,336);
    
    % Remove the zeros
    bothBinLabel = nonzeros(bothBinLabel);
    bothBinLabel = bothBinLabel';
    binDatax = nonzeros(binDatax);
    binDatax = binDatax';
    
end

% label = label(randperm(length(label)));

% partition all of the data at the bin level
nFold = 10; % nFold is how many partitions we want to split datax into

fprintf(['Leaving out ' leaveOut '\n']);
fprintf(['Analyzing ' features '\n']);

if strcmp(leaveOut, 'random')
    % take a random data set as our test
    indices = crossvalind('KFold',totalBins,nFold);
    %indices = crossvalind('KFold',nClips*nRepeats,nFold); % seq level indices
elseif strcmp(leaveOut, 'repeats')
    % take randomly chosen repeats of clips as our test
    trialIndices = crossvalind('KFold',nRepeats,nFold);
    % scale out trialIndices so each bin is labeled and repeat it nClips times
    indices = repmat(kron(trialIndices,ones(nUsedBins,1)),nClips,1);
elseif strcmp(leaveOut, 'clips')
    % take all repeats of a musical and not musical clip out
    musicalInd = find(sortedRandallClipLabels > 0);
    nmusicalInd = find(sortedRandallClipLabels < 0);
    musXInd = crossvalind('Kfold',nClips/2,nFold);
    nmusXInd = crossvalind('Kfold',nClips/2,nFold);
    together = zeros(nClips,1);
    together(musicalInd) = musXInd;
    together(nmusicalInd) = nmusXInd;
    % scale out clipIndices so all bins of each clip is labeled
    indices = kron(together,ones(nUsedBins*nRepeats,1));
else
    printf('Incorrect input. Please input "random", "repeats", or "clips"');
    return
end

acc2 = zeros(nFold, 1);

% visualization
if strcmp(validation_type,'vis')
    clip = 1; % view all repeats of ClipNo
    offset = (clip-1)*vecsPerClip;
    hold on;
    for rpt = 3:3 
        from = nUsedBins*(rpt-1)+1 + offset;
        to = nUsedBins*(rpt) + offset;
        plot(binDatax(from:to,1),binDatax(from:to,2));
    end
    %hold off;
    % view the 
    %scatter3(binDatax(:,1),binDatax(:,2),RandallBinLabel);
    %visualize_2d(binDatax, ind1, ind2, 'musicality');
    return;
end

feats = 0;

parfor fd = 1:nFold % loop through using each partition as a test group
    test = (indices == fd); % take one partition for testing
    train = ~test; % take everything else for training
    train_data = binDatax(train, :);
    test_data = binDatax(test, :);
    train_label = RandallBinLabel(train); 
    test_label = RandallBinLabel(test);
    if strcmp(validation_type, 'forest')
        opts = statset('UseParallel', 'always');
        bagged = TreeBagger(50, train_data, train_label, 'OOBVarImp', 'On', 'Options', opts);
        %             plot(oobError(bagged));
        %             xlabel('Number of Grown Trees');
        %             ylabel('Out-of-Bag Classification Error');
        classified = str2double(predict(bagged, test_data));
        feats = feats + bagged.OOBPermutedVarDeltaError;
        
        positive = find(classified == test_label);
        negative = find(classified ~= test_label);
        p1 = numel(find(classified(positive) == 2));
        p2 = numel(find(classified(positive) == 1));
        n1 = numel(find(classified(negative) == 2));
        n2 = numel(find(classified(negative) == 1));
        if p1+n1==0
            prec = p2/(p2+n2)*100;
        elseif p2+n2==0
            prec = p1/(p1+n1)*100;
        else
            prec = (p1/(p1+n1) + p2/(p2+n2))/2*100;
        end
        if p1+n2==0
            rec = p2/(p2+n1)*100;
        elseif p2+n1==0
            rec = p1/(p1+n2)*100;
        else
            rec = (p1/(p1+n2) + p2/(p2+n1))/2*100;
        end
        acc = numel(positive)/(numel(positive)+numel(negative))*100;
        
        acc2(fd,1) = acc;
        
    else
        model = svmtrain(train_label, train_data, '-t 1 -g 0.1 -c 5 -q');
        % model = svmtrain(train_label, train_data, '-t 0 -c 5 -q');
        [classified, accuracy, ~] = svmpredict(test_label, test_data, model);
        
        prec = 0;
        rec = 0;
        acc = 0;
        
        acc2(fd,1) = accuracy(1);
    end
end

if strcmp(validation_type,'forest')
    feats = feats./nFold;
    save([out '/forest.mat'], 'feats');
end

result(1, 1) = mean(acc2);
result(1, 2) = std(acc2);

end


function cwt_coeff = cwt_transform(trial, freq, sig, cmap)
trial = trial';
% [nchannel data_len] = size(trial);
% stimuli_time=15;
% expect_length=freq*stimuli_time;
% data=zeros(nchannel,expect_length);
wvname_delta = 'cmor0.022516-2.5';
wvname_theta = 'cmor0.050660-6';
wvname_alpha = 'cmor0.012665-10';
wvname_spindle = 'cmor0.05066-13';
wvname_beta = 'cmor0.000625-21';
wvname_gamma = 'cmor0.002026-35';
fc = [2.5 6 10 13 21 35];

[nchannel,trial_len] = size(trial);

nscale = [2 1 2 1 3 3];

cwt_coeff = zeros(nchannel * sum(nscale), trial_len);
if sig == 0
    for i = 1:nchannel;
        findex = (i-1)*sum(nscale);
        scale = freq * fc(1,1) ./ [2 3];
        cwt_coeff(findex+1:findex+2, :) = cwt(trial(i,:), scale, wvname_delta);

        scale = freq * fc(1,2) ./ [6];
        cwt_coeff(findex+3:findex+3, :) = cwt(trial(i,:), scale, wvname_theta);

        scale = freq * fc(1,3) ./[8 10];
        cwt_coeff(findex+4:findex+5, :) = cwt(trial(i,:), scale, wvname_alpha);

        scale = freq * fc(1,4) ./ [13];
        cwt_coeff(findex+6:findex+6, :) = cwt(trial(i,:), scale, wvname_spindle);

        scale = freq * fc(1,5) ./[17 21 25];
        cwt_coeff(findex+7:findex+9, :) = cwt(trial(i,:), scale, wvname_beta);

        scale = freq * fc(1,6) ./[30 35 38];
        cwt_coeff(findex+10:findex+12, :) = cwt(trial(i,:), scale, wvname_gamma);
    end
else
    for i = 1:nchannel;
        findex = (i-1)*sum(nscale);
        scale = zeros(1,12);
        scale(1:2) = freq * fc(1,1) ./ [2 3];
        cwt_coeff(findex+1:findex+2, :) = cwt(trial(i,:), scale(1:2), wvname_delta, 'plot');
        
        scale(3) = freq * fc(1,2) ./ [6];
        cwt_coeff(findex+3:findex+3, :) = cwt(trial(i,:), scale(3), wvname_theta, 'plot');

        scale(4:5) = freq * fc(1,3) ./[8 10];
        cwt_coeff(findex+4:findex+5, :) = cwt(trial(i,:), scale(4:5), wvname_alpha, 'plot');

        scale(6) = freq * fc(1,4) ./ [13];
        cwt_coeff(findex+6:findex+6, :) = cwt(trial(i,:), scale(6), wvname_spindle, 'plot');

        scale(7:9) = freq * fc(1,5) ./[17 21 25];
        cwt_coeff(findex+7:findex+9, :) = cwt(trial(i,:), scale(7:9), wvname_beta, 'plot');

        scale(10:12) = freq * fc(1,6) ./[30 35 38];
        cwt_coeff(findex+10:findex+12, :) = cwt(trial(i,:), scale(10:12), wvname_gamma, 'plot');
        
        figure
        wscalogram('image', cwt_coeff(findex+1:findex+12,:), 'scales', scale, 'ydata', trial(i,:));
        strcat('../spectral_gram/',cmap{i},'.png')
        saveas(gcf, ['../spectral_gram/' cmap{i} '.png']);
        
        %figure
        %plot([1 size(coefs,2)],[Sca Sca],'Color','m','LineWidth',2);
    end
end

trial = abs(trial');
end
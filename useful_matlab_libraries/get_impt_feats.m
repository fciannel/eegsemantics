function imptFeats = get_impt_feats(out, n) % get n most important features
load([out '/forest.mat']);
[~, indices] = sort(feats,'descend');
imptFeats = indices(1:n);
end
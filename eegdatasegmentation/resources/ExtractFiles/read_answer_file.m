function out = read_answer_file( fname )
% Reads the recorded participant answers.

    out = [];

    f = fopen(fname, 'r');
    n = 0;
    line = fgets(f);
    while ischar(line)
        n = n + 1;
        out = [out str2num(line)];
        line = fgets(f);
    end
end


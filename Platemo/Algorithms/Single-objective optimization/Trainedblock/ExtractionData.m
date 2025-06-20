clear; clc;

num_problems = 28;    
num_files    = 25;     
num_rows     = 2000;   

for p = 1:num_problems
    maxConLen = 0;
    for f = 1:num_files
        fname = sprintf('C06_CEC2017_F%d_M1_D30_%d.mat', p, f);
        if ~isfile(fname), continue; end
        S = load(fname, 'result');
        if ~isfield(S, 'result'), continue; end
        second_col = S.result(:,2);
        for r = 1:num_rows
            entry = second_col{r};
            if ~isempty(entry)
                c = entry(1).con;
                maxConLen = max(maxConLen, numel(c));
                break;
            end
        end
    end

    if maxConLen == 0
        maxConLen = 1;
    end

    colsPerFile = 1 + maxConLen;
    data_mat = NaN(num_rows, num_files * colsPerFile);

    for f = 1:num_files
        fname = sprintf('C06_CEC2017_F%d_M1_D30_%d.mat', p, f);
        col_start = (f-1)*colsPerFile + 1;
        col_obj   = col_start;
        col_con   = col_start + (1:maxConLen);

        if ~isfile(fname)
            continue;
        end
        S = load(fname, 'result');
        if ~isfield(S, 'result')
            continue;
        end

        second_col = S.result(:,2);
        for r = 1:num_rows
            entry = second_col{r};
            if isempty(entry)
                continue;
            end
            sol = entry(1);
            data_mat(r, col_obj) = sol.obj;
            c = sol.con;
            for k = 1:min(numel(c), maxConLen)
                data_mat(r, col_con(k)) = c(k);
            end
        end
    end

    out_name = sprintf('AGEA_F%d_Min_LCV.mat', p);
    save(out_name, 'data_mat');
    fprintf('complete F%d（con_len=%d），Save the result as %s\n', p, maxConLen, out_name);
end

disp('All problems have been resolved!');
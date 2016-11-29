% Copyright (C) 2016 Siu-Kei Muk, Jason Bolito
% All rights reserved.
%
% This software may be modified and distributed under the terms
% of the BSD license.  See the LICENSE file for details.

function [ new_LPN ] = fcorrect( LPN, formats, mismatch_map )
%FCORRECT Format-based correction. Given an LPN, a format database
%and a map containing all ambiguous mapping.
    min_error_threshold = 10;
    [errors, error_indices] = compute_errors(LPN, formats);
    min_error = min(errors);

    % compute format with maximum score
    scores = compute_scores(LPN, formats);
    [max_score, max_score_ix] = max(scores);
    max_mask = scores == max_score;
    new_LPN = LPN;
    
    % roll back if we have format clash
    if sum(max_mask) > 1
        fprintf('Format clashes detected. Rolling back!\n');
        return;
    end
    
    % perform correction only if we have some mismatches
    if (min_error > 0 && min_error < min_error_threshold)
%         fprintf('Most likely plate format: \n');
        likely_formats = formats(max_mask);
        disp(likely_formats);
        % compute indices that need to be corrected
        err_indices = error_indices{max_score_ix};
        for j = 1:numel(err_indices)
            % correct ambiguous chars only
            if isKey(mismatch_map, char(new_LPN(err_indices(j))))
                new_LPN(err_indices(j)) = mismatch_map(LPN(err_indices(j)));
            end
        end
        new_min_error = format_distance(new_LPN, likely_formats{1});
        % if our 'correction' increases the number of mismatches, revert
        % to the old plate.
        if new_min_error > 0
            fprintf('Plate still does not match format. Rolling back!\n');
            new_LPN = LPN;
        else
            fprintf('Corrected "%s" to "%s"\n', LPN, new_LPN);
        end
    end

function [ errors, error_indices ] = compute_errors(LPN, formats)
    num_formats = numel(formats);
    errors = zeros(num_formats, 1);
    error_indices = cell(0, 0);
    for i = 1:num_formats
        [errors(i), error_indices{i}] = format_distance(LPN, formats{i});
    end

function [ scores ] = compute_scores(LPN, formats)
    num_formats = numel(formats);
    scores = zeros(num_formats, 1);
    for i = 1:num_formats
        scores(i) = format_score(LPN, formats{i});
    end

% Copyright (C) 2016 Siu-Kei Muk, Jason Bolito
% All rights reserved.
%
% This software may be modified and distributed under the terms
% of the BSD license.  See the LICENSE file for details.

% We assume the testing images are named with the actual number on the
% plate.

setup_lpr;
directory = 'standard-plates/';
test_images = dir(strcat(directory,'*.jpg'));
failures = fopen('lpr_failures.txt', 'w');
summary = fopen('lpr_summary.txt', 'w');
test_stat = cell(0,3);
test_matches = zeros(1,numel(test_images));
count = 0;
for im_file = test_images'
    count = count + 1;
    [~,expected_str,~] = fileparts(im_file.name);
    im = imread(strcat(directory,im_file.name));
    lpn = deep_lpr(im,lpr_data);
    test_stat{count,1} = expected_str;
    test_stat{count,2} = lpn;
    passed = strcmp(expected_str,lpn);
    if passed
        fprintf('PASSED (%s)\n', expected_str);
    else
    	fprintf('FAILED (expected %s, got %s)\n',expected_str, lpn);
    	fprintf(failures, '%s\n', expected_str);
    end
    test_matches(count) = passed;
end

accuracy = sum(test_matches) / numel(test_images);
fprintf('accuracy: %f\ntotal: %d\n', accuracy, numel(test_images));
fprintf(summary, 'accuracy: %f\ntotal: %d\n', accuracy, numel(test_images));
fclose(failures);
fclose(summary);

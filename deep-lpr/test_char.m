% Copyright (C) 2016 Siu-Kei Muk, Jason Bolito
% All rights reserved.
%
% This software may be modified and distributed under the terms
% of the BSD license.  See the LICENSE file for details.

directory = 'cnn_test_char_db_50/';
dirs = dir(directory);
setup_lpr;

errors = cell(0,1);
correct_count = 0;
error_count = 0;
count = 0;

for i = 1 : numel(dirs)
    label = dirs(i).name;
    if strcmp(label,'.') || strcmp(label,'..')
        continue;
    end
    images = dir(fullfile(directory,label));
    for j = 1 : numel(images)
		im_name = images(j).name;
		if strcmp(im_name,'.') || strcmp(im_name,'..')
        	continue;
		end
        count = count + 1;
        im = imread(fullfile(directory,label,images(j).name));
        C{1} = im;
        chr = cnn_classify(C,lpr_data.net, lpr_data.mismatch_map);
        if strcmp(chr,label)
            correct_count = correct_count + 1;
        else
            error_count = error_count + 1;
			fullfile(label,im_name)
			chr
        end
    end
end

accuracy = correct_count / count

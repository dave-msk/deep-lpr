% Copyright (C) 2016 Siu-Kei Muk, Jason Bolito
% All rights reserved.
%
% This software may be modified and distributed under the terms
% of the BSD license.  See the LICENSE file for details.

function [ LPN ] = cnn_classify( chars, net, mismatch_map )
%CNN_CLASSIFY Recognition module. Takes a cell array of char images
% and attempts to recognise any characters.

% initial bare-bones implementation
char_width = 50;
char_height = 50;
ambiguous_threshold = 0.5;
recognition_threshold = 0.8;

LPN = '';
numchars = numel(chars);
for i = 1:numchars
    char_image = chars{i};
    % pass spaces through
    if numel(char_image) == 0
        chr = ' ';
    else
        % resizes image to espected CNN input size 50x50
        char_image = imresize(im2uint8(char_image), [char_height char_width]);
        % apply CNN
        [chr, post] = classify(net, char_image);
        chr = char(chr);
        % adaptive thresholing. if character is ambiguous use weaker
        % threshold, otherwise use the stronger one.
        if isKey(mismatch_map, chr)
            threshold = ambiguous_threshold;
        else
            threshold = recognition_threshold;
        end

        % reject as noise if not confident enough
	if max(post) < threshold 
		chr = ' ';
	end
    end 
    LPN = [LPN, chr];
end 

end

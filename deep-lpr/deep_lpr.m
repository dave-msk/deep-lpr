% Copyright (C) 2016 Siu-Kei Muk, Jason Bolito
% All rights reserved.
%
% This software may be modified and distributed under the terms
% of the BSD license.  See the LICENSE file for details.

function [ LPN ] = deep_lpr( image, lpr_data )
%DEEP_LPR Main pipeline function

segmentor = @(x) segment(x, true, false, false);
characters = segmentor(image);

%%%%%%
classify = @(x) cnn_classify(x, lpr_data.net, lpr_data.mismatch_map);
LPN = classify(characters);
%%%%%%

correct = @(x) fcorrect(x, lpr_data.formats, lpr_data.mismatch_map);
LPN = correct(LPN);
end

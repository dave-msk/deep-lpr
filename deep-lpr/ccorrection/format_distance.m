% Copyright (C) 2016 Siu-Kei Muk, Jason Bolito
% All rights reserved.
%
% This software may be modified and distributed under the terms
% of the BSD license.  See the LICENSE file for details.

function [ dist, mismatch_indices ] = format_distance( LPN, format )
%FORMAT_DISTANCE Returns the number of mismatches between a LPN and a given
%format
    min_length = min(length(LPN), length(format));
    max_length = max(length(LPN), length(format));
    error = max_length - min_length;
    mismatch_indices = zeros(min_length, 1);
    error_ix = 1;
    for i = 1:min_length
        fmt_error = format_error(LPN(i), format(i));
        if fmt_error > 0
            mismatch_indices(error_ix) = i; 
            error_ix = error_ix + 1;
        end
        error = error + fmt_error;
    end
    mismatch_indices = mismatch_indices(mismatch_indices > 0);
    if numel(mismatch_indices) == 0
        mismatch_indices = [];
    end
    dist = error;

function [ error ] = format_error( char, format_char )
    if format_char == 'n' || format_char == 'a'
        error = to_format(char) ~= format_char;
    else
        error = (char ~= format_char);
    end

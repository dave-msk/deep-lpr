% Copyright (C) 2016 Siu-Kei Muk, Jason Bolito
% All rights reserved.
%
% This software may be modified and distributed under the terms
% of the BSD license.  See the LICENSE file for details.

function [ fmt ] = to_format( char )
    if isnum(char)
        fmt = 'n';
    else if isalpha(char)
            fmt = 'a';
        else
            fmt = char;
        end
    end
end

% Copyright (C) 2016 Siu-Kei Muk, Jason Bolito
% All rights reserved.
%
% This software may be modified and distributed under the terms
% of the BSD license.  See the LICENSE file for details.

function [ eq ] = isalpha( char )
    eq = char >= 'A' && char <= 'Z';
end

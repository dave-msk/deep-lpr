% Copyright (C) 2016 Siu-Kei Muk, Jason Bolito
% All rights reserved.
%
% This software may be modified and distributed under the terms
% of the BSD license.  See the LICENSE file for details.

function [ score ] = format_score( LPN, format )

rc_score = 5;
f_score=1;

score = 0;
if length(LPN) ~= length(format)
    return;
end

n = length(LPN);
for i = 1:n
    char = LPN(i);
    format_char = format(i);
    if isalpha(format_char) || format_char == ' '
        sgn = (-1) ^ (format_char ~= char);
        score_val = rc_score;
    else
        score_val = f_score;
        sgn = (-1) ^ (format_char ~= to_format(char));
    end
    score = score + sgn * score_val;                 
end

end

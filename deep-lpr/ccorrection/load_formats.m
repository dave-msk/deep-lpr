% Copyright (C) 2016 Siu-Kei Muk, Jason Bolito
% All rights reserved.
%
% This software may be modified and distributed under the terms
% of the BSD license.  See the LICENSE file for details.

function [ formats ] = load_formats( file )
%LOAD_FORMATS Loads formats from text file.
fid = fopen(file);
tline = fgetl(fid);
formats = cell(0);
i = 1;
while ischar(tline);
    formats{i} = tline;
    tline = fgetl(fid);
    i = i + 1;
end
fclose(fid);

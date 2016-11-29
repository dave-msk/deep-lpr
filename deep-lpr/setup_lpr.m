% Copyright (C) 2016 Siu-Kei Muk, Jason Bolito
% All rights reserved.
%
% This software may be modified and distributed under the terms
% of the BSD license.  See the LICENSE file for details.

addpath 'ccorrection/';
addpath 'ccorrection/utils';
lpr_data.formats = load_formats('ccorrection/formats.txt');
lpr_data.net = load('matlab_cnn/matlab_cnnV3.mat');
lpr_data.net = lpr_data.net.net;
lpr_data.mismatch_map = containers.Map();
lpr_data.mismatch_map('O') = '0';
lpr_data.mismatch_map('0') = 'O';
lpr_data.mismatch_map('1') = 'I';
lpr_data.mismatch_map('I') = '1';
lpr_data.mismatch_map('2') = 'Z';
lpr_data.mismatch_map('8') = 'B';
lpr_data.mismatch_map('B') = '8';

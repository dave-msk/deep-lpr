% Copyright (C) 2016 Siu-Kei Muk, Jason Bolito
% All rights reserved.
%
% This software may be modified and distributed under the terms
% of the BSD license.  See the LICENSE file for details.

function [ C ] = segment( image, square_ar, show_image, debug)
%SEGMENT Performs character and space segmentation on a given image

    if nargin == 1
        square_ar = false;
        show_image = false;
        debug = false;
    else
        if nargin == 2
            show_image = false;
            debug = false;
        else
            if nargin == 3
                debug = false;
            end
        end
    end
    
    % convert image to grayscale and apply crop
    image_gray = rgb2gray(image);
    crop_perc = 0.05;
    hcrop_perc = 0.2;
    imwidth = size(image_gray, 2);
    imheight = size(image_gray, 1);
    crop_box = [crop_perc/2 * imwidth, hcrop_perc/2 * imheight, ...
        (1 - crop_perc) * imwidth, (1 - hcrop_perc) * imheight];
    image_gray = imcrop(image_gray, crop_box);

    % noise reduction step
    for pass = 1:2
        level = graythresh(image_gray);
        image_bw = im2bw(image_gray, level);

        % determine BG and FG based on white and black pixel counts
        white = sum(image_bw(:));
        black = numel(image_bw) - white;

        % perform image inversion if necessary
        if white > black
            image_bw = ~image_bw;
        end
        if pass == 1
            % reduce noise using variable-sized filters
            bg_mask = image_bw == 0;
            sd = 8 * std(im2double(image_gray(bg_mask)));
            filt_size = 4 * ceil(sd) + 1;
            image_gray = medfilt2(image_gray, [filt_size filt_size]);
            image_gray = imgaussfilt(image_gray, sd);
        end
    end
    image = imresize(image, [700, NaN]);
    imwidth = size(image_gray, 2);
    imheight = size(image_gray, 1);

    % use morphological opening to disconnect blobs with small connections.
    image_bw = imopen(image_bw, strel('disk', ceil(0.018 * imheight)));
    min_height = 0.3 * size(image_bw, 1);
    max_height = 0.9 * size(image_bw, 1);
    min_width = 0.01 * size(image_bw, 2);
    max_width = 0.2 * size(image_bw, 2);

    % get connected components
    [ccs, nccs] = bwlabel(image_bw);
    features = zeros(nccs, 6);
    bboxes = cell(nccs,1);
    for cc = 1 : nccs
        % extract relevant features from CCs.
        bw_cc = (ccs == cc);
        [xm, xM, ym, yM, width, height] = bbox(bw_cc);
        bboxes{cc} = [xm xM ym yM];
        features(cc, :) = [height, width, (ym + yM) / 2, xm, xM, (xm + xM) / 2]; 
    end

    % apply width/height filters
    [cc_indices, ~] = find((features(:, 1) > min_height) &...
        (features(:, 1) < max_height) &...
        (features(:, 2) > min_width) &...
        (features(:, 2) < max_width));

    vcentres = features(cc_indices, 3);

    % filter out all non vertically align chars
    centreline = median(vcentres);
    centreline_error = abs((vcentres - centreline)) / centreline;
    [cc_ix, ~] = find(centreline_error < 0.15);    
    % The rest are deamed to be chars.
    
    if show_image == true && numel(cc_ix) > 0
        subplot(3, numel(cc_ix), [1 numel(cc_ix)]);
        imshow(image);        
        subplot(3, numel(cc_ix), [numel(cc_ix) + 1, 2 * numel(cc_ix)]);
        imshow(image_bw);
    end
    

    % space segmentation
    heights = features(cc_indices(cc_ix), 1);
    max_height = max(heights);

    % allow small chars if big char hasn't been found yet
    small_char_allowed = true;
    char_ix = zeros(size(heights))';
    for i = 1 : numel(heights)
	if (max_height - heights(i)) / max_height >= 0.1
		if small_char_allowed
			char_ix(i) = true;
		end
        else
		small_char_allowed = false;
		char_ix(i) = true;
	end	
    end

    %no chars found
    cc_ix = cc_ix(logical(char_ix));
    if (cc_ix == 0)
        return;
    end

    spaces = diff(features(cc_indices(cc_ix), 6));
    min_space = min(spaces);
    max_space = max(spaces);
    % check space criteria
    if (numel(spaces) > 0 && (max_space - min_space) / max_space >= 0.2 && max_space / imwidth > 0.05)
        [cc_space_indices,~] = find(abs(spaces - max_space) / max_space <= 0.1 | abs(spaces - min_space) / min_space >= 0.4);
    else
        cc_space_indices = [];
    end
    numcells = numel(cc_ix) + numel(cc_space_indices);
    C = cell(numcells, 1);   
    if show_image == true && numel(cc_ix) > 0
        subplot(3, numcells, [1 numcells]);
        imshow(image);        
        subplot(3, numcells, [numcells + 1, 2 * numcells]);
        imshow(image_bw);
    end
    
    % write image to cell array and an empty space in the event of an empty
    % space
    cell_ix = 1;
    space_ix = 1;
    numspaces = numel(cc_space_indices);
    for char_ix = 1 : size(cc_ix)
        bb = bboxes{cc_indices(cc_ix(char_ix))};
        masked = image_bw & (ccs == cc_indices(cc_ix(char_ix)));
        % pad char images if necessary if 
        if square_ar
            C{cell_ix} = pad_image(masked(bb(3) : bb(4), bb(1) : bb(2)));
        else
            C{cell_ix} = masked(bb(3) : bb(4), bb(1) : bb(2));
        end
        if show_image == true
            subplot(3, numcells, 2 * numcells + cell_ix);
            imshow(C{cell_ix});
        end
        if space_ix <= numspaces && cc_space_indices(space_ix) == char_ix
            space_ix = space_ix + 1;
            cell_ix = cell_ix + 1;
            C{cell_ix} = [];
        end
        cell_ix = cell_ix + 1;
    end    
    if debug
	    fprintf('%d spaces detected\n', numspaces);
    end

%-------------------------------------------------------------------------
function [xmin, xmax, ymin, ymax, w, h] = bbox(bw)
    %computes the bounding box of a bw image
    clear w h;
    [ys, xs, ~] = find(bw);
    ymin = min(ys);
    ymax = max(ys);

    xmin = min(xs);
    xmax = max(xs);
    
    w = xmax - xmin + 1;
    h = ymax - ymin + 1;

function BW = pad_image(image_bw)
    [height, width] = size(image_bw);
    if height >= width
        padding = height - width;
        BW = padarray(image_bw, [0 floor(padding / 2)]);
        BW = padarray(BW, [0 mod(padding, 2)], 'post');
    else 
        padding = width - height;
        BW = padarray(image_bw, [floor(padding / 2) 0]);
        BW = padarray(BW, [mod(padding, 2) 0], 'post');
    end

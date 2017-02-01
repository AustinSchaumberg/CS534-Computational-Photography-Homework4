% Austin Schaumberg
% CS 534 | Fall 2016
% HW4-blend.m
function [ im_blended ] = blend( im_input1, im_input2 )
%BLEND Blends two images together via feathering
% Pre-conditions:
%     `im_input1` and `im_input2` are both RGB images of the same size
%     and data type
% Post-conditions:
%     `im_blended` has the same size and data type as the input images
    
    assert(all(size(im_input1) == size(im_input2)));
    assert(size(im_input1, 3) == 3);

    im_blended = zeros(size(im_input1), 'like', im_input1);

    %------------- YOUR CODE STARTS HERE -----------------
    
    % Utilize alpha function to calculate alpha values.
    alpha1 = rgb2alpha(im_input1);
    alpha2 = rgb2alpha(im_input2);

    % multiply each input image's RGB channel by thier 
    % respective alpha values.
    im_input1(:,:,1) = im_input1(:,:,1).* alpha1(:,:);
    im_input1(:,:,2) = im_input1(:,:,2).* alpha1(:,:);
    im_input1(:,:,3) = im_input1(:,:,3).* alpha1(:,:);
    
    im_input2(:,:,1) = im_input2(:,:,1).* alpha2(:,:);
    im_input2(:,:,2) = im_input2(:,:,2).* alpha2(:,:);
    im_input2(:,:,3) = im_input2(:,:,3).* alpha2(:,:);
    
    im_blended(:,:,1) = im_input1(:,:,1) + im_input2(:,:,1);
    im_blended(:,:,2) = im_input1(:,:,2) + im_input2(:,:,2);
    im_blended(:,:,3) = im_input1(:,:,3) + im_input2(:,:,3);
    
    % Calculate and sum together cumulative alpha values for
    % panorama stitching.
    im_blended_alpha = alpha1 + alpha2;
    
    [height,width] = size(im_blended_alpha);

    for i = 1:height
        for j = 1 : width
            if im_blended_alpha(i,j)>0
                im_blended(i,j,1) = im_blended(i,j,1)./im_blended_alpha(i,j);
                im_blended(i,j,2) = im_blended(i,j,2)./im_blended_alpha(i,j);
                im_blended(i,j,3) = im_blended(i,j,3)./im_blended_alpha(i,j);
            end
        end
    end
    
    %------------- YOUR CODE ENDS HERE -----------------

end

function im_alpha = rgb2alpha(im_input, epsilon)
% Returns the alpha channel of an RGB image.
% Pre-conditions:
%     im_input is an RGB image.
% Post-conditions:
%     im_alpha has the same size as im_input. Its intensity is between
%     epsilon and 1, inclusive.

    if nargin < 2
        epsilon = 0.001;
    end
    
    %------------- YOUR CODE STARTS HERE -----------------
    
    binary_Image = rgb2gray(im_input) == 0;
    d = bwdist(binary_Image,'euclidean');
    im_alpha = d/max(d(:));
    
    %------------- YOUR CODE ENDS HERE -----------------

end

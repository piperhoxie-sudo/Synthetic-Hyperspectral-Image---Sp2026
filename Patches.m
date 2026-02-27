function [BlurredIm] = Patches(Sigmas,rows,cols,ClassPixelsMat,OtherPixelsMat)
%PATCHES creates varying sizes of patches in an image using Gaussian
% Blurring
%   
%   usage: [BlurredIm] = Patches(Sigmas,rows,cols,ClassPixelsMat,OtherPixelsMat)
%
%   Sigmas = vector containing three values
%       - first value relates to percentage of patches we would like to be
%       small
%       - second value relates to percentage of patches we would like to be
%       medium
%       - third value relates to percentage of patches we would like to be
%       large
%   rows = desired rows of final image
%   cols = desired columns of final image
%   ClassPixelsMat = matrix containing assigned number of pixels of each 
%   class with their assigned table values
%   OtherPixelsMat = matrix containing rest of pixels with randomly assign
%   table values
%   BlurredIm = 2-D matrix with pixels assigned in patch formation
%
% choosing sigma for imgaussfit:
%   - 1% to 2% of the smallest dimension for small patches
%   - around 5% of the smallest dimension for medium sized patches
%   - around 10%-15% for large, continuous patches
%

% make 2-dimensional matrix with desired dimensions of random noise
NoiseIm = randn(rows, cols);

% apply gaussian filter to create "patches" of values

SmallestDim = min(rows,cols);

% Blur image using imgaussfilt
BlurredIm = Sigmas(1)*imgaussfilt(NoiseIm, SmallestDim*0.01) ...
    + Sigmas(2)*imgaussfilt(NoiseIm, SmallestDim*0.05) ...
    + Sigmas(3)*imgaussfilt(NoiseIm, SmallestDim*0.1);

% select the top values of the blurred image and assign ClassPixelsMat
k = length(ClassPixelsMat);
[top_values, indices] = maxk(BlurredIm(:), k);
BlurredIm(indices) = ClassPixelsMat;

% Assign the rest of the image OtherPixelsMat
allindices = 1:rows*cols;
otherindices = setdiff(allindices, indices);
BlurredIm(otherindices) = OtherPixelsMat;
end
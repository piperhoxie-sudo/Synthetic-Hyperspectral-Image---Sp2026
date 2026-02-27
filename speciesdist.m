function [ClassPixelsMat, OtherPixelsMat] = speciesdist(Classidx,ClassPerc,totalpixels,NumSpecies)
%SPECIESDIST This function allows you to select the percentage of pixels
% that will corespond to a specific species using the indices in the
% MeansTable that corespond to that species
% 
% usage:
%      [ClassPixelsMat, OtherPixelsMat] = speciesdist(Classidx,ClassPerc,totalpixels,NumSpecies)
%
%   Classidx = cell array of matrices - each matrix contains the column
%       indices in MeansTable coresponding to a specific species
%   ClassPerc = cell array of percentages - percentage of pixels that we
%       want to be the paired species from Classidx
%   totalpixels = rows*columns, total # of pixels in final image
%   NumSpecies = total number of species being used in image
%   ClassPixels = cell array of matrices of each species with desired
%   number of pixels and randomly selected species classes
%   OtherPixelsMat = matrix containing number of pixels not specified in
%   species distribution, randomly assigned unspecified species classes
%

% choose number of class pixels to be ClassPerc of total, round to whole # of pixels
ClassNumArray = cellfun(@(perc) round(perc * totalpixels), ClassPerc,...
    'UniformOutput', false); % round to whole # of pixels

% find total number of specified pixels
ClassNumMat = cell2mat(ClassNumArray);
ClassNum = sum(ClassNumMat); 

% find the # of remaining unassigned pixels to randomize
RemainingNum = totalpixels - ClassNum;

% find indices not specified in Classidx
ClassidxMat = cell2mat(Classidx);
OtheridxMat = setdiff(1:NumSpecies, ClassidxMat(:));

% randomly assign columns from selected classes
ClassPixels = cellfun(@(idx, num) idx(randi(length(idx), num, 1)),...
    Classidx, ClassNumArray, 'UniformOutput', false);
ClassPixelsMat = cell2mat(ClassPixels);

% select other columns randomly for rest of pixels
OtherPixelsMat = OtheridxMat(randi(length(OtheridxMat), RemainingNum, 1));

end
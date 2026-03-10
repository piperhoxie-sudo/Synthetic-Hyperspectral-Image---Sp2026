% Script to create a synthetic hyperspectral image and analyze it using
% machine learning to identify potential areas for controlled burns or
% forest fires
% SMART Fires, Piper Hoxie, 1/25/26

%% Read in data

wave_start = 400;
wave_end = 1000;
wave_space = 400;

files = {'alder_black.txt', 'alder_robert.txt','beargrass_cooney.txt'...
    'beargrass_robert.txt','cottbark.txt','cottonwd_black.txt'...
    'cottonwd_robert.txt','dougfir_black.txt','dougfir_cooney.txt'...
    'dougfir1_cooney.txt','fireweed_robert.txt','goldnrod.txt'...
    'grandfir.txt','grass.txt','grnalder_robert.txt','grngrass.txt'...
    'grnshrub.txt','larchgr.txt','lodgegr.txt'};

names = {'AlderBlack', 'AlderRobert','BrgrsCooney','BrgrsRobert'...
    'CottonBark','CottwoodBlack','CottwoodRobert','DougfirBlack'...
    'DougfirCooney','Dougfir1Cooney','FireweedRobert','Goldenrod'...
    'Grandfir','Grass','GreenAlderRobert','GreenGrass','GreenShrub'...
    'GreenLarch','GreenLodge'};

% Load data into a cell array
all_tables = cellfun(@(f) tablereader(f, wave_start, wave_end, wave_space), files, 'UniformOutput', false);

% extract columns from the cell array 'all_tables' and make into matrices
Means = cell2mat(cellfun(@(t) t.mean, all_tables, 'UniformOutput', false));
Stdplus = cell2mat(cellfun(@(t) t.stdplus, all_tables, 'UniformOutput', false));
Stdminus = cell2mat(cellfun(@(t) t.stdminus, all_tables, 'UniformOutput', false));

% Name the columns by converting the matrices to tables for reference
MeansTable = array2table(Means, 'VariableNames', names);
StdplusTable = array2table(Stdplus, 'VariableNames', names);
StdminusTable = array2table(Stdminus, 'VariableNames', names);

%% make HSI

% Background Info/Variables
% assign variables to dimensions of means
[NumWavelengths, NumSpecies] = size(Means); % Should be wave_space x total classes
% final image will be rows x columns x wave_space
rows = 100;
cols = 100;
totalpixels = rows*cols;

%% Select Species Distributions

% select columns in table that correspond to each class that distribution
% is specified for and make into cell array
DougFiridx = [8, 9, 10]; 
Cottwoodidx = [6, 7];
Brgrsidx = [3, 4];
Classidx = {DougFiridx, Cottwoodidx, Brgrsidx};

% select desired percent distributions for each index and create cell array
DougFirPerc = 0.30;
CottwoodPerc = 0.10;
BrgrsPerc = 0.10;
ClassPerc = {DougFirPerc, CottwoodPerc, BrgrsPerc};

% call speciesdist function to select percentages and classes of each
% species
[ClassPixelsMat, OtherPixelsMat] = speciesdist(Classidx,ClassPerc,totalpixels,NumSpecies);

%% Make species patches

GaussianBlur = 1;
PixelOverlay = 0;

% ------------------Option 1: Gaussian blurring--------------------------

if GaussianBlur == 1
% choosing sigma:
%   - 1% to 2% of the smallest dimension for small patches
%   - around 5% of the smallest dimension for medium sized patches
%   - around 10%-15% for large, continuous patches

% choose a mixed amount of each type for more randomized sizes of patches

% amount of each size of patch from smallest to largest (ratios)
Sigmas = [0.1 0.2 0.3];

[BlurredIm] = Patches(Sigmas,rows,cols,ClassPixelsMat,OtherPixelsMat);

% verify patches were made
figure();
imagesc(BlurredIm); 
colorbar;
title('Species Distribution Map');
axis image; % make image square

% --------------Option 2: Selected Pixel Overlay--------------------------

elseif PixelOverlay == 1



% verify patches were made
figure();
imagesc(BlurredIm); 
colorbar;
title('Species Distribution Map');
axis image; % make image square

% --------------Option 3: Default (Gaussian)------------------------------

else

Sigmas = [0.1 0.2 0.3];
[BlurredIm] = Patches(Sigmas,rows,cols,ClassPixelsMat,OtherPixelsMat);

% verify patches were made
figure();
imagesc(BlurredIm); 
colorbar;
title('Species Distribution Map');
axis image; % make image square

end

% flatten BlurredIm so it's easier to extract data
pixelindices = BlurredIm(:);

%% Add per pixel noise

% Gaussian noise to account for biological diversity

[GaussHSIData] = GaussNoise(Means, Stdplus, Stdminus, pixelindices);

% Poisson noise to account for sensor noise

%% Reshape into final image

% reshape into cube - 400x10000 right now, so first 
% reshape 10000 -> 100x100
tempCube = reshape(GaussHSIData, [wave_space, rows, cols]);

% Permute to get the standard HSI format: [Rows x Cols x Bands]
HSI = permute(tempCube, [2, 3, 1]);

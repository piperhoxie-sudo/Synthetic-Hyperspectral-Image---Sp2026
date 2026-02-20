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

% assign variables to dimensions of means
[NumWavelengths, NumSpecies] = size(Means); % Should be wave_space x total classes
% final image will be rows x columns x wave_space
rows = 100;
cols = 100;
totalpixels = rows*cols;

% select columns in table that correspond to each class that distribution
% is specified for and make into cell array
DougFiridx = [8, 9, 10]; 
Cottwoodidx = [6, 7];
Classidx = {DougFiridx, Cottwoodidx};

% select desired percent distributions for each index and create cell array
DougFirPerc = 0.30;
CottwoodPerc = 0.20;
ClassPerc = {DougFirPerc, CottwoodPerc};

% call speciesdist function to select percentages of each
[HSIPixels] = speciesdist(Classidx,ClassPerc,totalpixels,NumSpecies);

% Extract the 400 wavelengths for each pixel
HSIData = Means(:, HSIPixels); % 400 x 10000

% reshape into cube - 400x10000 right now, so first 
% reshape 10000 -> 100x100
tempCube = reshape(HSIData, [wave_space, rows, cols]);

% 4. Permute to get the standard HSI format: [Rows x Cols x Bands]
HSICube = permute(tempCube, [2, 3, 1]);

% We have a hyperspectral image! (I think)







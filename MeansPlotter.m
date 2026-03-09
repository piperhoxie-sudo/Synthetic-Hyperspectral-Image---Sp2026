% Script to plot the means and plus and minus standard deviations of
% several different species 

%% Read in data

wave_start = 400;
wave_end = 1000;
wave_space = 400;

files = {'alder_black.txt', 'beargrass_cooney.txt', 'dougfir1_cooney',...
    'ash_black.txt', 'barkchar.txt', 'charsoil_black.txt',...
    'charwood_black.txt', 'baresoil.txt','deadcott.txt', 'innrbark.txt',...
    'needbrow.txt', 'rockycal.txt'};

names = {'AlderBlack', 'BrgrsCooney','Dougfir1Cooney', 'AshBlack',...
    'CharBark', 'CharSoilBlack', 'CharWoodBlack', 'BareSoil','DeadCott',...
    'InnerBark', 'NeedBrown', 'RockyCal'};

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

%% Make plots

for i = 1:width(Means)
    figure(i);
    plot(Means(:,i));
    hold on; plot(Stdplus(:,i));
    hold on; plot(Stdminus(:,i)); hold off;
    legend('Mean', 'Std+', 'Std-');
    title(names{i});
end
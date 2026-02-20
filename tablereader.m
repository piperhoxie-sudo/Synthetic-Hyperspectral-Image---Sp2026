function [data] = tablereader(filename, wave_start, wave_end, wave_space)
% TABLEREADER Function to read in actual values of wavelength, mean, and
% standard deviations from a text file, redefine the wavelengths with caps
% and spacing desired, and interpolate new values of the means and standard 
% deviations at new wavelengths
%
%   usage: [data] = tablereader(filename, wave_start, wave_end, wave_space);
%
%   filename = name of file from frames.gov
%   wave_start = desired starting value of wavelengths
%   wave_end = desired ending value of wavelengths
%   wave_space = desired number of wavelengths, how many evenly spaced
%   sections between wave_start and wave_end
%   data = final table with interpolated values of mean, positive standard
%          deviation, and negative standard deviation at new wavelength
%          values
%   

%----------------------Read in wavelengths------------------------------

% Import text file as a table
data = readtable(filename, 'Delimiter', '\t', 'VariableNamingRule','preserve');

% Get all column names from the table
vars = data.Properties.VariableNames;
    
% Find indices for each column - deal with irregular column names
idxW = find(strcmpi(vars, 'Wavelength'), 1);
idxM = find(strcmpi(vars, 'Mean'), 1);
% 'Std+' is sometimes also name 'std+' or 'std +', so check for lowercase
% or std +
idxP = find(contains(vars, 'Std+', 'IgnoreCase', true) | contains(vars, 'std +'), 1);
idxS = find(contains(vars, 'Std-', 'IgnoreCase', true) | contains(vars, 'std -'), 1);
    
% Extract the data using the indices found above
wavelength1 = data{:, idxW};
mean1 = data{:, idxM};
stdplus1 = data{:, idxP};
stdminus1 = data{:, idxS};

% Choose wavelengths 400nm-1000nm, 400 evenly spaced sections - our specs
wavelength = linspace(wave_start,wave_end,wave_space);

% Interpolate values at the new wavelength points 
mean = interp1(wavelength1, mean1, wavelength);
stdplus = interp1(wavelength1, stdplus1, wavelength);
stdminus = interp1(wavelength1, stdminus1, wavelength);

% Make into column vectors
wavelength = wavelength(:);
mean = mean(:);
stdplus = stdplus(:);
stdminus = stdminus(:);

% Combine into new table
data = table(wavelength, mean, stdplus, stdminus);

end
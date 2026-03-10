function [GaussHSIData] = GaussNoise(Means, Stdplus, Stdminus, pixelindices)
%GAUSSNOISE function to apply gaussian noise per pixel per wavelength of 
% an image layout
%   
%   usage: [GaussHSIData] = GaussNoise(Means, Stdplus, Stdminus, pixelindices);
%
%   Means = matrix of the mean reflectance of 400 wavelengths of each
%       species
%   Stdplus = matrix of the positive standard deviation of reflectance 
%       of 400 wavelengths of each species
%   Stdminus = matrix of the negative standard deviation of reflectance 
%       of 400 wavelengths of each species
%   pixelindices = vector of assigned column/species in means that each
%       pixel will correspond to in the final image
%   NoisyHSIData = matrix with pixels with Gaussian noise applied to each
%       wavelength in each pixel
%

% extract all of the wavelength data for every pixel
M = Means(:,pixelindices);
Sp = Stdplus(:,pixelindices);
Sm = Stdminus(:,pixelindices);

% select random numbers for each element of M from a gaussian with most
% area from -1 to 1
num = 0.4*randn(size(M));

% max(num, 0) keeps all elements that are positive, the rest are 0, and
% vice versa - make a mask 
x = max(num, 0);
y = abs(min(num, 0));

GaussHSIData = M + x.*Sp + y.*Sm;

end
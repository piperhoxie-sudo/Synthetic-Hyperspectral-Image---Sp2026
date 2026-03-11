function [HSIData] = PoissNoise(GaussHSIData)
%POISSNOISE function to add poission noise to model sensor noise to a pixel
%
%   this models photon noise, which is noise caused by the numbers of
%   photons hitting a unit of area on the sensor. We have to multiply by a
%   gain so that the reflectance is now represented by a number of photons
%   that we can then make a poisson distribution with. 
%   
%   usage: [HSIData] = PoissNoise(GaussHSIData)
%
%   GaussHSIData = matrix with pixels with Gaussian noise applied to each
%       wavelength in each pixel
%   HSIData = matrix with pixels with Gaussian and Poissonn noise applied
%       to each wavelength in each pixel

% multiply the Gaussian data by a gain so that poissrnd doesn't just return
% ones
Gain = 2000; 
LambdaMatrix = GaussHSIData * Gain;

% Using the new matrix, select a value from a poisson distribution
% for each element of the final matrix. 
NoisyData = poissrnd(LambdaMatrix);

% Divide the gain back out
HSIData = NoisyData / Gain;

end
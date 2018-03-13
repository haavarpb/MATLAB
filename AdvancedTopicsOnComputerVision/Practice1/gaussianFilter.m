function filter = gaussianFilter(sigmaX, sigmaY, dimX, dimY, angle)
% by Håvard P. Brandal and Giulia Angarano. This function returns a 2D
% gaussian filter with customizable std deviation, rotation and spatial
% dimension. Filter is centered in the middle of the kernel, and will NOT
% wrap.

filterX = zeros(1,dimX); filterY = zeros(dimY,1); % Individual axis filters
muX = dimX/2; muY = dimY/2; % Center of filter

% Instantiate the filter
for px = 1:dimX
    filterX(px) = myGaussian(px, muX, sigmaX);
end
for px = 1:dimY
    filterY(px) = myGaussian(px, muY, sigmaY);
end

filter = filterY*filterX; % The complete 2D filter

if (angle ~= 0) || (sigmaY == sigmaX)
    filter = imrotate(filter, angle);
end
end

function fx = myGaussian(x, mu, sigma)
exponent = (-(x-mu)^2)/(2*sigma^2);
fx = (1/(sigma*sqrt(2*pi)))*exp(exponent);
end
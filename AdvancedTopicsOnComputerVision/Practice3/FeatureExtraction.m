%% Examine and extract features from the datasets
clear all
close all
load dataSet

% Do fourier power spectrum of all the images

fieldCell = fields(dataSet);
for field = 1:length(fieldCell)
    for element = 1:length(dataSet.(fieldCell{field}))
        i = dataSet.(fieldCell{field})(element).image;
        dataSet.(fieldCell{field})(element).powerSpectrum = log(fftshift(abs(fft2(i)).^2) + 1);
    end
end

%% Radial and directional power

bricks = addFeatures(dataSet.bricks);
concrete = addFeatures(dataSet.concrete);
bricksValidation = addFeatures(dataSet.bricksValidation);
concreteValidation = addFeatures(dataSet.concreteValidation);

% Plot directional 

figure
for elem = 1:length(bricks)
    [Sr, Sd] = radialDirectionalPower(bricks(elem).powerSpectrum);
    subplot(length(bricks),2,2*elem - 1)
    plot(Sd)
    subplot(length(bricks),2,2*elem)
    imshow(bricks(elem).image)
end

figure
for elem = 1:length(concrete)
    [Sr, Sd] = radialDirectionalPower(concrete(elem).powerSpectrum);
    subplot(length(concrete),2,2*elem - 1)
    plot(Sd)
    subplot(length(concrete),2,2*elem)
    imshow(concrete(elem).image)
end

dataSet.bricks = bricks;
dataSet.concrete = concrete;
dataSet.bricksValidation = bricksValidation;
dataSet.concreteValidation = concreteValidation;

figure
for elem = 1:length(bricksValidation)
    [Sr, Sd] = radialDirectionalPower(bricksValidation(elem).powerSpectrum);
    subplot(length(bricksValidation),2,2*elem - 1)
    plot(Sd)
    subplot(length(bricksValidation),2,2*elem)
    imshow(bricksValidation(elem).image)
end

figure
for elem = 1:length(concreteValidation)
    [Sr, Sd] = radialDirectionalPower(concreteValidation(elem).powerSpectrum);
    subplot(length(concreteValidation),2,2*elem - 1)
    plot(Sd)
    subplot(length(concreteValidation),2,2*elem)
    imshow(concreteValidation(elem).image)
end

save dataSetWithFeatures dataSet
function [S] = addFeatures(S)
    % This function takes in a structure of grayscale images, and adds to
    % it the following features:
    %
    % - Radial profile of power spectrum 
    % - Directional profile of power spectrum
    for element = 1:length(S)
        [Sr Sd] = radialDirectionalPower(S(element).powerSpectrum);
        S(element).Sr = Sr;
        S(element).Sd = Sd;
    end
end
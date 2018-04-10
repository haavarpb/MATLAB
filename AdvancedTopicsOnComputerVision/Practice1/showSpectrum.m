function [] = showSpectrum(F, t)
figure;
imshow(log(abs(F) + 1), []);
title(t);
end
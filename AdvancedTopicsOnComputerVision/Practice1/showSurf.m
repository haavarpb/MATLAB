function [] = showSurf(H, t)
figure; 
surf(H);
shading interp
title(t);
end
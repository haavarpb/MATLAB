function [Sr, Sd] = radialDirectionalPower(F)
    % This function takes in an fourier power spectrum and returns its
    % radial and directional profile
y0 = round(size(F,1)./2);
x0 = round(size(F,2)./2);
R = [1 min([x0, size(F,2) - x0, y0, size(F,1) - y0]) - 1];
T = [1 360];

Sr = zeros(1, R(2));
for r = R(1):R(2)
    for t = T(1):T(2)
        Sr(r) = Sr(r) + F(round(y0 + r*sind(t)), round(x0 + r*cosd(t)));
    end
end

Sd = zeros(1, T(2));
for t = T(1):T(2)
    for r = R(1):R(2)
        Sd(t) = Sd(t) + F(round(y0 + r*sind(t)), round(x0 + r*cosd(t)));
    end
end
end
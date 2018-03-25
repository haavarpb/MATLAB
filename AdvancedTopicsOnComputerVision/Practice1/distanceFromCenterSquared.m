function D_sq = distanceFromCenterSquared(M,N)
sz = max([M N]);
y_sq = repmat(diag(1:sz)*(1:sz)', 1, sz);
x_sq = y_sq';

d_sq = x_sq + y_sq;

lower_left = fliplr(d_sq);
upper_left = flipud(lower_left);
upper_right = fliplr(upper_left);
lower_right = d_sq;

d_non_cropped = [upper_left, upper_right;
                lower_left, lower_right];
sz2 = size(d_non_cropped);
d_sq_mid = d_non_cropped((round(sz2(1)/2) - round(M/2)):(round(sz2(1)/2) + round(M/2)), ...
                        (round(sz2(2)/2) - round(N/2)):(round(sz2(2)/2) + round(N/2)));
D_sq = d_sq_mid(1:M, 1:N);
end


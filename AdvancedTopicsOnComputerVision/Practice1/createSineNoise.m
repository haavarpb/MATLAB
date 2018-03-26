function n = createSineNoise(M, N, A, w, d)
n = repmat(A*sin(w.*(1:M))' + d, 1, N);
end
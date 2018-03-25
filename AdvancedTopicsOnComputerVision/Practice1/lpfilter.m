function H = lpfilter(type, M, N, D0, varargin)
D_sq = distanceFromCenterSquared(M,N);
if strcmp(type,'ideal')
    D_sq(sqrt(D_sq) <= D0) = 1;
    D_sq(sqrt(D_sq) > D0) = 0;
elseif strcmp(type,'btw')
    if isempty(varargin)
        n = 1.0;
    else
        n = varargin{1};
    end
    D_sq = 1./(1 + (sqrt(D_sq)./D0).^2*n);
elseif strcmp(type,'gauss')
    assert(D0 > 0, 'Error: D0 must be positive');
    D_sq = exp(-D_sq/(2*D0^2));
end
    H = circshift(D_sq, [-floor(M/2) -floor(N/2)]);
end
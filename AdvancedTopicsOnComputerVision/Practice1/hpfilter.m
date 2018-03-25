function H = hpfilter(type, M, N, D0, varargin)
H = 1 - lpfilter(type, M, N, D0, varargin{:});
end


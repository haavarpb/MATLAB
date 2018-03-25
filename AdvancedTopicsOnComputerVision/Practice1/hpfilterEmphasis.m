function H = hpfilterEmphasis(type, M, N, D0, a, b, varargin)
H = a + b.*hpfilter(type, M, N, D0, varargin{:});
end


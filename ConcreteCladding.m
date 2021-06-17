function S = ConcreteCladding(x)
    S = (3e-6)*power(x, 3) - 0.0001*power(x, 2) + (0.0033)*x;
end

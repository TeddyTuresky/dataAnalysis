function t = comparecorrs(a,b,c,n)

t = (a-b) * sqrt(((n - 3) * (1 + c)) / ...
    (2 * (1 - a^2 - c^2 - b^2 + 2 * a * c * b)));





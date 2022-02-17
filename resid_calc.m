function z = resid_calc(x,y)

if isvector(x) == 1;
    foo = fit(x,y,'poly1');
else
    foo = fit(x,y,'poly11');
end

z = y - foo(x);

end
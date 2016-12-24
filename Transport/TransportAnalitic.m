%
%f is a vector of linear syms functions (a_i + b_i * x_i, x_i = vars(i))
%vars is vector of syms variables from f
%F is restriction for sum of vars
%
function res = TransportAnalitic(f, vars, F)
a = [];
b = [];
for i = 1:length(vars)
    a = [a ( f(i) - diff( f(i) )*vars(i) ) ];
    b = [b double( diff( f(i) ) )];
end
res = zeros(1, length(vars));

for i = 1:length(vars)
    res(i) = ( (F + sum(a ./ b)) / (sum(1./b)) ) / b(i) - a(i)/b(i);;
end
res = double(res);
end
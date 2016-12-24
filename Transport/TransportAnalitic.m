%
%f is a vector of linear syms functions (a_i + b_i * x_i, x_i = vars(i))
%vars is vector of syms variables from f
%F is restriction for sum of vars
%
function res = TransportAnalitic(f, vars, F)
a = zeros(1, length(vars));
b = zeros(1, length(vars));
for i = 1:length(vars)
    a(i) = double(f(i) - diff(f(i)))
    b(i) = diff( f(i) ) ;
end
% res = zeros(1, length(vars));
% 
% for i = 1:length(vars)
%     res(i) = ( (F + sum(a ./ b)) / (sum(1./b)) ) / b(i) - a(i)/b(i);;
% end

k = 1;
temp_a = [];
temp_b = [];
for i=1:length(a)-1
    temp_a = a(1:i);
    temp_b = b(1:i);
    w = double(( (F + sum(temp_a ./ temp_b)) / (sum(1./temp_b)) ) / temp_b(i) - temp_a(i)/temp_b(i));
    if double(a(i+1)) < w
        k = i+1;
    end
end
new_a = a(1:k);
new_b= b(1:k);

w = ( (F + sum(new_a ./ new_b)) / (sum(1./new_b)) ) / new_b(i) - new_a(i)/new_b(i);



res = zeros(1,length(a));
for i=1:k
    res(i) = 1/b(i) *w - new_a(i)/new_b(i);
end
for i=k+1:length(a)
    res(i) = 0;
end
end
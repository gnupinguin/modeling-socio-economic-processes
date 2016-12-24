clear all
clc

syms ('x1', 'x2', 'x3')
f1 = 10 + 3 * x1;
f2 = 15 + 2 * x2;
f3 = 3 + x3;
%f = 10*x1 + 15*x2 + 3 * 0.5*x1^2 + x2^2;

f = int(f1) + int(f2) + int(f3);
vars = [x1 x2 x3];
func = [f1 f2 f3];
Aeq = [1 1 1];
beq = 3;
eps = 0.001;

FrankWolf(f, vars, [], [], Aeq, beq,[1 1 1], eps);



a=[];
for i = 1:length(vars)
    t = coeffs(func(i));
    a = [a t(1) ];
end

for i = 1:(length(a)-1)
    for j = 1 : (length(a)-i)
        if a(j+1) < a(j)
            tmp1 = a(j);
            tmp2 = func(j);
            tmp3 = vars(j);
            a(j) = a(j+1);
            a(j+1) = tmp1;
            func(j) = func(j+1);
            func(j+1) = tmp2;
            vars(j) = vars(j+1);
            vars(j+1) = tmp3;
        end
    end
end

disp('Analitic method: ')
disp(vars)
disp(TransportAnalitic(func, vars, beq))


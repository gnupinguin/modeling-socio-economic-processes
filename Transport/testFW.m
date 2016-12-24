clear all
clc

syms ('x1', 'x2', 'x3')
f1 = 10 + 3 * x1;
f2 = 15 + 2 * x2;
f3 = 3 + x3;
%f = 10*x1 + 15*x2 + 3 * 0.5*x1^2 + x2^2;

f = int(f1) + int(f2) + int(f3);
vars = [x1 x2 x3];
Aeq = [1 1 1];
beq = 3;
eps = 0.001;

FrankWolf(f, vars, [], [], Aeq, beq,[1 1 1], eps);

disp('Analitic method: ')
TransportAnalitic([f1 f2 f3], vars, beq)


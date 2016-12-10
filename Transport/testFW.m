clear all
close all
clc

syms ('x1', 'x2')
% f =  2 * x1 + 4 * x2 - x1 ^2 - 2 * x2 ^2;
f = 10*x1 + 15*x2 + 3 * 0.5*x1^2 + x2^2;

A = [1 2;2 -1];
b = [8 12]
A = A;
b = b;
Aeq = [1 1];
beq = 12;
eps = 0.001;
FrankWoolf(f, [x1 x2], [], [], Aeq, beq,[0 12], eps)
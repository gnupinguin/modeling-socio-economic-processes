clear all
close all
clc

syms ('x1', 'x2')
f =  2 * x1 + 4 * x2 - x1 ^2 - 2 * x2 ^2;
A = [1 2;2 -1];
b = [8 12]
A = A;
b = b;
eps = 0.1;
FrankWoolf(f, [x1 x2], A, b, [], [],[10 0], eps)
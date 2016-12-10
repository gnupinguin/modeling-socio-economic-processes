%
%
%method Frank-Woolf
%
%Ax<=b
%Aeq * x = beq
%
function res = FrankWoolf(f, vars, A, b, Aeq, beq, start_x, eps)
syms l;
grad = gradient(f, vars);
lb = zeros(length(vars),1);%left bound for vars: 0<=Xi
x = start_x;
while true
    point_grad = double(subs(grad, vars, x))'
    [z, fval] = linprog(-point_grad, A, b, Aeq, beq, lb, []);
    z = z';
    
    %find step of the calculation
    new_x = x + l*(z - x);
    f_l  = subs(f, vars, new_x);
    df_l = diff(f_l, l);
    lambda = min( solve(df_l == 0, l) );
    
    if lambda > 1 || lambda < 0
        lambda = rand();
    end
    
    new_x = x + lambda*(z - x);
    
    if norm(new_x -x) <= eps
        x = new_x;
        break;
    end
    x = new_x;
end
res = double(x);
end

solution = zeros(length(a), 1);
eps = 0.001;
new_a = [];
new_b = [];
for i = 1:length(a)
   if x_k(i) > eps
       new_a(end + 1) = a(i);
       new_b(end + 1) = b(i);
   end
end
w = (F + sum(new_a./new_b))/sum(1./new_b);
for i = 1:length(a)
   if x_k(i) > eps
       solution(i) = 1/b(i) * w - a(i)/b(i);
   else
       solution(i) = 0;
   end
end
disp(solution);

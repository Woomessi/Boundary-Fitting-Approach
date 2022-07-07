function q = doubleBeta(x,y,beta_1,beta_2,q_max,a,b) 
% 双β分布函数
if (x./a).^2 + (y./b).^2 - 1 < 0
    q = q_max .* (ones - x.^2 ./ a.^2).^(beta_1 - 1) .* (ones - y.^2 ./ (b.^2 .* (ones - x.^2 ./ a.^2))).^(beta_2 - 1);
else
    q = 0;
end
end

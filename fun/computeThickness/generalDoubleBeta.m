function q = generalDoubleBeta(DB,h,l,cos_gamma,cos_theta)
%曲面投影函数
if cos_gamma >= 0
q = DB.*(h./norm(l)).^2.*(cos_gamma./cos_theta.^3);
else
    q = 0;
end
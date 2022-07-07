function [f,sum_thickness,z_ref_now] = obj_offsetZmax_slicing_convex(x)
%%%%%%%%%%%%%%%%%%%%% 输入 %%%%%%%%%%%%%%%%%%%%%%%%%%%

% 输入喷涂参数
beta_1 = 2;
beta_2 = 2;
q_max = 0.135;
a = 150;
b = 30;
h = 100;

%%%%%%%%%%%%%%%%%%%% 预处理 %%%%%%%%%%%%%%%%%%%%%%%%%%
[point,facet,~,z_max,~,~,size_point] = preprocess_inverse('turbine_blade.STL',1);

%%%%% 输入喷涂间距 %%%%%%
offset = x(1);

%%% 输入喷涂速度 %%%
v_current = x(2);

%%% 输入喷涂高度 %%%
h1 = x(3);

z_ref_now = z_max-offset;

[~, thickness] = singlePassLocalSlicing(z_ref_now, v_current, point, facet, size_point, a, h1, h, beta_1, beta_2, q_max, b);
sum_thickness = thickness;
thickness_desired = 0.05;
f = sqrt(sum((sum_thickness - thickness_desired).^2)/size_point)/thickness_desired;
end
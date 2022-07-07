function [f,sum_thickness,z_ref_now] = obj_offsetZmax_slicing(x)
beta_1 = 2;
beta_2 = 2;
q_max = 0.2;
a = 150;
b = 30;
h = 100;

[point,facet,~,z_max,~,~,size_point] = preprocess('turbine_blade.STL',1);

offset = x(1);

v_current = x(2);

h1 = x(3);

z_ref_now = z_max-offset;

[~, thickness] = singlePassLocalSlicing(z_ref_now, v_current, point, facet, size_point, a, h1, h, beta_1, beta_2, q_max, b);
sum_thickness = thickness;
thickness_desired = 0.05;
f = sqrt(sum((sum_thickness - thickness_desired).^2)/size_point)/thickness_desired;
end
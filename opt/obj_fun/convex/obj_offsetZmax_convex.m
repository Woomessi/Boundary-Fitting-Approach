function [f,sum_thickness,z_ref_now] = obj_offsetZmax_convex(x)
beta_1 = 2;
beta_2 = 2;
q_max = 0.135;
a = 150;
b = 30;
h = 100;

[point,facet,~,z_max,z_min,~,size_point] = preprocess_inverse('turbine_blade.STL',1);

V = x(2);

H1 = [x(3),x(4),x(5),x(6),x(7),x(8)];
h1 = mean(H1);

order = 4;
size_obj = 6;
size_point_path = 100;

[boundary_upper, boundary_lower] = detectBoundary(facet, point);

offset = x(1);
z_ref_now = z_max+offset;
[~, thickness] = singlePassLocal(z_ref_now, V, point, boundary_upper, boundary_lower, facet, size_obj, H1, order, size_point_path, size_point, a, h1, h, beta_1, beta_2, q_max, b, z_max, z_min);
sum_thickness = thickness;
thickness_desired = 0.05;
f = sqrt(sum((sum_thickness - thickness_desired).^2)/size_point)/thickness_desired;
end
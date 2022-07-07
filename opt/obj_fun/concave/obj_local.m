function [f,sum_thickness,z_ref_now] = obj_local(x,sum_thickness,z_ref_now)
beta_1 = 2;
beta_2 = 2;
q_max = 0.2;
a = 150;
b = 30;
h = 100;

[point,facet,~,z_max,z_min,~,size_point] = preprocess('turbine_blade.STL',1);

V = x(2);

H1 = [x(3),x(4),x(5),x(6),x(7),x(8),x(9)];
h1 = mean(H1);

order = 4;
size_obj = 7;
size_point_path = 100;

[boundary_upper, boundary_lower] = detectBoundary(facet, point);

offset = x(1);
z_ref_next = z_ref_now - offset;
if z_ref_next <= z_min
    [~, thickness] = singlePassLocal(z_ref_next, V, point, boundary_upper, boundary_lower, facet, size_obj, H1, order, size_point_path, size_point, a, h1, h, beta_1, beta_2, q_max, b, z_max, z_min);
    sum_thickness = sum_thickness+thickness;
    thickness_desired = 0.05;
    f = sqrt(sum((sum_thickness - thickness_desired).^2)/size_point)/thickness_desired;
else
    point_optimized = zeros(1,size_point);
    j = 1;
    for i = 1:size_point
        if point(i,3)>=z_ref_next && point(i,3)<=z_ref_now
            point_optimized(j) = point(i,7);
            j = j+1;
        end
    end
    point_optimized(point_optimized == 0) = [];
    size_point_optimized = size(point_optimized,2);

    [~, thickness] = singlePassLocal(z_ref_next, V, point, boundary_upper, boundary_lower, facet, size_obj, H1, order, size_point_path, size_point, a, h1, h, beta_1, beta_2, q_max, b, z_max, z_min);
    sum_thickness = sum_thickness+thickness;

    thickness_desired = 0.05;
    f1 = sqrt(sum((sum_thickness(point_optimized) - thickness_desired).^2)/size_point_optimized)/thickness_desired;
    f = f1;
end
z_ref_now = z_ref_next;
end
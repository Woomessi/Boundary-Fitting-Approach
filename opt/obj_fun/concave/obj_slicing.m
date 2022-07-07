function [f,sum_thickness,z_ref_now,I] = obj_slicing(x,sum_thickness,z_ref_now)
beta_1 = 2;
beta_2 = 2;
q_max = 0.2;
a = 150;
b = 30;
h = 100;

[point,facet,~,~,z_min,~,size_point] = preprocess('turbine_blade.STL',1);

offset = x(1);
offset1 = x(4);
v_current = x(2);

h1 = x(3);

z_ref_next = z_ref_now - offset;
if z_ref_next > z_min
    I = 0;
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

    [~, thickness] = singlePassLocalSlicing(z_ref_next, v_current, point, facet, size_point, a, h1, h, beta_1, beta_2, q_max, b);
    sum_thickness = sum_thickness+thickness;

    thickness_desired = 0.05;
    f1 = sqrt(sum((sum_thickness(point_optimized) - thickness_desired).^2)/size_point_optimized)/thickness_desired;
    f = f1;
    z_ref_now = z_ref_next;
else
    I = 1;
    z_ref_next = z_min + offset1;

    [~, thickness] = singlePassLocalSlicing(z_ref_next, v_current, point, facet, size_point, a, h1, h, beta_1, beta_2, q_max, b);
    sum_thickness = sum_thickness+thickness;

    thickness_desired = 0.05;
    f1 = sqrt(sum((sum_thickness - thickness_desired).^2)/size_point)/thickness_desired;
    f = f1;
    z_ref_now = z_ref_next;
end
end
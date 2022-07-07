function [point_selected, point_optimized] = selectPointOptimized(size_point, point, z_ref, i, a, h1, h)
k1 = 1;
point_selected = zeros(1,size_point);
k2 = 1;
point_optimized = zeros(1,size_point);
for k = 1:size_point
    if point(k,3)<=z_ref(i)+1.5*a*h1/h && point(k,3)>=z_ref(i)-1.5*a*h1/h
        point_selected(1,k1) = point(k,7);
        k1 = k1+1;
    end
    if point(k,3)>=z_ref(i) && point(k,3)<=z_ref(i-1)
        point_optimized(1,k2) = point(k,7);
        k2 = k2+1;
    end
end
point_selected(point_selected == 0) = [];
point_optimized(point_optimized == 0) = [];
end
%SELECTPOINT Select the surface vertices that could be painted in this step
%
function point_selected = selectPoint(size_point, point, z_ref_current, a, h1, h)
    k1 = 1;
    point_selected = zeros(1,size_point);
    for k = 1:size_point
        if point(k,3)<=z_ref_current+1.5*a*h1/h && point(k,3)>=z_ref_current-1.5*a*h1/h
            point_selected(1,k1) = point(k,7);
            k1 = k1+1;
        end
    end
    point_selected(point_selected == 0) = [];
end
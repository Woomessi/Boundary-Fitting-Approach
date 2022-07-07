%GETINTERSECTIONLOCAL Get intersection points of the slice plane
%
%   POINT_SLICED is the information of the intersection points
%   SIZE_POINT_SLICED is the number of the intersection points
function [point_sliced, size_point_sliced] = getIntersectionLocal(point, boundary_upper, boundary_lower, facet, z_ref_current, z_max, z_min)
    if z_ref_current >= z_max
        point_sliced = point(boundary_upper,1:6);
        size_point_sliced = size(point_sliced,1);
    else
        if z_ref_current <= z_min
            point_sliced = point(boundary_lower,1:6);
            size_point_sliced = size(point_sliced,1);
        else
            [point_sliced,size_point_sliced,~,~] = slice(point,facet,z_ref_current);
        end
    end
end
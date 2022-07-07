%SINGLEPASSLOCAL Generate a certain path pass and calculate the resulting
%                coating thickness according to the Z coordinate of a slice
%                plane
%
%   T_POINT_PATH is the transformation matrixs of generated path points
%   THICKNESS is the coating thickness resulting from the path pass
%   Z_REF_CURRENT is the z coordinate of the current slice plane
%   V_CURRENT is the velocity of the spray gun along the current path pass
%
function [T_point_path, thickness] = singlePassLocal(z_ref_current, v_current, point, boundary_upper, boundary_lower, facet, size_obj, H1, order, size_point_path, size_point, a, h1, h, beta_1, beta_2, q_max, b, z_max, z_min)
[point_sliced, size_point_sliced] = getIntersectionLocal(point, boundary_upper, boundary_lower, facet, z_ref_current, z_max, z_min);
point_obj = getSamplePoints(size_obj, point_sliced, size_point_sliced, H1);
point_path = fitCurveLocal(point,point_sliced,point_obj,boundary_upper,boundary_lower,z_ref_current,size_point_sliced,order,size_obj,size_point_path);
T_point_path = interpolateOrientation(size_point_path, point_path);
distance = computeDistanceLocal(size_point_path, T_point_path);
point_selected = selectPoint(size_point, point, z_ref_current, a, h1, h);
thickness = computeThicknessLocal(T_point_path, distance, point, point_selected, size_point, h, beta_1, beta_2, q_max, a, b, v_current);
end
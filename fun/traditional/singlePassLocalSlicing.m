%SINGLEPASSLOCALSLICING Generate a certain path pass and calculate the resulting
%                       coating thickness according to the Z coordinate of 
%                       a slice plane
%
%   T_POINT_PATH is the transformation matrixs of generated path points
%   THICKNESS is the coating thickness resulting from the path pass
%   Z_REF_CURRENT is the z coordinate of the current slice plane
%   V_CURRENT is the velocity of the spray gun along the current path pass
%
function [T_point_path, thickness] = singlePassLocalSlicing(z_ref_current, v_current, point, facet, size_point, a, h1, h, beta_1, beta_2, q_max, b)

[point_sliced,size_point_sliced,~,~] = slice(point,facet,z_ref_current);
point_offset = offsetPoint(size_point_sliced, h1, point_sliced);
point_offset = sortrows(point_offset);
T_point_path = interpolateOrientation(size_point_sliced, point_offset);
distance = computeDistanceLocal(size_point_sliced, T_point_path);
point_selected = selectPoint(size_point, point, z_ref_current, a, h1, h);
thickness = computeThicknessLocal(T_point_path, distance, point, point_selected, size_point, h, beta_1, beta_2, q_max, a, b, v_current);
end
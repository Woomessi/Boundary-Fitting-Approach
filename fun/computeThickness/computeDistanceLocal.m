%COMPUTEDISTANCELOCAL Compute the distance of each path segment
%
function distance = computeDistanceLocal(size_point_path, T_point_path)
    distance = zeros(1,size_point_path-1);
    for j = 1:size_point_path-1
        distance(1,j) = norm(T_point_path{1,j+1}(1:3,4) - T_point_path{1,j}(1:3,4));
    end
end
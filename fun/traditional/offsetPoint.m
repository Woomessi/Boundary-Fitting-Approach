%OFFSETPOINT Offset each intersection point along the corresponding normal
%            vector
%
function point = offsetPoint(size_point, h1, point)
for j = 1:size_point
    point_offset = [eye(3) h1.*point(j,4:6)'; 0 0 0 1]*[point(j,1:3),1]';
    point(j,1:3) = point_offset(1:3)';
    point(j,4:6) = -point(j,4:6);
end
end
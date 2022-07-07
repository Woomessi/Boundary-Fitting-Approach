%INTERPOLATEORIENTATION Get the orientation of each path point
%
%   T_POINT_PATH is the transformation matrix of each path point
%
function T_point_path = interpolateOrientation(size_point_path, point_path)
T_point_path = cell(1,size_point_path);
    for j = 1:size_point_path-1
        v1 = point_path(j+1,1:3) - point_path(j,1:3);
        theta = getAngle(point_path(j,4:6),v1);
        theta = theta - pi/2;
        axis_rotate = cross(point_path(j,4:6),v1);
        vec_Z = angvec2r(theta,axis_rotate)*point_path(j,4:6)';
        vec_Z = vec_Z';
        vec_Z = vec_Z./norm(vec_Z);
        vec_X = -axis_rotate./norm(axis_rotate) ;
        vec_Y = v1./norm(v1);
        vec_P = point_path(j,1:3);
        T = [vec_X',vec_Y',vec_Z',vec_P'; 0 0 0 1];
        T_point_path(j) = mat2cell(T,4,4);
    end
        j = size_point_path;
        theta = getAngle(point_path(j,4:6),v1);
        theta = theta - pi/2;
        axis_rotate = cross(point_path(j,4:6),v1);
        vec_Z = angvec2r(theta,axis_rotate)*point_path(j,4:6)';
        vec_Z = vec_Z';
        vec_Z = vec_Z./norm(vec_Z);
        vec_X = -axis_rotate./norm(axis_rotate) ;
        vec_Y = v1./norm(v1);
        vec_P = point_path(j,1:3);
        T = [vec_X',vec_Y',vec_Z',vec_P'; 0 0 0 1];
        T_point_path(j) = mat2cell(T,4,4);
end
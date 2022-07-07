%FITCURVELOCAL Construct the polynomial curve to fit the sample points and
%              get the coordinates of the path points
%
%   POINT_PATH is the information of the path points
%
function point_path = fitCurveLocal(point,point_sliced,point_obj,boundary_upper,boundary_lower,z_ref_current,size_point_sliced,order,size_obj,size_point_path)
[co_y, co_z] = fitCoefficient(point_obj, order, point, boundary_upper, z_ref_current, boundary_lower);
t = point_obj(:,1);
t = sort(t);
t(1) = t(1)-(t(2)-t(1))/5;
t(size_obj) = t(size_obj)+(t(size_obj)-t(size_obj-1))/5;

size_point_curve = size_point_path*10;
interval = (t(size_obj)-t(1))/(size_point_curve-1);
t = t(1):interval:t(size_obj);

length = computeLength(size_point_curve, t, co_y, co_z);

[point_uni, normal_point_uni] = generateUniformPoint(length, size_point_path, t, co_y, co_z, point_sliced, size_point_sliced, size_point_curve);

point_path = [point_uni,normal_point_uni];
end

%FITCOEFFICIENT Get the coefficients of the polynomials
%
%   CO_Y The coefficients of the y-t polynomial
%   CO_Z The coefficients of the z-t polynomial
%
function [co_y, co_z] = fitCoefficient(point_obj, order, point, boundary_upper, z_ref_current, boundary_lower)
co_y = polyfit(point_obj(:,1),point_obj(:,2),order); 
co_z1 = polyfit(point(boundary_upper,1),point(boundary_upper,3)-(mean(point(boundary_upper,3))-z_ref_current),order);% 上边界z(t)关系拟合
co_z2 = polyfit(point(boundary_lower,1),point(boundary_lower,3)+z_ref_current-mean(point(boundary_lower,3)),order);% 下边界z(t)关系拟合
co_z = (mean(point(boundary_upper,3))-z_ref_current)*co_z2./(mean(point(boundary_upper,3))-mean(point(boundary_lower,3)))+(z_ref_current-mean(point(boundary_lower,3)))*co_z1./(mean(point(boundary_upper,3))-mean(point(boundary_lower,3)));
end

%COMPUTELENGTH Compute the length of the polynomial curve
%
function length = computeLength(size_point_curve, t, co_y, co_z)
length = 0;
for i_a = 1:size_point_curve-1
    p2 = [t(i_a+1),polyval(co_y,t(i_a+1)),polyval(co_z,t(i_a+1))];
    p1 = [t(i_a),polyval(co_y,t(i_a)),polyval(co_z,t(i_a))];
    vector = p2 - p1;
    length = length + norm(vector);
end
end

%GENERATEUNIFORMPOINT Generate path points along the polynomial curve at a
%                     uniform length interval
%   POINT_UNI is the coordinates of path points
%   NORMAL_POINT_UNI is the normals of path points
%
function [point_uni, normal_point_uni] = generateUniformPoint(length, size_point_path, t, co_y, co_z, point_sliced, size_point_sliced, size_point_curve)
length1 = 0;
interval1 = length/(size_point_path-1);
interval2 = interval1;
point_uni = zeros(size_point_path,3);
normal_point_uni = zeros(size_point_path,3);

point_uni(1,:) = [t(1),polyval(co_y,t(1)),polyval(co_z,t(1))];
vector = point_sliced(:,1:3)-point_uni(1,1:3);
distance = zeros(size_point_sliced,1);
for k = 1:size_point_sliced
    distance(k) = norm(vector(k,:));
end
[~,index_near] = min(distance);
normal_point_uni(1,:) = -point_sliced(index_near,4:6);

point_uni(size_point_path,:) = [t(size_point_curve),polyval(co_y,t(size_point_curve)),polyval(co_z,t(size_point_curve))];
vector = point_sliced(:,1:3)-point_uni(size_point_path,1:3);
distance = zeros(size_point_sliced,1);
for k = 1:size_point_sliced
    distance(k) = norm(vector(k,:));
end
[~,index_near] = min(distance);
normal_point_uni(size_point_path,:) = -point_sliced(index_near,4:6);

j = 2;
for i_b = 1:size_point_curve-1
    p2 = [t(i_b+1),polyval(co_y,t(i_b+1)),polyval(co_z,t(i_b+1))];
    p1 = [t(i_b),polyval(co_y,t(i_b)),polyval(co_z,t(i_b))];
    vector1 = p2 - p1;
    length1 = length1 + norm(vector1);
    if length1 > interval2
        [~,index] = min([interval2-length1+norm(vector1),length1-interval2]);
        if index == 1
            point_uni(j,:) = p1;
        else
            point_uni(j,:) = p2;
        end
        interval2 = interval2 + interval1;
        vector = point_sliced(:,1:3)-point_uni(j,1:3);
        distance = zeros(size_point_sliced,1);
        for k = 1:size_point_sliced
            distance(k) = norm(vector(k,:));
        end
        [~,index_near] = min(distance);
        normal_point_uni(j,:) = -point_sliced(index_near,4:6);
        j = j+1;
    end
end
end
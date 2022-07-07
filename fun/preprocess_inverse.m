%PREPROCESS_INVERSE   Preprocess the STL model and convert the concave surface
%                     into a convex surface with opposite normal vectors.
%
%   POINT is a matrix stores each vertex's coordinates, normal vectors and
%   index.
%
%   FACET is a matrix stores the indexs of each facet's vertices.
%   NORMAL is a matrix stores each facet's normal vector.
%   Z_MAX is the maximum Z coordinate of the model.
%   Z_MIN is the minimum Z coordinate of the model.
%   SIZE_FACET is the number of the facets.
%   SIZE_POINT is the number of the vertices.
%   FILENAME is the name of the STL model.
%   I is the indicator of whether the model should be rotated along the Y axis with
%   -90 degree.
%
function [point,facet,normal,z_max,z_min,size_facet,size_point] = preprocess_inverse(filename,I)

[point, facet, normal] = stlRead(filename);
normal = -normal;
size_point = size(point,1);
size_facet = size(facet,1);

area_facet = computeArea(point, facet, size_facet);
[normal, point] = rot2XZ(normal, area_facet, point);
[point, normal] = rot90(I, point, normal);
point = translate2Base(point, size_point);
point = getVertexNormal(point, size_point, facet, normal, area_facet);

z_max = max(point(:,3));
z_min = min(point(:,3));
end

%COMPUTEAREA Compute the area of each facet.
%
%   AREA_FACET is the area of each facet.
%
function area_facet = computeArea(point, facet, size_facet)
a = [point(facet(:,2),1)-point(facet(:,1),1),point(facet(:,2),2)-point(facet(:,1),2),point(facet(:,2),3)-point(facet(:,1),3)];
b = [point(facet(:,3),1)-point(facet(:,1),1),point(facet(:,3),2)-point(facet(:,1),2),point(facet(:,3),3)-point(facet(:,1),3)];
c = cross(a',b');
area_facet = zeros(size_facet,1);
for i = 1:size_facet
    area_facet(i) = 0.5.*norm(c(:,i));
end
end

%ROT2XZ Rotate the model to fit the XZ plane.
%
function [normal, point] = rot2XZ(normal, area_facet, point)
n_avg = sum(normal.*area_facet)./sum(area_facet);
n_avg = n_avg./norm(n_avg);
theta = acos(dot(n_avg,[0,-1,0]));
axis = cross(n_avg,[0,-1,0]);
point = (angvec2r(theta,axis)*point')';
normal = (angvec2r(theta,axis)*normal')';
end

%ROT90 Rotate the model along Y axis with -90 degree when I equals 1.
%
function [point, normal] = rot90(I, point, normal)
if I == 1
    point = (roty(-pi/2)*point')';
    normal = (roty(-pi/2)*normal')';
end
end

%TRANSLATE2BASE Translate the model to the origin area.
%
function point = translate2Base(point, size_point)
[~,index_max] = max(point(:,1));
pris = -point(index_max,:);
point = point + ones(size_point,3).*pris;
point = point + ones(size_point,3).*[800,0,0];
end

%GETVERTEXNORMAL Calculate the normal vector of each vertex.
%
function point = getVertexNormal(point, size_point, facet, normal, area_facet)
point = [point,zeros(size_point,4)];
for i = 1:size_point
    [facet_i,~,~] = find(facet == i);
    size_facet_i = size(facet_i,1);
    normal_i = normal(facet_i,:);
    s = area_facet(facet_i);
    n_sum = zeros(1,3);
    for j = 1:size_facet_i
        n_sum = n_sum + normal_i(j,:).*s(j);
    end
    n_avg = n_sum./sum(s);
    n_avg = n_avg./norm(n_avg);
    point(i,:) = [point(i,1:3),n_avg,i];
end
end
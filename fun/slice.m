%SLICE Slice the plane to get the intersection point 
%
function [point_sliced,size_point_sliced,point_neighboring,size_point_neighboring] = slice(point,facet,z_ref)
point1 = point(facet(:,1),1:3);
point2 = point(facet(:,2),1:3);
point3 = point(facet(:,3),1:3);

Z_REF = ones(size(point1,1),1)*z_ref;
t1 = (Z_REF-point1(:,3))./(point1(:,3)-point2(:,3));
t2 = (Z_REF-point2(:,3))./(point2(:,3)-point3(:,3));
t3 = (Z_REF-point3(:,3))./(point3(:,3)-point1(:,3));

normal1 = (point(facet(:,1),4:6)+point(facet(:,2),4:6))./2;
length_normal1 = sqrt(normal1(:,1).^2+normal1(:,2).^2+normal1(:,3).^2);
normal1 = normal1./length_normal1;

normal2 = (point(facet(:,2),4:6)+point(facet(:,3),4:6))./2;
length_normal2 = sqrt(normal2(:,1).^2+normal2(:,2).^2+normal2(:,3).^2);
normal2 = normal2./length_normal2;

normal3 = (point(facet(:,3),4:6)+point(facet(:,1),4:6))./2;
length_normal3 = sqrt(normal3(:,1).^2+normal3(:,2).^2+normal3(:,3).^2);
normal3 = normal3./length_normal3;

intersection_point1 = [point1+(point1-point2).*t1,normal1];
intersection_point2 = [point2+(point2-point3).*t2,normal2];
intersection_point3 = [point3+(point3-point1).*t3,normal3];
i1 = intersection_point1(:,3)<max(point1(:,3),point2(:,3))&intersection_point1(:,3)>min(point1(:,3),point2(:,3));
i2 = intersection_point2(:,3)<max(point2(:,3),point3(:,3))&intersection_point2(:,3)>min(point2(:,3),point3(:,3));
i3 = intersection_point3(:,3)<max(point3(:,3),point1(:,3))&intersection_point3(:,3)>min(point3(:,3),point1(:,3));
imain = i1+i2+i3 == 2;
point_neighboring = [[intersection_point1(i1&i2&imain,:),intersection_point2(i1&i2&imain,:)];[intersection_point2(i2&i3&imain,:),intersection_point3(i2&i3&imain,:)];[intersection_point3(i3&i1&imain,:),intersection_point1(i3&i1&imain,:)]];
point_sliced = [point_neighboring(:,1:6);point_neighboring(:,7:12)];
point_sliced = sortrows(point_sliced);
tol = 1e-10;
point_sliced = uniquetol(point_sliced,tol,'ByRows',true);
size_point_sliced = size(point_sliced,1);
size_point_neighboring = size(point_neighboring,1);
end
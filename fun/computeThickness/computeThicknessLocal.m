%COMPUTETHICKNESSLOCAL Calculate the coating thickness resulting from the 
%                      current path pass
%   THICKNESS The resulting coating thickness of each vertex
function thickness = computeThicknessLocal(T_point_path, distance, point, point_selected, size_point, h, beta_1, beta_2, q_max, a, b, v_current)
thickness = zeros(size_point,1);
size_point_selected = size(point_selected,2);
coordinate_point_selected = point(point_selected,:);
for j = 2:size(T_point_path,2)
    p = [T_point_path{1,j}(1:3,4);T_point_path{1,j}(1:3,3)]';
    for k = 1:size_point_selected
        t = coordinate_point_selected(k,:);
        l = t(1:3)-p(1:3);
        cos_gamma = sum(l.*-t(4:6))/(norm(l)*norm(t(4:6)));
        cos_theta = sum(l.*p(4:6))/(norm(l)*norm(p(4:6)));
        ref = p(1:3) + h*p(4:6)/norm(p(4:6));
        s0 = [(p(6)*l(1)*(ref(3)-p(3)) + p(5)*l(1)*(ref(2)-p(2)) + p(1)*(p(5)*l(2)+p(6)*l(3)) + p(4)*ref(1)*l(1))/(p(4)*l(1)+p(5)*l(2)+p(6)*l(3)),(p(6)*l(2)*(ref(3)-p(3)) + p(4)*l(2)*(ref(1)-p(1)) + p(2)*(p(4)*l(1)+p(6)*l(3)) + p(5)*ref(2)*l(2))/(p(4)*l(1)+p(5)*l(2)+p(6)*l(3)),(p(5)*l(3)*(ref(2)-p(2)) + p(4)*l(3)*(ref(1)-p(1)) + p(3)*(p(4)*l(1)+p(5)*l(2)) + p(6)*ref(3)*l(3))/(p(4)*l(1)+p(5)*l(2)+p(6)*l(3))];
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        basis_Path_Z = T_point_path{1,j}(1:3,3);
        basis_Path_Y = T_point_path{1,j}(1:3,2);
        basis_Path_X = T_point_path{1,j}(1:3,1);
        ori_Path = T_point_path{1,j}(1:3,4);
        ori_Ref_Path = [0;0;h];
        Trans = inv([basis_Path_X,basis_Path_Y,basis_Path_Z,[basis_Path_X,basis_Path_Y,basis_Path_Z]*ori_Ref_Path+ori_Path;0,0,0,1]);
        s0 = Trans*[s0,1]';
        %%%%%%%%%%%%%%%%%
        if cos_theta < 0 || cos_gamma < 0
            q_1 = 0;
        else
            q_0 = doubleBeta(s0(1),s0(2),beta_1,beta_2,q_max,a,b) ;
            q_1 = distance(1,j-1)*generalDoubleBeta(q_0,h,l,cos_gamma,cos_theta)/v_current;
            thickness(t(7)) = thickness(t(7)) + q_1;
        end
    end
end
end
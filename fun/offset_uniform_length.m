function point_obj = offset_uniform_length(size_obj, point_sliced, size_point_sliced, H1)
point_key = extractObjectivePoint(size_obj, point_sliced, size_point_sliced);
point_obj = offsetObjectivePoint(size_obj, H1, point_key);
end

function point_key = extractObjectivePoint(size_obj, point_sliced, size_point_sliced)
length = 0;
for i_a = 1:size_point_sliced-1
    vector = point_sliced(i_a+1,1:3) - point_sliced(i_a,1:3);
    length = length + norm(vector);
end

%%% 初始化 %%%
length1 = 0;
interval1 = length/(size_obj-1);
point_key = zeros(size_obj,6);% 初始化均分点

%%% 生成第一个均分点 %%%
point_key(1,:) = point_sliced(1,:);

%%% 生成最后一个均分点 %%%
point_key(size_obj,:) = point_sliced(size_point_sliced,:);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%% 生成其余的均分点 %%%
j = 2;
for i_b = 1:size_point_sliced-1
    p2 = point_sliced(i_b+1,:);
    p1 = point_sliced(i_b,:);
    vector1 = p2(1:3) - p1(1:3);
    length1 = length1 + norm(vector1);
    if length1 > interval1
        [~,index] = min([interval1-length1+norm(vector1),length1-interval1]);
        if index == 1
            point_key(j,:) = p1;
        else
            point_key(j,:) = p2;
        end
        length1 = 0;
        j = j+1;
    end
end

end

function point_obj = offsetObjectivePoint(size_obj, H1, point_key)
point_obj = zeros(size_obj,6);
for j = 1:size_obj
    point_offset = [eye(3) H1(j).*point_key(j,4:6)'; 0 0 0 1]*[point_key(j,1:3),1]';
    point_obj(j,1:3) = point_offset(1:3)';
    point_obj(j,4:6) = -point_key(j,4:6);
end
end
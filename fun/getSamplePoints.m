%GETSAMPLEPOINTS Extract the sample points
%
%   POINT_SAMPLE is the information of the sample points
function point_sample = getSamplePoints(size_point_sample, point_sliced, size_point_sliced, H1)
point_key = extractObjectivePoint(size_point_sample, point_sliced, size_point_sliced);
point_sample = offsetObjectivePoint(size_point_sample, H1, point_key);
end

%EXTRACTOBJECTIVEPOINT Extract the key points
%
%   POINT_KEY is the information of the key points
function point_key = extractObjectivePoint(size_point_sample, point_sliced, size_point_sliced)
point_key = zeros(size_point_sample,6);
for i = 1:size_point_sample
    point_ref = point_sliced(1,1)+(i-1)*(point_sliced(size_point_sliced,1)-point_sliced(1,1))/(size_point_sample-1);
    distance = abs(point_sliced(:,1)-point_ref*ones(size_point_sliced,1));
    [~,index] = min(distance);
    point_key(i,:) = point_sliced(index,:);
end
end

%OFFSETOBJECTIVEPOINT
%
%   POINT_SAMPLE is the information of the sample points
function point_sample = offsetObjectivePoint(size_point_sample, H1, point_key)
point_sample = zeros(size_point_sample,6);
for j = 1:size_point_sample
    point_offset = [eye(3) H1(j).*point_key(j,4:6)'; 0 0 0 1]*[point_key(j,1:3),1]';
    point_sample(j,1:3) = point_offset(1:3)';
    point_sample(j,4:6) = -point_key(j,4:6);
end
end
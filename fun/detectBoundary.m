%DETECTBOUNDARY Detect the upper and lower boundary points of the model
%
%   BOUNDARY_UPPER is the upper boundary points
%   BOUNDARY_LOWER is the lower boundary points
function [boundary_upper,boundary_lower] = detectBoundary(facet,point)
[edge, ic] = getEdge(facet);
[boundary_point, size_boundary_point, G] = extractBoundary(ic, edge);
boundary_segment_point = extractSegmentPoint(size_boundary_point, G, boundary_point, point);
boundary_segment = extractBoundarySegment(boundary_segment_point, G, size_boundary_point);
[boundary_upper, boundary_lower] = extractUpperLowerBoundary(point, boundary_segment);
end

%GETEDGE Construct edges of the STL model
%
function [edge, ic] = getEdge(facet)
edge = [facet(:,[1,2]);facet(:,[1,3]);facet(:,[2,3])];
edge = sort(edge,2);
[edge,~,ic] = unique(edge,'rows');
end

%EXTRACTBOUNDARY Extract the whole boundary points of the model
%
%   BOUNDARY_POINT is the information of the whole boundary points
%   SIZE_BOUNDARY_POINT is the number of the boundary poins
%   G is the graph of the neighboring boundary points
function [boundary_point, size_boundary_point, G] = extractBoundary(ic, edge)
counts = accumarray(ic,1);% returns number of repeats of each edge
edgeBdy = counts == 1;
boundary_line = edge(edgeBdy,:);
boundary_point = [boundary_line(:,1);boundary_line(:,2)];
boundary_point = unique(boundary_point);
size_boundary_point = size(boundary_point,1);
G = graph(boundary_line(:,1),boundary_line(:,2));
end

%EXTRACTSEGMENTPOINT Extract the four segment boundary points of the model
%
%   BOUNDARY_SEGMENT_POINT is the information of the four segment boundary
%   points
%
function boundary_segment_point = extractSegmentPoint(size_boundary_point, G, boundary_point, point)
boundary_segment_point = zeros(4,1);
j = 1;
for i = 1:size_boundary_point
    neighboring_boundary_point = neighbors(G,boundary_point(i));
    angle = getAngle(point(boundary_point(i),1:3)-point(neighboring_boundary_point(1),1:3),point(neighboring_boundary_point(2),1:3)-point(boundary_point(i),1:3));% 当前边界点与邻接点组成的向量之间的夹角
    if angle >=1 
        boundary_segment_point(j) = boundary_point(i);
        j = j+1;
    end
end
end

%EXTRACTBOUNDARYSEGMENT Divide the boundary loop into four indepent
%segments
%
%   BOUNDARY_SEGMENT is the information of boundary points in each segment
%
function boundary_segment = extractBoundarySegment(boundary_segment_point, G, size_boundary_point)
boundary_segment = cell(4,1);
i = 1;
j = 1;
k = 0;
current_boundary_point = boundary_segment_point(1);
neighboring_boundary_point = neighbors(G,current_boundary_point);
boundary_segment{i,1}(j) = current_boundary_point;
j = j+1;
k = k+1;
current_boundary_point = neighboring_boundary_point(1);
boundary_segment{i,1}(j) = current_boundary_point;
j = j+1;
k = k+1;
%%% 边界点分段 %%%%
while true
    neighboring_boundary_point = neighbors(G,current_boundary_point);
    if ismember(current_boundary_point,boundary_segment_point)
        if size(boundary_segment{i,1},2)==1
            neighboring_boundary_point = neighboring_boundary_point(~ismember(neighboring_boundary_point,boundary_segment{i-1,1}));
            current_boundary_point = neighboring_boundary_point;
            boundary_segment{i,1}(j) = current_boundary_point;
            j = j+1;
            k = k+1;
            if k == size_boundary_point+4
                break
            end
        else
            i = i+1;
            j = 1;
            boundary_segment{i,1}(j) = current_boundary_point;
            j = j+1;
            k = k+1;
            if k == size_boundary_point+4
                break
            end
        end
    else
        neighboring_boundary_point = neighboring_boundary_point(~ismember(neighboring_boundary_point,boundary_segment{i,1}));% 否则： 排除位于当前边界段的邻接点
        current_boundary_point = neighboring_boundary_point;
        boundary_segment{i,1}(j) = current_boundary_point;
        j = j+1;
        k = k+1;
        if k == size_boundary_point+4
            break
        end
    end
end
end

%EXTRACTUPPERLOWERBOUNDARY Extract the upper and lower boundary from
%boundary segments
%
function [boundary_upper, boundary_lower] = extractUpperLowerBoundary(point, boundary_segment)
z_avg = [mean(point(boundary_segment{1,1},3)),mean(point(boundary_segment{2,1},3)),mean(point(boundary_segment{3,1},3)),mean(point(boundary_segment{4,1},3))];
[~,indexUpper] = max(z_avg);
[~,indexLower] = min(z_avg);
boundary_upper = boundary_segment{indexUpper,1};
boundary_lower = boundary_segment{indexLower,1};
end

%   This program targets at inputting the optimal variables and returning 
%   the optimal uniformity indicator using boundary fitting approach. 
%   The figure shows the coating thickness distribution.

% rmpath(genpath('C:\projects\DISSERTATION\REF'))
% rmpath(genpath('C:\projects\DISSERTATION\revised'))
addpath(genpath('C:\projects\codes'))
clear
clc

%%%%%%%%%%%%%%%%%%%%% Inputting %%%%%%%%%%%%%%%%%%%%%%%%%%%
% Input parameters of the ellipse dual-β distribution model
beta_1 = 2;
beta_2 = 2;

% the maximum instant thickness for the concave surface. 
%
% for the concave surface
q_max = 0.2;
%
% for the convex surface
% q_max = 0.135;

a = 150; % semi-major axis
b = 30; % semi-minor axis
h = 100; % spray distance between the spray gun and the standard plane

%%%%%%%%%%%%%%%%%%%% Preprocessing %%%%%%%%%%%%%%%%%%%%%%%%%
% for the concave surface
%
[point,facet,~,z_max,z_min,~,size_point] = preprocess('turbine_blade.STL',1);
%
% for the convex surface
%
% [point,facet,~,z_max,z_min,~,size_point] = preprocess_inverse('turbine_blade.STL',1);

%%%%%%%%%%%%%%%%%%% Initialization %%%%%%%%%%%%%%%%%%%%%%%%%
rank = 4; % the rank of the polynomial curve
size_obj = 6; % the number of the sample points
size_point_path = 100; % the number of path points on a pass


% import the optimal variables
%
% for the concave surface
%
Sol = importdata("C:\projects\codes\opt\sol\concave\boundary_fitting\Sol.mat");
%
% for the convex surface
%
% Sol = importdata("C:\projects\codes\opt\sol\convex\boundary_fitting\Sol.mat");

% initialize the number of paths
size_path = size(Sol,1); 
% initialize the cell array stores all of the passes' transformation matrixs
T_point_path_all = cell(size_path,size_point_path);
% initialize the sum of paint thickness
sum_thickness = 0; 

%%%%%%%%%%%%%% Detect the boundary points %%%%%%%%%%%%%%%%%%
[boundary_upper, boundary_lower] = detectBoundary(facet, point);

%%%%%%%%%%%%%%%%%%%%%% Main loop %%%%%%%%%%%%%%%%%%%%%%%%%%%%
for i = 1:size_path
    solution = Sol(i,:);
    offset = solution(1); % the offset distance between adjacent passes
    
    % calculate the Z coordinate of the current slice plane
    if i == 1
        % for the initial pass, it's translated upward form the highest vertex
        z_slice_plane_current = z_max + offset; 
    else
        z_slice_plane_current = z_slice_plane_current - offset;
    end
    V = solution(2); % the velocity of the spray gun along the current pass

    % the spray distance of each sample point
    H1 = [solution(3),solution(4),solution(5),solution(6),solution(7),solution(8)];
    % the average spray distance
    h1 = mean(H1); 

    % Calculate the transformation matrix and the coating thickness 
    % resulting from a certain pass 
    [T_point_path, thickness] = singlePassLocal(z_slice_plane_current, V, point, boundary_upper, boundary_lower, facet, size_obj, H1, rank, size_point_path, size_point, a, h1, h, beta_1, beta_2, q_max, b, z_max, z_min);

    sum_thickness = sum_thickness + thickness;
    T_point_path_all(i,:) =  T_point_path;
end

%%%%%% Objective function %%%%%%%
thickness_desired = 0.05;
f = sqrt(sum((sum_thickness - thickness_desired).^2)/size_point)/thickness_desired;

%%%%%%%%%%%%%% Draw the figure of the thickness distribution %%%%%%%%%%%%%%
% drawFigure(facet, point, T_point_path_all, sum_thickness, h1/h, size_path, size_point_path)
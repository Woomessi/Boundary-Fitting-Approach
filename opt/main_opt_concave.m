% rmpath(genpath('C:\projects\DISSERTATION\REF'))
addpath(genpath('C:\projects\codes'))
clear
clc
[point,facet,~,z_max,z_min,~,size_point] = preprocess('turbine_blade.STL',1);

size_var0 = 9;
size_var = 9;
initialSpan = 1000;

lb0 = [0,100,50,50,50,50,50,50,50];
ub0 = [100,200,150,150,150,150,150,150,150];

lb = [100,100,50,50,50,50,50,50,50];
ub = [200,200,150,150,150,150,150,150,150];

options2 = optimoptions("particleswarm","SwarmSize",20,"InitialSwarmSpan",initialSpan,"Display","iter",'UseParallel',true,'MaxIterations',100);

[solution1,objectiveValue] = particleswarm(@obj_offsetZmax,size_var0,lb0,ub0,options2);
Sol = solution1;
[f,sum_thickness,z_ref_now] = obj_offsetZmax(solution1);

while z_ref_now > z_min
    [solution,objectiveValue] = particleswarm(@(x)obj_local(x,sum_thickness,z_ref_now),size_var,lb,ub,options2);
    Sol = [Sol;solution];
    [f,sum_thickness,z_ref_now] = obj_local(solution,sum_thickness,z_ref_now);
end

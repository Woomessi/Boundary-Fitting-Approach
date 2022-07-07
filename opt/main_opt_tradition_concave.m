% rmpath(genpath('C:\projects\DISSERTATION\REF'))
addpath(genpath('C:\projects\codes'))
clear
clc
[point,facet,~,z_max,z_min,~,size_point] = preprocess('turbine_blade.STL',1);

size_var0 = 3;
size_var = 4;
initialSpan = 1000;

lb0 = [1e-10,100,50];
ub0 = [100,200,150];

lb = [100,100,50,1e-10];
ub = [200,200,150,100];

options2 = optimoptions("particleswarm","SwarmSize",20,"InitialSwarmSpan",initialSpan,"Display","iter",'UseParallel',true,'MaxIterations',100);

[solution1,objectiveValue] = particleswarm(@obj_offsetZmax_slicing,size_var0,lb0,ub0,options2);
Sol = [solution1,0];
[f,sum_thickness,z_ref_now] = obj_offsetZmax_slicing(solution1);
I = 0;
while I == 0
    [solution,objectiveValue] = particleswarm(@(x)obj_slicing(x,sum_thickness,z_ref_now),size_var,lb,ub,options2);
    Sol = [Sol;solution];
    [f,sum_thickness,z_ref_now,I] = obj_slicing(solution,sum_thickness,z_ref_now);
end

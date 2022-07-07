%DRAWFIGURE Draw the figure of the coating thickness distribution
%
function drawFigure(facet, point, T_point_path_all, thickness, I, size_path, size_point_path)
patch('Faces',facet,'Vertices',point(:,1:3),'FaceVertexCData',thickness,'FaceColor','interp','LineStyle','none');
colormap hot
caxis([0.04,0.06])
c = colorbar;
c.Label.String = 'Thickness (mm)';
c.Location = 'southoutside';
axis([0,850,-200,200,-100,900])
axis equal
grid on
xlabel('X(mm)')
ylabel('Y(mm)')
zlabel('Z(mm)')
view(0,0)
ax = gca;
ax.FontSize = 16;
ax.FontName = 'Times New Roman';
ax.GridLineStyle = '--';
hold on
for i = 1:size_path
    for j = 1:size_point_path
        qv1 = quiver3(T_point_path_all{i,j}(1,4),T_point_path_all{i,j}(2,4),T_point_path_all{i,j}(3,4),T_point_path_all{i,j}(1,1),T_point_path_all{i,j}(2,1),T_point_path_all{i,j}(3,1),50*I,"filled",'m');
        qv2 = quiver3(T_point_path_all{i,j}(1,4),T_point_path_all{i,j}(2,4),T_point_path_all{i,j}(3,4),T_point_path_all{i,j}(1,2),T_point_path_all{i,j}(2,2),T_point_path_all{i,j}(3,2),50*I,"filled",'g');
        qv3 = quiver3(T_point_path_all{i,j}(1,4),T_point_path_all{i,j}(2,4),T_point_path_all{i,j}(3,4),T_point_path_all{i,j}(1,3),T_point_path_all{i,j}(2,3),T_point_path_all{i,j}(3,3),50*I,"filled",'b');
    end
end
legend([qv1,qv2,qv3],{'$\vec{i}_{Path}$','$\vec{j}_{Path}$','$\vec{k}_{Path}$'},'Interpreter','latex','FontSize',16)
end
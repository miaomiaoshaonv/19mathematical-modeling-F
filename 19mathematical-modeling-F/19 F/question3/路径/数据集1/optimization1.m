function [x_Cor,y_Cor,z_Cor] = optimization1(x0, y0, z0, x1, y1, z1, x2, y2, z2, x_C, y_C,z_C, fly_dis)
    %%%x0 y0 z0 球心坐标 r 半径
    %%%x_C, y_C,z_C  垂直或者水平方向上的所有点
    
    le = size (x_C,1);
    j = 1;
    %%%获取所有在球内的点
    for i = 1:le
         x = x_C(i);
         y = y_C(i); 
         z = z_C(i);
         dis = sqrt((x-x0)^2 + (y-y0)^2 +(z-z0)^2) + sqrt((x-x1)^2 + (y-y1)^2 +(z-z1)^2) + sqrt((x-x2)^2 + (y-y2)^2 +(z-z2)^2);
%          if dis <= fly_dis
%              x_s(j) = x;
%              y_s(j) = y;
%              z_s(j) = z;
%              %disAB(i) = sqrt((x-x1)^2 + (y-y1)^2 +(z-z1)^2)  + sqrt((x-x2)^2 + (y-y2)^2 +(z-z2)^2); 
%              disAB(i) = abs(x2 - x) + abs(y2 - y) + abs(z2 - z);
%              j = j+1;
%          end
    end
    
     
    [M,index] = sort(dis);
    x_Cor = x_C(index(1));
    y_Cor = y_C(index(1));
    z_Cor = z_C(index(1));

end
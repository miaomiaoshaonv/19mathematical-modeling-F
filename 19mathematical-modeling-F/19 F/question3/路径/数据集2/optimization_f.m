function [x_Cor,y_Cor,z_Cor] = optimization_f(x0, y0, z0, x1, y1, z1, x2, y2, z2, x_C, y_C,z_C, fly_dis)
    %%%x0 y0 z0 �������� r �뾶
    %%%x_C, y_C,z_C  ��ֱ����ˮƽ�����ϵ����е�
    
    le = size (x_C,1);
    j = 1;
    %%%��ȡ���������ڵĵ�
    for i = 1:le
         x = x_C(i);
         y = y_C(i);
         z = z_C(i);
         dis(i) =  sqrt((x-x1)^2 + (y-y1)^2 +(z-z1)^2);
         
         if  dis(i)< 1 * fly_dis
             x_s(j) = x;
             y_s(j) = y;
             z_s(j) = z;
             disAB(j) = sqrt((x-x0)^2 + (y-y0)^2 +(z-z0)^2) + sqrt((x-x1)^2 + (y-y1)^2 +(z-z1)^2) + sqrt((x-x2)^2 + (y-y2)^2 +(z-z2)^2);
             j = j+1;
         end
    end
    
     
    [M,index] = sort(disAB);
    x_Cor = x_s(index(1));
    y_Cor = y_s(index(1));
    z_Cor = z_s(index(1));

end
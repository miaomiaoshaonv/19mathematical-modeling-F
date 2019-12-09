function [ xf, yf, zf ] = contactpoint( x2, y2,z2,x0,y0,z0,A,B,C,D, x3, y3, z3,x1, y1, z1)

%%%  x2校正点  x0 圆心 x3 飞行方向上的一个点 x1 当前起点
syms x4 y4 z4
eq1=(x2 - x4) * (x0 - x4) +(y2 - y4) * (y0 - y4) + (z2 - z4) * (z0 - z4) ;
eq2=A*x4 + B*y4 + C*z4 + D;
eq3=(x0-x4)^2+(y0-y4)^2+(z0-z4)^2-200^2;
[x4 y4 z4]= solve(eq1,eq2,eq3,x4,y4,z4);

x4 = double(x4);
y4 = double(y4);
z4 = double(z4);

len = size(x4,1);
if len==1
    xf = x4;
    yf = y4;
    zf = z4;
else if len == 2
        x_1 = x4(1);
        y_1 = y4(1);
        z_1 = z4(1);
        x_2 = x4(2);
        y_2 = y4(2);
        z_2 = z4(2);
        
        alpha = acosd( ((x3 - x1)*(x2 - x1)+(y3 - y1)*(y2 - y1) + (z3 - z1)*(z2 - z1))/(sqrt((x3-x1)^2 + (y3-y1)^2 + (z3-z1)^2 )*sqrt((x2-x1)^2 + (y2-y1)^2 + (z2-z1)^2 )));
        
        d1 = sqrt((x_1 - x1)^2 + (y_1 - y1)^2 + (z_1 - z1)^2);
        d2 = sqrt((x_2 - x1)^2 + (y_2 - y1)^2 + (z_2 - z1)^2);
        if alpha < 90 
            if d1 < d2
                xf = x_1;
                yf = y_1;
                zf = z_1;
            else 
                xf = x_2;
                yf = y_2;
                zf = z_2;
            end
        else if alpha > 90
                if d1 < d2
                    xf = x_2;
                    yf = y_2;
                    zf = z_2;
                else 
                    xf = x_1;
                    yf = y_1;
                    zf = z_1;
                end
            end
        end
    end
end






end


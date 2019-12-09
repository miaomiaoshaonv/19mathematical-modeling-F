function [ xf, yf, zf ] = originaldot( x1,y1,z1,x3,y3,z3,A,B,C,D,x2,y2,z2)
%%% x1 起点 x3 飞行直线上的点 x2 

syms x0 y0 z0
eq1=(x3 - x1)* x0 + (y3 - y1)* y0 +(z3 - z1)* z0 -( x1*(x3-x1) + y1*(y3-y1) + z1*(z3-z1));
eq2=A*x0 + B*y0 + C*z0 + D;
eq3=(x0-x1)^2+(y0-y1)^2+(z0-z1)^2-200^2;
[x0, y0, z0] = solve(eq1,eq2,eq3,'x0','y0','z0');

x=double(x0);
y=double(y0);
z=double(z0);

len = size(x,1);
if len==1
    xf = x;
    yf = y;
    zf = z;
else if len == 2
        x_1 = x(1);
        y_1 = y(1);
        z_1 = z(1);
        x_2 = x(2);
        y_2 = y(2);
        z_2 = z(2);
        d1 = sqrt((x_1 - x2)^2 + (y_1 - y2)^2 + (z_1 - z2)^2);
        d2 = sqrt((x_2 - x2)^2 + (y_2 - y2)^2 + (z_2 - z2)^2);
        if d1 < d2
            xf = x_1;
            yf = y_1;
            zf = z_1;
        else 
            xf = x_2;
            yf = y_2;
            zf = z_2;
        end
    end
end
        

% scatter(x1, y1, z1, 'r')
% hold on
% scatter(x2, y2, z2, 'b')
% hold on
% scatter(x3, y3, z3, 'k')
% hold on
% scatter(x0, y0, z0, 'g')
% grid on


end


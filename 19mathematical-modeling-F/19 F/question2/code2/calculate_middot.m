function [P1, P2, P3] = calculate_middot(x_O,y_O,z_O,x2,y2,z2,x1,y1,z1,A,B,C,D)
syms x y z
eq1=(x - x_O) * (x2 - x1) +(y - y_O) * (y2 - y1) + (z - z_O) * (z2 - z1) ;
eq2=A*x + B*y + C*z + D;
eq3=(x-x_O)^2+(y-y_O)^2+(z-z_O)^2-200^2;
[x y z]= solve(eq1,eq2,eq3,'x','y','z');
x=double(x);
y=double(y);
z=double(z);

len = size(x,1);
if len==1
    P1 = x;
    P2 = y;
    P3 = z;
else if len == 2
        x_1 = x(1);
        y_1 = y(1);
        z_1 = z(1);
        x_2 = x(2);
        y_2 = y(2);
        z_2 = z(2);
         
        d1 = sqrt((x_1 - x1)^2 + (y_1 - y1)^2 + (z_1 - z1)^2);
        d2 = sqrt((x_2 - x1)^2 + (y_2 - y1)^2 + (z_2 - z1)^2);
 
        if d1 < d2
                P1 = x_1;
                P2 = y_1;
                P3 = z_1;
        else 
                P1 = x_2;
                P2 = y_2;
                P3 = z_2;
         end
    
    end
end

end


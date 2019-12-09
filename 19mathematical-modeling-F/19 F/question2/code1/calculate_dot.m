function [fx, fy ,fz]= calculate_dot(x1,y1,z1,x2,y2,z2,fly_dis)
    fx = x1 + sqrt((fly_dis)^2/(1 + ((y2-y1)/(x2-x1))^2 + ((z2-z1)/(x2-x1))^2));
    fy = (fx - x1)*(y2 - y1)/(x2-x1) + y1;
    fz = (fy - y1)*(z2 - z1)/(y2-y1) + z1;
    
end

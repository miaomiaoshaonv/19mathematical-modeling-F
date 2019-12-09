function [x3, y3, z3] = calculate_dot_longer(x_c,y_c,z_c, x1, y1, z1, c)

    x3 = x1 + sqrt((c)^2/(1 + ((y_c-y1)/(x_c-x1))^2 + ((z_c-z1)/(x_c-x1))^2));
    y3 = (x3 - x1)*(y_c - y1)/(x_c-x1) + y1;
    z3 = (y3 - y1)*(z_c - z1)/(y_c - y1) + z1;

end
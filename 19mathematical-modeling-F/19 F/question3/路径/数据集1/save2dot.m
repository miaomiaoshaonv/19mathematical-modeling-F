clear;
clc;

filename = 'dataset1';
data = xlsread(filename);

for i = 2:4
    for j = 1:613
        t = data(j,i);
        t = vpa(t,2);
        disp(t);
        data(j,i) = t;
    end
end


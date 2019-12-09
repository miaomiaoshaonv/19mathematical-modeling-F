function [index]=find_index(x0,y0,z0,x_Cor,y_Cor,z_Cor)

i_count=1;
for i=1:length(x0)
    beat(i_count)=(x0(i)-x_Cor)^2+(y0(i)-y_Cor)^2+(z0(i)-z_Cor)^2;
    i_count=i_count+1;
end

[min_deat index]=min(beat,[],2);

%%%���ݼ�1

clear;
clc;

filename = 'dataset1';
data = xlsread(filename);

x0 = data(2:612,2);
y0 = data(2:612,3);
z0 = data(2:612,4);
m0 = data(2:612,5);

%��������
error0=data(2:612,6);

index0=data(2:612,1);

j = 1;
k = 1;
for i = 1:611
    if m0(i) == 0
        x_L(j,1) = x0(i);
        y_L(j,1) = y0(i);
        z_L(j,1) = z0(i);
       
        x_L_index(j,1)=i;
        
         j = j + 1;
    end 
    if m0(i) == 1
        x_V(k,1) = x0(i);
        y_V(k,1) = y0(i);
        z_V(k,1) = z0(i);
        
        x_V_index(j,1)=i;
        
        k = k + 1;
    end
end
%initial dot ��ʼ��
x1 = data(1,2);
y1 = data(1,3);
z1 = data(1,4);
%final dot  �յ�
x2 = data(613,2);
y2 = data(613,3);
z2 = data(613,4);

% scatter3(x1,y1,z1,'p','filled')
% hold on
% scatter3(x2,y2,z2,'b','filled')
% hold on
% scatter3(x_L,y_L,z_L,'y','filled')
% hold on
% scatter3(x_V,y_V,z_V,'k','filled')
% 
% xlabel('x');
% ylabel('y');
% zlabel('z');

flag = 0;
%%%����
alpha1 = 25;
alpha2 = 15;
beta1 = 20;
beta2 = 25;
theta = 30;
delta = 0.001;
error_L = 0;
error_V = 0;

%%%% ����������У����������Լ��ɹ��ľ��룬 s��ʾ����
x_all = [];
y_all = [];
z_all = [];
fly_all = [];
s = 1;

x_all(s) = x1;
y_all(s) = y1;
z_all(s) = z1;

while flag == 0  %flag =1 ��ʾ�����յ� 
    
    disp(['No.',num2str(s) ,' fly ']);
    %%%��ǰ�㵽�յ��ֱ�� calculate_dot ������ֱ�߷���
    %%%�ɷ��еľ��룬�ɵ�ǰ������
    if s == 1
        fly_dis = (min(alpha2 - error_L,beta1 - error_V))/delta;
        initial_choice=rand(1,1);
        if(initial_choice>0.5)
            flag_Cor = 1;
            x_C = x_V;
            y_C = y_V;
            z_C = z_V; 
        else
            flag_Cor = 0;
            x_C = x_L;
            y_C = y_L;
            z_C = z_L; 
        end    
    else
        d1 = min(alpha1- error_V, alpha2- error_L)/delta;
        d2 = min(beta1- error_V, beta2- error_L)/delta;
        fly_dis = max(d1,d2);
        if d1 > d2
            flag_Cor = 1;
            x_C = x_V;
            y_C = y_V;
            z_C = z_V;
        else if d1 < d2
                flag_Cor = 0;
                x_C = x_L;
                y_C = y_L;
                z_C = z_L;
            end
        end
    end
    
    %%%�жϴ˴η��е�У����Ϊ��ֱ��ˮƽ 
    %%%flag_Cor 1:��ֱУ���� 0��ˮƽУ��
    
%     fly_dis = (min(alpha2 - error_L,beta1 - error_V))/delta;
%     if alpha2 - error_L < beta1 - error_V
%         flag_Cor = 0;
%         x_C = x_L;
%         y_C = y_L;
%         z_C = z_L;
%     else
%         flag_Cor = 1;
%         x_C = x_V;
%         y_C = y_V;
%         z_C = z_V;
%     end
    

    %%%�ɷ��о���ȷ��һ�����棬��ֱ�ߵõ�һ������
    [x, y ,z]= calculate_dot(x1,y1,z1,x2,y2,z2,fly_dis);
 
    %%%�������е�Ѱ�������У����
    [x_Cor,y_Cor,z_Cor] = optimization_f(x, y, z, x1, y1, z1, x2, y2, z2, x_C, y_C,z_C, fly_dis);
    
    index_Cor=find_index(x0,y0,z0,x_Cor,y_Cor,z_Cor);
    
   
    x_cor_all(s) = x_Cor;
    y_cor_all(s) = y_Cor;
    z_cor_all(s) = z_Cor;
    
    actual_dis = sqrt((x1-x_Cor)^2 + (y1-y_Cor)^2 +(z1-z_Cor)^2);
    fly_all(s) = actual_dis;
    
    %%%�ۼƴ�ֱˮƽ���
    error_L = error_L + actual_dis * delta;
    error1(s) = error_L;
    error_V = error_V + actual_dis * delta;
    error2(s) = error_V;
    
    %%%�������ﵽ�ֲ����ŵ�У����flag_Cor 1:��ֱУ���� 0��ˮƽУ��
    %%%��ȡ�µ��ۼ�ˮƽ����ֱ���
    
    %��Ϊ���ʳ�������Լ����������
    
    
    if(error0(index_Cor)==1)
        if flag_Cor == 1
           error_V = min(5,error_V);
             else if flag_Cor == 0
                     error_L = min(5,error_L);
                 end 
        end 
    else    
        if flag_Cor == 1
        error_V = 0;
             else if flag_Cor == 0
                     error_L = 0;
                 end 
         end
    end
    
    
%     scatter3(x,y,z,'p','filled');
%     hold on;
%     plot3(x_all, y_all, z_all, 'r');
%     xlabel('x label');
%     ylabel('y label');
%     zlabel('z label');
    %%%�ж��Ƿ�ﵽ�յ㣬�ﵽ��flag= 1
    dis_final = sqrt((x1-x2)^2 + (y1-y2)^2 +(z1-z2)^2);
    
    if dis_final < fly_dis
        flag = 1;
    end
    
    
    %%%��ȡ�µ��������
    x1 = x_Cor;
    y1 = y_Cor;
    z1 = z_Cor;
    
    s = s + 1;
    x_all(s) = x1;
    y_all(s) = y1;
    z_all(s) = z1;
 end


%���Ҿ����Ľ���������� ��ʼ�㵽�յ� all_index 
all_xyz=[x_all;y_all;z_all]';
all_error=[error1;error2]';


all_index=[];
all_index_count=1;
all_count=1;
all_beta=[];

for i=2:size(all_xyz,1)
    for j=1:length(x0)
     all_beta(all_count)=(all_xyz(i,1)-x0(j))^2+(all_xyz(i,2)-y0(j))^2+(all_xyz(i,3)-z0(j))^2;
     all_count=all_count+1;
    end
    all_count=1;
    [value,index]=min(all_beta,[],2);
    all_index(all_index_count)=index;
    all_index_count=all_index_count+1;
end

all_index=all_index';

for i=1:size(all_index,1)
    if(m0(all_index(i))==0)
        all_index(i,2)=0;
    else
        all_index(i,2)=1;
    end
end

for i=1:length(all_index)
    if(error0(all_index(i))==1)
        all_index(i,3)=1;
    else
        all_index(i,3)=0;
    end
end

for i=1:length(error2)
    all_index(i,4)=error2(i);
end

for i=1:length(error1)
    all_index(i,5)=error1(i);
end


save('x_cor.txt','x_cor_all','-ascii')
save('y_cor.txt','y_cor_all','-ascii')
save('z_cor.txt','z_cor_all','-ascii')

save('error_L.txt','error1','-ascii')
save('error_V.txt','error2','-ascii')




x_all(s+1) = x2;
y_all(s+1) = y2;
z_all(s+1) = z2;
fly_all(s) = dis_final;

flydis = sum(fly_all);

scatter3(x_all(1),y_all(1),z_all(1),'p','filled')
hold on
scatter3(x_all(s+1),y_all(s+1),z_all(s+1),'b','filled')
hold on
scatter3(x_L,y_L,z_L,'y','filled')
hold on
scatter3(x_V,y_V,z_V,'k','filled')
hold on
plot3(x_all, y_all, z_all, 'r');

xlabel('x label');
ylabel('y label');
zlabel('z label');
title(['total distance is ', num2str(flydis)]);




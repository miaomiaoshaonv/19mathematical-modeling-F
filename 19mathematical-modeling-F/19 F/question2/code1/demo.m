
clear;
clc;

filename = 'dataset1';
data = xlsread(filename);

[M N] = size(data);

x0 = data(2:M-1,2);
y0 = data(2:M-1,3);
z0 = data(2:M-1,4);
m0 = data(2:M-1,5);

j = 1;
k = 1;
for i = 1:M-2
    if m0(i) == 0
        x_L(j,1) = x0(i);
        y_L(j,1) = y0(i);
        z_L(j,1) = z0(i);
        j = j + 1;
    end 
    if m0(i) == 1
        x_V(k,1) = x0(i);
        y_V(k,1) = y0(i);
        z_V(k,1) = z0(i);
        k = k + 1;
    end
end
%initial dot
x1 = data(1,2);
y1 = data(1,3);
z1 = data(1,4);
%final dot
x2 = data(M,2);
y2 = data(M,3);
z2 = data(M,4);

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

tic;
while flag == 0  %flag =1 ��ʾ�����յ� 
    
    disp(['No.',num2str(s) ,' fly ']);
    %%%�ɷ��еľ��룬�ɵ�ǰ������
    %%%�жϴ˴η��е�У����Ϊ��ֱ��ˮƽ 
    %%%flag_Cor 1:��ֱУ���� 0��ˮƽУ��
    if s == 1
        fly_dis = (min(alpha2 - error_L,beta1 - error_V))/delta;
        flag_Cor = 0;
        x_C = x_L;
        y_C = y_L;
        z_C = z_L;      
        
        %%%��ǰ�㵽�յ��ֱ�� calculate_dot ������ֱ�߷���
        %%%�ɷ��о���ȷ��һ�����棬��ֱ�ߵõ�һ������
        [x, y ,z]= calculate_dot(x1,y1,z1,x2,y2,z2,fly_dis);
        %%%�������е�Ѱ�������У����
        [x_Cor,y_Cor,z_Cor] = optimization_f(x, y, z, x1, y1, z1, x2, y2, z2, x_C, y_C,z_C, fly_dis);
        ac_dis = sqrt((x1-x_Cor)^2 + (y1-y_Cor)^2 +(z1-z_Cor)^2);
        %%%%�洢�е㷽��
        x_contact = x1;
        y_contact = y1;
        z_contact = z1;
        
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
        
        %%%�ж��Ƿ�ﵽ�յ㣬�ﵽ��flag= 1 ����������
        [dis_final, O, P, Q] = calculate_arc(x_contact,y_contact,z_contact,x1, y1, z1,x2, y2, z2);
        if dis_final < min(theta - error_V, theta - error_L)/delta
            O_A(:,s) = O;
            P_A(:,s) = P;
            Q_A(:,s) = Q;
            flag = 1;
            break;
        end
        
        [x, y ,z]= calculate_dot(x1,y1,z1,x2,y2,z2,fly_dis);
        %%%���ؼ��������У����x_Cor,y_Cor,z_Cor���е�����x_c, y_c, z_c,�ͷ��о���ac_dis
        [x_Cor,y_Cor,z_Cor, x_c, y_c, z_c, ac_dis, O, P, Q] = optimization_m(x_contact,y_contact,z_contact,x, y, z, x1, y1, z1, x2, y2, z2, x_C, y_C,z_C, fly_dis);
        %%%�洢ÿ�ε�Բ�ĺ�ƽ�淽��
        O_A(:,s) = O;
        P_A(:,s) = P;
        Q_A(:,s) = Q;
        %%%%�洢�е㷽��
        x_contact = x_c;
        y_contact = y_c;
        z_contact = z_c;
    end
    

    
    %%%����ʵ�ʷ��о��벢�洢
    actual_dis = ac_dis;
    fly_all(s) = actual_dis;
    
    %%%�ۼƴ�ֱˮƽ���
    error_L = error_L + actual_dis * delta;
    error1(s) = error_L;
    error_V = error_V + actual_dis * delta;
    error2(s) = error_V;
    
    %%%�������ﵽ�ֲ����ŵ�У����flag_Cor 1:��ֱУ���� 0��ˮƽУ��
    %%%��ȡ�µ��ۼ�ˮƽ����ֱ���
    if flag_Cor == 1
        error_V = 0;
    else if flag_Cor == 0
           error_L = 0;
        end 
    end
    
    
    %%%�洢У����
    x_cor_all(s) = x_Cor;
    y_cor_all(s) = y_Cor;
    z_cor_all(s) = z_Cor;
    %%%��ȡ�µ��������
    x1 = x_Cor;
    y1 = y_Cor;
    z1 = z_Cor;
    
    %%%�洢���зɹ��ĵ�
    s = s + 1;
    x_all(s) = x1;
    y_all(s) = y1;
    z_all(s) = z1;
end

toc;

error1(s) = error_L + dis_final*delta;
error2(s) = error_V + dis_final*delta;

x_all(s+1) = x2;
y_all(s+1) = y2;
z_all(s+1) = z2;
fly_all(s) = dis_final;

flydis = sum(fly_all);

save('x_cor.txt','x_cor_all','-ascii')
save('y_cor.txt','y_cor_all','-ascii')
save('z_cor.txt','z_cor_all','-ascii')

save('error_L.txt','error1','-ascii')
save('error_V.txt','error2','-ascii')

scatter3(x_all(1),y_all(1),z_all(1),'p','filled')
hold on
scatter3(x_all(s+1),y_all(s+1),z_all(s+1),'b','filled')
hold on
scatter3(x_L,y_L,z_L,'y','filled')
hold on
scatter3(x_V,y_V,z_V,'g','filled')
hold on
% plot3(x_all, y_all, z_all, 'r');
% 


%%%ֱ�߷ɵ�·�� ����1.2����
x=[x_all(1),x_all(2)];
y=[y_all(1),y_all(2)];
z=[z_all(1),z_all(2)];
plot3(x,y,z,'k');
grid on;
hold on;

%%%���ô洢��ƽ�淽�̺����巽����ͼ�������л��߷��еĲ���
len = size(O_A, 2);
for i = 2:len
    x0 = O_A(1,i);
    y0 = O_A(2,i);
    z0 = O_A(3,i);
    x1 = P_A(1,i);
    y1 = P_A(2,i);
    z1 = P_A(3,i);
    x2 = Q_A(1,i);
    y2 = Q_A(2,i);
    z2 = Q_A(3,i);
    
    p1 = [O_A(1,i), O_A(2,i), O_A(3,i)];
    p2 = [P_A(1,i), P_A(2,i), P_A(3,i)];
    p3 = [Q_A(1,i), Q_A(2,i), Q_A(3,i)];
    
    arcPlot(p1,p2,p3,0,'r');
    hold on;
    
    x=[x2,x_all(i+1)];
    y=[y2,y_all(i+1)];
    z=[z2,z_all(i+1)];
    plot3(x,y,z,'k');
    hold on;
end

xlabel('x label');
ylabel('y label');
zlabel('z label');
title(['���ݼ�1  distance is ', num2str(flydis)]);


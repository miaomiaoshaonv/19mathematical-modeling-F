function [x_C,y_C,z_C,x_c, y_c, z_c, actual_dis,O, P, Q] = optimization_m(x_contact,y_contact,z_contact,x0, y0, z0, x1, y1, z1, x2, y2, z2, x_C, y_C,z_C, fly_dis)
    %%%x_CУ����  x_c�е� 
    %%%O Բ������ P ƽ�淽��
    
    
    %%%s>=2 �ڶ��η��м��Ժ���ȷ������
    %%%x_contact,y_contact,z_contact �ϴε��е����꣬���жϷ��з���
    %%%x0 y0 z0 �������� r �뾶
    %%%x_C, y_C,z_C  ��ֱ����ˮƽ�����ϵ����е�
    
    %%%%Ѱ�ҷ��з����ϵ�һ��������
    [x3, y3, z3] = calculate_dot_longer(x_contact,y_contact,z_contact, x1, y1, z1, 1000);

    %%%��ȡ���������ڵĵ�
    le = size (x_C,1);
    j = 1;
    for i = 1:le
         x = x_C(i);
         y = y_C(i);
         z = z_C(i);
         dis =  sqrt((x-x1)^2 + (y-y1)^2 +(z-z1)^2);
         if 400 < dis < 1 * fly_dis
             x_s(j) = x;
             y_s(j) = y;
             z_s(j) = z;
             disAB(j) = sqrt((x-x0)^2 + (y-y0)^2 +(z-z0)^2) + sqrt((x-x1)^2 + (y-y1)^2 +(z-z1)^2) + sqrt((x-x2)^2 + (y-y2)^2 +(z-z2)^2);
             j = j+1;
         end
    end
    
    %%%x_Cor y_Cor  z_Cor ȡ����յ��10��У����
    [M,index] = sort(disAB);
    x_Cor = x_s(index(1:10));
    y_Cor = y_s(index(1:10));
    z_Cor = z_s(index(1:10));

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%������յ��У������Ѱ�ҷ��й켣С��R��У����
   
    lenth = size(x_Cor,2);
    for k = 1:lenth
        x_m = x_Cor(k);
        y_m = y_Cor(k);
        z_m = z_Cor(k);
        %%% ���һ�������У���㣬�󻡳����еľ��룬���ȼ����Բ��x0���е�x4 x_m ĳһ��У����
        [A, B, C, D] = plain(x1, y1, z1,x_m,y_m,z_m,x3, y3, z3);
        %%% 200�뾶��Բ��
        [ x_O, y_O, z_O] = originaldot( x1,y1,z1,x3,y3,z3,A,B,C,D,x_m,y_m,z_m);
        %%% �е�
        [ x4, y4, z4 ] = contactpoint( x_m, y_m, z_m ,x_O, y_O, z_O, A, B, C, D,x3, y3, z3, x1, y1, z1);
        
        %%%�������еĹ켣
        l = sqrt((x1-x4)^2 + (y1-y4)^2 +(z1-z4)^2);
        alpha = acos((2 * 200^2 -l^2 )/(2*200*200));
        s = alpha * 200;
        d = sqrt((x_m - x4)^2 + (y_m - y4)^2 +(z_m - z4)^2);
        S = s + d;
        
        %%%��������������ѭ��������У������е�
        if S <= fly_dis
            x_C = x_m;
            y_C = y_m;
            z_C = z_m;
            x_c = x4;
            y_c = y4;
            z_c = z4;
            actual_dis = S;
            %%% �洢ƽ��ķ���ABCD �Լ� ��������
            O(1) = x_O;
            O(2) = y_O;
            O(3) = z_O;
            [P(1), P(2),P(3) ] = calculate_middot(x_O,y_O,z_O,x4,y4,z4,x1,y1,z1,A,B,C,D);
  
            Q(1) = x4;
            Q(2) = y4;
            Q(3) = z4;
            break;
        end
    end
    
end
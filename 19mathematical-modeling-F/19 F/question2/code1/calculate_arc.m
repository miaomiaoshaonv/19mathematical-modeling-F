function [S, O, P, Q] = calculate_arc( x_contact,y_contact,z_contact,x1, y1, z1,x2, y2, z2)
%%%%���㵱ǰ�㵽�յ�Ļ���
%%%%x_contact,y_contact,z_contact ��һ�ε��е�    x1, y1, z1 ��ǰ��    x2, y2, z2 �յ�
   
    %%%������з����ϵ�һ��
    [x3, y3, z3] = calculate_dot_longer(x_contact,y_contact,z_contact, x1, y1, z1, 1000);
    
    [A, B, C, D] = plain(x1, y1, z1, x2, y2, z2 ,x3, y3, z3);
    %%% 200�뾶��Բ��
    [ x_O, y_O, z_O] = originaldot( x1,y1,z1,x3,y3,z3,A,B,C,D,x2, y2, z2);
    %%% �е�
    [ x4, y4, z4 ] = contactpoint(x2, y2, z2 ,x_O, y_O, z_O, A, B, C, D,x3, y3, z3 ,x1, y1, z1);
        
    %%%�������еĹ켣
    l = sqrt((x1-x4)^2 + (y1-y4)^2 +(z1-z4)^2);
    alpha = acos(( 2 * 200^2- l^2)/(2*200*200));
    s = alpha * 200;
    d = sqrt((x2 - x4)^2 + (y2 - y4)^2 +(z2 - z4)^2);
    S = s + d;
    
    O(1) = x_O;
    O(2) = y_O;
    O(3) = z_O;
    
    [P(1), P(2),P(3) ] = calculate_middot(x_O,y_O,z_O,x4,y4,z4,x1,y1,z1,A,B,C,D);
    
     Q(1) = x4;
     Q(2) = y4;
     Q(3) = z4;
    
end


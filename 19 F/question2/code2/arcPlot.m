function arcPlot(p1, p2, p3 ,arcFlag,colour)
%���ܣ�
%���ݸ���3�����Բ��
%������
%pos�����������������pos=[0 0 0;2 2 0;4 0 0];
%arcFlag,��־λ��0��ʾҪ��Բ��������ֵ��ʾ����Բ
%colour,ָ��������ɫ������colour='r';
hold on
%��뾶��Բ������

p1p2=p2-p1;
u1=p1p2/sum(p1p2.^2);

p2p3=p3-p2;
u2=unitVec(p2p3);

normal=cross(p1p2,p2p3);
normal=unitVec(normal);


per2=cross(normal,u2);
per2=unitVec(per2);

mid1=(p1+p2)/2;
mid2=(p2+p3)/2;
dis2=sqrt(sum(p2p3.^2));
L=(vecDot(mid1,u1)-vecDot(mid2,u1))/vecDot(per2,u1);

arc_R=sqrt(L^2+1.0/4*dis2^2);

C=mid2+L*per2;

%��Բ�Ľ�
    vec1=p1-C;
    vec1=unitVec(vec1);
    vec2=p3-C;
    vec2=unitVec(vec2);
    theta=vecDot(vec1,vec2);
    normal2=cross(vec1,vec2);
if(arcFlag==0)
    theta=acos(theta);
    if(sqrt(sum((normal-normal2).^2))>1.0e-5)
        theta=2*pi-theta;
    end
else
    theta=2*pi;
end
%�������ݵ�
%Բ���ľֲ�����ϵ��λ����
vx=[1,0,0];
vy=[0,1,0];
vz=[0,0,1];
v1=vec1;
v3=normal;
v2=cross(v3,v1);
v2=unitVec(v2);
%��任����
r11=vecDot(v1,vx);r12=vecDot(v2,vx);r13=vecDot(v3,vx);
r21=vecDot(v1,vy);r22=vecDot(v2,vy);r23=vecDot(v3,vy);
r31=vecDot(v1,vz);r32=vecDot(v2,vz);r33=vecDot(v3,vz);
Tr=[r11,r12,r13,0;
    r21,r22,r23,0;
    r31,r32,r33,0;
    0,0,0,1];
Tt=[1,0,0,C(1);
    0,1,0,C(2);
    0,0,1,C(3);
    0,0,0,1];
%�ֲ�����ϵ���ݵ������
t=0:(theta)/100:theta;
x1=arc_R*cos(t);
y1=arc_R*sin(t);
z1=t*0;
pt=[x1;y1;z1;ones(size(x1))];
%�ֲ��������任�����������
pt=Tt*Tr*pt;

plot3(pt(1,:),pt(2,:),pt(3,:),colour);
xlabel('x')
ylabel('y')
zlabel('z')

view(-37.5,30)
hold on
grid on
axis equal
end
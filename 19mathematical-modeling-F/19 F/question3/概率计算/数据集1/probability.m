function [p_suc]=probability(all)
filename = 'dataset1';
data = xlsread(filename);


x0 = data(2:612,2);
y0 = data(2:612,3);
z0 = data(2:612,4);
m0 = data(2:612,5);

%概率误差点
error0=data(2:612,6);

index0=data(2:612,1);

j = 1;
k = 1;
for i = 1:611
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
%initial dot 初始点
x1 = data(1,2);
y1 = data(1,3);
z1 = data(1,4);
%final dot  终点
x2 = data(613,2);
y2 = data(613,3);
z2 = data(613,4);

flag = 0;
%%%参数
alpha1 = 25;
alpha2 = 15;
beta1 = 20;
beta2 = 25;
theta = 30;
delta = 0.001;
error_L = 0;
error_V = 0;

i_count=0;
%计算N 误差矫正点的个数
for i=1:size(all,1)
    if all(i,3)==1
        i_count=i_count+1;
    end
end


matrix=zeros(1,3);
x_pre=x1;
y_pre=y1;
z_pre=z1;

error(1,:)=[0,0,0];
c=size(all(:,1));
for i=1:size(all,1)  %校正点的个数
   row = size(error(:,1),1);
   
   for j = 1 : row %矩阵的行数
       if error(j,3) ~= 1
          index_cur = all(i,1);
          if i==1
              dist=sqrt((x0(index_cur)-x1)^2+( y0(index_cur)-y1)^2+(z0(index_cur)-z1)^2);
          else
              index_last = all(i-1,1);
              dist=sqrt(((x0(index_cur))-(x0(index_last)))^2+((y0(index_cur))-(y0(index_last)))^2+((z0(index_cur))-(z0(index_last)))^2);
          end
          error(j,1)= error(j,1) + dist*delta;
          error(j,2)= error(j,2) + dist*delta;
          if(all(i,2)==1)%垂直
             if((error(j,1)<alpha1))&&(error(j,2)<alpha2)
                 error(j,3)=0;
             else
                 error(j,3)=1;
             end
           end
             
             if (all(i,2)==0)%水平
               if((error(j,1)<beta1))&&(error(j,2)<beta2)
                   error(j,3)=0;
               else
                   error(j,3)=1;
                end 
             end             
       end
   end 

       if (all(i,2)==0)%水平
           if (all(i,3)==1) %可能出现校正不成功的点
               for z=1:row  %复制矩阵
                 error(z + row,:) = error(z ,:);
               end
               
                for p = 1: row    %矩阵的前半部分取80%的概率，校正成功
                    error(p,size( error(p,:),2)+1)=0.8;
                    if error( p,3)~= 1 
                         error( p,2) =0;
%                     else  error( p,1) = min(error( p,1),5);
                    end  
                end
                
                 for q = row+1: 2*row  %矩阵的后半部分取20%的概率，校正失败
                        error(q,size( error(q,:),2)+1)=0.2;
                        if error( q ,3)~= 1 
%                             error( q ,2) =0;
%                         else
                            error( q ,2) = min(error( q,2),5);
                        end  
                 end
           end
               if (all(i,3)==0) %校正成功的点
                   for h = 1:size(error(:,1),1)
                       if error( h ,3)~=1
                        error( h ,2) =0;
                       end
                   end
               end
           end
       
           if (all(i,2)==1)%垂直矫正
           if (all(i,3)==1) %可能出现校正不成功的点
               for z=1:row  %复制矩阵
                 error(z + row,:) = error(z ,:);
               end
               
                for p = 1: row    %矩阵的后半部分取80%的概率，校正成功
                    error(p,size( error(p,:),2)+1)=0.8;
                    if error( p,3)~= 1 
                        error( p,1) =0;
%                     else error( p,2) = min(error( p,1),5);
                    end  
                end
                
                 for q = row+1: 2*row  %矩阵的后半部分取20%的概率，校正失败
                        error(q,size( error(q,:),2)+1)=0.2;
                        if error( q ,3)~= 1 
%                             error( q ,2) =0;
%                         else 
                            error( q ,1) = min(error( q,1),5);
                        end  
                 end
           end
           if (all(i,3)==0) %校正成功的点
               for h = 1:size(error(:,1),1)
                   if error( h ,3)~=1
                    error( h ,1) =0;
                   end
               end 
           end
       end
end

  raw = size(error(:,1),1);
  p_lost=0;
  for l= 1: raw
      if error(l,3)==1
          p_lost=1;
          for k=4:size(error(1,:),2)
              if error(l,k)~=0
               p_lost= p_lost*error(l,k);
              end
          end
      end
      p_losta(l)=p_lost;
  end
   p_suc=1-sum(p_losta) ;
end

% i_copy=1;
% 
% for i=1:size(all,1)
% 
%    dis=(x(all(i,1))-x_pre)^2+( y(all(i,1))-y_pre)^2+(z(all(i,1))-z_pre)^2
%     
%    %当前点是下一次迭代的前一个点
%     x_pre=x(all(i,1));
%     y_pre=x(all(i,1));
%     z_pre=z(all(i,1));
%     
%     %计算当前的累计误差
%     error_V=error_V+dis*delta;
%     error_L=error_L+dis*delta;
%     
%     
%     %将累计误差添加到矩阵前两列
%     matrix(i_copy,1)=error_V;
%     matrix(i_copy,2)=error_L;
%     
%     %第三列，判断是否是符合要求的i_lost
%     %先判断是 V还是L
%     if(all(i,3)==0)
%         if(all(i,2)==1)%垂直
%             if((error_V<alpha1))&&(error_L<alpha2)
%                 matrix(i_copy,3)=0;
%                 error_V=0;
%             else
%                 matrix(i_copy,3)=1;
%                 error_V=alpha1-error_V;
%             end
%         else%水平
%                 if((error_V<beta1))&&(error_L<beta2)
%                     matrix(i_copy,3)=0;
%                     error_L=0;
%                 else
%                     matrix(i_copy,3)=1;
%                     error_L=alpha1-error_L;
%                 end
%             end 
%        else
%             
%           
%             
%             
%       end
%     
%     
%     
% end






% i_error=1;
% 
% 
% if i_count==0
%   max_prob=1;  
% else
%     %建立大小为 2^N,N+3的矩阵
%     matrix=zeros(2^(i_count),i_count+3);
%     
%     for i_roadLength=1:size(all,1)
%         %如果不是误差矫正点 正常执行
%         index=all(i_roadLength,1);
%         v_l=all(i_roadLength,2);
%         err=all(i_roadLength,3);
%         
%         if err==0
%             dis=sqrt((x(all(1,1))-x1)^2+(y(all(1,1))-y1)^2+(z(all(1,1))-z1)^2);
% %             error_L=error_L+dis*delta;
% %             error_V=error_V+dis*delta;
%             
%             matrix(1,1)=error_L;
%             matrix(1,2)=error_V;
%             
%             if(v_l==1)%等于1时是垂直矫正点 否则为水平矫正点
%                 if((error_V+dis*delta<alpha1)&&(error_L+dis*delta<alpha2))
%                     matrix(1,3)=0;%可以矫正成功
%                     error_L=error_L+dis*delta;
%                     error_V=0;
%                 else
%                    
%                     
%                 end
%                 
%             else
%                  if((error_V<beta1)&&(error_L<beta2))
%                     matrix(1,3)=0;
%                     error_L=error_L+dis*delta;
%                     error_L=0;
%                 else
% %                      matrix(1,3)=1;
% %                      error_L=error_L+dis*delta;
% %                      error_V=min(error_V+dis*delta,5);
%                 end
%                 
%             end
%             
%         else %如果为误差矫正点，复制前面的行到当前行
%            i_error=i_error*2;
%             dis=sqrt((x(all(1,1))-x1)^2+(y(all(1,1))-y1)^2+(z(all(1,1))-z1)^2);
% %           error_L=error_L+dis*delta;
% %           error_V=error_V+dis*delta;
%             
%             matrix(1,1)=error_L;
%             matrix(1,2)=error_V;
%             
%             
%             for i_copy=1:i_roadLength-1
%                 matrix(i_roadLength+i_copy,:)=
%             end
%             
%             
%             
%         end
%         
%         
%         
%         
%     end
% end
% 
% 
% 

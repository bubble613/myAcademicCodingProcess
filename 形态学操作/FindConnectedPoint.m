function R=FindConnectedPoint(p,Beta_pad,ind,n_l)
    %保存边界坐标对象
    Obj=[];
    %以p为中心点，从边界图中取出3*3大小的块区域
    Block=Beta_pad(p(1,1)-n_l:p(1,1)+n_l,p(1,2)-n_l:p(1,2)+n_l);
    Obj=p;
    %将图像中的p点置零
    Beta_pad(p(1,1),p(1,2))=0;
    %将块区域中的p点置零
    Block(n_l+1,n_l+1)=0;
    A=cell(1,3);
    %将p点从下标矩阵中删除
    for j=1:size(ind,1)
        if ind(j,:)==p
            ind(j,:)=[];
            break;
        end
    end
    %寻找块区域中为1的点的下标
    [rows,cols]=find(Block==1);
    ind_sub=cat(2,rows,cols);
    if ~isempty(ind_sub)
        %确定块中数值为1的点的坐标
        for i=1:size(ind_sub,1) 
            p_next=[];
            if ind_sub(i,1)<=n_l+1
                p_next(1,1)=p(1,1)-abs(n_l+1-ind_sub(i,1));
                if ind_sub(i,2)<=n_l+1                    
                    p_next(1,2)=p(1,2)-abs(n_l+1-ind_sub(i,2));
                else
                    p_next(1,2)=p(1,2)+abs(n_l+1-ind_sub(i,2));                    
                end
            else
                p_next(1,1)=p(1,1)+abs(n_l+1-ind_sub(i,1));
                if ind_sub(i,2)<=n_l+1                    
                    p_next(1,2)=p(1,2)-abs(n_l+1-ind_sub(i,2));
                else
                    p_next(1,2)=p(1,2)+abs(n_l+1-ind_sub(i,2));                    
                end                
            end
            if Beta_pad(p_next(1,1),p_next(1,2))~=0                        
                A=FindConnectedPoint(p_next,Beta_pad,ind,n_l);
                Obj=cat(1,A{1,1},Obj);   
            end                       
            %更新下标矩阵
            ind=A{1,2};
            Beta_pad=A{1,3};
        end
    end
    %返回结果
    R={Obj,ind,Beta_pad};
end
function [DataTest,DataTrain,CTest,CTrain,data_col,tt_label,tt_index] = samplesdivide1(indian_pines_corrected,indian_pines_gt,train,randpp,im_gt,flag)

CTrain = [];
CTest = [];
DataTest  = [];
DataTrain = [];
%====================
tt_label = [];
tt_index = [];
%====================
[m,n,p] = size(indian_pines_corrected);
data_col = reshape(indian_pines_corrected,m*n,p);
[mm,nn] = ind2sub([m n],1:m*n);     %用来确定等效的下标值 就是一个M行N列的数组 将其地理坐标沿着列将其拉成一竖着条
data_col = [mm' nn' data_col];
%========================================
ind = [];
label = [];
im_gt_1d = im_gt;
for x = 0:1:max(indian_pines_gt(:)),
    index_t =  find(im_gt_1d == x);%每一类索引
    ind = [ind index_t];
    
    label_t = uint8(ones(1,length(index_t)))*x;%每一类标签
    label = [label label_t];
end
%========================================
for i = 1:max(indian_pines_gt(:))
    
    ci = length(find(indian_pines_gt==i));
    datai = data_col(find(indian_pines_gt==i),:);
    % %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % indian :在Pavia和Salina数据中  每类训练样本取的是30个 剩余的为测试样本    与Indian不同，不是整个数据集的10%
    if flag==1
        
        if train>1
            cTrain = ceil(train);
        else
            cTrain  = ceil(train*ci);
        end
    else
        cTrain = train;  %Pavia和Salina
    end
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    cTest  = ci-cTrain;
    %===============================
    tt_label_i = uint8(ones(1,cTest))*i;
    tt_label = [tt_label tt_label_i];
    %===============================
    CTrain = [CTrain cTrain];
    CTest = [CTest cTest];
    
    index = randpp{i};
    
    DataTest = [DataTest; datai(index(1:cTest),:)];
    DataTrain = [DataTrain; datai(index(cTest+1:cTest+cTrain),:)];
    %=================================================================
    label_c = find(label == i); %返回x中非零元素的序号从标签从1开始的索引
    random_index = label_c(index(:,1:cTest));%将每类的标签打乱顺序
    
    temp = ind(random_index);%返回训练样本的索引值
    tt_index = [tt_index temp];
    %=================================================================
    
end


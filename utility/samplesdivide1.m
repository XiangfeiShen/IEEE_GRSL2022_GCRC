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
[mm,nn] = ind2sub([m n],1:m*n);     %����ȷ����Ч���±�ֵ ����һ��M��N�е����� ����������������н�������һ������
data_col = [mm' nn' data_col];
%========================================
ind = [];
label = [];
im_gt_1d = im_gt;
for x = 0:1:max(indian_pines_gt(:)),
    index_t =  find(im_gt_1d == x);%ÿһ������
    ind = [ind index_t];
    
    label_t = uint8(ones(1,length(index_t)))*x;%ÿһ���ǩ
    label = [label label_t];
end
%========================================
for i = 1:max(indian_pines_gt(:))
    
    ci = length(find(indian_pines_gt==i));
    datai = data_col(find(indian_pines_gt==i),:);
    % %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % indian :��Pavia��Salina������  ÿ��ѵ������ȡ����30�� ʣ���Ϊ��������    ��Indian��ͬ�������������ݼ���10%
    if flag==1
        
        if train>1
            cTrain = ceil(train);
        else
            cTrain  = ceil(train*ci);
        end
    else
        cTrain = train;  %Pavia��Salina
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
    label_c = find(label == i); %����x�з���Ԫ�ص���Ŵӱ�ǩ��1��ʼ������
    random_index = label_c(index(:,1:cTest));%��ÿ��ı�ǩ����˳��
    
    temp = ind(random_index);%����ѵ������������ֵ
    tt_index = [tt_index temp];
    %=================================================================
    
end


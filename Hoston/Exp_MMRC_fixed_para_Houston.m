%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%  STRUCTURED COLLABORATIVE REPRESENTATION FOR HYPERSPECTRAL CLASSFICATION
%       AUTHOR: xfshen95@163.com
%               EXP: Parameter Setting
%
%
%
%
%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

clc;
close all;
clear;
statistics = [];%统计 OA,kappa,AA,CA
% for T=3:2:11
% India  data

results=[];

load Houston;load Houston_gt ;load Houston_randp;%纹理%如果?filename?�?MAT 文件，load(filename)?会将 MAT 文件中的变量加载�?MATLAB??工作�?

data=Houston;
gth=Houston_gt;

% max_label=max(max(Houston_gt));
% randp=cell(1,10);
% for i=1:10
%
%     for j=1:max_label
%         Num=length(find(Houston_gt==j));
%         randp{i}{1,j}=randperm(Num,Num);
%
%     end
% end
%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


% smoothing
for i=1:size(data,3);             %返回矩阵的波段数   1:�? 2：列
    data(:,:,i) = imfilter(data(:,:,i),fspecial('average',3));%imfilter:多维度滤波器   平均滤波器：大小�?*7
end
%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
[nr,nc,nb]=size(data);%==================

data=reshape(data,nr*nc,nb)';
data=data/max(max(max(data)));
data=reshape(data',nr,nc,nb);

%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

Map=cell(15,15);

flag=0;
ratio = 60;
%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


lambda=4e-8;


aux_results_multiple=[];
aux_results=[];
for iter = 1:10
    
    %======================================
    im_gt_1d = reshape(gth,1,nr*nc);
    %======================================
    randpp=randp{iter};
    
    % 随机将数据化分为训练集和测试�?
    [DataTest, DataTrain,CTest,CTrain,data_col,tt_label,tt_index] = samplesdivide1(data,gth,ratio,randpp,im_gt_1d,flag);
    %%
    tic
    class = sccr(DataTrain, CTrain, DataTest, lambda);
    
    %class = NRS_Classification(DataTrain, CTrain, DataTest, lambda);
    toc
    
    %% ===============================================================================
    [OA,kappa,AA,CA] = calcError(tt_label-1, class-1, 1: max(gth(:)));
    % %
    aux_results = [lambda OA kappa AA CA'];
    aux_results_multiple = [aux_results_multiple;aux_results];
    
    fprintf('\n %dth iteration---OA: %f--- AA: %f---Kappa: %f ---[lambda: %f] \n', iter, OA, AA, kappa, lambda);
    for i = 1:1:length(class)%没有加二次判�?
        im_gt_1d(tt_index(i)) = class(i); %没有加二次判�?
        %                 im_gt_1d(tt_index(i)) = class_finally(i); %---------------------
    end
    
    result_map = reshape(im_gt_1d,nr,nc);
    
    %     [row,col] = size(result_map);
    %     load mycmap
    %     figure('name','im_map'),set(gcf,'Position',[5,5,col,row],'color','w');
    %     set(gca,'position',[0 0 1 1]);
    %     imagesc(result_map)           %imagesc(A) 将矩阵A中的元素数�?按大小转化为不同颜色，并在坐标轴对应位置处以这种颜色染色
    %     colormap(mycmap)
    
end
results=[results;mean(aux_results_multiple)];
% Map{ii_lambda,ii_gamma}=result_map;
fprintf('---- Iteration scenarios. lambda %i gamma %i----\n',lambda);








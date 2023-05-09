%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%  STRUCTURED COLLABORATIVE REPRESENTATION FOR HYPERSPECTRAL CLASSFICATION
%       AUTHOR: xfshen95@163.com
%               EXP: BASIC EXPERIMENT (PARAMETERS FIXED)
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

load Indian_pines_corrected;load Indian_pines_gt;load Indian_pines_randp ;%纹理%如果?filename?�? MAT 文件，load(filename)?会将 MAT 文件中的变量加载�? MATLAB??工作�?
data = indian_pines_corrected;
gth  = indian_pines_gt;
%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


% smoothing
for i=1:size(data,3);             %返回矩阵的波段数   1:�?  2：列
    data(:,:,i) = imfilter(data(:,:,i),fspecial('average',5));%imfilter:多维度滤波器   平均滤波器：大小�?7*7
end
%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
[nr,nc,nb]=size(data);%==================

data=reshape(data,nr*nc,nb)';
data=data/max(max(max(data)));
data=reshape(data',nr,nc,nb);
%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
[m, n]=ind2sub([nr, nc], 1:nr*nc);
odi=[m',n'];
Data=[odi,reshape(data,nr*nc,nb)];
%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
results=[];
Map=cell(15,15);


lambda=1e-6;
gamma=5e-6;


ratio = 0.1;
flag=1;
%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

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
    %class = gcrc(DataTrain, CTrain, DataTest, 1e-6,4e-7, 2e-7);
    class = sccr(DataTrain, CTrain, DataTest, 1e-6);
    toc
    
    %% ===============================================================================
    [OA,kappa,AA,CA] = calcError(tt_label-1, class-1, 1: max(gth(:)));
    % %
    aux_results = [lambda gamma OA kappa AA CA'];
    aux_results_multiple = [aux_results_multiple;aux_results];
    
    fprintf('\n %dth iteration---OA: %f--- AA: %f---Kappa: %f ---[lambda: %f, gamma: %f]\n', iter, OA, AA, kappa, lambda,gamma);
    for i = 1:1:length(class)%没有加二次判�?
        im_gt_1d(tt_index(i)) = class(i); %没有加二次判�?
        %                 im_gt_1d(tt_index(i)) = class_finally(i); %---------------------
    end
    
    result_map = reshape(im_gt_1d,nr,nc);
    
    [row,col] = size(result_map);
    %load mycmap
    figure('name','im_map'),set(gcf,'Position',[5,5,col,row],'color','w');
    set(gca,'position',[0 0 1 1]);
    imagesc(result_map)           %imagesc(A) 将矩阵A中的元素数�?�按大小转化为不同颜色，并在坐标轴对应位置处以这种颜色染�?
    %colormap(mycmap)
    box on
    axis off
    xx=result_map;
    
end
results=[results;mean(aux_results_multiple)];
% Map{ii_lambda,ii_gamma}=result_map;
fprintf('---- Iteration scenarios. lambda %i gamma %i----\n',lambda,gamma);


%  end
%end




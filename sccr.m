function class = sccr(DataTrains, CTrain, DataTests, lambda)

% Grouped Collaborative Representation for Hyperspectral Image Classification Using a Two-Phase Strategy
% 
% [GCR] Xiangfei Shen, Wenxing Bao*, Hongbo Liang, Xiaowu Zhang, and Xuan Ma,
%"Grouped Collaborative Representation for Hyperspectral Image Classification Using a Two-Phase Strategy", 
% IEEE Geoscience and Remote Sensing Letters, 2021, 19: 1-5..
%
% -------------------------------------------------------------------
%
% Usage:
%
% class = sccr(DataTrains, CTrain, DataTests, lambda)
%
% ---------------------------------------------------------------------
%
% Please see [GCRC] for more details.
%
% Please contact Xiangfei Shen (xfshen95@163.com) to report bugs or 
% provide suggestions and discussions for the codes.
%
% ---------------------------------------------------------------------
% version: 1.0 (27-Jul-2022)
% ---------------------------------------------------------------------
%
% Copyright (Oct., 2022):       Xiangfei Shen (xfshen95@163.com/xfshen95@outlook.com)
%
% GCRC is distributed under the terms of
% the GNU General Public License 2.0.
%
% Permission to use, copy, modify, and distribute this software for
% any purpose without fee is hereby granted, provided that this entire
% notice is included in all copies of any software which is or includes
% a copy or modification of this software and in all copies of the
% supporting documentation for such software.
% This software is being provided "as is", without any express or
% implied warranty.  In particular, the authors do not make any
% representation or warranty of any kind concerning the merchantability
% of this software or its fitness for any particular purpose."
% ---------------------------------------------------------------------


DataTrain = DataTrains(:,3:end);
DataTest  = DataTests(:,3:end);

DDT = DataTrain*DataTrain';
A=DataTrain';
numClass = length(CTrain);
[m Nt]= size(DataTest);
for j = 1: m
    
    if mod(j,round(m/20))==0
        fprintf('*...');
    end

    
    Y = DataTest(j, :); % 1 x dim
    

    norms = clcSpeCor(Y,DataTrain);
    
    G = diag(lambda.*norms);
    
    
    weights = (DDT + G)\(DataTrain*Y');
    
    a = 0;
    for i = 1: numClass
        % Obtain Multihypothesis from training data
        HX = DataTrain((a+1): (CTrain(i)+a), :); % sam x dim
        HW = weights((a+1): (CTrain(i)+a));
        a = CTrain(i) + a;
        Y_hat = HW'*HX;
        
        Dist_Y(j, i) = norm(Y - Y_hat);
    end
    Dist_Y(j, :) = Dist_Y(j, :)./sum(Dist_Y(j, :));
end
[~, class] = min(Dist_Y');
end


function SIDSAD=clcSpeCor(r,X)

[N,L]=size(X);
SIDSAD=zeros(1,N);

for i=1:N
    
    SIDSAD(i)=hyperSIDSAD(r',X(i,:)');
    
end
aux=SIDSAD.^2;
SIDSAD=aux./min(aux);


end
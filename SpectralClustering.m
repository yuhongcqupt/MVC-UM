function [ groups ] = SpectralClustering( CKSym,n )
%UNTITLED 此处显示有关此函数的摘要
%输入：CKSym 相似度矩阵  n:类簇个数
%   输出 最终每个样本的label
warning off;
N = size(CKSym,1); %获取样本的个数
Maxiter = 1000;%谱聚类最大迭代次数?1000
replic = 20; % Number of replications for KMeans

% using Normalized Symmetric Laplacian L = I - D^{-1/2} W D^{-1/2}
% 计算归一化的拉普拉斯矩阵
DN = diag( 1./sqrt(sum(CKSym)+eps) );
LapN = speye(N) - DN * CKSym *DN;
[uN,sN,vN] = svd(LapN);
kerN = vN(:,N-n+1:N);
for i = 1:N
    kerNS(i,:) = kerN(i,:) ./ norm(kerN(i,:)+eps);
end
groups = kmeans(kerNS,n,'maxiter',Maxiter,'replicates',replic,'EmptyAction','singleton');

end


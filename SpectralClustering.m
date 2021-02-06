function [ groups ] = SpectralClustering( CKSym,n )
%UNTITLED �˴���ʾ�йش˺�����ժҪ
%���룺CKSym ���ƶȾ���  n:��ظ���
%   ��� ����ÿ��������label
warning off;
N = size(CKSym,1); %��ȡ�����ĸ���
Maxiter = 1000;%�׾�������������?1000
replic = 20; % Number of replications for KMeans

% using Normalized Symmetric Laplacian L = I - D^{-1/2} W D^{-1/2}
% �����һ����������˹����
DN = diag( 1./sqrt(sum(CKSym)+eps) );
LapN = speye(N) - DN * CKSym *DN;
[uN,sN,vN] = svd(LapN);
kerN = vN(:,N-n+1:N);
for i = 1:N
    kerNS(i,:) = kerN(i,:) ./ norm(kerN(i,:)+eps);
end
groups = kmeans(kerNS,n,'maxiter',Maxiter,'replicates',replic,'EmptyAction','singleton');

end


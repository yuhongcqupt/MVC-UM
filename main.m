folder_now = pwd;  addpath([folder_now, '\ClusteringMeasure']);
load('orl.mat');
load('orl_y.mat');
v = 2; n ={};d={};
for a = 1:v
    [n{a},d{a}] = size(X{a});
end;
removw_level = 0;
[ X,y,mappings ] = processData( X,y,[removw_level,removw_level]);
cls_num = max(y{1});
map = {};
map{1,2} = located(mappings,1,2);
map{1,1} = zeros(1,1);
[W,H,P] = DGUMMVC_orl(X,map,y,cls_num);
for a = 1:v
    disp(sprintf('generate the clustering result of view %d.......\n',a));
    C = kmeans(H{a},cls_num,'maxiter',1000,'replicates',20,'EmptyAction','singleton');
    [A nmi avgent] = compute_nmi(y{a},C);
    acc = Accuracy(C,double(y{a}));
    [f,p,r] = compute_f(y{a},C);
    [AR,RI,MI,HI]=RandIndex(y{a},C);
    disp(sprintf('acc: %f.......\n',acc));
    disp(sprintf('nmi: %f.......\n',nmi));
end
disp(sprintf('generate the macc@q according to P...'));
a1 = mappingsACC(P{1,2},map{1,2},1);
a2 = mappingsACC(P{1,2},map{1,2},3);
a3 = mappingsACC(P{1,2},map{1,2},10);
disp(sprintf('MACC@1 %f.......\n',a1));
disp(sprintf('MACC@3 %f.......\n',a2));
disp(sprintf('MACC@10 %f.......\n',a3));

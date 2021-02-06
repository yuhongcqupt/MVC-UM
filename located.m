function [ map ] = located( mappings,a,b)
%LOCATED 此处显示有关此函数的摘要 定位视图1到视图2中的映射位置
%   mappings{1}  mappings{2}  .. a,b 计算
n = size(mappings{a},2);
map = zeros(1,n);
for i = 1 :n
    for j =1:n
        if mappings{a}(1,i) == mappings{b}(1,j)
            map(1,i) = j;
            break;
        end
    end
    
end
end


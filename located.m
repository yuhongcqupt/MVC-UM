function [ map ] = located( mappings,a,b)
%LOCATED �˴���ʾ�йش˺�����ժҪ ��λ��ͼ1����ͼ2�е�ӳ��λ��
%   mappings{1}  mappings{2}  .. a,b ����
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


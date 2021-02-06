function [ datas, labels, mappings ] = processData( raw_data,y,levels )
n_views = size(raw_data,2); 
for a = 1 : n_views 
   raw_data{a} = [ raw_data{a},y{a}]; 
end
mappings ={};
labels = {};
datas = {};
for a = 1 : n_views 
    n_view_a = size(raw_data{a}, 1);
    d_view_a = size(raw_data{a}, 2);
    mapping = randperm(n_view_a); 
    datas{a} = zeros(size(raw_data{a}));
    for i = 1:n_view_a
       datas{a}(i,:) = raw_data{a}(mapping(i),:);
    end
    n_view_a = ceil(n_view_a - n_view_a * levels(a));
    datas{a} = datas{a}(1:n_view_a,:);
    labels{a} = datas{a}(:,end);
    datas{a} = datas{a}(1:n_view_a,1:end-1);
    mappings{a} = mapping(1:n_view_a);
end
end


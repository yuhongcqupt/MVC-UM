
function [ W,H,P] = DGUMMVC_orl( datas, map, y,cls_num)
disp(sprintf('initialize.......'));
cnt_views = size(datas,2);
IsConverge = 0;
X = {}; 
n_views = {};
d_views = {};
H = {};
W = {};
P = {};
dim = 90;
alpha = 1e-3;
beta =1e2;
tau =1;
MAX_ITER = 3000;
for a = 1 : cnt_views
    X{a} = datas{a};% N x d
    n_views{a} = size(X{a},1);
    d_views{a} = size(X{a},2);
    X{a} = X{a}';% d x N
%     temp_X = repmat(sqrt(sum(X{a}.^2,2)),1,size(X{a},2));
%     X{a} = X{a}./temp_X; 
    T = sort(X{a},2,'descend');
    mmax = repmat(T(:,1),1,n_views{a});
    minx =repmat( T(:,end),1,n_views{a} );
    X{a} = (X{a} - minx)./(mmax-minx);
end
for a = 1: cnt_views
    S{a} = L2_distance_1(X{a},X{a});
    W{a} = rand(d_views{a},dim);
    H{a} = rand(n_views{a},dim);
    for b = a :cnt_views
        P{a,b} = ones(n_views{a},n_views{b});
        P{b,a} = P{a,b}';
    end
end
num_para = 11;
results = zeros(MAX_ITER,num_para);
cnt_convergence = 0;
thrsh = 1e-6;
iter = 1
last_cg{1} = 0;
last_cg{2} = 0;
while(IsConverge ==0 && iter<MAX_ITER+1)
    disp(sprintf('iteraton:%d.......\n',iter));
    for a = 1 :cnt_views
        T = (X{a}*H{a})./(W{a}*H{a}'*H{a});
        W{a} = W{a}.*T;
        W{a}(find(isnan(W{a}))) = 0;
    end
    for a = 1 :cnt_views
        D_X = diag(sum(S{a},1));
        V = zeros(n_views{a},dim);
        for b = 1 :cnt_views
            if b~=a
                V = V + P{a,b}*H{b};
            end
        end
        T1 = 2*X{a}'*W{a} + 2*beta*V + (S{a} + S{a}')*H{a}; 
        T2 = H{a}*W{a}'*W{a} + 2*tau*(D_X+D_X') *H{a} + 2* beta * cnt_views*H{a};
        H{a} = H{a}.* (T1./T2);     
    end
    for a = 1 :cnt_views
         for b = a: cnt_views
            if a ~= b
                T1 = 2*beta*H{a}*H{b}'+alpha * (S{a}*P{a,b}*S{b}'+S{a}'*P{a,b}*S{b}');
                T2 = 2*alpha * ( S{a}*P{a,b}*P{a,b}'*S{a} + S{a}'*P{a,b}*P{a,b}'*S{a}')*P{a,b} + 2*beta*P{a,b}*H{b}*H{b}';
                P{a,b} = P{a,b}.* (T1./T2);
                P{b ,a}= P{a,b}';
            end
         end
    end
    if (iter==1)
        for a = 1 :cnt_views
            results(iter,(a-1)*4+1) = norm(X{a}-W{a}*H{a}',inf);
            last_cg{a} = results(iter,(a-1)*4+1);
        end
        iter = iter + 1
    end
    cnt = 0;
    for a = 1 :cnt_views
        results(iter,(a-1)*4+1) = norm(X{a}-W{a}*H{a}',inf);
        if ( abs(results(iter,(a-1)*4+1)-last_cg{a}) <thrsh )
            cnt = cnt+1;
            last_cg{a} = results(iter,(a-1)*4+1);
        end
    end
    if (cnt ==cnt_views )
        cnt_convergence = cnt_convergence + 1;
    else
        cnt_convergence = 0;
    end
    if(cnt_convergence == 10)
       return; 
    end
    iter = iter + 1;
end
end


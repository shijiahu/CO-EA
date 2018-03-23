
for w = 1:50
FV = cell(100,3);
for i = 1:100
    c = randperm(20);
    parent1 = subp(1,i).neighbour(c(1),1);%在每个染色体中邻域中选两个来做种群的父母----标号
    parent2 = subp(1,i).neighbour(c(2),1);
    
    %汉明距离
    d = pdist2(child{1,parent2},child{1,parent1},'hamming');
    e = d(1:15,1:15);
    f = find(e == 0);
    
    if w<2 
        %自适应-----两个相似度差异大的进行接下来的交叉变异
        while corr2(child{1,parent2}(1:20,1:20),child{1,parent1}(1:20,1:20))>0.7 || length(f)>5
            c = randperm(20);
            parent1 = subp(1,i).neighbour(c(1),1);%在每个染色体中邻域中选两个来做种群的父母----标号
            parent2 = subp(1,i).neighbour(c(2),1);

            d = pdist2(child{1,parent2},child{1,parent1},'hamming');
            e = d(1:9,1:9);
            f = find(e == 0);
        end
    end
    %——————————————————————交叉变异————————————————————————

    if rand()<elasticrate
        %部分交换%交叉        
        
        a = randperm(carnum(1,parent1));%父母1随机选择一条路线1
        b = randperm(carnum(1,parent2));%父母2随机选择一条路线2  
       
                             
        child{1,parent1} = [child{1,parent2}(b(1),:);child{1,parent1}];%交叉完成没有删除重复元素
       % child{1,parent1}(25,:) = [];
        child{1,parent2} = [child{1,parent1}(a(1),:);child{1,parent2}];%这两条路线都是加到了第一行
      %  child{1,parent2}(25,:) = [];
        %删除重复值
        numm = zeros(1,25);%临时存放个体看看有没有重复的------父母1处理--------------------------------
        j =1;
        count1 = 1;
        count2 = 1;
        count3 = 1;
        while count1<carnum(1,parent1)+5
            %disp(count1);
            temp = child{1,parent1}(count1,count2);
            if temp ~= 0
                if any(numm == temp)%判断有没有重复值，有的话后面的元素前移
                    child{1,parent1}(count1,count2:24) = child{1,parent1}(count1,(count2+1):25);                    
                else
                    numm(1,j) = temp;
                    j = j + 1;
                    count2 = count2 + 1;
                end                
                count3 = count3 + 1;
            else
                count1 = count1 + 1;
                count2 = 1;
            end
        end
        numm = zeros(1,25);%临时存放个体看看有没有重复的------父母2处理------------------------------------
        j =1;
        count1 = 1;
        count2 = 1;
        count3 = 1;
        while count1<=(carnum(1,parent2)+5)
            temp = child{1,parent2}(count1,count2);
            if temp ~= 0
                if any(numm == temp)%判断有没有重复值，有的话后面的元素前移
                    child{1,parent2}(count1,count2:24) = child{1,parent2}(count1,(count2+1):25);                    
                else
                    numm(1,j) = temp;
                    j = j + 1;
                    count2 = count2 + 1;
                end                
                count3 = count3 + 1;
            else
                count1 = count1 + 1;
                count2 = 1;
            end
        end
        %去掉全零行
        for q = 1 : 3
            for k = 1:20
                if child{1,parent1}(k,1) == 0 && child{1,parent1}(k+1,1) ~= 0
                     child{1,parent1}(k:19,:) = child{1,parent1}(k+1:20,:); 
                end
                if child{1,parent2}(k,1) == 0 && child{1,parent2}(k+1,1) ~= 0
                     child{1,parent2}(k:19,:) = child{1,parent2}(k+1:20,:); 
                end
            end
        end
    end
    if rand()<squeezerate
        %————————————————————合并最短路线——————————————————
               
        c = 0;%--------------------------处理1
        for k = 1:20
            if c>0 && child{1,parent1}(k,1) ~= 0 && child{1,parent1}(k,2) == 0
                c = c+1;
                child{1,parent1}(temp,c) = child{1,parent1}(k,1);
                child{1,parent1}(k,:) = 0;
            elseif c == 0 && child{1,parent1}(k,1) ~= 0 && child{1,parent1}(k,2) == 0%一条路线上只有一个节点
                 c = 1;
                 temp = k;
            end            
        end
        c = 0;%--------------------------处理2
        for k = 1:20
            if c>0 && child{1,parent2}(k,1) ~= 0 && child{1,parent2}(k,2) == 0
                c = c + 1;
                child{1,parent2}(temp,c) = child{1,parent2}(k,1);
                child{1,parent2}(k,1) = 0;
            elseif c == 0 && child{1,parent2}(k,1) ~= 0 && child{1,parent2}(k,2) == 0%一条路线上只有一个节点
                 c = 1;
                 temp = k;
            end            
        end
        %------------------------------去掉全零行
        for q = 1:10
            for k = 1:20
                if child{1,parent1}(k,1) == 0 && child{1,parent1}(k+1,1) ~= 0
                     child{1,parent1}(k:20,:) = child{1,parent1}(k+1:21,:); 
                end
                if child{1,parent2}(k,1) == 0 && child{1,parent2}(k+1,1) ~= 0
                     child{1,parent2}(k:20,:) = child{1,parent2}(k+1:21,:); 
                end
            end
        end
    end%——————————————————————————————————————
    
    if rand()<shufflerate
        %---------------------------------------------随机洗牌---------------------------------------------
        
    end
    
    %——————————更新参考点z——————————————
    
    [dis1,tim1,remu1,count1] = rsm2(child,cus,parent1);
    if idealz(1,2) > dis1(1,1) && idealz(2,2) > remu1
        idealz(1,2) = dis1(1,1);
        idealz(2,2) = remu1;
        idealz(1,1) = parent1;
        idealz(2,1) = parent1;
    %    disp(idealz);
    end
    [dis2,tim2,remu2,count2] = rsm2(child,cus,parent2);
    if idealz(1,2) > dis2(1,1) && idealz(2,2) > remu2
        idealz(1,2) = dis2(1,1);
        idealz(2,2) = remu2;
        idealz(1,1) = parent2;
        idealz(2,1) = parent2;
%         disp(idealz);
    end
    %—————————————————————————————
    
    if dis1(1,1) < dis2(1,1) && remu1 < remu2
        temp1 = dis1(1,1);
        temp2 = remu1;
    elseif  dis1(1,1) > dis2(1,1) && remu1 > remu2
        temp1 = dis2(1,1);
        temp2 = remu2;
    else
        temp1 = 0;
        temp2 = 0;
    end
    
    if temp1==0 && temp2==0
        continue;
    end
    %—————————更新邻域解————————————————
    %就是在parent1和2的邻域范围内的每一个个体-----20个
    %
    for j = 1:20
        parent = subp(1,i).neighbour(j,1);%在种群的邻域中的标号1-20
        weight1 = subp(1,parent).weight(1,1);%标号的权重
        weight2 = subp(1,parent).weight(2,1);
        if weight1 == 0;
            weight1 = 0.00001;
        elseif weight2 == 0;
            weight2 = 0.00001;
        end
%         [dis1,tim1,remu1,count1] = rsm2(child,cus,parent);  %20个每个轮一遍
        [dis,tim,remu,count3] = rsm2(child,cus,i);%一直不变
        part1 = abs(temp1-idealz(1,2));      
        part2 = abs(temp2-idealz(2,2));
        part3 = abs(dis(1,1)-idealz(1,2)); %种群的个体  i     
        part4 = abs(remu-idealz(2,2));
        if max(weight1*part1,weight2*part2)<=max(weight1*part3,weight2*part4)
            %把前面的给后面
%             if  isempty(FV{i,1})
%                 FV{i,1} = child{1,parent};
%                 FV{i,2} = temp1;
%                 FV{i,3} = temp2;
%                 ccc = ccc + 1;
%             end
%             if FV{i,2} > temp1 && FV{i,3} > temp2
                child{1,i} =  child{1,parent}; 
                FV{i,1} = child{1,i};
                FV{i,2} = temp1;
                FV{i,3} = temp2;
                ccc = ccc + 1;
%             end
            
        end
    end   
    
    %——————————————————————————————
end



end

for i = 1:100
    if isempty(FV{i,1})
        FV{i,1} = child{1,i};
        [dis2,tim2,remu2,count2] = rsm2(child,cus,i);
        FV{i,2} = dis2(1,1);
        FV{i,3} = remu2;
    end
end





% childchild = child1(1,1:50);
% child1(1,1:50) = child2(1,51:100);
% child2(1,51:100) = child3(1,1:50);
% child3(1,1:50) = child4(1,1:50);
% child4(1,1:50) = childchild;

%再分别让child1-4迭代五代

% childchild = {child1;child2;child3;child4};

% % % 
%SP==算是失败吧==
FV1 = FV(:,2:3);
FV1 = cell2mat(FV1);
FV1 = unique(FV1,'rows');
n = length(FV1);
d = zeros(1,20);
e = zeros(1,n-1);

for i = 1 : n-1
    d = zeros(1,20);
    for j = 1:20        
        temp = subp(1,i).neighbour(j,1);
        if temp>n 
            d(j) = e(i-1);
        else
            d(j) = abs(FV1(i,1)-FV1(temp,1))+abs(FV1(i,2)-FV1(temp,2));
        end
    end
    e(i) = min(d(1,2:20));
end

summ1 = 0;
for i = 1:n-1
    summ1 = summ1 + e(i)*e(i);
end

GD = sqrt(summ1)/(n-1);

ee = e<50;
eee = zeros(1,30);
t = 1;
for i  = 1:n-1
    if ee(i) == 1
        eee(1,t) = e(i);
        t = t + 1;
    end
end

n = t;

summ = 0;
avg = mean(eee(1,1:t-1));
for i = 1:n-1
    summ = summ + (avg-eee(1,i))*(avg-eee(1,i));
end

S = sqrt(summ/(n-1));


%算标准差
min(FV1(:,1))
max(FV1(:,1))
min(FV1(:,2))
max(FV1(:,2))
avg1 = mean(FV1(:,2));
avg2 = mean(FV1(:,1));


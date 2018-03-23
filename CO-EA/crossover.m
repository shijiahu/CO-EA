function child = crossover( child,carnum,parent)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here


    numm = zeros(1,25);%临时存放个体看看有没有重复的------父母1处理--------------------------------
    j =1;
    count1 = 1;
    count2 = 1;
    count = 1;
    while count1<=(carnum(1,parent)+1)
        temp = child{1,parent}(count1,count2);
        if temp ~= 0
            if any(numm == temp)%判断有没有重复值，有的话后面的元素前移
                child{1,parent}(count1,count2:24) = child{1,parent}(count1,(count2+1):25);                    
            else
                numm(1,j) = temp;
                j = j + 1;
                count2 = count2 + 1;
            end                
            count = count + 1;
        else
            count1 = count1 + 1;
            count2 = 1;
        end
    end
    %去掉全零行
    for k = 1:20
        if child{1,parent}(k,1) == 0 && child{1,parent}(k+1,1) ~= 0
             child{1,parent}(k:23,:) = child{1,parent}(k+1:24,:); 
        end
    end
end


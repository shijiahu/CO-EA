function [ distancefee,timespan,remuneration,count1 ] = rsm2( chrosm,cus,j  )
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here


    distancefee = zeros(1,10);
 

    Qt = zeros(1,100);%记录故障时间
    Qd = zeros(1,100);%记录故障时间

    timespan = 0;
    

    pe = 0.2;%早到
    pee = 0.3;%晚到
    
    %RSM评价目标值方法
    N = 10;           

        nowtime = 0;%记录目前的时间----------------------------要改+.+         

        for k = 1 : N
            cus.randemand = zeros(25);
            cus.sigma = zeros(25);
            cus.sigma = (1/3*cus.u).*rand;
            cus.randemand = abs(floor(normrnd(cus.u,cus.sigma)));%随机第1-N遍需求
            count1 = 1;%加一条路线
            count2 = 1;%加一个节点
            count = 0;
            capacitycount = 0;%记录判断容量约束

            %indi1 = chrosmosome{1,j}(count1,count2);
            while count~=25%判断是否25个客户都算完了------这一个循环是一个染色体的路线-------
                while chrosm{1,j}(count1,count2)%不是0的情况下-----这一个循环处理是一条路线的------
                    indi1 = chrosm{1,j}(count1,count2);
                    if count2 == 1%是一条路线的第一个节点
                        distancefee(1,k) = distancefee(1,k) + distancexy(cus,indi1,0);%计算到仓库的距离 
                        nowtime = max(cus.earlyt(indi1),distancexy(cus,indi1,0));
                        if nowtime<cus.earlyt(indi1)
                            Qt(1,j) = Qt(1,j)+pe*(cus.earlyt(ind1) - nowtime);%记录故障等待时间
                       elseif nowtime>cus.latet(indi1)
                            Qt(1,j) = Qt(1,j)+pee*(nowtime - cus.latet(indi1) );%记录故障等待时间
                       end        
                    else                    
                        indi2 = chrosm{1,j}(count1,count2-1);
                        distancefee(1,k) = distancefee(1,k) + distancexy(cus,indi1,indi2);%计算到前一个节点的距离

                        nowtime = max(cus.earlyt(indi1),distancexy(cus,indi1,indi2)+10+nowtime);%在后者开始的时间————————————————————————————

                        if nowtime<cus.earlyt(indi1)
                            Qt(1,j) = Qt(1,j)+pe*(cus.earlyt(indi1) - nowtime);%记录故障等待时间
                       elseif nowtime>cus.latet(indi1)
                            Qt(1,j) = Qt(1,j)+pee*(nowtime - cus.latet(indi1) );%记录故障等待时间
                       end        
                        %disp(distancefee{1,1}(1,k));

                    end
                    capacitycount = capacitycount + cus.randemand(indi1);
                    if capacitycount > 200

                        Qd(1,k) = Qd(1,k) + distancexy(cus,indi1,0)*2;
                    end
                    
                    count2 = count2 + 1;
                    
                    count  = count + 1;
                end
%                 if count2 == 1
%                     indi1 = chrosm{1,j}(count1,count2);
%                 else
%                     disp(count2);
%                     disp(j)
                    indi1 = chrosm{1,j}(count1,count2-1);%——————————————————————————
                    
%                     disp(indi1);
%                 end
                
                distancefee(1,k) = distancefee(1,k) + distancexy(cus,indi1,0);
                count1 = count1 + 1; 
                count2 = 1;
                capacitycount = 0;%记录判断容量约束
                nowtime = 0;
            end

        end

        timespan = timespan + distancefee(1,k) + Qt(1,j)+10*25;%————————————————————————————
        if timespan <= 6000%25个人的四个小时
            remuneration = 10*timespan;            
        else
            remuneration = 80+20*(timespan-6000);   
        end
   
end


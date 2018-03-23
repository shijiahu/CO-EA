function [distancefee,timespan,remuneration] = rsm( chrosm,cus,Qt,j )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

    %每条染色体的每条路线都要算出来
    % distancefee = {zeros(25,10)};
    % distancefee = repmat(distancefee,1,100);
    distancefee = zeros(1,10);
    %持续时间
%     timespan = zeros(1,100);
%     remuneration = zeros(1,100);
    %司机报酬

    %Qt = zeros(1,100);%记录故障时间
    Qd = zeros(1,100);%记录故障时间

    %每条染色体的每条路线都要算出来
    % distancefee = {zeros(25,10)};
    % distancefee = repmat(distancefee,1,100);
%     distancefee = zeros(100,10);
    %持续时间
    timespan = 0;
    %remuneration = 0;
    %司机报酬

    
    
    %RSM评价目标值方法
    N = 10;
    %for j = 1 : 100

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
                        if count2 == 1
                            distancefee(1,k) = distancefee(1,k) + distancexy(cus,indi1,0);%计算到仓库的距离 
                        else                    
                            indi2 = chrosm{1,j}(count1,count2-1);
                            distancefee(1,k) = distancefee(1,k) + distancexy(cus,indi1,indi2);%计算到仓库的距离
                            %disp(distancefee{1,1}(1,k));
                        end
                        capacitycount = capacitycount + cus.randemand(indi1);
                        if capacitycount > 200

                            Qd(1,k) = Qd(1,k) + distancexy(cus,indi1,0)*2;
                        end
                        count2 = count2 + 1;
                        count  = count + 1;
                    end
                    indi1 = chrosm{1,j}(count1,count2-1);
                    distancefee(1,k) = distancefee(1,k) + distancexy(cus,indi1,0);
                    count1 = count1 + 1; 
                    count2 = 1;
                    capacitycount = 0;%记录判断容量约束
                end            
            end
            timespan = timespan + distancefee(1,k) + Qt(1,j)+90*25;
            if timespan <= 6000%25个人的四个小时
                remuneration = 10*timespan;            
            else
                remuneration = 80+20*(timespan-6000);   
            end
   % end
end


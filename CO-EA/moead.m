function pareto = moead( mop, varargin)
%   MOEAD runs moea/d algorithms for the given mop.
%   Detailed explanation goes here
%   The mop must to be minimizing.--------mop是多目标，最小化它
%   The parameters of the algorithms can be set through varargin.---所有变量
%   包括：
%   popsize: The subproblem's size.子问题的大小---------种群大小
%   niche: the neighboursize, must less then the popsize.---------------邻域大小
%   iteration: the total iteration of the moead algorithms before
%   finish.--------------- 一共迭代多少次200次
%   method: the decomposition method, the value can be 'ws' or 'ts'.
%   分解的方法（应该一个是权重分布，一个是切比雪夫）


    starttime = clock;

    %global variable definition.------全局变量（这五个都是）
    global params idealpoint objDim parDim itrCounter;
    
    %set the random generator.随机数产生器----无论多少次都是一样的结果
    rand('state',10);
    
    %Set the algorithms parameters.-----设置算法的参数
    paramIn = varargin;
    [objDim, parDim, idealpoint, params, subproblems]=init(mop, paramIn);   %用初始化函数初始化这五个参数od=2；pd=30
    
    itrCounter=1;
    while ~terminate(itrCounter)%判断停止时间
        tic;
        subproblems = evolve(subproblems, mop, params);%进化--这里的mop应该已经变成1*101的了
 %       disp(sprintf('iteration %u finished, time used: %u', itrCounter, toc));%tic用来保存当前时间，而后使用toc来记录程序完成时间
        itrCounter=itrCounter+1;
    end
    
    %display the result.
    pareto=[subproblems.curpoint];
    pp=[pareto.objective];
    scatter(pp(1,:), pp(2,:));
  %  disp(sprintf('total time used %u', etime(clock, starttime)));
end

function [objDim, parDim, idealp, params, subproblems]=init(mop, propertyArgIn)
%Set up the initial setting for the MOEA/D.------------------------------------------------初始化函数！！！！！！
    objDim=mop.od;%2
    parDim=mop.pd;%30    
    idealp=ones(objDim,1)*inf;      %inf是无穷大=.=
    
    %the default values for the parameters.---------参数的默认值
    params.popsize=100;params.niche=30;params.iteration=100;
    params.dmethod='ts';
    params.F = 0.5; %F和CR又是什么？？？是变异率那种?
    params.CR = 0.5;
    
    %handle the parameters, mainly about the
    %popsize-------处理参数，按照demo重新赋值，主要关注popsize
    while length(propertyArgIn)>=2
        prop = propertyArgIn{1};
        val=propertyArgIn{2};
        propertyArgIn=propertyArgIn(3:end);

        switch prop
            case 'popsize'
                params.popsize=val;
            case 'niche'
                params.niche=val;
            case 'iteration'
                params.iteration=val;
            case 'method'
                params.dmethod=val;
            otherwise
                warning('moea doesnot support the given parameters name');
        end
    end
    %上面这些结束就是popsize=100，niche=20，objdim=2，iteration=200，dmethod=‘te’
    
    subproblems = init_weights(params.popsize, params.niche, objDim);
    %初始化权重向量和邻域
    
    params.popsize = length(subproblems);%101
    
    %initial the subproblem's initital state.--------初始化子问题的初始状态
    inds = randompoint(mop, params.popsize);%这句主要是给ind赋值--------是1*101的结构体，每个都是30*1的
    [V, INDS] = arrayfun(@evaluate, repmat(mop, size(inds)), inds, 'UniformOutput', 0);
   
    %repmat(mop, size(inds))对evaluate的处理结果放在V里，inds对evaluate的处理结果放在INDS里
    %目前没有办法测--------------------？？？？？？？？？？？？？？？？？？？？？？？？？？？？
    v = cell2mat(V);
    idealp = min(idealp, min(v,[],2));%2是按行求最小，1是按列求最小
    %disp(v);
    
    %indcells = mat2cell(INDS, 1, ones(1,params.popsize));8j
    [subproblems.curpoint] = INDS{:};%将当前得到的INDS放到子问题的curpoint里
    clear inds INDS V indcells;%清空
end
    
function subproblems = evolve(subproblems, mop, params)%进化函数
    global idealpoint;%参考点
   
    for i=1:length(subproblems)%1-101
        %new point generation using genetic operations, and evaluate
        %it.用遗传算法产生新的点，并评价这个新的个体
        ind = genetic_op(subproblems, i, mop.domain, params);
        [obj,ind] = evaluate(mop, ind);
        %update the idealpoint.------更新参考点
        idealpoint = min(idealpoint, obj);
        
        %update the neighbours.------更新邻域
        neighbourindex = subproblems(i).neighbour;
        subproblems(neighbourindex)=update(subproblems(neighbourindex),ind, idealpoint);
        %clear ind obj neighbourindex neighbours;        

        clear ind obj neighbourindex;
    end
end

function subp =update(subp, ind, idealpoint)
    global params
    
    newobj=subobjective([subp.weight], ind.objective,  idealpoint, params.dmethod);
    oops = [subp.curpoint]; 
    oldobj=subobjective([subp.weight], [oops.objective], idealpoint, params.dmethod );
    
    C = newobj < oldobj;
    [subp(C).curpoint]= deal(ind);
    clear C newobj oops oldobj;
end

function y =terminate(itrcounter)
    global params;
    y = itrcounter>params.iteration;
end

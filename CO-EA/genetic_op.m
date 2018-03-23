function ind=genetic_op(subproblems, index, domain, params)
%GENETICOP function implemented the DE operation to generate a new
%individual from a subproblems and its neighbours.------产生新的子问题和它的邻域

%   subproblems: is all the subproblems.------所有子问题
%   index: the index of the subproblem need to
%   handle.-----要处理的子问题的索引------从1-101
%   domain: the domain of the origional multiobjective problem.-----原始多目标问题的域
%   ind: is an individual structure.-------一个个体结构体

    neighbourindex = subproblems(index).neighbour;%邻域的索引----是一个竖排的邻域标号
    
    %The random draw from the neighbours.
    nsize = length(neighbourindex);%这个不应该都是20嘛
    si = ones(1,3)*index;%这是干啥
    
    si(1)=neighbourindex(ceil(rand*nsize));%ceil(rand*nsize)是产生一个1-20的随机数，这句就是取邻域的一个数
    while si(1)==index%一定要他们不相等
        si(1)=neighbourindex(ceil(rand*nsize));
    end
    
    si(2)=neighbourindex(ceil(rand*nsize));
    while si(2)==index || si(2)==si(1)
        si(2)=neighbourindex(ceil(rand*nsize));
    end
    
    si(3)=neighbourindex(ceil(rand*nsize));
    while si(3)==index || si(3)==si(2) || si(3)==si(1)
        si(3)=neighbourindex(ceil(rand*nsize));
    end
    %也就是最后si中的三个数不等于index也互不相等
     
    %retrieve the individuals.-----检索个体
    points = [subproblems(si).curpoint];%应该是一个1*3的，每个curpoint都是一个带INDS属性的-----这些是特殊选出来的
    selectpoints = [points.parameter];
    
    oldpoint = subproblems(index).curpoint.parameter;%原始的
    parDim = size(domain, 1);%或许可以当成30
    
    jrandom = ceil(rand*parDim);%生成1-30的一个随机数
    
    randomarray = rand(parDim, 1);%这个默认生成的是0-1之间的随机数啊哦哦这是要看看进不进行交叉变异
    deselect = randomarray<params.CR;
    deselect(jrandom)=true;
    newpoint = selectpoints(:,1)+params.F*(selectpoints(:,2)-selectpoints(:,3));
    newpoint(~deselect)=oldpoint(~deselect);
    
    %repair the new value.
    newpoint=max(newpoint, domain(:,1));
    newpoint=min(newpoint, domain(:,2));
    
    ind = struct('parameter',newpoint,'objective',[], 'estimation',[]);
    %ind.parameter = newpoint;
    %ind = realmutate(ind, domain, 1/parDim);
    ind = gaussian_mutate(ind, 1/parDim, domain);
    
    %clear points selectpoints oldpoint randomarray deselect newpoint neighbourindex si;
end
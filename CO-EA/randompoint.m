function ind = randompoint(prob, n)
%RANDOMNEW to generate n new point randomly from the mop problem given.

if (nargin==1)%nargin输入参数可调，一个参数
    n=1;
end

randarray = rand(prob.pd, n);%n是popsize种群大小（30*101）-----默认0-1的
lowend = prob.domain(:,1);%变了吗，应该没有啊，是一竖行0-----这个domain是定义域？也就是x是取0-1之间的数？
span = prob.domain(:,2)-lowend;%一竖行1减一竖行0=1
point = randarray.*(span(:,ones(1, n)))+ lowend(:,ones(1,n));%初始点？？
cellpoints = num2cell(point, 1);%把point变成了一行

indiv = struct('parameter',[],'objective',[], 'estimation', []);%个体？
ind = repmat(indiv, 1, n);%复制101个
[ind.parameter] = cellpoints{:};%ind的parameter参数都是30*1的了

% estimation = struct('obj', NaN ,'std', NaN);
% [ind.estimation] = deal(repmat(estimation, prob.od, 1));
end

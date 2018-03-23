function [v, x] = evaluate( prob, x )
%EVALUATE function evaluate an individual structure of a vector point with
%the given multiobjective problem.

%   Detailed explanation goes here
%   prob: is the multiobjective problem.---prob是多目标问题
%   x: is a vector point, or a individual structure.----x是个体的结构体
%   v: is the result objectives evaluated by the mop.-------v是目标评价的结果
%   x: if x is a individual structure, then x's objective field
%   is modified with the evaluated value and pass
%   back.-----如果x是一个个体结构体，x的目标域被评价值改进，同时传回

%   TODO, need to refine it to operate on a vector of points.
    if isstruct(x)
        v = prob.func(x.parameter);%判断x是否是一个结构体，如果是的话，取ind.paramenter带到目标函数里算
        %然后把v给ind的那个objective------应该是inds里的
        x.objective=v;
    else
        v = prob.func(x);%x不是结构体（怎么会有这种情况呢？？？？）-----而且不传回是要怎样？！算出来就扔了？？？
    end
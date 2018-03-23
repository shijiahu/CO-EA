function demo()

mop = testmop('zdt1',30);
%disp(mop);

pareto = moead( mop, 'popsize', 100, 'niche', 20, 'iteration', 200, 'method', 'te');

%printf(pareto);
%pareto = moead( mop, 'popsize', 100, 'niche', 20, 'iteration', 200, 'method', 'ws');

end
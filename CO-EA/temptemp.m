

% 并行分布式---四种群
% tst
% child1 = child(1,1:25);
% child2 = child(1,26:50);
% child3 = child(1,51:75);
% child4 = child(1,76:100);
% 
% 
% subp=init_weights(24, 20, 2);%++++++++99，20，2
% child = child1;
% tst2;
% child1 = child;
% child = child2;
% tst2;
% child2 = child;
% child = child3;
% tst2;
% child3 = child;
% child = child4;
% tst2;
% child4 = child;
% 
% child(1,1:25) = child1;
% child(1,26:50) = child2;
% child(1,51:75) = child3;
% child(1,76:100) = child4;
% %打乱child
% child= child(randperm(length(child)));
% subp=init_weights(99, 20, 2);%++++++++99，20，2
% tst3;

%并行分布式---两种群
% 
tst
child1 = child(1,1:50);
child2 = child(1,51:100);


subp=init_weights(49, 20, 2);%++++++++99，20，2
child = child1;
tst2;
child1 = child;
child = child2;
tst2;
child2 = child;


child(1,1:50) = child1;
child(1,51:100) = child2;

%打乱child
child= child(randperm(length(child)));
subp=init_weights(99, 20, 2);%++++++++99，20，2
tst3;
% 
% 
% 并行分布式---五种群
% tst
% child1 = child(1,1:20);
% child2 = child(1,21:40);
% child3 = child(1,41:60);
% child4 = child(1,61:80);
% child5 = child(1,81:100);
% 
% 
% subp=init_weights(19, 20, 2);%++++++++99，20，2
% child = child1;
% tst2;
% child1 = child;
% child = child2;
% tst2;
% child2 = child;
% child = child3;
% tst2;
% child3 = child;
% child = child4;
% tst2;
% child4 = child;
% child = child5;
% tst2;
% child5 = child;
% 
% child(1,1:20) = child1;
% child(1,21:40) = child2;
% child(1,41:60) = child3;
% child(1,61:80) = child4;
% child(1,81:100) = child5;
% %打乱child
% child= child(randperm(length(child)));
% subp=init_weights(99, 20, 2);%++++++++99，20，2
% tst3;


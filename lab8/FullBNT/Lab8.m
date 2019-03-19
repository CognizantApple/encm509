%%% Set up the network for example 1 %%%
N = 4; %the total number of nodes or random variables
W = 1; %the fiirt node called W (Winter)
I = 2;
C = 3;
F = 4; %each node is assigned a number
dag = zeros(N,N); %define a NxN matrix which specifies the graph structure
dag(W,[I C]) = 1; %W is a parent of both I and C
dag(I, F) = 1; %I is a parent to F
dag(C, F) = 1; %C is a parent to F
discrete_nodes = 1:N; %all node take discrete values.
node_sizes = [2 2 2 2]; % each node takes 2 values (e.g. True and False).

onodes=[]; %Specifying which nodes are the observed ones (here none)
bnet=mk_bnet(dag,node_sizes,'discrete',discrete_nodes,'observed',onodes);

bnet.CPD{W} = tabular_CPD(bnet, W, [0.5 0.5]);
bnet.CPD{C}= tabular_CPD(bnet, C, [0.8 0.2 0.2 0.8]);
bnet.CPD{I} = tabular_CPD(bnet, I, [0.5 0.9 0.5 0.1]);
bnet.CPD{F} = tabular_CPD(bnet, F, [1 0.1 0.1 0.01 0 0.9 0.9 0.99]);

engine = jtree_inf_engine(bnet);
% you can also use: engin = var_elim_inf_engine(bnet);
evidence = cell(1,N);% the size of the evidence vector

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% EXERCISE 1 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
evidence{F} = 2;% the evidence of Fever is True

[engine, loglik] = enter_evidence(engine, evidence);
marg = marginal_nodes(engine, I);
% calculate the updated value of probability for Influenza
disp("EXERCISE 1:");
marg.T % Check the value P(Influenza | Fever = True)
marg.T(2) % Check the specific value P(Influenza = True | Fever = True)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% EXERCISE 2 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
evidence{C} = 2;% the evidence of Cold is True

[engine, loglik] = enter_evidence(engine, evidence);
marg = marginal_nodes(engine, I);
% calculate the updated value of probability for Influenza
disp(' EXERCISE 2: ');
marg.T % returns the value P (Influenza|Cold = True, Fever = True),
marg.T(2) % returns the value P (Influenza = True|Cold = True, Fever = True)

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

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% EXERCISE 3 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
evidence = cell(1,N);
[engine, loglik] = enter_evidence(engine, evidence); % no evidence
m = marginal_nodes(engine, [I C F]); %it returns m as a structure.
%Its T field is a 3-dimensional array that contains
%joint probability on the specified nodes

disp(' EXERCISE 3: ');
m.T(1,1,2)
m.T(2,2,2)
m.T(1,2,2)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% EXERCISE 7 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
N2 = 4;

%generate training data
nsamples=30;
samples = cell(N2, nsamples);
for i=1:nsamples
    samples(:,i) = sample_bnet(bnet);
end
data = cell2num(samples);

%define the trainable network
W2 = 1; I2 = 2; C2 = 3; F2 = 4;

node_sizes = ones(1,N2);
node_sizes(1,1) = 2;
node_sizes(1,2)= 2;
node_sizes(1,3) = 2;
node_sizes(1,4) = 2;

order = [W2 I2 C2 F2];
max_fan_in = 2;
dag2 = learn_struct_K2(data, node_sizes, order, 'max_fan_in', max_fan_in);

bnet2 = mk_bnet(dag2, node_sizes);
seed = 4;
rand('state', seed);
bnet2.CPD{W2} = tabular_CPD(bnet2, W2);
bnet2.CPD{C2} = tabular_CPD(bnet2, C2);
bnet2.CPD{I2} = tabular_CPD(bnet2, I2);
bnet2.CPD{F2} = tabular_CPD(bnet2, F2);

bnet2 = learn_params(bnet2, data);

CPT3_original = cell(1,N);
for i=1:N
    S=struct(bnet.CPD{i});
    CPT3_original{i}=S.CPT;
end

CPT3_trained = cell(1,N2);
for i=1:N2
    S=struct(bnet2.CPD{i});
    CPT3_trained{i}=S.CPT;
end

disp(' EXERCISE 7: ');

%%% Set up the network for example 2 %%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% EXERCISE 4 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
N = 5; %the total number of nodes or random variables
Se = 1; % Node 1, season
Fl = 2; % Node 2, Flight
Sa = 3; % Node 3, SARS
Fe = 4; % Node 4, Fever
Co = 5; % Node 5, Cough
dag = zeros(N,N); %define a NxN matrix which specifies the graph structure
dag(Se, Sa) = 1; % Season is a parent to SARS
dag(Fl, Sa) = 1; % Flight is a parent to SARS
dag(Sa,[Fe Co]) = 1; %SARS is a parent of both Fever and Cough
discrete_nodes = 1:N; %all node take discrete values.
node_sizes = [2 2 2 2 2]; % each node takes 2 values (e.g. True and False).

onodes=[]; %Specifying which nodes are the observed ones (here none)
bnet=mk_bnet(dag,node_sizes,'discrete',discrete_nodes,'observed',onodes);

%%% NOTE: Treat "Low season" as False (1), "High season" as True (2),

bnet.CPD{Se} = tabular_CPD(bnet, Se, [0.90 0.10]); % Low, high
bnet.CPD{Fl} = tabular_CPD(bnet, Fl, [0.70 0.30]); % false, true
%                                    F:F,L  F,H  T,L  T,H T:F,L F,H  T,L  T,H
bnet.CPD{Sa} = tabular_CPD(bnet, Sa, [0.98 0.98 0.97 0.95 0.02 0.02 0.03 0.05]);
%                                   F: F    T  T: F    T
bnet.CPD{Fe} = tabular_CPD(bnet, Fe, [0.80 0.10 0.20 0.90]);
%                                   F: F    T  T: F    T
bnet.CPD{Co} = tabular_CPD(bnet, Co, [0.70 0.35 0.30 0.65]);


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% EXERCISE 5 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Find the joint probability that:
% P(Season=High, Flight=False, SARS =False, Fever=True, Cough=True)
engine = var_elim_inf_engine(bnet);
evidence = cell(1,N); % the size of the evidence vector
% define the size of the evidence vector, but do not
% define the evidence of nodes, using:
[engine, loglik] = enter_evidence(engine, evidence);
marg = marginal_nodes(engine, [Se Fl Sa Fe Co])

disp("EXERCISE 5:");
%Season = High(2), Flight = False(1), SARS = False(1), Fever = True(2), and Cough = True(2),
marg.T(2,1,1,2,2)


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% EXERCISE 6 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

disp("EXERCISE 6:");
% The probability of SARS = True when Season is Low
disp('The probability of SARS = True (2) when Season is Low');
engine = var_elim_inf_engine(bnet);
evidence = cell(1,N); % the size of the evidence vector
evidence{Se} = 1; % false (low)
[engine, loglik] = enter_evidence(engine, evidence);
marg = marginal_nodes(engine, Sa);
marg.T(2)

% The probability of Cough = True when Season is Low
disp('The probability of Cough = True (2) when Season is Low');
engine = var_elim_inf_engine(bnet);
evidence = cell(1,N); % the size of the evidence vector
evidence{Se} = 1; % false (low)
[engine, loglik] = enter_evidence(engine, evidence);
marg = marginal_nodes(engine, Co);
marg.T(2)

% The probability of Season = High When SARS = True
disp('The probability of Season = High (2) When SARS = True');
engine = var_elim_inf_engine(bnet);
evidence = cell(1,N); % the size of the evidence vector
evidence{Sa} = 2; % true
[engine, loglik] = enter_evidence(engine, evidence);
marg = marginal_nodes(engine, Se);
marg.T(2)

% The probability of Fever = False When SARS = True
disp('The probability of Fever = False (1) When SARS = True');
engine = var_elim_inf_engine(bnet);
evidence = cell(1,N); % the size of the evidence vector
evidence{Sa} = 2;  % true
[engine, loglik] = enter_evidence(engine, evidence);
marg = marginal_nodes(engine, Fe);
marg.T(1)

% The probability of SARS = False when Cough is True
disp('The probability of SARS = False (1) when Cough is True');
engine = var_elim_inf_engine(bnet);
evidence = cell(1,N); % the size of the evidence vector
evidence{Co} = 2;  % true
[engine, loglik] = enter_evidence(engine, evidence);
marg = marginal_nodes(engine, Sa);
marg.T(1)

% The probability of Flight = True when Cough is True
disp('The probability of Flight = True (2) when Cough is True');
engine = var_elim_inf_engine(bnet);
evidence = cell(1,N); % the size of the evidence vector
evidence{Co} = 2; % true
[engine, loglik] = enter_evidence(engine, evidence);
marg = marginal_nodes(engine, Fl);
marg.T(2)

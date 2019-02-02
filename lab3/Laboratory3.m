%Grab the prepared data
[AuthSigs, ForgSigs, MeanAuth, MeanForg] = GetDatabase();

mu_a    = mean(MeanAuth)
sigma_a = cov(MeanAuth)
% Genuine signatures in green
plotgaus(mu_a, sigma_a, [0 1 0]);
hold on;
mu_f    = mean(MeanForg)
sigma_f = cov(MeanForg)
% Forged signatures in red
plotgaus(mu_f, sigma_f, [1 0 0]);

% Plot each class data as a set of points in the 2D plane
plot(MeanAuth(:,1), MeanAuth(:,2), 'go');
plot(MeanForg(:,1), MeanForg(:,2), 'ro');
xlabel('Pressure');
ylabel('Velocity');
title('Class Points and Gaussians');

% SECTION 2.2
% Compute the prior probabilities for the authentic and forged classes
N = size(MeanAuth,1) + size(MeanForg,1)
Pa =  size(MeanAuth,1)/N
Pf =  size(MeanForg,1)/N

% Compute the posterior probabilities for each class

for i = 1:length(MeanAuth(:,1))
    aglog(i) = gloglike(MeanAuth(i), mu_a, sigma_a) + log(Pa);
    fglog(i) = gloglike(MeanForg(i), mu_a, sigma_a) + log(Pa);
end

% Plot the authentic and forged signatures???
gausplot(MeanAuth, mu_a, sigma_a, 'Authentic');
gausplot(MeanForg, mu_f, sigma_f, 'Forged');




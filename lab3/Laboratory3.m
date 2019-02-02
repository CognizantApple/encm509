%Grab the prepared data
[AuthSigs, ImposterSigs, MeanAuth, MeanImposter] = GetDatabase();

mu_a = mean(MeanAuth)
sigma_a = cov(MeanAuth)
% Genuine signatures in green
plotgaus(mu_a, sigma_a, [0 1 0]);
hold on;
mu_f = mean(MeanImposter)
sigma_f = cov(MeanImposter)
% Imposter signatures in red
plotgaus(mu_f, sigma_f, [1 0 0]);

% Plot each class data as a set of points in the 2D plane
plot(MeanAuth(:,1), MeanAuth(:,2), 'go');
plot(MeanImposter(:,1), MeanImposter(:,2), 'ro');
xlabel('Pressure');
ylabel('Velocity');
title('Class Points and Gaussians');










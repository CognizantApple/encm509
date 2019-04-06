x=-25:0.01:-10;

non_match = normpdf(x,-23.37693333,2.153586126);

match = normpdf(x,-17.40603333,0.1245023025);

figure;
plot(x,non_match);
hold on
plot(x,match);
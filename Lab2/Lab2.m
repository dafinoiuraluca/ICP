% d(j) = 1/T * (y_j - y_(j- 1))
% aflam max derivata
% tragi o tangenta pe punctul de max
% faci metoda tangentei pt aia
%% Exercitiul 1
% Hf3_min = tf(4.25, conv(conv([0.3*60 1], [22.5*60 1]), [40*60 1]));

Hf3 = tf(4.25, conv(conv([0.3 1], [22.5 1]), [40 1]));
figure, 
subplot(311), step(Hf3);
title('Step response of the initial transfer function')

%% Metoda tangentei
y_stationar = 4.24;
y0 = 0;

m_stationar = 1;
m0 = 0;

k = (y_stationar - y0) / (m_stationar - m0);
T_tangeta = 66.4;
Tm1 = 9.87;

T_esantion1 = 15;

H_tangenta = tf(k, [T_tangeta 1], 'IOdelay', Tm1);
subplot(312), step(H)
title('Tangent method')

%% Metoda Cohen - Coon
% m_stationar632 = 0.632 * y_stationar; % t = 66.4
% m_stationar28 = 0.28 * y_stationar; % t = 33.8;
t632 = 66.8;
t28 = 33.8;
T_CC = 1.5 * (t632 - t28);
Tm2 = 1.5 * (t28 - 1/3 * t632);
alpha = T_CC/Tm2;
T_esantion2 = 20;

H_CC = tf(k, [T_CC 1], 'IOdelay', Tm2);
subplot(313), step(H_CC)
title('Cohen-Coon method')

%% Derivata & tangenta
f = step(Hf3);
d = zeros(length(f), 1);
for i = 2:length(f)
    d(i) = 1 * (f(i) - f(i - 1));
end
[max_derivative, index] = max(d);
tangent = f(index) - max_derivative * index;
figure, plot(1:length(f), f)
hold on
plot(index, f(index), 'ro')

t = 0:length(f);
tangent_line = max_derivative * t + tangent;
plot(t, tangent_line, 'g--');
hold off

%% Plotare derivata
dmax = 0.09;
step(H_CC)

line([18.4 dmax], [0 y_stationar])

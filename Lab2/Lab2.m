% d(j) = 1/T * (y_j - y_(j- 1))
% aflam max derivata
% tragi o tangenta pe punctul de max
% faci metoda tangentei pt aia
%% Exercitiul 1
Hf3 = tf(4.25, conv(conv([0.3 1], [22.5 1]), [40 1]));
figure, 
subplot(311), step(Hf3);
title('Original plot of the tf step response')

% Metoda tangentei
y_stationar = 4.24;
y0 = 0;

m_stationar = 1;
m0 = 0;

k = (y_stationar - y0) / (m_stationar - m0);
T_tangeta = 66.4;
Tm1 = 9.87;

T_esantion1 = 15;

H = tf(k, [T_tangeta 1], 'IOdelay', Tm1);
subplot(312), step(H)
title('Tangent method')

% Metoda Cohen - Coon
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

f = step(Hf3);
d = zeros(length(f), 1);
for i = 2:length(f)
    d(i) = 1 * (f(i) - f(i - 1));
end
figure, plot(d)
%% Plotare derivata
dmax = 0.09;
step(H_CC)

line([18.4 dmax], [0 y_stationar])
%% Exercitiul2
% pentru Cohen- Coon
% coloana 3 - primul tabel
% coloana 4 - al doilea tabel

%% Acordare pentru procese cu timp mort (raspuns optim in raport cu referinta)
% Chien - Hrones - Reswich - pentru raspuns aperiodic
% P
Kr1 = 0.3 * T_tangeta / (Tm2 * k);

% PI
Kr2 = 0.35 * T_tangeta/(Tm2 * k);
Ti2 = 1.2 * Tm2;
Hr2 = tf(Kr2, [Kr2/Ti2 1]);

% PID
Kr3 = 0.6*T_tangeta/(Tm2 * k);
Ti3 = Tm2;
Td3 = 0.5*Tm2;
Hr3 = Kr3* (1 + Td3/Ti3) + tf([1 Kr3/Ti3]) + tf([Td3, [1 Kr3/T_CC]]);


%% Acordare pentru procese cu timp mort (raspuns optim la perturbatii)
% Cohen-Coon
% P
Kr4 = 1.5/k * (1/alpha + 0.333);

% PI
Kr5 = 1.5/k * (1/alpha + 0.333);
Ti5 = Tm2 * (3.33 * alpha + 0.333 * alpha ^ 2)/(1 + 2.2 * alpha);

% PID
Kr6 = 1.35/k *(1/alpha+ 0.2);
Ti6 = Tm2 * (2.5 * alpha + 0.5 * alpha ^ 2)/(1 + 0.6 * alpha);
% Td = Tm2*

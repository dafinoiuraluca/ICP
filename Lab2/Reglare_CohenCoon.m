%% Acordare pentru procese cu timp mort
clearvars;
%% Metoda Cohen-Coon
k = 4.24;
T_cc = 49.5;
Tm2 = 17.3;
alpha = T_cc/Tm2;
H_CC = tf(k, [T_cc 1], 'IOdelay', Tm2);

%% Raspuns optim la perturbatii - Cohen Coon

% P
Kr_cc = 1.5 / k * (1/alpha + 0.333);

% PI
Kr_PI_cc = 1.5 / k * (1/alpha + 0.333);
Ti_PI_cc = Tm2 * (3.33 * alpha + 0.333 * alpha^2)/(1 + 2.2*alpha);
Hr_PI_cc = Kr_PI_cc * tf([Ti_PI_cc 1], [Ti_PI_cc 0]);

% PID
Kr_PID_cc1 = 1.35 / k * (1/alpha + 0.2);
Ti_PID_cc1 = Tm2 * (2.5 * alpha + 0.5 * alpha^2)/(1 + 0.6*alpha);
Td_PID_cc1 = Tm2 * 0.37 * alpha / (1 + 0.2 * alpha);
Hr_PID_cc1 = Kr_PID_cc1 * tf([(Ti_PID_cc1^2*T_cc + Td_cc1^2*Ti_PID_cc1) (Ti_PID_cc1^2 + Td_cc1 * T_cc) Td_cc1], [Ti_PID_cc1 * T_cc Ti_PID_cc1^2]);

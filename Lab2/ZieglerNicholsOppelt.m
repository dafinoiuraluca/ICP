%% Acordare pentru procese cu timp mort
clearvars;
%% Metoda tangentei
k = 4.24;
T_tangenta = 66.4;
Tm1 = 9.87;
H_tangenta = tf(k, [T_tangenta 1], 'IOdelay', Tm1);
[num_tangenta, den_tangenta] = tfdata(H_tangenta, 'v');
%% Raspuns optim in raport cu referinta
%% Ziegler-Nicholis

% P
Kr_P_zn = T_tangenta / (Tm1 * k);


% PI
Kr_PI_zn = 0.9*T_tangenta/(Tm1 * k);
Ti_PI_zn = 3.3*Tm1;
Hr_PI_zn = Kr_PI_zn * tf([Ti_PI_zn 1], [Ti_PI_zn 0]);
[num_PI_zn0, den_PI_zn1] = tfdata(Hr_PI_zn, 'v');
% PID q = 0 ?????????? => kr ????

% PID q = 1
Kr_PID_zn1 = 1.2 * T_tangenta/(Tm1 * k);
Ti_PID_zn1 = 2*Tm1;
Td_zn1 = 0.5 * Tm1;

Hr_PID_zn1 = Kr_PID_zn1 * (tf(Td_zn1, Ti_PID_zn1) + tf(1, [Ti_PID_zn1 0]) + tf([Td_zn1 0], [T_tangenta 1]));
% Hr_PID_zn1 = Kr_PID_zn1 * tf([Ti_PID_zn1^2*T_tangenta + Td_zn1^2*Ti_PID_zn1 Ti_PID_zn1^2 + Td_zn1 * T_tangenta Td_zn1], [Ti_PID_zn1 * T_tangenta Ti_PID_zn1^2]);
[num_PID_zn1, den_PID_zn1] = tfdata(Hr_PID_zn1, 'v');

Hr_PID_zn0 = Kr_PID_zn1 * (tf(1, [Ti_PID_zn1 0]) + tf([Td_zn1 0], [T_tangenta 1]));
% Hr_PID_zn0 = Kr_PID_zn1 * tf([Td_zn1*Ti_PID_zn1 T_tangenta+Ti_PID_zn1 1], [Ti_PID_zn1 * T_tangenta Ti_PID_zn1]);
[num_PID_zn0, den_PID_zn0] = tfdata(Hr_PID_zn0, 'v');
figure; step(H_tangenta); hold on
step(feedback(Hr_PI_zn * H_tangenta, 1))
%% Oppelt

% P 
Kr_P_o = T_tangenta / (Tm1 * k);

% PI
Kr_PI_o = 0.8*T_tangenta/(Tm1 * k);
Ti_PI_o = 3*Tm1;
Hr_PI_o = Kr_PI_o * tf([Ti_PI_o 1], [Ti_PI_o 0]);

% PID q = 1
Kr_PID_o1 = 1.2 * T_tangenta/(Tm1 * k);
Ti_PID_o1 = 2*Tm1;
Td_o1 = 0.42 * Tm1;

Hr_PID_o1 = Kr_PID_o1 * (tf(Td_o1, Ti_PID_o1) + tf(1, [Ti_PID_o1 0]) + tf([Td_o1 0], [T_tangenta 1]));
[num_PID_o1, den_PID_o1] = tfdata(Hr_PID_o1, 'v');

Hr_PID_o0 = Kr_PID_o1 * (tf(1, [Ti_PID_o1 0]) + tf([Td_o1 0], [T_tangenta 1]));
[num_PID_o0, den_PID_o0] = tfdata(Hr_PID_o0, 'v');
%% Raspuns optim la perturbatii
%% Kopelovici (pentru raspuns aperiodic)

% P
Kr_P_ka = 0.3 * T_tangenta / (Tm1 * k);

% PI
Kr_PI_ka = 0.6 * T_tangenta / (Tm1 * k);
Ti_PI_ka = 0.8 * Tm1 + 0.5 * T_tangenta;
Hr_PI_ka = Kr_PI_ka * tf([Ti_PI_ka 1], [Ti_PI_ka 0]);

% PID q = 1
Kr_PID_ka1 = 0.95 * T_tangenta / (Tm1 * k);
Ti_PID_ka1 = 2 * Tm1;
Td_ka1 = 0.4 * Tm1;
Hr_PID_ka1 = Kr_PID_ka1 * tf([(Ti_PID_ka1^2*T_tangenta + Td_ka1^2*Ti_PID_ka1) (Ti_PID_ka1^2 + Td_ka1 * T_tangenta) Td_ka1], [Ti_PID_ka1 * T_tangenta Ti_PID_ka1^2]);

%% Kopelovici (pentru raspuns oscilant)

% P
Kr_P_ko = 1.41/k * (T_tangenta / Tm1) ^ 0.917;

% PI
Kr_PI_ko = 1.41/k * (T_tangenta / Tm1) ^ 0.945;
Ti_PI_ko = 2.03 * T_tangenta * (Tm1 / T_tangenta) ^ 0.739;
Hr_PI_ko = Kr_PI_ko * tf([Ti_PI_ko 1], [Ti_PI_ko 0]);

% PID q = 1
Kr_PID_ko1 = 1.3/k * (T_tangenta / Tm1) ^ 0.945;
Ti_PID_ko1 = 0.917 * T_tangenta * (Tm1 / T_tangenta) ^ 0.771;
Td_ko1 = 0.59 * Tm1;
Hr_PID_ko1 = Kr_PID_ko1 * tf([(Ti_PID_ko1^2*T_tangenta + Td_ko1^2*Ti_PID_ko1) (Ti_PID_ko1^2 + Td_ko1 * T_tangenta) Td_ko1], [Ti_PID_ko1 * T_tangenta Ti_PID_ko1^2]);

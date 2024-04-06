%% Acordare pentru procese cu timp mort
clearvars;
%% proces initial
Hf3 = tf(4.25, conv(conv([0.3 1], [22.5 1]), [40 1]));

%% Metoda tangentei
k = 4.24;
T_tangenta = 66.4;
Tm1 = 9.87;
H_tangenta = tf(k, [T_tangenta 1], 'IOdelay', Tm1);
[num_tangenta, den_tangenta] = tfdata(H_tangenta, 'v');
step(H_tangenta)
%% Raspuns optim in raport cu referinta - tabel 2.1
%% Chien-Hrones-Reswich (pentru raspuns aperiodic)
% P
Kr_P_chr = 0.3 * T_tangenta / (Tm1 * k);

% PI
Kr_PI_chr = 0.35 * T_tangenta / (Tm1 * k);
Ti_PI_chr = 1.2 * Tm1;
Hr_PI_chr = Kr_PI_chr * tf([Ti_PI_chr 1], [Ti_PI_chr 0]);

% PID
Kr_PID_chr1 = 0.6 * T_tangenta / (Tm1 * k);
Ti_PID_chr1 = Tm1;
Td_chr1 = 0.5 * Tm1;

Hr_PID_chr1 = Kr_PID_chr1 * (tf(Td_chr1, Ti_PID_chr1) + tf(1, [Ti_PID_chr1 0]) + tf([Td_chr1 0], [T_tangenta 1]));
[num_PID_chr1, den_PID_chr1] = tfdata(Hr_PID_chr1, 'v');

Hr_PID_chr0 = Kr_PID_chr1 * (tf(1, [Ti_PID_chr1 0]) + tf([Td_chr1 0], [T_tangenta 1]));
[num_PID_chr0, den_PID_chr0] = tfdata(Hr_PID_chr0, 'v');
%% Raspuns optim la perturbatii - tabel 2.2
%% Chien-Hrones-Reswich (pentru raspuns aperiodic)

% P
Kr_P_chr_p = 0.3 * T_tangenta / (Tm1 * k);

% PI
Kr_PI_chr_p = 0.6 * T_tangenta / (Tm1 * k);
Ti_PI_chr_p = 4 * Tm1;
Hr_PI_chr_p = Kr_PI_chr_p * tf([Ti_PI_chr_p 1], [Ti_PI_chr_p 0]);
[num_PID_chr_a, den_PID_chr_a] = tfdata(Hr_PI_chr_p, 'v');

% PID
Kr_PID_chr1_p = 0.95 * T_tangenta / (Tm1 * k);
Ti_PID_chr1_p = 2.4 * Tm1;
Td_chr1_p = 0.42 * Tm1;

Hr_PID_chr1_a = Kr_PID_chr1_p * (tf(Td_chr1_p, Ti_PID_chr1_p) + tf(1, [Ti_PID_chr1_p 0]) + tf([Td_chr1_p 0], [T_tangenta 1]));
[num_PID_chr1_a, den_PID_chr1_a] = tfdata(Hr_PID_chr1_a, 'v');

Hr_PID_chr0_a = Kr_PID_chr1 * (tf(1, [Ti_PID_chr1_p 0]) + tf([Td_chr1_p 0], [T_tangenta 1]));
[num_PID_chr0_a, den_PID_chr0_a] = tfdata(Hr_PID_chr0_a, 'v');


figure, 
step(feedback(Hr_PID_chr1_a*Hf3, 1)), hold on
step(feedback(Hr_PID_chr0_a*Hf3, 1)), grid


%% Performante
%% Raspuns cu P - in raport cu referinta
figure, step(Hf3), hold on
step(feedback(Kr_P_chr * Hf3, 1))
legend('Proces', 'Proces regulat')
title('P control')
%% Raspuns cu PI - in raport cu referinta
figure, step(Hf3), hold on
step(feedback(Hr_PI_chr*Hf3, 1))
legend('Proces', 'Proces regulat')
title('PI control')
%% Raspuns cu P - optim la perturbatii
figure, step(Hf3), hold on
step(feedback(Kr_P_chr_p * Hf3, 1))
legend('Proces', 'Proces regulat')
title('P control')
%% Raspuns cu PI - in raport cu referinta
figure, step(Hf3), hold on
step(feedback(Hr_PI_chr_p*Hf3, 1))
legend('Proces', 'Proces regulat')
title('PI control')



%% Cerinta 3 - simulink comparatie intre PID-uri pentru acelasi criteriu de acordare
% Comparare intre P, PI, PID pe metoda
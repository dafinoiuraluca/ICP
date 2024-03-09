load("sets_lab1.mat")

%% Metoda tangentei
%% First set
close all;
figure, plot(data1.u, data1.y), grid
% first order without deadtime

y01 = 0; 
y_stationar1 = data1.y(end);

m_stationar1 = 1;
m01 = 0;

k1 = (y_stationar1 - y01) / (m_stationar1 - m01);
T1 = 1;

H1 = tf(k1, [T1 1]);

line([0, m_stationar1], [0, y_stationar1])
line([0, 5], [y_stationar1, y_stationar1], 'LineStyle', '--')
line([m_stationar1, m_stationar1], [0, y_stationar1], 'LineStyle', '--')
hold

step(H1, data1.u)

%% Second set
close all;
figure, plot(data2.u, data2.y), grid
% first order with deadtime

y02 = data2.y(1);
y_stationar2 = data2.y(end);

m02 = 0;
m_stationar2 = 1;

k2 = (y_stationar2 - y02) / (m_stationar2 - m02);

tm2 = 0.4;
T_total2 = 1.134;
T2 = T_total2 - tm2;

H2 = tf(k2, [T2 1], 'IOdelay', tm2);

line([tm2, m_stationar2], [0, y_stationar2])
line([0, 5], [y_stationar2, y_stationar2], 'LineStyle', '--')
line([T2, T2], [0, y_stationar2], 'LineStyle', '--')
hold

step(H2, data2.u)

%% Third set
%% Metoda tangentei
close all;
figure, plot(data3.u, data3.y), grid
% ordin superior 

y03 = data3.y(1);
y_stationar3 = data3.y(end);

m03 = 0;
m_stationar3 = 1;

k3 = (y_stationar3 - y03) / (m_stationar3 - m03);

tm3 = 0.2;
T_total3 = 1.4; % 4.5501 -> citit la 4.67
T3 = T_total3 - tm3;

H3 = tf(k3, [T3 1], 'IOdelay', tm3);

hold
step(H3, data3.u)
%% Metoda Cohen Coon
close all;
figure, plot(data3.u, data3.y), grid
% ordin superior 

% se foloseste acelasi k -> k3
t28 = 0.7; % y - 2.015
t632 = 1.4; % y - 4.5501

T4 = 1.5 * (t632 - t28);
tm4 = 1.5 * (t28 - t632 / 3);
alfa = T4/tm4;

H4 = tf(k3, [T4 1], 'IOdelay', tm4);

hold
step(H4, data3.u)
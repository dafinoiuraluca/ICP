%% Modelling
clear all;

% momentul de inertie
J = 0.4; % Kg * m2

% coeficientul de frecare
Kf = 0.1115; % adimn

% rezistenta rotorica
Rr = 0.156; % ohmi

% rezistenta statorica
Rs = 0.294; % ohmi

% inductanta rotorica
Lr = 0.0417; % H

% inductanta statorica
Ls = 0.0424; % H

% inductanta mutuala intre infasurarea statorica si cea rotorica
Lm = 0.041; % H

% cuplu rezistent
Mr = 0;

% => vals pt alpha, beta, gamma

alpha = Rr/Lr;
gamma = 1 - Lm^2/(Ls*Lr);
beta = 1/gamma * Lm/(Ls*Lr);

% turatia nominala
nn = 2940; % rot/min

% frecventa nominala
fn = 50; %Hz

%%
Hf = tf(2, conv([8 1], [10 1]));
[numF, denF] = tfdata(Hf, 'v');
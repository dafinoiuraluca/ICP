%% Dahlin
clearvars;
Tm = 2.5;
Hf11 = tf(4.3, conv([5 1], [23 1]), 'IOdelay', Tm);
[numF, denF] = tfdata(Hf11, 'v');

% Step1: Functia de transfer discreta
Ts = 0.5;
[numDf, denDf] = c2dm(numF, denF, Ts, 'zoh');
Hf11_discret = tf(numDf, denDf, Ts, 'InputDelay', 3, 'Variable', 'z^-1');

% Step2: Functia de transfer in bucla inchisa impusa
T01 = 14;
Ho = tf(1, [T01 1], 'IOdelay', Tm);
[numO, denO] = c2dm(1, [T01 1], Ts, 'zoh');
Ho_discret = tf(numO, denO, Ts,'InputDelay', 3, 'Variable', 'z^-1');

Hf11d = tf(numDf, denDf, Ts);
Hod = tf(numO, denO, Ts);

% Step3: Regulator
Hr = 1/Hf11d * (Hod/(1 - Hod));
Hr = minreal(Hr);
[numR, denR] = tfdata(Hr, 'v');
Hr_z = tf(numR, denR, Ts, 'InputDelay', 3, 'Variable', 'z^-1');
[numRe, denRe] = tfdata(Hr_z, 'v');

zeros = roots(numRe);
poles = roots(denRe);
Hr_nou = zpk(zeros, poles, 1, Ts, 'Variable', 'z^-1');
Hr_bun = tf(numRe, 1.9602*[1 -1 0], Ts, 'Variable', 'z^-1');
[numRbun, denRbun] = tfdata(Hr_bun, 'v');
%% Kalman
clear all;
Tm2 = 3; 
Hf21 = tf(1.25, conv([9 1], [14 1]), 'IODelay', Tm2);
[numF, denF] = tfdata(Hf21, 'v');

% Functia de transfer discreta
Ts2 = Tm2/5;
[numDf, denDf] = c2dm(numF, denF, Ts2, 'zoh');
Hf21_discret = tf(numDf, denDf, Ts2, 'InputDelay', Tm2/Ts2, 'Variable', 'z^-1');

% Suma coeficientilor
k = 1/(0.001722 + 0.00166);

% Formarea polinoamelor P si Q prin inmultirea cu k a polinoamelor A,
% respectiv B
P = [0 0 0 0 0 k.*[0 0.001722 0.00166]]; %[1 -1.8936 0.8963]
Q = [k.*[1 -1.894 0.8963] 0 0 0 0 0 ]; %[0.001722 0.00166]
Hr = tf(Q, [1 0 0 0 0 0 0 0]-P, Ts2, 'Variable', 'z^-1');
[numR, denR] = tfdata(Hr, 'v');

% semnalul de comanda are niste oscilatii ft mari fix la inceput, lucru
% neacceptat de elementele de executie => trebuie modificata forma
% regulatorului pt a obtine o forma de unda a semnalului de comanda
% acceptata de elementele de executie (fara oscilatii puternice sau care sa
% depaseasca valoarea de saturatie a acestora)
Hr1 = zpk(Hr);

% se gaseste polul cel mai apropriat de limita de stabilitate si se elimina
% prin substitutia lui cu z^-1 = 1
pole(Hr1); % cei mai apropriati: (-0.7363 - 0.2517i) si (-0.7363 + 0.2517i)

% num = 295.68 (1-0.9582z^-1) (1-0.9354z^-1)
% den = (1-z^-1)(1 - 1.114z^-1 + 0.9632z^-2) (1 + 0.6412z^-1 + 0.8415z^-2)
% * (-1.7363 - 0.2517i) * (-1.7363 + 0.2517i)

a = conv([1 -1.114 0.9632], [1 0.6412 0.8415]);
b = conv(a, [1 -1]);
c = -1.7363-0.2517i;
d = -1.7363+0.2517i;
denRsimplificat = d*c*b;

Hr2 = tf(numR, denRsimplificat, Ts2, 'Variable', 'z^-1');
zpk(Hr2);
[numR2, denR2] = tfdata(Hr2, 'v');

% se micsoareaza domeniul de variatie a semnalului de comanda, dar apar mai
% multe oscilatii  => modificari aditionale

% substituim iar cu 1, de data asta in (1 - 1.114z^-1 + 0.9632z^-2) care
% vine (0.5569z^-1 + 0.8081i) * (0.5569z^-1 - 0.8081i) 
a1 = conv([1 0.6412 0.8415], [1 -1]);
b1 = (1.5569+1.8081i) * (1.5569-1.8081i);
c1 = (-1.7363-0.2517i) * (-1.7363+0.2517i);
denRs1 = a1*b1*c1;

Hr3 = tf(numR, denRs1, Ts2, 'Variable', 'z^-1');
zpk(Hr3);
[numR3, denR3] = tfdata(Hr3, 'v');

% fiindca am lasat si ultimul termen nesimplificat, tot avem oscillatii =>
a2 = [1 -1];
b2 = (-0.3206 + 0.8595i)*(-0.3206 - 0.8595i);
denRs2 = a2*b2*c1*b1;

Hr4 = tf(numR, denRs2, Ts2, 'Variable', 'z^-1');
zpk(Hr4);
[numR4, denR4] = tfdata(Hr4, 'v');

% a mai scazut domeniul de variatie a semnalului de comanda si nu mai e asa
% agresiv



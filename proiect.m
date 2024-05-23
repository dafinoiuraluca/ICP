%% Date initiale
m = 2;
n = 5;

% The nominal power of the generator
PGnom = 488 - 5*(m + n); % MW

% The nominal pressure of the living steam in the boiler
pabvnom = 172 - (n - m); % bar

% The thermic specific consumption 
n_theta = 1/(2232+ 2 * (m + n)); % Mcal/MWh

% The processed team enthalpy
i2 = 862 - (n + m); % Mcal/to %to = tona
% dupa supraincalzitor

%% Design termic

% Puterea calorica a combustibilului (gaz metan)
PC_ch4 = 8.5; % Mcal/Nm3;

% Debitul de combustibil nominal
qC_nom = n_theta * PGnom / PC_ch4; % Nm3/h

% Temperatura nominala a aburului viu
theta_abnom = 530; % grade celsius

% Continut O2 molecular in gazele arse
O2 = 0.05; % 5%

% Presiunea nominala a aburului in tambur
Pabvtnom = 1.1 * pabvnom; %bar

% Temp nominala a aburului dupa primul supraincalzitor
theta_absinom = 480; % grade celsius

% Debitul nominal de aer de combustie
alpha = 1.1; a = 1.09; b = 0.25;
qaernom = qC_nom * alpha * (a*PC_ch4/1000 + b); %Nm3/h

% Depresiunea nominala in focar
delta_p_Fnom = -2; %mmH2O

% Debitul de gaze arse
% banuiesc ca qCH4nom se refera la debitul nominal de combustibil de mai
% sus
qganom = qaernom + qC_nom; % Nm3/h

% Debitul nominal al aburului viu
i1 = 30; % energie termica continuta in apa condensata MCal/tona
qabvnom = n_theta* PGnom/(i2 - i1); %[to/h] %qabviu

% Debitul apei de alimentare
qapanom = qabvnom;

% Salinitate nominala
Snom = 0.01; %mg/tona

% Debitul de injectie
qijnom = 0.01 * qabvnom; % tona/h

% Debitul de purja
qpjnom = 0.001 * qabvnom;

%% Design electric

% Factorul de putere
cos_phi = 0.825;

% Putere aparenta 
S_Gnom = PGnom/cos_phi; % [MVA]

% Putere reactiva nominala
Q_Gnom = sqrt(S_Gnom^2 - PGnom^2); % [MVAr]

% Tensiunea la bornele generatorului
U_Gnom = 30; % [kV]

% Tensiunea de excitatie normala
U_Enom = 600; % [V]

% Puterea nominala a excitatricei
P_Enom = 0.0025 * PGnom; % [MW]

% Puterea nominala a puntii comandate
P_PCnom = 0.01*P_Enom; % [kW]
 
% Curentul nominal de excitatie
i_Enom = P_Enom/U_Enom; % [kA]

% Tensiunea nominala a puntii comandate
U_PCnom = 360; % [V]

% Constanta de timp a excitatiei excitatricei
T_EE = 0.1; % [sec]

% Constanta de timp a excitatricei generatorului
T_E = 0.75; % [sec]

% Constanta de timp a generatorului trifazat
T_G = 5; % [sec]

% Curentul puntii comandate
i_Pcnom = P_PCnom / U_PCnom; % [A]


%% Functii de transfer
%% De la prima intrare - debitul de combustibil in raport cu

% presiunea aburului viu
k11 = pabvnom/qC_nom; % h*bar/Nm3
T11 = 6000; % s
Tm11 = 600; % s
H11 = tf(k11, [T11 1], 'IOdelay', Tm11);


% continutul de O2 din gazele arse
k12 = O2/qC_nom; % %*h/Nm3
Tm12 = 10;
T12 = 60;
H12 = tf(k12, [T12 1], 'IOdelay', Tm12);


% presiunea aburului viu in tambur
k15 = Pabvtnom/qC_nom; % h*bar/Nm3
Tm15 = 540; 
T15 = 5400;
H15 = tf(k15, [T15 1], 'IOdelay', Tm15);


% debitul de abur viu
k16 = qabvnom/qC_nom; % tona/Nm3
Tm16 = 720; 
T16 = 7200;
H16 = tf(k16, [T16 1], 'IOdelay', Tm16);


% temperatura aburului in supraincalzitorul intermediar
k17 = theta_absinom/qC_nom; % h*Celsius / Nm3
Tm17 = 600;
T17 = 6000;
H17 = tf(k17, [T17 1], 'IOdelay', Tm17);


% temperatura aburului viu
k18 = theta_abnom/qC_nom;
Tm18 = 720;
T18 = 7200;
H18 = tf(k18, [T18 1], 'IOdelay', Tm18);


%% De la a doua intrare - debitul de aer de combustie in raport cu

% presiunea aburului viu
k21 = pabvnom/qaernom; % h*bar/Nm3
Tm21 = 600;
T21 = 6000;
H21 = tf(k21, [T21 1], 'IOdelay', Tm21);


% continutul de O2 in gazele arse
k22 = O2/qaernom; % %*h/Nm3
Tm22 = 10;
T22 = 60;
H22 = tf(k22, [T22 1], 'IOdelay', Tm22);


% depresiunea din focar
k23 = delta_p_Fnom/qaernom; % h*mmH20/Nm3
Tm23 = 10;
T23 = 5;
H23 = tf(k23, [T23 1], 'IOdelay', Tm23);


% presiunea aburului din tambur
k25 = pabvnom/qaernom; % h*bar/Nm3
Tm25 = 540;
T25 = 5400;
H25 = tf(k25, [T25 1], 'IOdelay', Tm25);


% debitul de aer viu
k26 = qabvnom/qaernom; % tona/Nm3
Tm26 = 720;
T26 = 7200;
H26 = tf(k26, [T26 1], 'IOdelay', Tm26);


% temperatura aburului viu in supraincalzitorul intermediar
k27 = theta_absinom/qaernom; % h*Celsius/Nm3
Tm27 = 600;
T27 = 6000;
H27 = tf(k27, [T27 1], 'IOdelay', Tm27);


% temperatura aburului viu
k28 = theta_abnom/qaernom; % h*Celsius/Nm3 
Tm28 = 720;
T28 = 7200;
H28 = tf(k28, [T28 1], 'IOdelay', Tm28);


%% De la a treia intrare - debitul de gaze arse in raport cu

% depresiunea in focar
k33 = delta_p_Fnom/qganom; % h*mmH2O/Nm3
Tm33 = 5;
T33 = 10;
H33 = tf(k33, [T33 1], 'IOdelay', Tm33);


%% De la a patra intrare - debitul de apa de alimentare in raport cu

% nivelul apei din tambur - hnom = 100mm = 0.1m
k44 = 0.1/qapanom; % h*m/tona
Tm44 = 20;
T44 = 20;
H44 = tf(k44, [T44 1], 'IOdelay', Tm44);


% debitul aburului viu
k46 = qabvnom/qapanom; %adim
Tm46 = 720;
T46 = 7200;
H46 = tf(k46, [T46 1], 'IOdelay', Tm46);


% salinitatea 
k49 = Snom/qapanom; % h*%/tona
Tm49 = 3600;
T49 = 36000;
H49 = tf(k49, [T49 1], 'IOdelay', Tm49);


%% De la a cincea intrare - debitul de injectie (apa sau abur) in raport cu

% temperatura aburului viu
k57 = 100/qijnom; % h*Celsius/tona
Tm57 = 10;
T57 = 10;
H57 = tf(k57, [T57 1], 'IOdelay', Tm57);

%% De la a sasea intrare - debitul de purja in raport cu

% salinitatea
k69 = 1/qpjnom; % h * %/Nm3
Tm69 = 60;
T69 = 60;
H69 = tf(k69, [T69 1], 'IOdelay', Tm69);
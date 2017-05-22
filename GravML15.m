function LL = GravML15(ParamsTemp, paramsfit)
paramsfit = abs(paramsfit); %Ensures that parameters have correct sign
%% Parameters to be fitted
%beta1
%deathfrac
%kappa
datatimes = [0,4,6,11,13,17,25,29,31,38,40,45,47,52,54,56,61,64,68,69,...
    72,74,77,79,81,84,86,88,94,104,105,106,108,113,120,122,127,129];

% Time: from May 24 to September 30
% Cumulative cases in Guinea
infectedGuinea = [258,281,291,328,344,351,398,390,390,413,412,408,409,...
    406,411,410,415,427,460,485,495,495,506,510,519,543,579,607,648,812,...
    862,861,936,942,1022,1074,1157,1199];
% Cumulative deaths in Guinea
deadGuinea = [174,186,193,208,215,226,264,267,270,303,305,307,309,304,...
    310,310,314,319,339,358,363,367,373,377,380,394,396,406,430,517,555,...
    557,595,601,635,648,710,739];
% Cumulative cases in Sierra Leone
infectedSierraLeone = [0,16,50,79,81,89,97,128,158,239,252,305,337,386,...
    397,442,454,525,533,646,691,717,730,783,810,848,907,910,1026,1261,...
    1361,1424,1620,1673,1940,2021,2304,2437];
% Cumulative deaths in Sierra Leone
deadSierraLeone = [0,5,6,6,6,7,49,55,34,99,101,127,142,194,197,206,219,...
    224,233,273,286,298,315,334,348,365,374,392,422,491,509,524,562,562,...
    597,605,622,623];
% Cumulative cases in Liberia
infectedLiberia = [13,13,14,14,14,14,33,41,51,107,115,131,142,172,174,...
    196,224,249,329,468,516,554,599,670,786,834,972,1082,1378,1871,2046,...
    2081,2407,2710,3280,3458,3696,3834];
% Cumulative deaths in Liberia
deadLiberia = [11,11,12,12,12,12,24,25,34,65,75,84,88,105,106,116,127,...
    129,156,255,282,294,323,355,413,466,576,624,694,1089,1224,1137,1296,...
    1459,1677,1830,1998,2069];

%% Params 
alpha = ParamsTemp(1);              %1. Rate from E to I1
beta1 = paramsfit(1:3);             %2-4. Beta for I1
betaratio = ParamsTemp(5);          %5. Ratio between beta1 and the betas 
                                    %for I2 and F
deathfrac = paramsfit(4:6);         %6, 7, 8. Overall mortality rate--
                % ended up rewriting gamma, r1, etc. to be in terms of this
deathfrac2 = ParamsTemp(9);         %9.  Fraction who die in I2 
delta2 = ParamsTemp(10);            %10. Burial rate 
k02 = ParamsTemp(11);               %11. 1/number of days it takes to leave
                                    %I2 (for either F or R)
k21 = ParamsTemp(12);               %12. 1/number of days it takes to leave
                                        %I1 (for either I2 or R)
Rbed = ParamsTemp(13);      	    %13. rate of leaving R (hospital)
distancefactor = ParamsTemp(14);    %14 Distance factor
kappa = paramsfit(7:9);             %15, 16, 17. constant for influence of 
                                    % other patches on a patch
knorm = ParamsTemp(18);             %18. Constant for the reporting rate 
 %and fraction of the total population that's at risk

numpatches = 3;                     % Number of patches: 3


ParamsTemp = [alpha beta1 betaratio deathfrac deathfrac2 delta2 k02 k21...
    Rbed distancefactor kappa knorm]; 
k = knorm*[11745189 6092075 4294077];       %pops from world bank
%NOTE - Guinea SL Liberia order!
%% initial conditions
% Guinea
I1_ICG = 10/k(1);       %people who showed up infected in last few days 
                        % from t(-1) to  t(0)
I2_ICG = 6/k(1);        %people who die in next 2 days from t = 0 
                        % (b/c they were in I2 before then)
F_ICG = 3/k(1);         %recent dead from last 2-3 days
R_ICG = 6/k(1);  % Recovered persons (estimated based on number of deaths
                 % versus number of cases overall)
EH_ICG = 2*(I1_ICG + I2_ICG + F_ICG); % R0 ? 2, so number of exposed is
                                      % approx. equal to twice the infected
EA1_ICG = 0; % Insignificant cases in other countries in past few days
EA2_ICG = 0;
IC_ICG = 258/k(1); % From data
S_ICG = 1 - IC_ICG - EH_ICG; % Total population, minus infected/exposed
DC_ICG = 174/k(1); %From Data
IHC_ICG = 258/k(1); %All cases to date are from local transmission
IA1C_ICG = 0/k(1);
IA2C_ICG = 0/k(1);
initialGuinea = [S_ICG EH_ICG EA1_ICG EA2_ICG I1_ICG I2_ICG F_ICG R_ICG ...
    IC_ICG DC_ICG IHC_ICG IA1C_ICG IA2C_ICG];

% Sierra Leone
I1_ICSL = 5/k(2);       %people who showed up infected in last few days
                        % from t(-1) to  t(0)
I2_ICSL = 3/k(2);       %people who die in next 2 days from t = 0
                        % (b/c they were in I2 before then)
F_ICSL = 0/k(2);         %recent dead from last 2-3 days
R_ICSL = 0/k(2);   % Recovered persons (estimated based on number of deaths
                 % versus number of cases overall)
EH_ICSL = 0/k(2);
EA1_ICSL = 2*(I1_ICSL + I2_ICSL + F_ICSL);% R0 ? 2, so number of exposed is
                                      % approx. equal to twice the infected
EA2_ICSL = 0/k(1);
IC_ICSL = 8/k(2); % From data 
S_ICSL = 1 - IC_ICSL - EA1_ICSL; % what is the 271 +185 part
IC_ICSL = 8/k(2);  %From data
DC_ICSL = 0/k(2);      %From data
IHC_ICSL = 6/k(2); % Cases from home transmission
IA1C_ICSL = 2/k(2); % Cases from "away" transmission
IA2C_ICSL = 0/k(2);
initialSierraLeone = [S_ICSL EH_ICSL EA1_ICSL EA2_ICSL I1_ICSL I2_ICSL...
    F_ICSL R_ICSL IC_ICSL DC_ICSL IHC_ICSL IA1C_ICSL IA2C_ICSL];

%Liberia
I1_ICL = 2/k(3);       %people who showed up infected in last few days
                        % from t(-1) to  t(0)
I2_ICL = 0/k(3);       %people who die in next 2 days from t = 0
                        % (b/c they were in I2 before then)
F_ICL = 0/k(3);         %recent dead from last 2-3 days
R_ICL = 0/k(3);    % Recovered persons (estimated based on number of deaths
                 % versus number of cases overall)  
EH_ICL = 0;
EA1_ICL = 2*(I1_ICL + I2_ICL + F_ICL); % Recovered persons (estimated based 
    % on number of deaths versus number of cases overall) 
EA2_ICL = 0/k(3);
IC_ICL = 2/k(3); % From data
S_ICL = 1 - IC_ICL - EA1_ICL; %Number of susceptibles (population minus
                % 
DC_ICL = 0/k(3);      %new cases last 15 days - new dead last 15 days
IHC_ICL = 0/k(3); 
IA1C_ICL = 2/k(3); % seed cases from Guinea
IA2C_ICL = 0/k(3); 
initialLiberia = [S_ICL EH_ICL EA1_ICL EA2_ICL I1_ICL I2_ICL F_ICL R_ICL...
    IC_ICL DC_ICL IHC_ICL IA1C_ICL IA2C_ICL];

initial0 = [initialGuinea initialSierraLeone initialLiberia];
%% Run Model
[t,x] = ode45(@ebola_gmodel15,datatimes,initial0,[],ParamsTemp,numpatches);
Gkorrekt = k(1); % correction factor for Guinea
SLkorrekt = k(2); % correction factor for Sierra Leone
Lkorrekt = k(3); % correction factor for Liberia
G_cases  = Gkorrekt*x(:,9); 
G_deaths = Gkorrekt*x(:,10);
SL_cases = SLkorrekt*x(:,22);
SL_deaths = SLkorrekt*x(:,23);
L_cases = Lkorrekt*x(:,35);
L_deaths = Lkorrekt*x(:,36);

% Differences
d1 = G_cases - infectedGuinea'; 
d2 = G_deaths - deadGuinea';
d3 = SL_cases - infectedSierraLeone';
d4 = SL_deaths - deadSierraLeone';
d5 = L_cases - infectedLiberia';
d6 = L_deaths - deadLiberia';

%% GoF (Goodness of fit)
LL = sum(d1.^2 + d2.^2 + d3.^2 + d4.^2 + d5.^2 + d6.^2);


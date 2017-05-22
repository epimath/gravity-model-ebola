% Main code for EVD gravity model

% Original code by Jeremy P D'Silva
% Edits by JPD & MCE


%% Data

data = struct;

% Time: until Sep 30, from May 24
data.times = [0,4,6,11,13,17,25,29,31,38,40,45,47,52,54,56,61,64,68,69,...
    72,74,77,79,81,84,86,88,94,104,105,106,108,113,120,122,127,129];
% Cumulative cases in Guinea
data.infectedGuinea = [258,281,291,328,344,351,398,390,390,413,412,408,409,...
    406,411,410,415,427,460,485,495,495,506,510,519,543,579,607,648,812,...
    862,861,936,942,1022,1074,1157,1199];
% Cumulative deaths in Guinea
data.deadGuinea = [174,186,193,208,215,226,264,267,270,303,305,307,309,304,...
    310,310,314,319,339,358,363,367,373,377,380,394,396,406,430,517,555,...
    557,595,601,635,648,710,739];
% Cumulative cases in Sierra Leone
data.infectedSierraLeone = [0,16,50,79,81,89,97,128,158,239,252,305,337,386,...
    397,442,454,525,533,646,691,717,730,783,810,848,907,910,1026,1261,...
    1361,1424,1620,1673,1940,2021,2304,2437];
% Cumulative deaths in Sierra Leone
data.deadSierraLeone = [0,5,6,6,6,7,49,55,34,99,101,127,142,194,197,206,219,...
    224,233,273,286,298,315,334,348,365,374,392,422,491,509,524,562,562,...
    597,605,622,623];
% Cumulative cases in Liberia
data.infectedLiberia = [13,13,14,14,14,14,33,41,51,107,115,131,142,172,174,...
    196,224,249,329,468,516,554,599,670,786,834,972,1082,1378,1871,2046,...
    2081,2407,2710,3280,3458,3696,3834];
% Cumulative deaths in Liberia
data.deadLiberia = [11,11,12,12,12,12,24,25,34,65,75,84,88,105,106,116,127,...
    129,156,255,282,294,323,355,413,466,576,624,694,1089,1224,1137,1296,...
    1459,1677,1830,1998,2069];

%% Params & Latin Hypercube Sample

numpatches = 3;
paramscaling = lhsdesign(500,18);
paramranges = [0.1   0 0 0 1.5 0.5 0.5 0.5 0.9 1/3 0.5 1/7 1/15 1 8 8 8 ...
    0.001; 0.125 1 1 1 5   0.9 0.9 0.9 1.0 1   1 1/5 1/5 4 12 12 12 0.1];
% Biologically plausible ranges for parameter ranges

plottimes = data.times(1):1:(data.times(end)+31); %May 24 to october 31

% k = knorm*[11745189 6092075 4294077];       
%NOTE - 1. Guinea 2. SL 3. Liberia is the order!   
% Makes matrices for saving stuff
GuineaRuns = [];
GuineaDeathsRuns = [];
GuineaHRuns = [];
GuineaSierraLeoneRuns = [];
GuineaLiberiaRuns = [];
SierraLeoneRuns = [];
SierraLeoneDeathsRuns = [];
SierraLeoneHRuns = [];
SierraLeoneGuineaRuns = [];
SierraLeoneLiberiaRuns = [];
LiberiaRuns = [];
LiberiaDeathsRuns = [];
LiberiaHRuns = [];
LiberiaGuineaRuns = [];
LiberiaSierraLeoneRuns = [];
   
GofRuns = [];
ParamEstRuns = [];
 
for i = 1:500
    i
    % LHS parameters
    ParamsTemp = paramscaling(i,:).*(paramranges(2,:) - ...
        paramranges(1,:)) + paramranges(1,:);  
    
    %% ML (Parameter fitting)
    beta1 = ParamsTemp(2:4);
    deathfrac = ParamsTemp(6:8);
    kappa = ParamsTemp(15:17);
    
    [MiniParamEsts,Gof] = fminsearch(@(paramsfit)...
        GravML15(ParamsTemp,paramsfit,data),[beta1 deathfrac kappa]);
    MiniParamEsts = abs(MiniParamEsts); 
    
    ParamEsts = ParamsTemp;
    ParamEsts(2:4) = MiniParamEsts(1:3);
    ParamEsts(6:8) = MiniParamEsts(4:6);
    ParamEsts(15:17) = MiniParamEsts(7:9);
    
    % More initial Conditions
%     i*exp(1)
    knorm =  ParamEsts(end);
    k = knorm*[11745189 6092075 4294077]; 
    
    %% initial conditions for plotting/saving
    % Guinea
    I1_ICG = 10/k(1);       %people who showed up infected in last few days
    % from t(-1) to  t(0)
    I2_ICG = 6/k(1);        %people who die in next 2 days from t = 0
    % (b/c they were in I2 before then)
    F_ICG = 3/k(1);         %recent dead from last 2-3 days
    R_ICG = 6/k(1); % Recovered persons(estimated based on number of deaths
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
    initialGuinea = [S_ICG EH_ICG EA1_ICG EA2_ICG I1_ICG I2_ICG F_ICG...
        R_ICG IC_ICG DC_ICG IHC_ICG IA1C_ICG IA2C_ICG];
    
    % Sierra Leone
    I1_ICSL = 5/k(2);       %people who showed up infected in last few days
    % from t(-1) to  t(0)
    I2_ICSL = 3/k(2);       %people who die in next 2 days from t = 0
    % (b/c they were in I2 before then)
    F_ICSL = 0/k(2);         %recent dead from last 2-3 days
    R_ICSL = 0/k(2);   % Recovered persons (estimated based on number of
    % deaths versus number of cases overall)
    EH_ICSL = 0/k(2);
    EA1_ICSL = 2*(I1_ICSL + I2_ICSL + F_ICSL);% R0=2, so number of exposed 
    % is approx. equal to twice the infected
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
    R_ICL = 0/k(3);% Recovered persons (estimated based on number of deaths
    % versus number of cases overall)
    EH_ICL = 0;
    EA1_ICL = 2*(I1_ICL + I2_ICL + F_ICL); % Recovered persons (estimated 
    % based on number of deaths versus number of cases overall)
    EA2_ICL = 0/k(3);
    IC_ICL = 2/k(3); % From data
    S_ICL = 1 - IC_ICL - EA1_ICL; %Number of susceptibles (population minus
    %
    DC_ICL = 0/k(3);      %new cases last 15 days - new dead last 15 days
    IHC_ICL = 0/k(3);
    IA1C_ICL = 2/k(3); % seed cases from Guinea
    IA2C_ICL = 0/k(3);
    initialLiberia = [S_ICL EH_ICL EA1_ICL EA2_ICL I1_ICL I2_ICL F_ICL...
        R_ICL IC_ICL DC_ICL IHC_ICL IA1C_ICL IA2C_ICL];
    
    initial0 = [initialGuinea initialSierraLeone initialLiberia];
    
    
    %% Run model for plotting/saving
    [t,x] = ode45(@ebola_gmodel15,plottimes,initial0,[],ParamEsts,numpatches);
%     i*pi
    Guinea_cases = k(1)*x(:,9);
    Guinea_deaths = k(1)*x(:,10);
    Guinea_cases_home = k(1)*x(:,11);
    Guinea_cases_SierraLeone = k(1)*x(:,12);
    Guinea_cases_Liberia = k(1)*x(:,13);
    SierraLeone_cases = k(2)*x(:,22);
    SierraLeone_deaths = k(2)*x(:,23);
    SierraLeone_cases_home = k(2)*x(:,24);
    SierraLeone_cases_Guinea = k(2)*x(:,25);
    SierraLeone_cases_Liberia = k(2)*x(:,26);
    Liberia_cases = k(3)*x(:,35);
    Liberia_deaths = k(3)*x(:,36);
    Liberia_cases_home = k(3)*x(:,37);
    Liberia_cases_Guinea = k(3)*x(:,38);
    Liberia_cases_SierraLeone = k(3)*x(:,39);
    
    % add current data to large matrices
    GuineaRuns = [GuineaRuns, Guinea_cases];
    GuineaDeathsRuns = [GuineaDeathsRuns, Guinea_deaths];
    GuineaHRuns = [GuineaHRuns, Guinea_cases_home];
    GuineaSierraLeoneRuns = [GuineaSierraLeoneRuns,...
        Guinea_cases_SierraLeone];
    GuineaLiberiaRuns = [GuineaLiberiaRuns, Guinea_cases_Liberia];
    SierraLeoneRuns = [SierraLeoneRuns, SierraLeone_cases];
    SierraLeoneDeathsRuns = [SierraLeoneDeathsRuns,...
        SierraLeone_deaths];
    SierraLeoneHRuns = [SierraLeoneHRuns, SierraLeone_cases_home];
    SierraLeoneGuineaRuns = [SierraLeoneGuineaRuns,...
        SierraLeone_cases_Guinea];
    SierraLeoneLiberiaRuns = [SierraLeoneLiberiaRuns,...
        SierraLeone_cases_Liberia];
    LiberiaRuns = [LiberiaRuns, Liberia_cases];
    LiberiaDeathsRuns = [LiberiaDeathsRuns, Liberia_deaths];
    LiberiaHRuns = [LiberiaHRuns, Liberia_cases_home];
    LiberiaGuineaRuns = [LiberiaGuineaRuns, Liberia_cases_Guinea];
    LiberiaSierraLeoneRuns = [LiberiaSierraLeoneRuns,...
        Liberia_cases_SierraLeone];
    
    
    GofRuns = [GofRuns, Gof];
    ParamEstRuns = [ParamEstRuns, ParamEsts'];
    
  
    
figure(1)   
    set(gca,'LineWidth',1,'FontSize',20,'FontName','Arial',...
        'FontWeight','Bold')    
    hold on
    plot(t,Guinea_cases,'r','LineWidth',2);
    plot(data.times,data.infectedGuinea,'ro');
    plot(t,Guinea_deaths,'k','LineWidth',2);
    plot(data.times,data.deadGuinea,'ko');
    legend('Model - Cases', 'Data - Cases', 'Model - Deaths', ...
        'Data - Deaths') 
    xlabel('Days');
    title('Guinea');
    xlim([0 159]);
%Plot for Sierra Leone
figure(2)
    set(gca,'LineWidth',1,'FontSize',20,'FontName','Arial',...
        'FontWeight','Bold')
    hold on
    plot(t,SierraLeone_cases,'r','LineWidth',2);
    plot(data.times,data.infectedSierraLeone,'ro');
    plot(t,SierraLeone_deaths,'k','LineWidth',2);
    plot(data.times,data.deadSierraLeone,'ko');
    legend('Model - Cases', 'Data - Cases', 'Model - Deaths', ...
        'Data - Deaths') 
    xlabel('Days');
    title('Sierra Leone');
    xlim([0 plottimes(end)]);
%Plot for Liberia
figure(3)
    set(gca,'LineWidth',1,'FontSize',20,'FontName','Arial',...
        'FontWeight','Bold')
    hold on
    plot(t,Liberia_cases,'r','LineWidth',2);
    plot(data.times,data.infectedLiberia,'ro');
    plot(t,Liberia_deaths,'k','LineWidth',2);
    plot(data.times,data.deadLiberia,'ko');
    legend('Model - Cases', 'Data - Cases', 'Model - Deaths',...
        'Data - Deaths') 
    xlabel('Days');    
    title('Liberia');
    xlim([0 plottimes(end)]);
%Home v. Away 1
figure (4)
    set(gca,'LineWidth',1,'FontSize',20,'FontName','Arial',...
        'FontWeight','Bold')
    hold on
    plot(t,Guinea_cases_home,'r','LineWidth',2);
    plot(t,Guinea_cases_SierraLeone,'k','LineWidth',2);
    plot(t,Guinea_cases_Liberia,'b','LineWidth',2);
    legend('Home','Away') 
    xlabel('Days');
    title('Guinea Home v. Away');
    xlim([0 plottimes(end)]);
%Home v. Away 2
figure (5)
    set(gca,'LineWidth',1,'FontSize',20,'FontName','Arial','FontWeight',...
        'Bold')
    hold on
    plot(t,SierraLeone_cases_home,'r','LineWidth',2);
    plot(t,SierraLeone_cases_Guinea,'k','LineWidth',2);
    plot(t,SierraLeone_cases_Liberia,'b','LineWidth',2);
    legend('Home','Away')  
    xlabel('Days');
    title('Sierra Leone Home v. Away');
    xlim([0 plottimes(end)]);
%Home v. Away 3
figure (6)
    set(gca,'LineWidth',1,'FontSize',20,'FontName','Arial','FontWeight',...
        'Bold')
    hold on
    plot(t,Liberia_cases_home,'r','LineWidth',2);
    plot(t,Liberia_cases_Guinea,'k','LineWidth',2);
    plot(t,Liberia_cases_SierraLeone,'b','LineWidth',2);
    legend('Home','Away') 
    xlabel('Days');
    title('Liberia Home v. Away');
    xlim([0 plottimes(end)]);

end
 

%% Some Notes


bestparams = ParamEstRuns(:,find(GofRuns == min(GofRuns)))

%% More stuff
LHSParamsKeep = ParamEstRuns;
LHSGofKeep = GofRuns;
WhatsWhat = [];
GuineaCasesKeep = [];
GuineaDeathsKeep = [];
GuineaHKeep = [];
GuineaSLKeep = [];
GuineaLKeep = [];
SierraLeoneCasesKeep = [];
SierraLeoneDeathsKeep = [];
SierraLeoneHKeep = [];
SierraLeoneGKeep = [];
SierraLeoneLKeep = [];
LiberiaCasesKeep = [];
LiberiaDeathsKeep = [];
LiberiaHKeep = [];
LiberiaGKeep = [];
LiberiaSLKeep = [];
WhatsWhat = [WhatsWhat, 'LHSBestFitGuinea,   ']
GuineaCasesKeep = [GuineaCasesKeep,...
    GuineaRuns(:,find(GofRuns == min(GofRuns)))];
GuineaDeathsKeep = [GuineaDeathsKeep,...
    GuineaDeathsRuns(:,find(GofRuns == min(GofRuns)))];
GuineaHKeep = [GuineaHKeep, GuineaHRuns(:,find(GofRuns == min(GofRuns)))];
GuineaSLKeep = [GuineaSLKeep,...
    GuineaSierraLeoneRuns(:,find(GofRuns == min(GofRuns)))];
GuineaLKeep = [GuineaLKeep,...
    GuineaLiberiaRuns(:,find(GofRuns == min(GofRuns)))];

WhatsWhat = [WhatsWhat, 'LHSBestFitSierraLeone,   ']
SierraLeoneCasesKeep = [SierraLeoneCasesKeep,...
    SierraLeoneRuns(:,find(GofRuns == min(GofRuns)))];
SierraLeoneDeathsKeep = [SierraLeoneDeathsKeep,...
    SierraLeoneDeathsRuns(:,find(GofRuns == min(GofRuns)))];
SierraLeoneHKeep = [SierraLeoneHKeep, ...
    SierraLeoneHRuns(:,find(GofRuns == min(GofRuns)))];
SierraLeoneGKeep = [SierraLeoneGKeep, ...
    SierraLeoneGuineaRuns(:,find(GofRuns == min(GofRuns)))];
SierraLeoneLKeep = [SierraLeoneLKeep,...
    SierraLeoneLiberiaRuns(:,find(GofRuns == min(GofRuns)))];

WhatsWhat = [WhatsWhat, 'LHSBestFitLiberia,   ']
LiberiaCasesKeep = [LiberiaCasesKeep,...
    LiberiaRuns(:,find(GofRuns == min(GofRuns)))];
LiberiaDeathsKeep = [LiberiaDeathsKeep,...
    LiberiaDeathsRuns(:,find(GofRuns == min(GofRuns)))];
LiberiaHKeep = [LiberiaHKeep,...
    LiberiaHRuns(:,find(GofRuns == min(GofRuns)))];
LiberiaGKeep = [LiberiaGKeep,...
    LiberiaGuineaRuns(:,find(GofRuns == min(GofRuns)))];
LiberiaSLKeep = [LiberiaSLKeep, ...
    LiberiaSierraLeoneRuns(:,find(GofRuns == min(GofRuns)))];

WhatsWhat = [WhatsWhat, 'LHSMedianGuinea,   ']
GuineaCasesKeep = [GuineaCasesKeep, median(GuineaRuns,2)];
GuineaDeathsKeep = [GuineaDeathsKeep, median(GuineaDeathsRuns,2)];
GuineaHKeep = [GuineaHKeep, median(GuineaHRuns,2)];
GuineaSLKeep = [GuineaSLKeep, median(GuineaSierraLeoneRuns,2)];
GuineaLKeep = [GuineaLKeep, median(GuineaLiberiaRuns,2)];

WhatsWhat = [WhatsWhat, 'LHSMedianSierraLeone,   ']
SierraLeoneCasesKeep = [SierraLeoneCasesKeep, median(SierraLeoneRuns,2)];
SierraLeoneDeathsKeep = [SierraLeoneDeathsKeep,...
    median(SierraLeoneDeathsRuns,2)];
SierraLeoneHKeep = [SierraLeoneHKeep, median(SierraLeoneHRuns,2)];
SierraLeoneGKeep = [SierraLeoneGKeep, median(SierraLeoneGuineaRuns,2)];
SierraLeoneLKeep = [SierraLeoneLKeep, median(SierraLeoneLiberiaRuns,2)];

WhatsWhat = [WhatsWhat, 'LHSMedianLiberia,   ']
LiberiaCasesKeep = [LiberiaCasesKeep, median(LiberiaRuns,2)];
LiberiaDeathsKeep = [LiberiaDeathsKeep, median(LiberiaDeathsRuns,2)];
LiberiaHKeep = [LiberiaHKeep, median(LiberiaHRuns,2)];
LiberiaGKeep = [LiberiaGKeep, median(LiberiaGuineaRuns,2)];
LiberiaSLKeep = [LiberiaSLKeep, median(LiberiaSierraLeoneRuns,2)];


% 95 percent confidence interval-ish

WhatsWhat = [WhatsWhat, 'LHSGuineabottom,   ']
GuineaCasesKeep = [GuineaCasesKeep, quantile(GuineaRuns,0.025,2)];
GuineaDeathsKeep = [GuineaDeathsKeep, quantile(GuineaDeathsRuns,0.025,2)];
GuineaHKeep = [GuineaHKeep, quantile(GuineaHRuns,0.025,2)];
GuineaSLKeep = [GuineaSLKeep, quantile(GuineaSierraLeoneRuns,0.025,2)];
GuineaLKeep = [GuineaLKeep, quantile(GuineaLiberiaRuns,0.025,2)];

WhatsWhat = [WhatsWhat, 'LHSSierraLeonebottom,   ']
SierraLeoneCasesKeep = [SierraLeoneCasesKeep, ...
    quantile(SierraLeoneRuns,0.025,2)];
SierraLeoneDeathsKeep = [SierraLeoneDeathsKeep, ...
    quantile(SierraLeoneDeathsRuns,0.025,2)];
SierraLeoneHKeep = [SierraLeoneHKeep, quantile(SierraLeoneHRuns,0.025,2)];
SierraLeoneGKeep = [SierraLeoneGKeep,...
    quantile(SierraLeoneGuineaRuns,0.025,2)];
SierraLeoneLKeep = [SierraLeoneLKeep,...
    quantile(SierraLeoneLiberiaRuns,0.025,2)];

WhatsWhat = [WhatsWhat, 'LHSLiberiabottom,   ']
LiberiaCasesKeep = [LiberiaCasesKeep, quantile(LiberiaRuns,0.025,2)];
LiberiaDeathsKeep = [LiberiaDeathsKeep,...
    quantile(LiberiaDeathsRuns,0.025,2)];
LiberiaHKeep = [LiberiaHKeep, quantile(LiberiaHRuns,0.025,2)];
LiberiaGKeep = [LiberiaGKeep, quantile(LiberiaGuineaRuns,0.025,2)];
LiberiaSLKeep = [LiberiaSLKeep, quantile(LiberiaSierraLeoneRuns,0.025,2)];

WhatsWhat = [WhatsWhat, 'LHSGuineatop,   ']
GuineaCasesKeep = [GuineaCasesKeep, quantile(GuineaRuns,0.975,2)];
GuineaDeathsKeep = [GuineaDeathsKeep, quantile(GuineaDeathsRuns,.975,2)];
GuineaHKeep = [GuineaHKeep, quantile(GuineaHRuns,.975,2)];
GuineaSLKeep = [GuineaSLKeep, quantile(GuineaSierraLeoneRuns,.975,2)];
GuineaLKeep = [GuineaLKeep, quantile(GuineaLiberiaRuns,.975,2)];

WhatsWhat = [WhatsWhat, 'LHSSierraLeonetop,   ']
SierraLeoneCasesKeep = [SierraLeoneCasesKeep,...
    quantile(SierraLeoneRuns,0.975,2)];
SierraLeoneDeathsKeep = [SierraLeoneDeathsKeep, ...
    quantile(SierraLeoneDeathsRuns,0.975,2)];
SierraLeoneHKeep = [SierraLeoneHKeep, quantile(SierraLeoneHRuns,0.975,2)];
SierraLeoneGKeep = [SierraLeoneGKeep,...
    quantile(SierraLeoneGuineaRuns,0.975,2)];
SierraLeoneLKeep = [SierraLeoneLKeep,...
    quantile(SierraLeoneLiberiaRuns,0.975,2)];

WhatsWhat = [WhatsWhat, 'LHSLiberiatop,   ']
LiberiaCasesKeep = [LiberiaCasesKeep, quantile(LiberiaRuns,0.975,2)];
LiberiaDeathsKeep = [LiberiaDeathsKeep,...
    quantile(LiberiaDeathsRuns,0.975,2)];
LiberiaHKeep = [LiberiaHKeep, quantile(LiberiaHRuns,0.975,2)];
LiberiaGKeep = [LiberiaGKeep, quantile(LiberiaGuineaRuns,0.975,2)];
LiberiaSLKeep = [LiberiaSLKeep, quantile(LiberiaSierraLeoneRuns,0.975,2)];
   

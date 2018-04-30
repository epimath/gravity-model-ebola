%% Runner for the movable-start-date model
%Start dates
%% Country-level data
for i = 1
    datatimes1 = [0 2 3 6 8 11 15 18 20 23 26 29 33 37 39 40 43 46 55 59 61 ...
        66 68 72 80 84 86 93 95 100 102 107 109 111 116 119 123 124 127 129 ...
        132 134 136 139  141 143 149 159 160 161 163 168 175 177 182 184 ...
        185 189 191 196 198 203 207 211 213 217 219 224 226 231 233 238 245 ...
        252 259 266 273 280 287 294 301 308 315 322 329 336 343 350 357];
    % plottimes = datatimes1(1):1:datatimes1(end);% Time: until Sep 30, from March 30
    % Cumulative cases in Guinea
    infectedGuinea = [112 122 127 143 151 159 168 197 203 208 218 224 226 ...
        231 235 236 233 248,258,281,291,328,344,351,398,390,390,413,412,...
        408,409,406,411,410,415,427,460,485,495,495,506,510,519,543,579,...
        607,648,812,862,861,936,942,1022,1074,1157,1199 1199 1298 1350 1472 ...
        1519 1540 1553 1906 1667 1731 1760 1878 1919 1971 2047 2134 2164 ...
        2292 2416 2597 2707 2775 2806 2871 2917 2975 3044 3108 3155 3219 ...
        3285 3389 3429];
    % Cumulative deaths in Guinea
    deadGuinea = [70 80 80 86 95 101 108 122 129 136 141 143 149 155 157 ...
        158 157 171 174,186,193,208,215,226,264,267,270,303,305,307,309,304,...
        310,310,314,319,339,358,363,367,373,377,380,394,396,406,430,517,555,...
        557,595,601,635,648,710,739 739 768 778 843 862 904 926 997 1018 ...
        1041 1054 1142 1166 1192 1214 1260 1327 1428 1525 1607 1708 1781 ...
        1814 1876 1910 1944 1995 2057 2091 2129 2170 2224 2263];
    % Cumulative cases in Sierra Leone
    infectedSierraLeone = [0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0,16,50,79,...
        81,89,97,128,158,239,252,305,337,386,397,442,454,525,533,646,691,...
        717,730,783,810,848,907,910,1026,1261,1361,1424,1620,1673,1940,2021,...
        2304,2437,2437 2789 2950 3252 3410 3706 3896 5235 5338 4759 4862 ...
        5368 5586 6073 6190 6599 7312 7897 8356 9004 9446 9780 10124 10340 ...
        10518 10740 10934 11103 11301 11466 11619 11751 11841];
    % Cumulative deaths in Sierra Leone
    deadSierraLeone = [0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0,5,6,6,6,7,49,...
        55,34,99,101,127,142,194,197,206,219,224,233,273,286,298,315,334,...
        348,365,374,392,422,491,509,524,562,562,597,605,622,623 623 879 930 ...
        1183 1200 1259 1281 1500 1510 1070 1130 1169 1187 1250 1267 1398 ...
        1583 1768 2085 2582 2758 2943 3062 3145 3199 3276 3341 3408 3461 ...
        3546 3629 3691 3747];
    % Cumulative cases in Liberia
    infectedLiberia = [3 3 3 7 8 7 10 10 10 13 13 13 13 13 13 13 13 13 13,...
        13,14,14,14,14,33,41,51,107,115,131,142,172,174,196,224,249,329,468,...
        516,554,599,670,786,834,972,1082,1378,1871,2046,2081,2407,2710,3280,...
        3458,3696,3834 3834 3924 4076 4249 4262 4665 4665 6535 6535 6525 ...
        6619 6822 6878 7069 7082 7168 7635 7719 7797 7862 8018 8157 8331 ...
        8478 8622 8745 8881 9007 9238 9249 9343 9526 9602];
    % Cumulative deaths in Liberia
    deadLiberia = [1 1 1 3 5 6 6 6 6 6 6 6 11 11 11 11 11 11 11,11,12,12,12,...
        12,24,25,34,65,75,84,88,105,106,116,127,129,156,255,282,294,323,355,...
        413,466,576,624,694,1089,1224,1137,1296,1459,1677,1830,1998,2069,...
        2069 2210 2316 2458 2484 2705 2705 2413 2413 2697 2766 2836 2812 ...
        2964 2963 3016 3145 3177 3290 3384 3423 3496 3538 3605 3686 3746 ...
        3826 3900 4037 4117 4162 4264 4301];
end

%% Load district-level data
for i = 1:63
    s3 = 'TimeCourseDataLate/';
    s4 = num2str(i);
    s5 = strcat('data',s4);
    temp = xlsread(strcat(s3,s4,'.xlsx'));
    eval([s5 '= temp;'])
end
%% Set some parameters and initial conditions
plottimes = 0:370; % Day 0: March 31 2014  (e.g. Day 334 is 28 February 2015) 

% number of patches, number of equatinos 
numpatches = 63;
numeq = 11;

% read initial conditions from excel file 
initial1 = reshape(xlsread('InitialConditions2'),numeq *...
    numpatches, 1);
population = [];


% for i=1:numpatches
%     population = [population initial1(1 + 11*(i - 1))];
% end

% count population of each patch based on initial conditions 
for i=1:numpatches
    population = [population (initial1(1 + 11*(i - 1)) + initial1(8 +...
        11*(i-1)) + initial1(9 + 11*(i-1)))];
end


%% Initial guesses for knorm 
for i = 1:1
    knormUnfitted = [0.0005
        0.001
        0.00005
        0.0006
        0.0001
        0.0003
        0.0001
        0.0002
        0.001
        0.0014
        0.0001
        0.0001
        0.0001
        0.0001
        0.0001
        0.0001
        0.0001
        0.0004
        0.0001
        0.0015
        0.0001
        0.0022
        0.0007
        0.014
        0.00135
        0.0001
        0.00045
        0.0017
        0.0067
        0.0005
        0.0014
        0.0101
        0.0038
        0.001
        0.057
        0.038
        0.025
        0.0475
        0.0045
        0.027
        0.032
        0.0355
        0.025
        0.0101
        0.0421
        0.014
        0.255
        0.020
        0.00895
        0.0037
        0.0018
        0.0018
        0.004
        0.0007
        0.018
        0.0044
        0.0111
        0.00225
        0.00585
        0.0016
        0.0055
        0.006
        0.0037];
end
knormUnfitted = abs(knormUnfitted);
reshape(knormUnfitted,1,63);

%%
alpha = 0.1059;
beta1 = [0.0950 0.0504 0.1555];
betaratio = 2;          %3. Ratio between beta1 and the betas for I2 and F
deathfrac = [0.6643 0.3910 0.6710] ;         %4, 5, 6. Overall mortality rate--ended up rewriting gamma, r1, etc. to be in terms of this
deathfrac2 = 0.97;         %7.  Fraction who die in I2 (used 0.95 here, but could also just be 1, i.e. everyone).
delta2 = 0.9;            %8. Burial rate (was named b)
k02 = 0.8;               %9. 1/number of days it takes to leave I2 (for either F or R)
k21 = 0.2;               %10. 1/number of days  takes to leav1,3)e I1 (for either I2 or R)
Rbed = 0.2;      	    %11. rate of leaving R (hospital)
distancefactor = 2.0000;    %12 Distance factor
% kappa = 8.5;
kappa = ones(1,63);
kappa = kappa .* 8.5;
adjustedPatch = 0;
ParamEsts = [alpha beta1 betaratio deathfrac deathfrac2 delta2 k02 k21...
    Rbed distancefactor kappa  adjustedPatch];

%% Calculate new knorms
% "OldKnorm" contains the number of cases in each district when
% knormUnfitted was used to run the model. We want the model and the data
% to line up on Day 306. Thus, we calculate what knorm we would have needed
% to rescale the model to line up with the data on day 306, by grabbing the
% data for day 306 and then using knormCalculator2 on the result. 

load('OldKnorm','cases')
dateWanted = 306;
modelCases = cases(dateWanted + 1,:);
dataCases = zeros(1,63);

for i = 1:63
    i
    s4 = num2str(i);
    s5 = strcat('data',s4);
    eval(['temp=' s5 ';' ]);
    [a,b] = find(temp(1,:)==dateWanted,1);
    dataCases(i) = temp(2,b);
end

startCases = zeros(1,63);
for i = 1:63
    startCases(i) = initial1(8 + numeq * (i - 1));
end

knorm = knormCalculator2(modelCases,dataCases,startCases,knormUnfitted);


%% Further adjustments 
% (adjusting knorms for certain districts to get better overall fits)
% The commented-out adjustments were not used for the model simulations
% appearing in the paper. 

knorm(61) = (47/45)*knorm(61);
knorm(60) = 1.02*knorm(60);
knorm(59) = (4412/4793)*knorm(59);
knorm(58) = 1.1*knorm(58);
knorm(57) = 0.99*knorm(57);
knorm(54) = 1.1*knorm(54);
knorm(52) = 1.02*knorm(52);
% knorm(48) = 0.9*knorm(48); % 
% knorm(45) = 0.95*knorm(45); %
% knorm(41) = 0.95*knorm(41); %
% knorm(39) = 0.75*knorm(39); %
knorm(35) = 1.05*knorm(35);
knorm(30) = 1.6*knorm(30);
knorm(29) = 0.97*knorm(29);
knorm(34) = (12/11)*knorm(34);
knorm(25) = (21/20)*knorm(25);
knorm(24) = 1.025*knorm(24);
knorm(20) = (9/10)*knorm(20);
knorm(18) = (10/8)*knorm(18);
knorm(10) = (12/9)*knorm(10);
knorm(8) = (92/100)*knorm(8);
% knorm(4) = 0.95*knorm(4);
% knorm(2) = (35/44)*knorm(2);


knorm(1) = (487/643)*knorm(1); %(373/766)*1.2*knorm(1);
knorm(8) = (86 / 79.5) * knorm(8);
%% Calculate startDates 
% not used for this version of the model. 
% startDates = zeros(1,63);
% for i = 1:63
%     s4 = num2str(i);
%     s5 = strcat('data',s4);
%     eval(['temp=' s5 ';' ]);
%     startJunk = find(temp(2,:),1);
%     if startJunk
%         startDates(i) = temp(1,startJunk);
%     else
%         startDates(i) = 300;
%     end
% end
%% initial conditions and distances
distances = xlsread('Distance_Matrix_3_21');

for i = 1:numpatches
    for j = 2:numeq
        initial1(j + numeq * (i - 1)) = initial1(j + numeq * ( i - 1)) / knorm(i);
    end
end

%% Run model
[t, y] = ode15s(@ebola_gmodelINT8,plottimes,initial1,[],ParamEsts,...
    numpatches,population,distances);
knorm(1) = knorm(1) / 1.125;

for i = 1:63
    for j = 2:11
        y(:,j + 11 * (i - 1)) = y(:,j + 11 * (i - 1)) * knorm(i);
    end
end


%%
cases = zeros(length(plottimes),63);
% startDates = zeros(1,63);
for n = 1:numpatches
    cases(:,n) = y(:,(8 + 11*(n-1)));
end

numCasesEnd = zeros(1,64);
numCasesEnd(1) = sum(cases(end,:));
for n = 1:numpatches
    numCasesEnd(n + 1) = numCasesEnd(1) - cases(end,n);
end

% for j = 1:63
%     casesDate = cases(:,j);
%     index = find(casesDate > 1,1);
%     startDates(j) = index;
% end
%
% a = 1:1:length(usedIndex);
% plotDates = zeros(1,length(usedIndex));
% for i = 1:1:length(usedIndex)
%     plotDates(i) = startDates(usedIndex(i));
% end



%% Sum of least squares for model values versus data (all districts combined) 
for i = 1:63
    junkVar = [];
    i;
    s4 = num2str(i);
    s5 = strcat('data',s4);
    eval(['junkVar =' s5 ';'])
    times = junkVar(1,:);
    junkCases = junkVar(2,:);
    junkDeaths = junkVar(3,:);
    PatchCasesDate = zeros(1,length(times));
    PatchDeathsDate = zeros(1,length(times));
    for j = 1:length(times)
        j;
        time_ind = times(j) + 1;
        PatchCasesDate(j) = y(time_ind,8 + (i - 1) * 11);
        PatchDeathsDate(j) = y(time_ind,9 + (i - 1) * 11);
    end
    casesDiffs = sum((PatchCasesDate - junkCases).^2);
    deathsDiffs = sum((PatchCasesDate - junkDeaths).^2);
    diffValues(i) = sum(casesDiffs) + sum(deathsDiffs);
end

LL = sum(diffValues)

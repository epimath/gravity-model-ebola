%Ebola Spatial SEI1I2FRD model

function dxdt = ebola_gmodel15(t,x, params, numpatches)

%% Data for gravity term

distance = [0,265,710; 265,0,546 ; 710,546,0];	%Data taken from Google...
%           Maps Directions, September 30, 2014, about 9:17 PM Eastern Time
population = [11745189 6092075 4294077];	%Data taken from World Bank...
                                        % populations on September 30, 2014

%% Parameter    					Explanation of parameter

alpha = params(1); %1/latent period, rate at which people pass from E to I1
beta1 = params(2:4);					%Transmission from I1
betaratio = params(5);	%Ratio of I2 and D transmission to I1 transmission
deathfrac = params(6:8);   %fraction of I1s who go to die (through I2)
                            % for each country
deathfrac2 = params(9);					%fraction of I2s who die
delta2 = params(10);					%Burial rate
k02 = params(11);					%1/I2 period (rate of leaving I2)
k21 = params(12);					%1/I1 period (rate of leaving I1)
Rbed = params(13);					%1/Estimated time needing a hospital 
                                    % bed (rate of leaving hospital)
distancefactor = params(14);				%exponent on distance term
kappa = [10^(-params(15)) 10^(-params(16)) 10^(-params(17))];				
    %constant by which theta (patch-patch influence) is multiplied
numeq = 13;                         %how many equations are there
 



%% System of ODEs

dxdt = zeros(numeq*numpatches,1);

for n = 1:numpatches
    sigma1 = 0;
    sigma2 = 0;
    sigma3 = 0;
    %Parameters calculated from other parameters
    betan = beta1(n);
    beta2 = betaratio*betan;				%Transmission of I2s
    betaD = betaratio*betan;				%Transmission of Fs
    gamma = deathfrac*k21/deathfrac2;	%Rate of movement from I1 to I2
    r1 = (ones(size(deathfrac))-(deathfrac/deathfrac2))*k21;	
    %Rate of recovery from I1
    delta = deathfrac2*k02;					%Rate of death from I2
    r2 = (1-deathfrac2)*k02;				%Rate of recovery from I2
%     'first for loop!'
    kappan = kappa(n);
    if n == 1 %GUINEA
        sigma1 = sigma1 + betan*x(5+numeq*(n-1)) + ...
            beta2*x(6+numeq*(n-1)) + beta2*x(7+numeq*(n-1)); %GUINEA
        sigma2 = sigma2 + betan*x(5+numeq*(n)) + beta2*x(6+numeq*(n))...
            + beta2*x(7+numeq*(n)); %SIERRA LEONE
        sigma3 = sigma3 + betan*x(5+numeq*(n+1)) + ...
            beta2*x(6+numeq*(n+1)) + beta2*x(7+numeq*(n+1)); %LIBERIA
        thetaGSL = kappan*population(n)*population(2)/...
            (distance(2,n)^distancefactor); 
        %"GRAVITATIONAL" ATTRACTION BETWEEN GUINEA AND SIERRA LEONE
        sigma2 = thetaGSL*sigma2;
        thetaGL =  kappan*population(n)*population(3)/...
            (distance(3,n)^distancefactor); 
        %GRAVITATIONAL ATTRACTION BETWEEN GUINEA AND LIBERIA
        sigma3 = thetaGL*sigma3;
    elseif n == 2 %SIERRALEONE
        sigma1 = sigma1 + betan*x(5+numeq*(n-1)) + ...
            beta2*x(6+numeq*(n-1)) + beta2*x(7+numeq*(n-1)); %SIERRA LEONE
        sigma2 = sigma2 + betan*x(5+numeq*(n-2)) + ...
            beta2*x(6+numeq*(n-2)) + beta2*x(7+numeq*(n-2)); %GUINEA
        sigma3 = sigma3 + betan*x(5+numeq*(n)) +...
            beta2*x(6+numeq*(n)) + beta2*x(7+numeq*(n)); %LIBERIA
        thetaSLG = kappan*population(n)*population(1)...
            /(distance(1,n)^distancefactor);
        %GRAVITATIONAL ATTRACTION BETWEEN SIERRA LEONE AND GUINEA
        sigma2 = thetaSLG*sigma2;
        thetaSLL = kappan*population(n)*population(3)/...
            (distance(3,n)^distancefactor); 
        %GRAVITATIONAL ATTRACTION BETWEEN SIERRA LEONE AND LIBERIA
        sigma3 = thetaSLL*sigma3;
    else
        sigma1 = sigma1 + betan*x(5+numeq*(n-1)) + ...
            beta2*x(6+numeq*(n-1)) + beta2*x(7+numeq*(n-1)); %LIBERIA
        sigma2 = sigma2 + betan*x(5+numeq*(n-3)) +...
            beta2*x(6+numeq*(n-3)) + beta2*x(7+numeq*(n-3)); %GUINEA
        sigma3 = sigma3 + betan*x(5+numeq*(n-2)) +...
            beta2*x(6+numeq*(n-2)) + beta2*x(7+numeq*(n-2));%SIERRA LEONE
        thetaLG =  kappan*population(n)*population(1)/...
            (distance(1,n)^distancefactor);
        %GRAVITATIONAL ATTRACTION BETWEEN LIBERIA AND GUINEA
        sigma2 = thetaLG*sigma2;
        thetaLSL = kappan*population(n)*population(2)/...
            (distance(2,n)^distancefactor);
        %GRAVITATIONAL ATTRACTION BETWEEN Liberia AND Sierra Leone
        sigma3 = thetaLSL*sigma3;
    end
    %dSdt  
    dxdt(1+numeq*(n-1)) = -(sigma1 + sigma2 + sigma3)*x(1+numeq*(n-1)); %  
    %dEHdt
    dxdt(2+numeq*(n-1)) = sigma1*x(1+numeq*(n-1)) - alpha*x(2+numeq*(n-1));
    %dEA1dt
    dxdt(3+numeq*(n-1)) = sigma2*x(1+numeq*(n-1)) - alpha*x(3+numeq*(n-1));
    %dEA2dt
    dxdt(4+numeq*(n-1)) = sigma3*x(1+numeq*(n-1)) - alpha*x(4+numeq*(n-1));
    %dI1dt
    dxdt(5+numeq*(n-1)) = alpha*(x(2+numeq*(n-1)) + x(3+numeq*(n-1)) +...
        x(4+numeq*(n-1))) - gamma(n)*x(5+numeq*(n-1)) -...
        r1(n)*x(5+numeq*(n-1)); 
    %dI2dt
    dxdt(6+numeq*(n-1)) = gamma(n)*x(5+numeq*(n-1)) - ...
        delta*x(6+numeq*(n-1)) - r2*x(6+numeq*(n-1));
    %dFdt
    dxdt(7+numeq*(n-1)) = delta*x(6+numeq*(n-1)) - delta2*x(7+numeq*(n-1)); 
    %dRdt
    dxdt(8+numeq*(n-1)) = r1(n)*x(5+numeq*(n-1)) + r2*x(6+numeq*(n-1))...
        - Rbed*x(8+numeq*(n-1)); 
    %dICdt
    dxdt(9+numeq*(n-1)) = alpha*(x(2+numeq*(n-1)) + x(3+numeq*(n-1))...
        + x(4+numeq*(n-1))); 
    %dDCdt
    dxdt(10+numeq*(n-1)) = delta*x(6+numeq*(n-1));
    %dIHCdt
    dxdt(11+numeq*(n-1)) = alpha*x(2+numeq*(n-1));
    %dIA1Cdt
    dxdt(12+numeq*(n-1)) = alpha*x(3+numeq*(n-1)); 
    %dIA2Cdt
    dxdt(13+numeq*(n-1)) = alpha*x(4+numeq*(n-1)); 
end

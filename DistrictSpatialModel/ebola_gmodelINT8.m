%Ebola Spatial SEI1I2FRD model

function dxdt = ebola_gmodelINT8(t,x, params, numpatches, population, distance)
%% Parameter    					Explanation of parameter

alpha = params(1); 					%1/latent period, rate at which people pass from E to I1
beta1 = params(2:4); 					%Transmission from I1
betaratio = params(5); 					%Ratio of I2 and D transmission to I1 transmission
deathfrac = params(6:8); 				%fraction of I1s who go to die (through I2) for each country
deathfrac2 = params(9);					%fraction of I2s who die
delta2 = params(10);					%Burial rate
k02 = params(11);					%1/I2 period (rate of leaving I2)
k21 = params(12);					%1/I1 period (rate of leaving I1)
Rbed = params(13);					%1/Estimated time needing a hospital bed (rate of leaving hospital)
distancefactor = params(14);				%exponent on distance term
kappa = [10^(-params(15))];
for i = 1:(numpatches - 1)
	kappa = [kappa 10^(-params(15 + i))];					%constant by which theta (patch-patch influence) is multiplied
end
adjustedPatch = params(end); % This is the patch with transmission knocked out


numeq = 11;                         %how many equations are there



%% System of ODEs

dxdt = zeros(numeq*numpatches,1); 
% 'hello! I made the dxdt'

for n = 1:numpatches
    %Parameters calculated from other parameters
    if n > 48
        betan = beta1(3);
        deathfracn = deathfrac(3);
    elseif n > 34
        betan = beta1(2);
        deathfracn = deathfrac(2);
    else
        betan = beta1(1);
        deathfracn = deathfrac(1);
    end
    
    betaHome = betan / population(n);        

    gamma = deathfracn*k21/deathfrac2;			%Rate of movement from I1 to I2
    r1 = (1 - (deathfracn/deathfrac2))*k21;	%Rate of recovery from I1
    r1n = r1;
    delta = deathfrac2*k02;					%Rate of death from I2
    r2 = (1 - deathfrac2)*k02;				%Rate of recovery from I2
    
    theta = zeros(numpatches);
    sigma = zeros(numpatches);
    sigmaHome = zeros(numpatches,1); 
    betaAway = zeros(numpatches,1);
    for junk = 1:63
        betaAway(junk) = betan / population(junk);
    end
    
    
    for i = 1:numpatches
        for j = 1:numpatches
            if (i ~= j)
                kappan = kappa(i);
                theta(i,j) =  kappan * population(i) * population(j) / ...
                    (distance(i,j) ^ distancefactor);
                sigma(i,j) =  theta(i,j)*(betaAway(j) * x(4 + numeq*(j - 1)) +...
                    betaAway(j) * betaratio * x(5 + numeq*(j - 1)) + betaAway(j)...
                    * betaratio * x(6 + numeq*(j - 1)));
            else
                sigmaHome(i) =  (betaHome * x(4 + numeq*(j - 1)) + ...
                    betaHome * betaratio * x(5 + numeq*(j - 1)) + betaHome...
                    * betaratio * x(6 + numeq*(j - 1)));
                sigma(i,j) = 0;
            end
        end
    end
    sigmaAway = sum(sigma,2);
    
    if n == adjustedPatch

            sigmaHome(n) = 0;
            sigmaAway(n) = 0;

    end
    dxdt(1 + numeq * (n - 1)) = -(sigmaHome(n) + sigmaAway(n)) *...
        x(1 + numeq * (n - 1)); %dSdt 
    dxdt(2 + numeq * (n - 1)) = sigmaHome(n) * x(1 + numeq * (n - 1)) - ...
        alpha * x(2 + numeq * (n - 1)); %dEHdt
    dxdt(3 + numeq * (n - 1)) = sigmaAway(n) * x(1 + numeq * (n - 1)) ...
        - alpha * x(3 + numeq * (n - 1)); %dEAdt
    dxdt(4 + numeq * (n - 1)) = alpha * (x(2 + numeq * (n - 1)) + ...
        x(3 + numeq * (n - 1))) - gamma * x(4 + numeq * (n - 1)) - ...
        r1n * x(4 + numeq * (n - 1)); %dI1dt
    dxdt(5 + numeq * (n - 1)) = gamma * x(4 + numeq * (n - 1)) - ...
        delta * x(5 + numeq * (n - 1)) - r2 * x(5 + numeq * (n - 1)); %dI2dt
    dxdt(6 + numeq * (n - 1)) = delta * x(5 + numeq * (n - 1)) - ...
        delta2 * x(6 + numeq * (n - 1)); %dFdt
    dxdt(7 + numeq * (n - 1)) = r1n * x(4 + numeq * (n - 1)) + ...
        r2 * x(5 + numeq * (n - 1)) - Rbed * x(8 + numeq * (n - 1)); %dRdt
    dxdt(8 + numeq * (n - 1)) = alpha * (x(2 + numeq * (n - 1)) + ... 
        x(3 + numeq * (n - 1))); %dICdt
    dxdt(9 + numeq * (n - 1)) = delta * x(5 + numeq * (n - 1)); %dDCdt
    dxdt(10 + numeq * (n - 1)) = alpha * x(2 + numeq * (n - 1)); %dIHCdt
    dxdt(11 + numeq * (n - 1)) = alpha * x(3 + numeq * (n - 1)); %dIACdt
end


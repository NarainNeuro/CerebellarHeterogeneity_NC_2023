function [Ift, stats] = PlotMatch4(param, p,v, Theory, VPCRaw, Dent,  BlsEst )

global Plotcheck

% Uniform
clr(1,4,1:3)                = rgb('Navy');   % Navy
clr(1,3,1:3)                = rgb('CornflowerBlue'); % Cornflower
clr(1,2,1:3)                = rgb('Aqua'); % light blue
clr(1,1,1:3)                = rgb('LightBlue'); % light blue

% Gaussian
clr(2,1,1:3)                = rgb('Lavender');
clr(2,2,1:3)                = rgb('Plum'); % purple
clr(2,3,1:3)                = rgb('Orchid'); % Violet
clr(2,4,1:3)                = rgb('DarkOrchid'); % purple


% Greys
ct(1,1:3)                   = rgb('LightGray');
ct(2,1:3)                   = rgb('DimGray'); % purple
ct(3,1:3)                   = rgb('SlateGray'); % Violet
ct(4,1:3)                   = rgb('DarkSlateGray'); % purple


timeline                    = param.genpars.timeline;
endtime                     = param.genpars.endtime;
Wmc                         = length(param.prior.wm);


Int = BlsEst ;

% Isolate around prior and regress with theoretical prior


if(p == 1)
    
    for wm = 1%1:Wmc
    
%     Uniform prior
a       = param.prior.uni(1,v);
b       = param.prior.uni(2,v);
rangep  = a+1  : b;

theory = Theory{wm}.bls.teVals(rangep)';

Integ  = Int(rangep)';

% size(Integ)

regMt = [ones(length(Integ),1) Integ];

% size(theory)
% size(regMt)
% Obtain Stats
[I, bint, ci, rint, stats] = regress(theory,regMt);

% DnDisp('Sum of integrabd value for uniform is: ')
% sum(Integ)

% fit
Ift       =  I(1) + I(2).*Integ;




figure(1000), hold on
title('Uniform')
plot(rangep,theory,'-','Color',ct(wm,:),'LineWidth',2)
plot(rangep,Ift,'-','Color',squeeze(clr(p,wm,:)))
plot(rangep,rangep,'k--' )
figure, hold on
title('All Wm')

    
    
end
    


else
    
    
    
    % Gaussian prior
mu      = param.prior.gauss(1,v);
sd      = param.prior.gauss(2,v);
rangep  = mu - sd : mu + 2*sd;

for wm = 1%1:Wmc

theory = Theory{wm}.bls.teVals(rangep)';

Integ  = Int(rangep)';

regMt = [ones(length(Integ),1) Integ];

% Obtain Stats
[I, bint, ci, rint, stats] = regress(theory,regMt);

% fit
Ift       =  I(1) + I(2).*Integ;

prior = 1/sqrt(sd^2).*exp(-0.5*(rangep-mu).^2./sd^2)*1000 + 300;


if(Plotcheck)
figure(1001), hold on
title('Gaussian')
plot(rangep,prior,'k-')
plot(rangep,theory,'-','Color',ct(wm,:),'LineWidth',2)
plot(rangep,Ift,'-','Color',squeeze(clr(p,wm,:)))
plot(rangep,rangep,'k--' )

end


end

end





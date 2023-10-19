function [Ift, stats] = PlotMatch5(param,p,v, Theory, VPCRaw, Dent,  BlsEst, Vector )

global Plotcheck

% Uniform --- Shades of Orange
clr(1,1,1:3)                = rgb('Orange');   
clr(1,2,1:3)                = rgb('DarkOrange'); 
clr(1,3,1:3)                = rgb('FireBrick'); 
clr(1,4,1:3)                = rgb('Crimson'); 

% Gaussian --- Shades of Blue
clr(2,1,1:3)                = rgb('DeepSkyBlue');
clr(2,2,1:3)                = rgb('CornflowerBlue');
clr(2,3,1:3)                = rgb('Indigo'); % Violet
clr(2,4,1:3)                = rgb('MidnightBlue'); % purple


% True
ct(1,1:3)                   = rgb('Black');
ct(2,1:3)                   = rgb('DarkSlateGray'); % 
ct(3,1:3)                   = rgb('SlateGray'); % 
ct(4,1:3)                   = rgb('DarkGray'); % 


timeline                    = param.genpars.timeline;
endtime                     = param.genpars.endtime;
Wmc                         = length(param.prior.wm);


Int = BlsEst ;
figure(133)
plot(BlsEst,'r')
plot(BlsEst(Vector),'g')
% Isolate around prior and regress with theoretical prior


if(p == 1)
    
    for wm = 1:Wmc
    
%     Uniform prior
a       = param.prior.uni(1,v);
b       = param.prior.uni(2,v);
rangep  = Vector;

theory = Theory(p,rangep)';
figure(90); hold on
plot(rangep,theory)

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

% prior = Theory{wm}.bls.prior.*0.5 + 300;
if(Plotcheck)

figure(1000), hold on
title('Uniform')
% plot(prior,'-','Color',squeeze(clr(p,v,:)))
plot(rangep,theory,'-','Color',ct(1,:))
plot(rangep,Ift,'-','Color',squeeze(clr(p,v,:)))
if(v == 2)
plot(300:1600,300:1600,'--','Color',ct(3,:) )
end
% axis([400 1300 400 1200]) % Two Prior
axis([400 1700 400 1450])
grid on
end
    
    
end
    


else
    
    
    
    % Gaussian prior
mu      = param.prior.gauss(1,v);
sd      = param.prior.gauss(2,v);
rangep  = Vector;

for wm = 1:Wmc

theory = Theory(p,rangep)';
figure(91); hold on
plot(rangep,theory)

Integ  = Int(rangep)';

regMt = [ones(length(Integ),1) Integ];

% Obtain Stats
[I, bint, ci, rint, stats] = regress(theory,regMt);

% fit
Ift       =  I(1) + I(2).*Integ;

prior = 1/sqrt(sd^2).*exp(-0.5*(timeline-mu).^2./sd^2)*8000 + 250;


if(Plotcheck)
figure(1001), hold on
title('Gaussian')
plot(prior,'-','Color',squeeze(clr(p,v,:)))
plot(rangep,theory,'-','Color',ct(1,:))
plot(rangep,Ift,'-','Color',squeeze(clr(p,v,:)))
if(v == 2)
plot(200:1600,200:1600,'--','Color',ct(3,:) )
end
% axis([400 1200 400 1200]) % Two Prior
axis([250 1400 200 1200])
grid on
end


end

end





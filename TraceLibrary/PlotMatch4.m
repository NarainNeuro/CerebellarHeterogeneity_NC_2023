function [Ift, stats] = PlotMatch4(param, p,v, Theory, VPCRaw, Dent,  BlsEst )

global Plotcheck

Plotcheck = 1;

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
weber                       = param.prior.wm;

            
                samples                 = 400;
                Nrepeats                = 100000;
                
                tmvec                   = 1:endtime;
%                 ts2tm = @(x) random('norm',x,x*Wmc,size(x));


Int = BlsEst ;

% Isolate around prior and regress with theoretical prior


if(p == 1)
    
    for wm = 1:Wmc
    
%     Uniform prior
a       = param.prior.uni(1,v);
b       = param.prior.uni(2,v);
% rangep  = a - 100 : b+300;
rangep  = a +1 : b ;
tsVals = round(linspace(a+1,b, samples));

theory = Theory{wm}.bls.teVals(rangep)';
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

prior = Theory{wm}.bls.prior.*0.8 + 300;


% vect = rangep;
% Beehive   = Ift;
% figure(143), hold on, plot(rangep,Ift)
% f_tmvec     = Beehive;

ts2tm = @(x) random('norm',x,x*weber,size(x));
f_tm    = @(tm) interp1(rangep,Ift,tm);

 for i                      = 1:length(tsVals)
	this_ts                 = tsVals(i);
	tm_sim                  = ts2tm(repmat(this_ts,Nrepeats,1));
	te_sim                  = f_tm(tm_sim);
	teVals(i,1:Nrepeats)    = te_sim;
    bh_sd(i)                = nanstd(te_sim);
    bh_mu(i)                = nanmean(te_sim);

end 
% regMt = [ones(length(bh_mu),1) bh_mu'];
% % size(theory)
% % size(regMt)
% [I, bint, ci, rint, stats] = regress(theory,regMt);
% Ift       =  I(1) + I(2).*Integ;
% Ift
% bh_mu = bh_mu*1.12;
if(Plotcheck)

figure(1000), hold on
title('Uniform')
plot(prior,'-','Color',squeeze(clr(p,v,:)))
shadedErrorBar(tsVals,bh_mu,bh_sd,{'color',clr(p,v,:)})
plot(rangep,theory,'-','Color',ct(1,:))
% plot(rangep,Ift,'-','Color',squeeze(clr(p,v,:)))
if(v == 2)
plot(300:1700,300:1700,'--','Color',ct(3,:) )
end
% axis([400 1300 400 1200]) % Two Prior
axis([400 1700 400 1700])
grid on
end
    
    
end
    


else
    
    
    
    % Gaussian prior
mu      = param.prior.gauss(1,v);
sd      = param.prior.gauss(2,v);
rangep  = mu - 2*sd : mu + 2*sd;
tsVals = round(linspace(mu - 2*sd+1,mu + 2*sd, samples));

for wm = 1:Wmc

theory = Theory{wm}.bls.teVals(rangep)';
figure(91); hold on
plot(rangep,theory)

Integ  = Int(rangep)';

regMt = [ones(length(Integ),1) Integ];

% Obtain Stats
[I, bint, ci, rint, stats] = regress(theory,regMt);

% fit
Ift       =  I(1) + I(2).*Integ;

prior = 1/sqrt(sd^2).*exp(-0.5*(timeline-mu).^2./sd^2)*4000 + 250;



vect = rangep;
Beehive   = Ift;
f_tmvec     = Beehive;
ts2tm = @(x) random('norm',x,x*weber,size(x));
f_tm    = @(tm) interp1(vect,f_tmvec,tm);

 for i      = 1:length(tsVals)
	this_ts = tsVals(i);
	tm_sim  = ts2tm(repmat(this_ts,Nrepeats,1));
	te_sim  = f_tm(tm_sim);
	teVals(i,1:Nrepeats) = te_sim;
    bh_sd(i)            = nanstd(te_sim);
    bh_mu(i)            = nanmean(te_sim);

end 
% regMt = [ones(length(bh_mu),1) bh_mu];
% [I, bint, ci, rint, stats] = regress(theory,regMt);
% Ift       =  I(1) + I(2).*Integ;
% 

% bh_mu = bh_mu*1.12;
if(Plotcheck)
figure(1001), hold on
title('Gaussian')
plot(prior,'-','Color',squeeze(clr(p,v,:)))
shadedErrorBar(tsVals,bh_mu,bh_sd,{'color',clr(p,v,:)})
plot(rangep,theory,'-','Color',ct(1,:))
% plot(rangep,Ift,'-','Color',squeeze(clr(p,v,:)))
if(v == 2)
plot(200:1600,200:1600,'--','Color',ct(3,:) )
end
% axis([400 1200 400 1200]) % Two Prior
axis([250 1400 250 1400])
grid on
end


end

end





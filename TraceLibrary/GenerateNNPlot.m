function [Ift, stats] = GenerateNNPlot(param, p,v, Theory, VPCRaw, Dent,  BlsEst )

global Plotcheck

% Uniform
clr(1,1:3)                = rgb('Black');   % Navy
clr(2,1:3)                = rgb('Maroon'); % Cornflower
clr(3,1:3)                = rgb('FireBrick'); % light blue


or(1,1:3)                = rgb('Orange');   % Navy
or(2,1:3)                = rgb('DarkOrange'); % Cornflower
or(3,1:3)                = rgb('FireBrick'); % light blue



timeline                    = param.genpars.timeline;
endtime                     = param.genpars.endtime;
Wmc                         = length(param.prior.wm);
weber                       = 0.07;
sdx                         = 50; % motor noise

Int = BlsEst ;


if(p == 1)
    
wm = 1;
    
%     Uniform prior
lb       = param.prior.uni(1,v);
ub       = param.prior.uni(2,v);
range = lb:ub;

sampler = lb - 200: ub + 200; func = Int(sampler)';
t2 = Theory{wm}.bls.teVals(sampler)';
regMt = [ones(length(func),1) func];
I2 = regress(t2,regMt); tracefun = I2(1) + I2(2).*func;

theory = Theory{wm}.bls.teVals(range)';
Integ  = Int(range)';

% size(Integ)

regMt = [ones(length(Integ),1) Integ];
[I, bint, ci, rint, stats] = regress(theory,regMt);



% fit
Ift       =  I(1) + I(2).*Integ;

% Generating motor noise around the time estaimate

ts2tm = @(x) random('norm',x,x*weber,size(x));

f_tm    = @(tm) interp1(sampler, tracefun,tm);

tsVals = round(linspace(lb,ub,11));
Nrepeats = 1000;

 for i                      = 1:length(tsVals)
	this_ts                 = tsVals(i);
	tm_sim                  = ts2tm(repmat(this_ts,Nrepeats,1));
	te_sim                  = f_tm(tm_sim);
	teVals(i,1:Nrepeats)    = te_sim;
    bh_sd(i)                = nanstd(te_sim);
    bh_mu(i)                = nanmedian(te_sim);

end 


figure(1000), hold on

if(v == 1)
 % Add labels
                            hTitle = title('Trace Jazayeri Shadlen 2010');
                            hXLabel = xlabel('Sample interval (ms)');
                            hYLabel = ylabel('Production time (ms)');
                            % Adjust font
                            set(gca, 'FontName', 'Helvetica')
                            set([hTitle, hXLabel, hYLabel], 'FontName', 'AvantGarde')
%                             set([hLegend, gca], 'FontSize', 8)
                            set([hXLabel, hYLabel], 'FontSize', 10)
                            set(hTitle, 'FontSize', 12, 'FontWeight' , 'bold')

                            % Adjust axes properties
                            set(gca, 'Box', 'off', 'TickDir', 'out', 'TickLength', [.02 .02], ...
                            'XMinorTick', 'off', 'YMinorTick', 'off', 'YGrid', 'off', ...
                            'XColor', [.3 .3 .3], 'YColor', [.3 .3 .3], 'XTick', [494 671 847 1023 1200], ...
                            'YTick', [494 671 847 1023 1200], ...
                            'LineWidth', 1)

                        plot([450 1250],[450 1250],'--k')
                      

                        
end
  prior_mu = lb + (ub - lb)*0.5;
  plot(range,ones(length(range),1)*prior_mu,'k--')
% plot(range,theory,'-','Color',ct(wm,:),'LineWidth',2)

% plot(range,Ift,'-','Color',clr(v,:),'MarkerEdgeColor','none','MarkerFaceColor',clr(v,:),'LineWidth',3)
for i = 1:length(tsVals)
plot(tsVals(i)*ones(Nrepeats,1),teVals(i,:),'.','Color',clr(v,:),'MarkerSize',6)
end
plot(tsVals,bh_mu,'o-','MarkerFaceColor',clr(v,:),'MarkerEdgeColor','none','MarkerSize',10,'Color',clr(v,:),'LineWidth',6)
axis([430 1250 430 1250])
    

figure(2000), hold on

if(v == 1)
 % Add labels
                            hTitle = title('Trace predictions');
                            hXLabel = xlabel('Tm (ms)');
                            hYLabel = ylabel('Te (ms)');
                            % Adjust font
                            set(gca, 'FontName', 'Helvetica')
                            set([hTitle, hXLabel, hYLabel], 'FontName', 'AvantGarde')
%                             set([hLegend, gca], 'FontSize', 8)
                            set([hXLabel, hYLabel], 'FontSize', 10)
                            set(hTitle, 'FontSize', 12, 'FontWeight' , 'bold')

                            % Adjust axes properties
                            set(gca, 'Box', 'off', 'TickDir', 'out', 'TickLength', [.02 .02], ...
                            'XMinorTick', 'off', 'YMinorTick', 'off', 'YGrid', 'off', ...
                            'XColor', [.3 .3 .3], 'YColor', [.3 .3 .3], 'XTick', [494 671 847 1023 1200], ...
                            'YTick', [494 671 847 1023 1200], ...
                            'LineWidth', 1)

                        plot([450 1250],[450 1250],'--k')
                      

                        
end
%   prior_mu = lb + (ub - lb)*0.5;
%   plot(range,ones(length(range),1)*prior_mu,'k--')
 plot(range,theory,'-','Color','k','LineWidth',1)
plot(range,Ift,'-','Color',or(v,:),'LineWidth',1)

axis([430 1250 430 1250])
    
else
    error('Use the PlotMatch library of functions for generic prior implementations')

end


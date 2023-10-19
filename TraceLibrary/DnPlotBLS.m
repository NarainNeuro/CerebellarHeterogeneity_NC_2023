function [] = DnPlotBLS(th,param,p)

% Get BLS and check with TeTs version
 [F, Fder, P] = DnBLS(param,'Plotcheck',1);


% Color Matrix

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


figure(140+p), hold on
title('E(te|ts)')
 pr = P(p,:);
 plot(pr,'-','Color',[0.6 0.6 0.6])
 
for w = 1:length(param.prior.wm)
    
    tetm = squeeze(F(p,w,:));
    tets = th{w}.bls.teVals;
    ts   = th{w}.bls.tsVals;
    
   
 plot(ts,ts,'k--');
 plot(tetm,'-','Color',clr(p,w,:))
 plot(ts,tets,'-','Color',clr(p,w,:))
end
xlabel('ts')
ylabel('te')

%  axis([200 1000 200 1000])


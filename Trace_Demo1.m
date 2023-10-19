
%% Figures for TRACE
%% October 24, 2016
%% Devika Narain Aerts
%% Massachusetts Institute of Technology, Cambridge, MA, USA



clear all; close all; clc;

% ----------------------------- INIT SECTION ------------------------------
DnDisp('    This code is a demo for the TRACE MODEL')                             
disp('')

                
             
addpath('TraceLibrary')
disp('')
DnDisp('Library path pwd/TraceLibrary successfully added to your Matlab search path');
disp('')


% --------------------------------------------------------------------------
    


                                     Plotcheck              = 1;
                                     DoSave                 = 0;
                                     PlotPoissonRaster      = 0;
                                     PlotEPSP               = 0;
                                     LearningwithW          = 0;
                                     DoLearnAgain           = 0;
                                     GetColorAgain          = 0;
                                     
                                     
                                     DoBasisAgain           = 0;  % in presave
                                     RunDnDiagnosticTools   = 0; %  not included
                                     RunDnPlotCascade       = 0; %  not included
                                     
                                     
                                     
                                     



               [param]                                      = DnSetDefaultsTrace();

      

    % ----------------------------      Unpacking default structure   ------------------------------
    
                        N                       = param.basis.N; % No of kernels in the basis set  
                        endtime                 = param.genpars.endtime;
                        timeline                = param.genpars.timeline;
                        Nobs                    = param.genpars.obs;
                        clr                     = param.color.cmap3;
                        w0                      = param.learn.W0;
                        
                        Samples                 = 20;
                        No_prior               = 1;
                        
                                       
                        
              
                        % --------------------------------------------------------------------    
            DnDisp('--------------------------------------------------------------------------');
            disp(' ')
            DnDisp('                                     TRACE                             ');
            disp(' ')
            DnDisp('---------------------------------------------------------------------------');


            % ---------------------------------- EC Afferents ----------------------------------- 
           
            if(~DoBasisAgain)
            load('PreSave/Basis.mat');
            else
            DnDisp('Please Set DoBasisAgain to zero and make sure you have the PreSave folder')
            error('Error. See Above.')
            end
            
            if(No_prior == 1), DnDisp( 'Beehive for Uniform prior'); p = 1; end %else DnDisp( 'Beehive for Gaussian prior'); p = 2;end
            
            if(p == 1), PriorType = 'Uniform'; end %else, PriorType  = 'Gaussian'; end
            
            
             DnDisp(' Obtaining prior distributions and equilibrium solutions ... ');
            
            [prior{1}.dist]                                 =  Getprior(param, PriorType,'Strength',0.1,'Vary',1);  

            [CoAna, w, w_bar, BasisEff]                     =  DnEquilBH(BasisSet,prior, param); 

            delw                                            =  (w0 -  w_bar);
            %               
            for n = 1:N, VPCRawAn(n,:)                      =  BasisSet(n,:).*(delw); end
            
            DnDisp(' Dentate and integrated output at steady state ... ');

            DentAn                                          =  -mean(VPCRawAn,1);
            DentAn                                          =  DentAn - mean(DentAn);

            BlsAna                                          =  cumsum(DentAn);

            % ----------------------------------Spike Simulation ----------------------------------- 
              
            DnDisp(' Commencing Spike simulation ... ');
            
            % Get EPSP
              tic
              epsp                                          = DnGC_PCInflux(nhp, param);
              toc
              
            % CF Spike
            DnDisp(' Climbing fiber input ... ');


               [cfspike, cfinput]                           = DnClimbingFiber(param,p); 

      
if(DoLearnAgain)
            DnDisp(' Doing Learning ... ');
            DnDisp(' This might take a minute or two... ');
            
            tic
            
            % Do Learning   
             [Wmat, Pot, V_PC]                                   = DnDoLearn2(epsp, param, cfspike, cfinput); 
             
            toc
            
             % --------------------------------- Dentate Simulation ---------------------------------
             DnDisp(' Integrating output and saving results ... ');  
             [int, dmp]                                     = DnIntergrateOp(param, Pot, p); 
             
             
             sim.Wmat = Wmat;
             sim.Pot = Pot;
             sim.int = int;
             sim.dmp = dmp;
             sim.vpc = V_PC;
   
             save('PreSave/Learning2.mat','-v7.3','sim');          
else
             load('PreSave/Learning.mat');
    
end




             
% --------------------------------------------------------------------------------------------------
  %                                         Plots and Figures
% --------------------------------------------------------------------------------------------------


 DnDisp(' Ready to plot results ... ');   
  
  
% Colors for the Basis Set
if(GetColorAgain), CNew = GetBasisColor(); else load('PreSave/BasisColor.mat'); end



%% FIGURE PLOTTING THE BASIS SETS


% --------------------------------------------------------------------------------------------------

h = figure(100);
hold on;
                        MgcNo           = 30;
                        BasisVect       = round(linspace(10,N-10,MgcNo));
                        ColorVect       = round(linspace(1,size(CNew,1),MgcNo));

                        ClUniform(1:3)  = rgb('Orange');
                        prange1         = param.prior.uni(1,1);
                        prange2         = param.prior.uni(2,1);
                        
                        prior           = zeros(endtime,1); prior(prange1+1:prange2) = ones((prange2 - prange1),1)*0.1;
                        prior           = DnLinTrans(prior, [1 -0.2]);
                       

                        subplot(1,2,1), hold on

                        for i = 1:MgcNo, plot(timeline,BasisSet(BasisVect(i),:),'-','Color',CNew(ColorVect(i),:) ), end
                        plot(prior,'-','Color',ClUniform)
                        
                        %  Add labels
                        hTitle = title('Basis set before learning');
                        hXLabel = xlabel('Time ms');
                        hYLabel = ylabel('Activity');

                          % Adjust font
                        set(gca, 'FontName', 'Helvetica')
                        set([hTitle, hXLabel, hYLabel], 'FontName', 'Helvetica')
                        set([hXLabel, hYLabel], 'FontSize', 10)
                        set(hTitle, 'FontSize', 11, 'FontWeight' , 'bold')
  
  
                         % Adjust axes properties
                        set(gca, 'Box', 'off', 'TickDir', 'out', 'TickLength', [.02 .02], ...
                            'XMinorTick', 'off', 'YMinorTick', 'off', 'YGrid', 'on', ...
                            'XColor', [.3 .3 .3], 'YColor', [.3 .3 .3], 'YTick', 0:500:2500, ...
                            'LineWidth', 1) 
                        
                        subplot(1,2,2), hold on
                        
                        BS = squeeze(BasisEff(:,:));
                        
                         % Add labels
                        hTitle = title('Basis set after learning');
                        hXLabel = xlabel('Time ms');
                        hYLabel = ylabel('Activity');

                          % Adjust font
                        set(gca, 'FontName', 'Helvetica')
                        set([hTitle, hXLabel, hYLabel], 'FontName', 'Helvetica')
                        set(hTitle, 'FontSize', 11, 'FontWeight' , 'bold')
                        
                        % Adjust axes properties
                        set(gca, 'Box', 'off', 'TickDir', 'out', 'TickLength', [.02 .02], ...
                            'XMinorTick', 'off', 'YMinorTick', 'off', 'YGrid', 'on', ...
                            'XColor', [.3 .3 .3], 'YColor', [.3 .3 .3], 'YTick', 0:500:2500, ...
                            'LineWidth', 1) 

     for i = 1:MgcNo, plot(timeline,BS(BasisVect(i),:),'-','Color',CNew(ColorVect(i),:) ), end
                        plot(prior,'-','Color',ClUniform)
                        
                        
% --------------------------------------------------------------------------------------------------                        

                        
                        %FIGURE PLOTTING THE WEIGHTS, PC ACTIVITY ETC


% --------------------------------------------------------------------------------------------------                        
                        
  %%
  
  
h = figure(101);
hold on;

    subplot(1,2,1), hold on

                            % Add labels
                            hTitle = title('Weights of GC-PC synapses');
                            hXLabel = xlabel('Neurons)');
                            hYLabel = ylabel('Weights (au)');
                            % Adjust font
                            set(gca, 'FontName', 'Helvetica')
                            set([hTitle, hXLabel, hYLabel], 'FontName', 'AvantGarde')
%                             set([hLegend, gca], 'FontSize', 8)
                            set([hXLabel, hYLabel], 'FontSize', 10)
                            set(hTitle, 'FontSize', 12, 'FontWeight' , 'bold')

                            % Adjust axes properties
                            set(gca, 'Box', 'off', 'TickDir', 'out', 'TickLength', [.02 .02], ...
                            'XMinorTick', 'off', 'YMinorTick', 'off', 'YGrid', 'on', ...
                            'XColor', [.3 .3 .3], 'YColor', [.3 .3 .3], 'YTick', 0:1, ...
                            'LineWidth', 1)


subplot(1,2,2), 


                            % Add labels
                            hTitle = title('PC Activity');
                            hXLabel = xlabel('time ms)');
                            hYLabel = ylabel('Activity');
                            % Adjust font
                            set(gca, 'FontName', 'Helvetica')
                            set([hTitle, hXLabel, hYLabel], 'FontName', 'AvantGarde')
%                             set([hLegend, gca], 'FontSize', 8)
                            set([hXLabel, hYLabel,], 'FontSize', 10)
                            set(hTitle, 'FontSize', 12, 'FontWeight' , 'bold')

                            % Adjust axes properties
                            set(gca, 'Box', 'off', 'TickDir', 'out', 'TickLength', [.02 .02], ...
                            'XMinorTick', 'off', 'YMinorTick', 'off', 'XTick' ,[0 529 1059], 'YTick', [],...
                            'XColor', [.3 .3 .3], 'YColor', [.3 .3 .3], ...
                            'LineWidth', 1)



                            MagicNumber = 6;
                            ObsVect     = [ 100 300 500 800];
                            % Grayscale color
                            ct          = colormap(gray(MagicNumber));
  


for m = 1:length(ObsVect)
    
                        index           = ObsVect(m);

                        for n           = 1:N
                        wt              =  sim.Wmat(index-10:index+10,n);
                        wt              = DnLinTrans(wt, [0.01, 0.8]);
                        wi(n)           = mean(wt);
                        wsd(n)          = std(wt);

                        end
    
                        for t           = 1:endtime
                        pt              = sim.Pot(ObsVect(m),t);
                        pt              = DnLinTrans(pt, [100, 90]); % Baseline PC firing
                        it              = sim.int(ObsVect(m),t);
                        pi(t)           = mean(pt);
                        psd(t)          = std(pt)/(10);  

                        end
   
    
                        subplot(1,2,1), hold on
                        shadedErrorBar(1:N,wi,wsd,{'color',ct(m,:)})

                        subplot(1,2,2), hold on
                        pi = smooth(pi,150);
%                         shadedErrorBar(1:endtime,pi,psd,{'color',ct(m,:)})

%                         plot(1:endtime,pi,'Color',ct(m,:))
                        plot(1:endtime,pi,'Color',ct(m,:))

    
end

                        subplot(1,2,2), 


                        prior = zeros(endtime,1);
                        prior(prange1+1:prange2) = ones((prange2 - prange1),1)*10;  
                        plot(1:endtime, prior,'-','Color',ClUniform) 
                         xlim([- 100 endtime])
                        
                        
                        
     %%                   

   figure(102), hold on
   
   
                        MagicNumber     = 2;

                        ObsVect         = 901:910;


                        prange1         = param.prior.uni(1,1);
                        prange2         = param.prior.uni(2,1);

                        for m           = 1 %:10
                        index           = ObsVect( m);


                        for t = 1:endtime
                        it = sim.int(index-10:index+10,t);
                        it = DnLinTrans(it,[0.1 40]);
                        ii(t) = mean(it);
                        isd(t) = std(it);  
                        end
                        
                        % small jitter to make sure symbols are visible and
                        % do not overlap completely
                        ip = ii + normrnd(0,0.01,1,1)*(11-m);


                         shadedErrorBar(1:endtime,ip,isd,{'-','color',[0.5 0.5 0.5]})
                         plot(1:endtime,ip,'-','Color','k')

                        end

                        plot([0 0], [28 60],'--k')   
                        xlim([-100 prange2+50])
                        
                        prior = zeros(endtime,1);
                        prior(prange1+1:prange2) = ones((prange2 - prange1),1) + 25;      
                        plot(1:endtime, prior,'-','Color',ClUniform) 
                        xlim([- 100 endtime])
                        
                                                %  Add labels
                        hTitle = title('Basis set before learning');
                        hXLabel = xlabel('Time ms');
                        hYLabel = ylabel('Activity');

                          % Adjust font
                        set(gca, 'FontName', 'Helvetica')
                        set([hTitle, hXLabel, hYLabel], 'FontName', 'Helvetica')
                        set([hXLabel, hYLabel], 'FontSize', 10)
                        set(hTitle, 'FontSize', 11, 'FontWeight' , 'bold')
  
  
                         % Adjust axes properties
                        set(gca, 'Box', 'off', 'TickDir', 'out', 'TickLength', [.02 .02], ...
                            'XMinorTick', 'off', 'YMinorTick', 'off', 'YGrid', 'on', 'XTick', [0 529 1059], 'YTick', [30 40],  ...
                            'XColor', [.3 .3 .3], 'YColor', [.3 .3 .3], 'YTick', 0:500:2500, ...
                            'LineWidth', 1) 
                        
                        
   
 % --------------------------------------------------------------------------------------------------                        

                        
                                        % PHYSIOLOGY for RSG


% --------------------------------------------------------------------------------------------------                        
                              
  
h =  figure(103); hold on

                            % Add labels
                            hTitle = title('Model predictions: integrated op');
                            hXLabel = xlabel('Time ms');
                            hYLabel = ylabel('Activity');
                            % Adjust font
                            set(gca, 'FontName', 'Helvetica')
                            set([hTitle, hXLabel, hYLabel], 'FontName', 'AvantGarde')
%                             set([hLegend, gca], 'FontSize', 8)
                            set([hXLabel, hYLabel], 'FontSize', 10)
                            set(hTitle, 'FontSize', 12, 'FontWeight' , 'bold')

                            % Adjust axes properties
                            set(gca, 'Box', 'off', 'TickDir', 'out', 'TickLength', [.02 .02], ...
                            'XMinorTick', 'off', 'YMinorTick', 'off', 'YGrid', 'off',...
                            'XColor', [.3 .3 .3], 'YColor', [.3 .3 .3], 'YTick', 30:10:60, ...
                            'LineWidth', 1)


 Clr(1,1:3) = rgb('CornFlowerBlue');
  Clr(2,1:3) = rgb('DeepSkyBlue');
   Clr(3,1:3) = rgb('ForestGreen');
    Clr(4,1:3) = rgb('LimeGreen');
     Clr(5,1:3) = rgb('YellowGreen');
      Clr(6,1:3) = rgb('Gold');
       Clr(7,1:3) = rgb('Orange');
        Clr(8,1:3) = rgb('DarkOrange');
         Clr(9,1:3) = rgb('Crimson');
          Clr(10,1:3) = rgb('FireBrick');
 
 

                        priorsplit      = round(linspace(prange1,prange2,10)); 

                        MagicNumber     = 2;

                        ObsVect         = 901:910;


                        prange1         = param.prior.uni(1,1);
                        prange2         = param.prior.uni(2,1);
  

                        for pr          = 1:10
                        ax              = [priorsplit(pr) priorsplit(pr)];
                        ay              = [28 60];
                        plot(ax,ay,'--','Color',[0.5 0.5 0.5])   
                        end

                        for m           = 1:10
                        index           = ObsVect(11 - m);


                        for t = 1:endtime
                        it = sim.int(index-10:index+10,t);
                        it = DnLinTrans(it,[0.1 40]);
                        ii(t) = mean(it);
                        isd(t) = std(it);  
                        end
                        
                        % small jitter to make sure symbols are visible and
                        % do not overlap completely
                        ip = ii + normrnd(0,0.01,1,1)*(11-m);

                        cutat = 1:priorsplit(11-m);
                        cutsd = 1:10:priorsplit(11-m);

                        plot(cutat,ip(cutat),'-','Color',Clr((11-m),:))
                        for i = 1:length(cutsd)
                        plot([cutsd(i) cutsd(i)],[ip(cutsd(i)) - isd(cutsd(i)) ip(cutsd(i)) + isd(cutsd(i))],'-','Color',Clr(11-m,:))
                        end
                        plot(priorsplit(11-m),ip(priorsplit(11-m)),'o','MarkerFaceColor',Clr(11-m,:),'MarkerEdgeColor','k','MarkerSize',10)


                        end

                        plot([0 0], [28 60],'--k')   
                        xlim([-100 prange2+50])


% --------------------------------------------------------------------------------------------------                        

                        
                                        % Dynamics of learning


% --------------------------------------------------------------------------------------------------                        
    

                        
                        
h = figure(104); hold on

load('PreSave/DynamicNW.mat'); % refer to Simulation DynamicNWWN - run on openmind
xline = 401:25:700;
vr = 1:4;
vr2 = 5:12;
xline = xline + 25;

                            % Add labels
                            hTitle = title('Transitions from Narrow to Wide');
                            hXLabel = xlabel('Trials');
                            hYLabel = ylabel('Del Activity');
                            % Adjust font
                            set(gca, 'FontName', 'Helvetica')
                            set([hTitle, hXLabel, hYLabel], 'FontName', 'AvantGarde')
%                             set([hLegend, gca], 'FontSize', 8)
                            set([hXLabel, hYLabel], 'FontSize', 10)
                            set(hTitle, 'FontSize', 12, 'FontWeight' , 'bold')

                            % Adjust axes properties
                            set(gca, 'Box', 'off', 'TickDir', 'out', 'TickLength', [.02 .02], ...
                            'XMinorTick', 'off', 'YMinorTick', 'off', 'YGrid', 'off', ...
                            'XColor', [.3 .3 .3], 'YColor', [.3 .3 .3],  ...
                            'LineWidth', 1)

                            errorbar(xline(1:end), AveMat(1,1:end),SdMat(1,1:end),'k--')
                            plot(xline(vr), AveMat(1,vr),'o','MarkerFaceColor','k','MarkerSize',10,'MarkerEdgeColor','k')
                            plot(xline(vr2), AveMat(1,vr2),'o','MarkerFaceColor','w','MarkerSize',10,'MarkerEdgeColor','k')

                            errorbar(xline(1:end), AveMat(2,1:end),SdMat(2,1:end),'k--')
                            plot(xline(vr), AveMat(2,vr),'s','MarkerFaceColor','w','MarkerSize',10,'MarkerEdgeColor','k')
                            plot(xline(vr2), AveMat(2,vr2),'s','MarkerFaceColor','k','MarkerSize',10,'MarkerEdgeColor','k')
                            plot([500 500],[52 63],'k--')




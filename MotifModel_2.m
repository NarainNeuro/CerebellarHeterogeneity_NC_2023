
clc;
close all;
clear all;
load("PreSave/TraceforMotif.mat");
DeltaCol = rgb('CornflowerBlue');
DistCol = rgb('DarkTurquoise');

                                                    wcf             = param.learn.wcf;
                                                    ap_func         = param.learn.cfEPSPfunc;
                                                    x               = 1:80;
                                                    win             = length(x);
                                                    scale           = param.learn.scale2one;
                                                    scaleact         = 20;
                                                    AP_pro          = ap_func(x,wcf)*scale*scaleact;
                                                    DeltaTrace      = EffDel*scaleact;
                                                    UniTrace        = EffUni*scaleact;
                                                    gain_pcpc       = 0.5;
                                                    gain_pcmli      = 0.5;

% ------ Feedforward Motifs -------------


% PC1 receives positive and negative airpuff feedback
Base_pc1             = 50;% Hz
V_pc1_delta_test     = Base_pc1 - DeltaTrace;
V_pc1_delta_train    = V_pc1_delta_test;
V_pc1_delta_train1   = V_pc1_delta_test;
V_pc1_delta_train1(350:350 + win-1) = V_pc1_delta_train(350:350 + win-1) + AP_pro;
V_pc1_delta_train2   = V_pc1_delta_test;
V_pc1_delta_train2(350:350 + win-1) = V_pc1_delta_train(350:350 + win-1) - AP_pro;

V_pc1_uni_test                    = Base_pc1 - UniTrace;
V_pc1_uni_train                   = V_pc1_uni_test;
V_pc1_uni_train(200:200 + win-1)  = V_pc1_uni_train(200:200 + win-1) + AP_pro;
V_pc1_uni_train(275:275 + win-1)  = V_pc1_uni_train(275:275 + win-1) + AP_pro;
V_pc1_uni_train(350:350 + win-1)  = V_pc1_uni_train(350:350 + win-1) + AP_pro;
V_pc1_uni_train(425:425 + win-1)  = V_pc1_uni_train(425:425 + win-1) + AP_pro;
V_pc1_uni_train(500:500 + win-1)  = V_pc1_uni_train(500:500 + win-1) + AP_pro;



% PC1 - PC2
% PC1 - TRACE activity profile - receives CF tuned to airpuff
% PC2 - no CF tuning but receives disinhibitory collateral input
Base_pc2 = 50;% Hz

V_pc2_delta_test = Base_pc2 - gain_pcpc*(DeltaTrace);
V_pc2_uni_test = Base_pc2 - gain_pcpc*(UniTrace);

V_pc2_delta_train = V_pc2_delta_test;
V_pc2_uni_train = V_pc2_uni_test;
V_pc2_delta_train(350:350 + win-1) = V_pc2_delta_train(350:350 + win-1) + AP_pro ;
V_pc2_uni_train(200:200 + win-1)   = V_pc2_uni_train(200:200 + win-1)   + AP_pro;
V_pc2_uni_train(275:275 + win-1)   = V_pc2_uni_train(275:275 + win-1)   + AP_pro;
V_pc2_uni_train(350:350 + win-1)   = V_pc2_uni_train(350:350 + win-1)   + AP_pro;
V_pc2_uni_train(425:425 + win-1)   = V_pc2_uni_train(425:425 + win-1)   + AP_pro;
V_pc2_uni_train(500:500 + win-1)   = V_pc2_uni_train(500:500 + win-1)   + AP_pro;


% PC1 - MLI
% PC1 - TRACE activity profile - receives CF tuned to airpuff
% MLI - receives disinhibitory collateral input from PC1
Base_mli = 20;% Hz

V_mli_delta_test = Base_mli + gain_pcmli*(DeltaTrace);
V_mli_uni_test = Base_mli + gain_pcmli*(UniTrace);

V_mli_delta_train = V_mli_delta_test;
V_mli_uni_train = V_mli_uni_test;
V_mli_delta_train(350:350 + win-1) = V_mli_delta_train(350:350 + win-1) + AP_pro ;

V_mli_uni_train(200:200 + win-1)   = V_mli_uni_train(200:200 + win-1)   + AP_pro;
V_mli_uni_train(275:275 + win-1)   = V_mli_uni_train(275:275 + win-1)   + AP_pro;
V_mli_uni_train(350:350 + win-1)   = V_mli_uni_train(350:350 + win-1)   + AP_pro;
V_mli_uni_train(425:425 + win-1)   = V_mli_uni_train(425:425 + win-1)   + AP_pro;
V_mli_uni_train(500:500 + win-1)   = V_mli_uni_train(500:500 + win-1)   + AP_pro;


% Plotting Delta condition for PC1
figure(1);
subplot(1,2,1)
hold on;

plot(V_pc1_delta_train1,'-', 'Color',DeltaCol)
plot(V_pc1_delta_test,'-','Color',[0.7 0.7 0.7])
plot([350 350], ylim, 'k--')


  % Add labels
                        hTitle = title('PC1 positive Delta');
                        hXLabel = xlabel('Time ms');
                        hYLabel = ylabel('Activity');

                          % Adjust font
                        set(gca, 'FontName', 'Helvetica')
                        set([hTitle, hXLabel, hYLabel], 'FontName', 'Helvetica')
                        set(hTitle, 'FontSize', 11, 'FontWeight' , 'bold')
                        
                        % Adjust axes properties
                        set(gca, 'Box', 'off', 'TickDir', 'out', 'TickLength', [.02 .02], ...
                            'XMinorTick', 'off', 'YMinorTick', 'off', 'YGrid', 'off', ...
                            'XColor', [.3 .3 .3], 'YColor', [.3 .3 .3], ...
                            'XTick', [0, 350], 'LineWidth', 1) 

subplot(1,2,2)
hold on;

plot(V_pc1_delta_train2, '-', 'Color',DeltaCol)
plot(V_pc1_delta_test,'-','Color',[0.7 0.7 0.7])
ylim([-10 60]);
plot([350 350], ylim, 'k--')

  % Add labels
                        hTitle = title('PC1 negative Delta');
                        hXLabel = xlabel('Time ms');
                        hYLabel = ylabel('Activity');

                          % Adjust font
                        set(gca, 'FontName', 'Helvetica')
                        set([hTitle, hXLabel, hYLabel], 'FontName', 'Helvetica')
                        set(hTitle, 'FontSize', 11, 'FontWeight' , 'bold')
                        
                        % Adjust axes properties
                        set(gca, 'Box', 'off', 'TickDir', 'out', 'TickLength', [.02 .02], ...
                            'XMinorTick', 'off', 'YMinorTick', 'off', 'YGrid', 'off', ...
                            'XColor', [.3 .3 .3], 'YColor', [.3 .3 .3], ...
                            'XTick', [0, 200,350,500],'YTick',[ 0 50],'LineWidth', 1) 



% Plotting Uniform condition for PC1
figure(2);
hold on;
title('PC1 positive Uni')
plot(V_pc1_uni_train)
plot(V_pc1_uni_test)


% Plotting Delta and Uniform condition for PC2
figure(3);
subplot(1,2,1)
hold on;
title('PC2 Delta')
plot(V_pc2_delta_test)
plot(V_pc2_delta_train)

subplot(1,2,2)
hold on
title('PC2 Uni')
plot(V_pc2_uni_test)
plot(V_pc2_uni_train)



% Plotting Uniform condition for PC2
figure(4);
subplot(1,2,1)
hold on;
title('MLI delta')
plot(V_mli_delta_test)
plot(V_mli_delta_train)

subplot(1,2,2)
hold on;
title('MLI uni')
plot(V_mli_uni_test)
plot(V_mli_uni_train)




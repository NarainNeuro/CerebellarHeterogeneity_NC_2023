 function [Coincidence, w,w_bar,w_sd,BasisEff] = GetWRight(BasisSet, prior, param)

%  prior = prior{1}.dist;
 figure; plot(prior), pause(1)
 
global DoConv


                        N                           = param.basis.N; % No of kernels in the basis set  
                        endtime                     = param.genpars.endtime;
                        timeline                    = param.genpars.timeline;   
                        I                           = param.learn.Inpwt;
                        tau                         = param.learn.tau;
                        xiltd                       = param.learn.ltdxi; 
                        alpha                       = param.learn.alpha;
                        gKernal                     = param.learn.EPSPfunc;
                        kw                          = param.learn.kernalwidth;


                        Coincidence(1:N,1:endtime)  = zeros(N,endtime);
                        w_bar(1:endtime)            = zeros(endtime,1);
                        w(1:N,1:endtime)            = zeros(N,endtime);
                        BasisEff(1:N,1:endtime)     = zeros(N,endtime);
                         
                       

                        for n = 1:N
                       
                                  Coincidence(n,:)  = BasisSet(n,:).*prior;                       
                                  
                         
                             for j = 1:endtime
                                  BasisSet(n,:) = BasisSet(n,:).*((1-Coincidence(n,j)));
                             end
                         
                        end
                        BasisEff = BasisSet;
                            
for i = 1:endtime

                        w_bar(i)                    = (I/alpha) - (xiltd/alpha)*mean(BasisEff(:,i));
                       

                        w(1:N,i)                    = (I/alpha)*ones(N,1) - (xiltd/alpha).*(BasisEff(:,i));

                        w_sd(i)                     = std(w(:,i))/sqrt(N);
   
end


% figure; hold on
% plot(timesr)
% plot(gKernal(kw))
% % 
%  figure;
%  subplot(1,3,1), hold on
% plot(timeline, Coincidence(:,:))
% subplot(1,3,2), hold on
% plot(timeline, BasisSet)
% plot(timeline, mean(BasisSet,1))
% subplot(1,3,3), hold on
% % plot(w_bar)
% figure;
% plot(BasisEff)

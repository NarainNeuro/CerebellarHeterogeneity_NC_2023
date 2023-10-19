function [Wmat Potential V_PC_Raw]    = DnDoLearn2(PC_EPSP, param, CFSpikeIndex, CF_Input, varargin)

% DnDoLearn2.m
% Simplistic and fast version of DoLearn Suite
% Some rules need RunDnDiagnostic to evaluate results


ruletype = 'Coincidence';
wintype  = 'Assymetric';

optargin         = size(varargin,2);

for i            = 1:2:optargin    
        switch varargin{i}
        case 'RuleType'
        ruletype = varargin{i+1};
        case 'WindowType'
        wintype  = varargin{i+1};
        end
end

                                    N               = param.basis.N;
                                    N_obs           = param.genpars.obs;
                                    endtime         = param.genpars.endtime;
                                    timeline        = param.genpars.timeline;
                                    neuronvector    = param.genpars.neurvector;
                                    aswin           = param.learn.assymwin; 
                                    CFpeak          = param.learn.cf_peak;
                                    TauLTP          = param.learn.tau_ltp;                         
                                    TauLTD          = param.learn.tau_ltd;
                                    tau             = param.learn.tau;
                                    Inp_wt          = param.learn.Inpwt;      
                                    alpha           = param.learn.alpha;
                                    W0              = param.learn.W0;

            Wmat(1:N_obs,1:N)                       = ones(N_obs,N)*W0;
            
            Potential(1:N_obs,1:endtime)            = zeros(N_obs,endtime);
            
            V_PC_Raw = [];
                     
                        

    for o = 1 : N_obs 
        
        V_PC_Raw{o}.mat         = zeros(N,endtime);
            for n = 1:N
              if(~strcmp(ruletype,'CovarianceRule'))
                % ---------------------------------------------------------------------------------
                % Simple coincidence detection
                del                               = CFSpikeIndex(o);
                     if(del>0)
                      pce                         = PC_EPSP{o}.mat(n,CFSpikeIndex(o));
                     else
                      pce                         = 0;
                     end
                
              else
                % modified interpretation of covariance rule    
                
                
                 %  Warning: Error handling required for covariance rule -
                 %  instability
                try                                    
                pce                               = cov(PC_EPSP{o}.mat(n,CFSpikeIndex(o)-aswin(1):CFSpikeIndex(o)-aswin(2)),CF_Input(o,n,CFSpikeIndex(o)-aswin(1):CFSpikeIndex(o)-aswin(2)));    
                catch
                                             RunDnDiagnostic(); % Run full diagnostic because covariance caluclations can be unstable
                end
                
              end
                
                Cova(o,n) = pce;
 
                if(pce < 0), DnDisp('In DnDoLearn: Serious issue >> coincidence probability is negative'); end

                kappa                             = Cova(o,n);
                check                             = round(kappa*100); % Is coincidence too small to waste computational time on?
                
                %  Difference equation Euler's method: 
                
             if(o > 1)
                    
              if( check >= 0) % Is coincidence too small to waste computational time on?

                                 dw_dt                               = (Wmat(o-1,n)/TauLTP) - (Inp_wt/tau) - (kappa/TauLTD);           
              else
                            % restoring force alone
                                 dw_dt                               = (Wmat(o-1,n)/TauLTP) - (Inp_wt/tau); 
              end  
              
                            % Weight update
                                 Wmat(o,n)                           =  Wmat(o-1,n) + dw_dt;   
              end
                 
                % For each observation, and each PC, linear bases are stored 
                                  V_PC_Raw{o}.mat(n,:)               = (Wmat(o,n) - W0).*PC_EPSP{o}.mat(n,:);
            end
    end
     
    

             DnDisp('Averaging...')
                            

            for    o = 1:N_obs
                Potential(o,1:endtime)       = mean(V_PC_Raw{o}.mat,1);
            end                  

            
% 
 figure(500), hold on
 
 Obs = [20 40 50 100 500 800 1000];
 for i = 1:length(Obs)
       plot(Potential(Obs(i),:))
 end

 
 
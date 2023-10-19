

function [CFSpikeIndex, CF_Input]             = DnClimbingFiber(param, p, varargin )

% DnClimbingFiber.m
% Devika Narain Aerts 2016

% Allows various regimes of stimuli presentation through complex fiber
% spikes

                                                   
                                                    CaseType = 'Normal';
                                                    
if(size(varargin,2)>=1)
switch(varargin{1})
    
% %     case 'Interference'
% %         CaseType = 'Interference';
     case 'Forgetting'
          CaseType = 'Forgetting';
% %     case 'Expansion'
% %         CaseType = 'Expansion';
% %     case 'Contraction'
% %         CaseType = 'Contraction';
end
end


                                                    N_obs           = param.genpars.obs;
                                                    start           = param.prior.uni(1,p);
                                                    stop            = param.prior.uni(2,p); 
                                                    Gaussmu         = param.prior.gauss(1,p);
                                                    Gausssd         = param.prior.gauss(2,p);
                                                    aswin           = param.learn.assymwin;  
                                                    wcf             = param.learn.wcf;
                                                    cf_skewedfunc   = param.learn.cfEPSPfunc;
                                                    endtime         = param.genpars.endtime;
                                                    x               = 1:param.learn.win;
                                                    win             = param.learn.win;
                                                    scale           = param.learn.scale2one;
                                                    dt              = param.genpars.dt;
                                                    No_prior        = param.prior.no;
                                                    tau_cf          = param.learn.gc_tau*0.75;                                          
                                                    EPSP_cf         = cf_skewedfunc(x,wcf)*scale;
                                                    halfwidth       = round(win*0.5); 
                                     CF_Input(1:N_obs,1:endtime)    = zeros(N_obs,endtime);
                                     CFSpikeIndex(1:N_obs)          = zeros(N_obs,1);


                        % Assymetric EPSP with respect to mean stimulus
switch CaseType
    
    case 'Normal'
                        for o = 1:N_obs

                            % Uniform
                            observe                                                     = round(random('uniform',start/dt,stop/dt,1));
                            CF_Input(o,observe + 1 - halfwidth : observe + halfwidth)   = EPSP_cf;
                            CFSpikeIndex(o)                                             = observe ;

                        end
                        
  

                  
                    
                    
    case 'Forgetting'
        
      % --------------------------------------- Forgetting  -----------------------------------------  
        
    half = N_obs*0.5;
    
                    for o = 1:N_obs

 % ----------------------------------------------------------------------------------------------  
                       if(o<=half)

                                start           = param.prior.uni(1,1);
                                stop            = param.prior.uni(2,1); 
                                Gaussmu         = param.prior.gauss(1,1);
                                Gausssd         = param.prior.gauss(2,1);


                            observe                                                     = round(random('uniform',start/dt,stop/dt,1));

                            CF_Input(o,observe + 1 - halfwidth : observe + halfwidth)   = EPSP_cf;
                            CFSpikeIndex(o)                                             = observe ;

                      end
                            % ----------------------------------------------------------------------------------------------
                    end
                    
                    
                    

  
%       case 'Expansion'
        
      % --------------------------------------- Expansion  -----------------------------------------        
       
%           half = N_obs*0.2;
%     
%                     for o = 1:N_obs
% 
%  % ----------------------------------------------------------------------------------------------  
%                        if(o<=half)
% 
%                                 start           = param.prior.uni(1,1);
%                                 stop            = param.prior.uni(2,1); 
%                                 Gaussmu         = param.prior.gauss(1,1);
%                                 Gausssd         = param.prior.gauss(2,1);
% 
%                             if(p == 1)
%                             % Uniform
%                             observe                                                     = round(random('uniform',start/dt,stop/dt,1));
% 
%                             CF_Input(o,observe + 1 - halfwidth : observe + halfwidth)   = EPSP_cf;
%                             CFSpikeIndex(o)                                             = observe ;
% 
% 
%                             else
%                                 
%                     
% 
%                             % Gaussian
%                             observe                                                     = abs(round(normrnd(Gaussmu/dt,Gausssd/dt,1,1)));
%                             if(observe < halfwidth)
%                             observe                                                     = Gaussmu/dt;
%                             end
% 
%                             if(observe>endtime)
%                             DnDisp('Prior sampled outside range - reassigned : Gaussian')
%                             observe = Gaussmu/dt;
%                             end
% 
%                             CF_Input(o,observe + 1 - halfwidth : observe + halfwidth)   = EPSP_cf;
%                             CFSpikeIndex(o)                                             = observe ;
%                             end
%                        else
%                            
%                                 start           = param.prior.uni(1,2);
%                                 stop            = param.prior.uni(2,2); 
%                                 Gaussmu         = param.prior.gauss(1,2);
%                                 Gausssd         = param.prior.gauss(2,2);
% 
%                             if(p == 1)
%                             % Uniform
%                             observe                                                     = round(random('uniform',start/dt,stop/dt,1));
% 
%                             CF_Input(o,observe + 1 - halfwidth : observe + halfwidth)   = EPSP_cf;
%                             CFSpikeIndex(o)                                             = observe ;
% 
% 
%                             else
%                                 
%                     
% 
%                             % Gaussian
%                             observe                                                     = abs(round(normrnd(Gaussmu/dt,Gausssd/dt,1,1)));
%                             if(observe < halfwidth)
%                             observe                                                     = Gaussmu/dt;
%                             end
% 
%                             if(observe>endtime)
%                             DnDisp('Prior sampled outside range - reassigned : Gaussian')
%                             observe = Gaussmu/dt;
%                             end
% 
%                             CF_Input(o,observe + 1 - halfwidth : observe + halfwidth)   = EPSP_cf;
%                             CFSpikeIndex(o)                                             = observe ;
%                             end
%                       end
%                             % ----------------------------------------------------------------------------------------------
%                     end
%         
%         case 'Contraction'
%         
%       % --------------------------------------- Contraction  -----------------------------------------        
%        
%           half = N_obs*0.5;
%     
%                     for o = 1:N_obs
% 
%  % ----------------------------------------------------------------------------------------------  
%                        if(o<=half)
% 
%                                 start           = param.prior.uni(1,2);
%                                 stop            = param.prior.uni(2,2); 
%                                 Gaussmu         = param.prior.gauss(1,2);
%                                 Gausssd         = param.prior.gauss(2,2);
% 
%                             if(p == 1)
%                             % Uniform
%                             observe                                                     = round(random('uniform',start/dt,stop/dt,1));
% 
%                             CF_Input(o,observe + 1 - halfwidth : observe + halfwidth)   = EPSP_cf;
%                             CFSpikeIndex(o)                                             = observe ;
% 
% 
%                             else
%                                 
%                     
% 
%                             % Gaussian
%                             observe                                                     = abs(round(normrnd(Gaussmu/dt,Gausssd/dt,1,1)));
%                             if(observe < halfwidth)
%                             observe                                                     = Gaussmu/dt;
%                             end
% 
%                             if(observe>endtime)
%                             DnDisp('Prior sampled outside range - reassigned : Gaussian')
%                             observe = Gaussmu/dt;
%                             end
% 
%                             CF_Input(o,observe + 1 - halfwidth : observe + halfwidth)   = EPSP_cf;
%                             CFSpikeIndex(o)                                             = observe ;
%                             end
%                        else
%                            
%                                 start           = param.prior.uni(1,1);
%                                 stop            = param.prior.uni(2,1); 
%                                 Gaussmu         = param.prior.gauss(1,1);
%                                 Gausssd         = param.prior.gauss(2,1);
% 
%                             if(p == 1)
%                             % Uniform
%                             observe                                                     = round(random('uniform',start/dt,stop/dt,1));
% 
%                             CF_Input(o,observe + 1 - halfwidth : observe + halfwidth)   = EPSP_cf;
%                             CFSpikeIndex(o)                                             = observe ;
% 
% 
%                             else
%                                 
%                     
% 
%                             % Gaussian
%                             observe                                                     = abs(round(normrnd(Gaussmu/dt,Gausssd/dt,1,1)));
%                             if(observe < halfwidth)
%                             observe                                                     = Gaussmu/dt;
%                             end
% 
%                             if(observe>endtime)
%                             DnDisp('Prior sampled outside range - reassigned : Gaussian')
%                             observe = Gaussmu/dt;
%                             end
% 
%                             CF_Input(o,observe + 1 - halfwidth : observe + halfwidth)   = EPSP_cf;
%                             CFSpikeIndex(o)                                             = observe ;
%                             end
%                       end
%                             % ----------------------------------------------------------------------------------------------
%                     end   
%         
%         
 end

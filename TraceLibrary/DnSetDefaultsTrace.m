
function [param] = DnSetDefaultsTrace()



% Devika Narain Aerts

% DnSetDefaults.m
% Default Parameter file for Trace
% Each parameter in the code is asigned here and only modified under
% flagged controls



                    param.basis.N            = 1000;                     % No of kernels in the basis set

%% General Parameters

                    param.genpars.dt         = 1;           % dt in millisecond
                    param.genpars.startbasis = 0;
                    param.genpars.time       = 1500;        % endtime time
                    param.genpars.obs        = 1000;         % observations
                    param.genpars.timeline   = param.genpars.dt:param.genpars.dt:param.genpars.time; 
                    param.genpars.endtime    = length(param.genpars.timeline);
                    param.genpars.neurvector = round(random('uniform',1,param.basis.N,50,1));
                    param.s1                 = '--------------------------------------------------';
                    
                     %% Parameters for the basis
                    param.basis.method       = 'Ganguli';               % Ganguli, Simoncelli - NIPS paper
                    param.basis.leakedge     = 0;                       % expansion required to avoid basis compression
                    param.basis.continuum    = round(linspace(param.genpars.startbasis,param.genpars.endtime,param.basis.N));
                    param.basis.Scale        = 1e+4;                       % transforming set
                    param.basis.d            = ones(param.basis.N,1);   % Density
                    param.basis.sig          = 40;                     % Kernal sigma                        

%                   Gain function params:      default linear
                    param.basis.dropoff      = 'Exponential';           % Or Linear
                    param.basis.slope        = 0.1;                    % If linear
                    param.basis.const        = 0.5;                   % for both
                    param.basis.tau          = 3000;                    % If exponential, decay
                    param.basis.sigcomp      = 0.2;                     % By how much should the sigma decay (0 to 1)
                    param.basis.amp          = 1;                      
                    
                    param.s2                 = '-----------------------------------------------';
                    
%% Parameters for the prior
                    param.prior.no           = 2;           % No of priors
                    
                    
                    param.prior.uni(1,1:3)   = [150 0 0];%[529 0 0]; % In event of a single prior    
                    param.prior.uni(2,1:3)   = [450 0 0];%[1059 0 0];
                    
                    param.prior.gauss(1,1:3) = [300 0 0]; % If Gaussian prior is used   
                    param.prior.gauss(2,1:3) = [10 0 0];
                    param.prior.wm           = 0.1;
                    param.prior.range        = 151:450;
                    param.prior.stim         = param.genpars.timeline;
                    param.prior.unimu        = [150 300 450];
                    param.s3                 = '--------------------------------------------------';


%% Parameters for inhomogeneous Poisson Process

                    param.poisson.baseline   = 10;           % Hz
                    param.poisson.maxfire    = 100;          % Hz
                    param.poisson.refract    = 2;           % ms
                    param.poisson.dt         = 1e-3;        % because Hz in 1/s - convert to ms
                    param.s4                 = '--------------------------------------------------';
                    
%% Parameters for Cerebellar Learning
                    
                    param.learn.s5          = '------- Climbing Fiber ------';    
                    param.learn.win         = 50;      % length of eligibility window;
                    param.learn.win_biol    = 50;      % largest possible biological eligibility window;
                    param.learn.window      = 1: param.learn.win;
                    param.learn.assymwin    = [100 50];   
                    param.learn.scale2one   = 140;
                    param.learn.kernalwidth = 20;
                    param.learn.EPSPfunc    = @(wcf) 1./sqrt(2*pi.*(wcf).^2).*exp(-0.5.*(param.learn.window-mean(param.learn.window)).^2./(wcf).^2);
                    param.learn.wcf         = 1;        % Asymmetric twist in EPSP                    
                    param.learn.cf_peak     = 50;       % Based on above parameters
                    param.learn.gcmpscale   = 12;
                    param.learn.cfEPSPfunc  = @(x,wcf) 1./sqrt(2*pi.*(x./wcf).^2).*exp(-0.5.*(x-mean(x)).^2./(x./wcf).^2); 
                        
                    
                    param.learn.s6          = '------- Granule Cell ------';
                    param.learn.gc_tau      = 10;
                    param.learn.gc_func     = @(tau,x)1./sqrt(2.*pi.*tau^2).*exp(-0.5.*x.^2./tau^2);
                    param.learn.baseline    = 0.1;
                    
                    
                    param.learn.s7          = '------- Learning Rule ------';
                    param.learn.tau         = 200;   % time constant of entire system
                    param.learn.ltdxi       = 4;     % relative adjustment of LTD
                    param.learn.alpha       = 1;     % relative adjustement of LTP
                    param.learn.Inpwt       = 1;     % Basline input
                    param.learn.tau_ltp     = param.learn.tau/param.learn.alpha; 
                    param.learn.tau_ltd     = param.learn.tau/param.learn.ltdxi;                  
                    param.learn.W0          = 1;
                    
                       
% Colors 
                     colormap  parula
                     param.color.cmap        = colormap;
                     foo                     = round(linspace(1,60,6));
                     param.color.cmap2       = param.color.cmap(foo,1:3);
                     param.color.cmap3       = repmat(param.color.cmap,10,1); 
                
                    











function [param] = DnSetDefaultsCoincidence()



% Devika Narain Aerts

% DnSetDefaults.m
% Default Parameter file for Das Klavier main
% Each parameter in the code is asigned here and only modified under
% flagged controls



                    param.basis.N            = 500;                     % No of kernels in the basis set

%% General Parameters

                    param.genpars.dt         = 1;           % dt in millisecond
                    param.genpars.startbasis = 0;
                    param.genpars.time       = 2000;        % endtime time
                    param.genpars.obs        = 300;         % observations
                    param.genpars.timeline   = param.genpars.dt:param.genpars.dt:param.genpars.time; 
                    param.genpars.endtime    = length(param.genpars.timeline);
                    param.genpars.neurvector = round(random('uniform',1,param.basis.N,50,1));
                    param.s1                 = '--------------------------------------------------';
                    
                     %% Parameters for the basis
                    param.basis.method       = 'Ganguli';               % Ganguli, Simoncelli - NIPS paper
                    param.basis.leakedge     = 0;                    % expansion required to avoid basis compression
                    param.basis.continuum    = round(linspace(param.genpars.startbasis,param.genpars.endtime,param.basis.N));
                    param.basis.Scale        = 1;                    % transforming set
                    param.basis.d            = ones(param.basis.N,1); % Density
                    param.basis.sig          = 150;                     % Kernal sigma                        
%                   Gain function params:      default linear
                    param.basis.dropoff      = 'Exponential'; % Or Linear
                    param.basis.slope        = 1e-5;
                    param.basis.const        = 0.001;
                    param.basis.tau          = 2000;
                    param.basis.sigcomp      = 0.1; % By how much should the sigma decay (0 to 1)
                    param.basis.amp          = 10;
                    
                    param.s2                 = '--------------------------------------------------';
                    
%% Parameters for the prior
                    param.prior.no           = 2;           % No of priors
                    param.prior.uni(1,1:3)   = [494 671 847];%[600 1000];%[500 700 0];%[500 800 1100];%[500 700];   % Lowerbound for Uniform
                    param.prior.uni(2,1:3)   = [847 1023 1200];%[620 1020];%[900 1400 0];%[900 1200 1500];%[900  1400];   % Upperbound for uniform
                    
                    param.prior.gauss(1,1:3) = [600 1000 0];%[900 1200];%[600 1000 0];%[500 800 1100];%[600 1000];   % Mus for Gauss
                    param.prior.gauss(2,1:3) = [100 200 0];%[10 10];%[100 200 0];%[100 100 100];%[100 200];   % Sigmas for Gauss
                    param.prior.wm           = 0.1;%[0.1 0.12 0.15 0.2];
                    param.prior.range        = 501:1000;
                    param.prior.stim         = param.genpars.timeline;
                    param.s3                 = '--------------------------------------------------';


%% Parameters for inhomogeneous Poisson Process

                    param.poisson.baseline   = 10;           % Hz
                    param.poisson.maxfire    = 80;          % Hz
                    param.poisson.refract    = 2;           % ms
                    param.poisson.dt         = 1e-3;        % because Hz in 1/s - convert to ms
                    param.s4                 = '--------------------------------------------------';
                    
%% Parameters for Cerebellar Learning
                    
                    param.learn.s5          = '------- Climbing Fiber ------';    
                    param.learn.win         = 400;%150;
                    param.learn.win_biol    = 150;
                    param.learn.window      = 1: param.learn.win;
                    param.learn.assymwin    = [100 50];     % Biol = [100 50]
                    param.learn.scale2one   = 140;
                    param.learn.kernalwidth = 200;
                    param.learn.EPSPfunc    = @(wcf) 1./sqrt(2*pi.*(wcf).^2).*exp(-0.5.*(param.learn.window-mean(param.learn.window)).^2./(wcf).^2);
                    param.learn.wcf         = 1; % Asymmetric twist in EPSP                    
                    param.learn.cf_peak     = 50; % Based on above parameters
                    param.learn.gcmpscale   = 12;
                     
                        
                    
                    param.learn.s6          = '------- Granule Cell ------';
                    param.learn.gc_tau      = 20;
                    param.learn.gc_func     = @(tau,x)1./sqrt(2.*pi.*tau^2).*exp(-0.5.*x.^2./tau^2);
                    param.learn.baseline    = 0.1;
                    
                    
                    param.learn.s7          = '------- Learning Rule ------';
                    param.learn.tau         = 50;
                    param.learn.ltdxi       = 4;
                    param.learn.alpha       = 1; 
                    param.learn.Inpwt       = 1;
                    
                    param.learn.W0          = param.learn.Inpwt/param.learn.alpha;
                    
                       
% Colors 
                    colormap  winter
                    param.color.cmap        = colormap;
                    foo                     = round(linspace(1,60,6));
                    param.color.cmap2       = param.color.cmap(foo,1:3);
                    param.color.cmap3       = repmat(param.color.cmap,10,1); 
                    param.color.cmap4       = repmat(param.color.cmap,2,1); 
                    
                    
                    
                    
                    











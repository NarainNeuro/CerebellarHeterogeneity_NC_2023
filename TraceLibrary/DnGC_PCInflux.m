
function [PC_EPSP] = DnGC_PCInflux(nhp, param)


% DnGC_PCInflux.m
% Devika Narain Aerts 2016

% Unpack structure elements
        N               = param.basis.N;
        N_obs           = param.genpars.obs;
        tau             = param.learn.gc_tau;
        Scale           = param.learn.gcmpscale;
        epsp_func       = param.learn.gc_func;
        baseline        = param.learn.baseline;
        timeline        = param.genpars.timeline;
        endtime         = param.genpars.endtime;
        EPSP_train      = epsp_func(tau,timeline);
        neuronvector    = param.genpars.neurvector;
        
        
        
% Initialize output matrix        


 for o  = 1:N_obs,
     PC_EPSP{o}.mat = zeros(N,endtime);
     
     for n = 1:N,
        spiketrain       = nhp{o}.mat(n,:);
        Convl       = conv(spiketrain,EPSP_train)*Scale; % corresponds to 0-1
        Convl       = Convl(1:endtime);   
        PC_EPSP{o}.mat(n,:)      = Convl;

% ------ uncomment to debug ------
% subplot(1,3,1)
%  plot(squeeze(PC_EPSP(o,n,:)))
% subplot(1,3,2)
% plot(spiketrain)
% subplot(1,3,3)
% plot(Convl)
%    pause; clf

    end, end


% ------ uncomment to debug ------
% figure(123)
% o = 100;
% for i = 1:6
%     subplot(2,3,i), hold on
%     a = squeeze(PC_EPSP(o,i,:));
%     plot(a);
% end

    

function [Integral DemeanPotential]  = DnIntergrateOp(param, Potential,p)

% DnIntegrateOp.m
% DNA 2016


CheckIntegral = 0;


        N_obs       = param.genpars.obs;
        timeline    = param.genpars.timeline;
        endtime     = param.genpars.endtime;
        cmap        = param.color.cmap2;
        omat        = round(linspace(1,N_obs,6)); 
        
        
        DemeanPotential(1:N_obs,1:endtime) = zeros(N_obs,endtime);
        Integral(1:N_obs,1:endtime)        = zeros(N_obs,endtime);
        
        
        for o = 1:N_obs
        estpot = smooth(squeeze(Potential(o,:)),10);
        DemeanPotential(o,:) = estpot - mean(estpot);

        % Initial State
        r = 0;
        % Euler's method
        for t = 1:endtime
        dcn = - DemeanPotential(o,t);
        drdt = dcn;
        % State Update
        r = r + drdt;
        Integral(o,t) = r;
        end
        end

        
        if(CheckIntegral)   
         
            RunDnDiagnostics('CheckIntegral');
        end
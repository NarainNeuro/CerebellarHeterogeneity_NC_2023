
function [Theory]  = DnGetBLS(param,p, varargin)
optargin = size(varargin,2);
v = 1;

for i = 1:2:optargin
    switch varargin{i}
        case 'UseFunction'
            Author = varargin{i+1};
        case 'PlotCheck'
            PlotCheck = 1;
            case 'Vary'
            v = varargin{i+1};
    end
end                                
                            

                                    N_obs           = param.genpars.obs;
                                    start           = param.prior.uni(1,v);
                                    stop            = param.prior.uni(2,v); 
                                    Gmu             = param.prior.gauss(1,v);
                                    Gsd             = param.prior.gauss(2,v);
                                    endtime         = param.genpars.endtime;
                                    wm              = param.prior.wm;
                                    wlimit          = length(wm);
                                    ts              = param.prior.stim;
                                    lb              = param.genpars.dt; 
                                    ub              = endtime;
 
                                    
 

 if(strcmp(Author,'Mehrdad')) 

    % Convert BLS est into te 
    for w = 1:wlimit
        
    d = MJTeTs(start,stop,wm(w)); % Only for Uniform priors
    
    Theory{w}.bls = d;
    end
  
 else
   
         % Convert BLS est into te 
    for w = 1:wlimit
    
    if(p==1)
    d = DnTeTs(w,'Params',param,'Vary',v,'Uniform'); 
    else
    d = DnTeTs(w,'Params',param,'Vary',v,'Gaussian');
    end
    Theory{w}.bls = d;
  
  
 end, end
 


                                      
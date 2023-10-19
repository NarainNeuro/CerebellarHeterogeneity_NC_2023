
function BasisSet = DnGenerateBasis( param)

% Function uses Ganguli & Simoncelli gain population coding (NIPS, not so long ago - check year)
global PlotBasis 


    


                        % Unpacking structure elements for use
                        N           = param.basis.N;            % No of kernels in the basis set
                        rangestim   = param.basis.continuum;   
                        Scale       = param.basis.Scale;         % transforming set
                        d           = param.basis.d;             % Density
                        slope       = param.basis.slope;
                        sig         = param.basis.sig;
                        tau         = param.basis.tau;
                        type        = param.basis.dropoff;
                        amp         = param.basis.amp;
                        scomp       = param.basis.sigcomp;
                        slim1       = sig*(1-scomp);
                        slim2       = sig*(1+scomp);
                        
                        
                        if(strcmp(type,'Linear'))
                            DoLinear = 1;
                        else
                            DoLinear = 0;
                        end
                      
                        
                       % Kernal sigma
                        
                        const       = param.basis.const;
                        timeline    = param.genpars.timeline;
                        endtime     = param.genpars.endtime;
                        
                        BasisSet(1:N,1:endtime) = zeros(N,endtime);
                        
                        SigVec      = linspace(slim1,slim2,N);
                        
                        % Tuning Function
                        TuneFnc     = @(x,g,mu,sig)g.*(1./(2*pi.*sig^2).*exp(-0.5.*(x-mu).^2./sig^2) );
                        
                        % Gain function
                        
                        % LINEAR GAIN FUNCTION
                        if(DoLinear)
                            
                        g           = -rangestim.*slope + const; % Linear Gain function
                        
                        % EXPONENTIAL GAIN FUNCTION
                        else
                            
                        g           = amp.*exp(-rangestim./tau) + const; % Linear Gain function
                        
                        end
                        %  DNA Note: Check influence of 'd' on the basis set when time permits 
                        
                       
                        
                        slope = param.basis.slope; %sig = param.basis.sig; 
                            
                        
                            
                        for n                   = 1:N
                            
                        mu                      = rangestim(n);
                        xeff                    = timeline;%d(n).*(timeline - (N/d(n)) );
                        sig                     = SigVec(n);
                        
                        if(DoLinear)
                        BasisSet(n,:)           = (TuneFnc(xeff,g(n),mu,sig).*Scale);
                        else
                        BasisSet(n,:)           = (TuneFnc(xeff,g(n),mu,sig));
                        end
                            
                        end 
                        
                        if(PlotBasis)
                            
                        figure, hold on 
                        for n = 1:N
                                                  plot(BasisSet(n,:)), end
                                                  for t = 1:endtime, MeanT(t) = mean(BasisSet(:,t)); end
                                                  plot(MeanT,'-k','Linewidth',2)
                        end
                        
                        
                        
                        
                        
                        
                  
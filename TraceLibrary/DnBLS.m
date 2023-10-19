function [Fnct, Fder, Prior4plot] = DnBLS(param, varargin)

v = 1;

optargin = size(varargin,2);
Plotcheck = 0;
for i = 1:2:optargin
    switch varargin{i}
        case 'Plotcheck'
            Plotcheck = varargin{i+1};
        case 'Vary'
            v = varargin{i+1};
            
        end
    end

        
 

% General Variables

Starttime                   = param.genpars.dt; % ms
Stoptime                    = param.genpars.endtime;
tm                          = [Starttime:Stoptime]';
Len                         = length(tm);
PriorCond                   = param.prior.no;
wm                          = param.prior.wm;
WmCond                      = length(param.prior.wm);

% Initializations
Fnct(1:PriorCond,1:WmCond,1:Len)      = zeros(PriorCond,WmCond,Len);
Prior4plot(1:PriorCond,1:Len)         = zeros(PriorCond,Len);
Fder(1:PriorCond,1:WmCond,1:Len-1)    = zeros(PriorCond,WmCond,Len-1);


% Options
method_opts.dx              = 1;   % Controls the bin size of the numerical integration; 10ms is usually accurate
method_opts.type            = 'quad';  % Controls the method used to perform numerical integration


for w = 1:WmCond
    
    % Uniform
    prior_opts.type          = 'uniform';

    LowerBound               = param.prior.uni(1,v); 
    UpperBound               = param.prior.uni(2,v);  
    Fnct(1,w,:)              = SWEBayes(tm,wm(w),LowerBound,UpperBound,'method',method_opts,'prior',prior_opts);
    Fder(1,w,:)              = Fnct(1,w,2:end) - Fnct(1,w,1:end-1); 
    if(Plotcheck)
    Prior4plot(1,LowerBound+1:UpperBound)          = ones((UpperBound-LowerBound ),1).*100 + 200; % for plots
    end
    
    % Gaussian
    prior_opts.type          = 'Gaussian';
     
    prior_opts.mu            = param.prior.gauss(1,v);
    prior_opts.sig           = param.prior.gauss(2,v) ;
    LowerBound               = Starttime;
    UpperBound               = Stoptime;
    Fnct(2,w,:)              = SWEBayes(tm,wm(w),LowerBound,UpperBound,'method',method_opts,'prior',prior_opts);
    Fder(2,w,:)              = Fnct(2,w,2:end) - Fnct(2,w,1:end-1);
            K                = 1/sqrt(2*pi*prior_opts.sig^2);
    if(Plotcheck)        
    Prior4plot(2,:)          = K.*exp(-0.5.*(tm-prior_opts.mu).^2./prior_opts.sig^2).*6000 + 200;
    end
end

 

% Color Matrix
if(Plotcheck)
% Uniform --- Shades of Orange
clr(1,1,1:3)                = rgb('Orange');   
clr(1,2,1:3)                = rgb('DarkOrange'); 
clr(1,3,1:3)                = rgb('FireBrick'); 
clr(1,4,1:3)                = rgb('Crimson'); 

% Gaussian --- Shades of Blue
clr(2,1,1:3)                = rgb('DeepSkyBlue');
clr(2,2,1:3)                = rgb('CornflowerBlue');
clr(2,3,1:3)                = rgb('Indigo'); % Violet
clr(2,4,1:3)                = rgb('MidnightBlue'); % purple


% True
ct(1,1:3)                   = rgb('Black');
ct(2,1:3)                   = rgb('DarkSlateGray'); % 
ct(3,1:3)                   = rgb('SlateGray'); % 
ct(4,1:3)                   = rgb('DarkGray'); % 

% Bimodal
clr(3,1,1:3)                = [0.1 0.5 0.1]; % forest green
clr(3,2,1:3)                = [0.1 0.8 0.1]; % light green
clr(3,3,1:3)                = [0.1 0.5 0.1]; % forest green
clr(3,4,1:3)                = [0.1 0.8 0.1]; % light green

figure(321)
cnt = 0;
            
            % Uniform
            cnt = cnt + 1;
            subplot(1,2,cnt), hold on
            title('fBLS Uniform')
            b1 = Prior4plot(1,:);
            plot(tm,tm,'--k')
            plot(tm,b1,'-','Color',clr(2,1,1:3))
            for w = 1:WmCond
            a1 = squeeze(Fnct(1,w,:));
            kleur = squeeze(clr(1,w,:));
            plot(tm,a1,'-','Color',kleur)            
            end
            ylabel('Te')
            xlabel('Tm')
%             axis([0 Stoptime 200 1200])
%             legend('unity','prior','BLS w1','BLS w2')
            
            % Gaussian
            cnt = cnt + 1;
            subplot(1,2,cnt), hold on
            title('fBLS Gaussian')
            b2 = Prior4plot(2,:);
            plot(tm,tm,'--k')
            plot(tm,b2,'-','Color',kleur)
            for w = 1:WmCond
            a2 = squeeze(Fnct(2,w,:));
            kleur = squeeze(clr(2,w,:));
            plot(tm,a2,'-','Color',kleur)
            end
%             axis([0 Stoptime 200 1200])
            ylabel('Te')
            xlabel('Tm')
%             legend('unity','prior','BLS w1','BLS w2')

end



       
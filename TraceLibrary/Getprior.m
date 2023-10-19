function [prior] = Getprior(param, type, varargin)

% GetPrior
% Devika Narain Aerts 2016

Pno = size(varargin,2);
v = 1;

        for i = 1:2:Pno
        switch varargin{i}
        case 'Strength'
        maxrate = varargin{i+1};
        case 'Vary'
        v = varargin{i+1};
        end, end


mu_p        = param.prior.gauss(1,v);
sd_p        = param.prior.gauss(2,v);
endtime     = param.genpars.endtime;
timeline    = param.genpars.timeline;
unia        = param.prior.uni(1,v);
unib        = param.prior.uni(2,v);


prior(1:endtime) = zeros(endtime,1);



switch type
    
    case 'Gaussian'
        prior = 1./sqrt(2*pi*sd_p^2).*exp(-0.5.*(timeline-mu_p).^2./2./sd_p^2);
        
    case 'Uniform'
        
   prior(unia+1:unib) = ones((unib-unia),1)/(unib-unia);
        
end

baseline = 0;
maxrt = max(prior);
minrt = min(prior);
if(size(maxrt,1)>1), maxrt = maxrt(1); end
if(size(minrt,1)>1), maxrt = minrt(1); end

prior = baseline + (prior - minrt).*((maxrate - baseline)./(maxrt - minrt));

figure;
plot(prior)

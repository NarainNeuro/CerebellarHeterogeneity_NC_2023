function [func]  = DnNormalize(Incoming,varargin)

% Takes a matrix Nxntimes and a maxrate argument
baseline = 0;
if((varargin{1}))
    maxrate = varargin{1};
else
    maxrate = 1;
end

if((varargin{2}))
    baseline = varargin{2};

end



% Only for 1 or 2D Matrices - Note to DNA: Need to generalize to
% N-dimensional matrix

generic     = size(Incoming);

if(length(generic)>1)
rs          = size(Incoming,1);
cs          = size(Incoming,2);


maxrt       = max(max(Incoming));
minrt       = min(min(Incoming));

if(size(maxrt,1)>1), maxrt = maxrt(1); end
if(size(minrt,1)>1), maxrt = minrt(1); end

% Normalize between values 0 and maxrate

func = baseline.*ones(rs,cs) + (Incoming - minrt.*ones(rs,cs)).*((maxrate - baseline)./(maxrt - minrt));

else
    
rs          = size(Incoming,1);    
    
maxrt = max(Incoming);
minrt = min(Incoming); 

if(size(maxrt,1)>1), maxrt = maxrt(1); end
if(size(minrt,1)>1), maxrt = minrt(1); end

func = baseline.*ones(rs,1) + (Incoming - minrt.*ones(rs,1)).*((maxrate - baseline)./(maxrt - minrt));

end
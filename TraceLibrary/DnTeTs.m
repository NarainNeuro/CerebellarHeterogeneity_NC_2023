% based on Mehrdad's code
% Author: Devika Narain

function d = DnTeTs( w, varargin)


% Note while calling this function, Prior type must be input last after all
% other parameters because of 1:2:optargin

optargin = size(varargin,2);

for i = 1:2:optargin
    switch varargin{i}
        case 'Uniform'
            PriorType = 1;
            plotval = 1;
        case 'Gaussian'
            PriorType = 2;
            plotval = 2;
        case 'Params'
            param = varargin{i+1};
             case 'Vary'
            v = varargin{i+1};
    end
end
%             

timeline = param.genpars.dt:param.genpars.endtime;
d.wM = param.prior.wm(w);
Nrepeats  = 100000;
d.tsVals = timeline;

ts2tm = @(x) random('norm',x,x*d.wM,size(x));
	
% f_tm = RSGpsy_f_tm(d.wM, d.tsVals, PriorType, param);
[fnct fder pr] = DnBLS(param, 'Plotcheck', 1,'Vary',v);
tmvec = timeline;
f_tmvec = squeeze(fnct(PriorType,w,:));

f_tm = @(tm) interp1(tmvec,f_tmvec,tm);

for i = 1:length(d.tsVals)
	this_ts = d.tsVals(i);
	tm_sim = ts2tm(repmat(this_ts,Nrepeats,1));
	te_sim = f_tm(tm_sim);
	d.teVals(i) = nanmean(te_sim);
end

d.original = f_tmvec;
d.prior = squeeze(pr(PriorType,:));
% figure(200+plotval), hold on
% plot(d.tsVals,d.original,'-k')
% plot(d.tsVals,d.teVals)
%  plot(prior*100+200,'-k')
% axis equal
% dline
		











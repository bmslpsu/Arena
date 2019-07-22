function [wrapfunc] = wrap_func(func,lim)
%% wrap_func: wrap function position
%   INPUTS:
%       func     	:   function [panel#]
%   OUTPUTS:
%       wrapfunc   	:   wrapped function [panel#]
%---------------------------------------------------------------------------------------------------------------------------------
if nargin==1
    lim = 96 + 1; % default
end

% n = length(func);
% frac = nan(n,1);
% rem = nan(n,1);
% for kk = 1:n
%     frac(kk) = floor(func(kk)/lim);
%     rem(kk) = mod(func(kk),lim);
%     if frac(kk)>=1
%         rem(kk) = rem(kk) + 1;
%     end
% end
% wrapfunc = rem;

lambdaWrapped = wrapTo2Pi(deg2rad(3.75*func));
wrapfunc = rad2deg(lambdaWrapped)/3.75;


% wrapfunc = func(:);
% fct = floor(func/lim);
% cnd = fct>0;
% 
% wrapfunc(cnd) = wrapfunc(cnd) - (lim*fct(cnd) - 1);

end
function [varargout] = CalculateContrast(varargin)
% CalculateContrast: returns Michelson contrasts for LED arena luminance levels
% NOTES:    1. Luminance values source: "A modular display system for insect behavioral neuroscience"
%           2. Michelson Contrast Formula : https://www.schorsch.com/en/kbase/glossary/contrast.html
% USAGE: 2 modes
%   [T] = CalculateContrasts()
%       - Returns table of all possible intensity combinations, and their mappings to lumiance & Michelson contrast
%   [Contrast] = CalculateContrasts(I_1,I_2)
%       - Returns Michelson contrast for two intensity values using gs=4 mode (must be positive integers from 0-15)
%       - If I_1 % I_2 are arrays, then [Contrast] will return an array of Michelson contrasts
%% Mapping Fucntions%%
%---------------------------------------------------------------------------------------------------------------------------------
Int_to_Lum = @(x) (7*10.02/15)*x; % mapping LED intensity (gs=4) to luminance (cd*m^-2) from paper
MichContr   = @(imax,imin) (imax-imin)./(imax+imin); % mapping luminance to Michelson contrast
if nargin==2
    I1 = varargin{1}(:);
    I2 = varargin{2}(:);
    if any(size(I1)~=size(I2))
        error('Intensity arrays must be the same size')
    end
    Int = [I1,I2];
    if any(any(Int<0)) || any(any(Int>15)) || any(any(round(Int)~=Int))
        error('Intensities must be positive integers from 0-15')
    end
    Lmax = Int_to_Lum(max(Int));
	Lmin = Int_to_Lum(min(Int));
    Contrast = MichContr(Lmax,Lmin);
    varargout{1} = Contrast;
elseif (nargin==1) || (nargin>2)
    error('Input options include: two intensity values OR zero inputs')
elseif (nargin==0)
    % Calculate all possible contrast ratios
    INT_level.gs1   = 0:2^(1)-1;   	% contrast values for gs=1
    INT_level.gs2   = 0:2^(2)-1;  	% contrast values for gs=2
    INT_level.gs3   = 0:2^(3)-1;   	% contrast values for gs=3
    INT_level.gs4   = 0:2^(4)-1;   	% contrast values for gs=4

    LUM_level   = Int_to_Lum(INT_level.gs4); % luminance corresponding to each intensity level for gs=4

    % Luminance vs LED Intensity Settings
    figure (1) ; clf ; hold on ; grid on ; grid minor ; box on
    title('Luminance vs LED Intensity Settings')
    xlabel('LED Display Intensity Level (gs=3)','FontSize',14,'interpreter','latex')
    ylabel('Luminance $[cd*m^{-2}]$','FontSize',16,'interpreter','latex')
    plot(INT_level.gs4,LUM_level,'-og','LineWidth',3,'MarkerSize',8)

    % Find all unique combinations of contrast levels
    [A,B] = meshgrid(INT_level.gs4,INT_level.gs4);
    C  = cat(2,A',B');
    allComb = reshape(C,[],2);   % all combinations of intensities
    [~,jj] = unique(sort(allComb,2),'rows','stable');
    unqComb = allComb(jj,:); % non repeated & unique combinations of intensities
    nComb = length(unqComb); % # of combinations

    % Michelson contrasts for all unique combinations of intensities
    Contrast = nan(nComb,1);
    Imax = nan(nComb,1);
    Imin = nan(nComb,1);
    Lmax = nan(nComb,1);
    Lmin = nan(nComb,1);
    for kk = 1:nComb
        Imax(kk) = max(unqComb(kk,:));      % max intensity
        Imin(kk) = min(unqComb(kk,:));      % min intensity
        Lmax(kk) = Int_to_Lum(Imax(kk));    % max luminance
        Lmin(kk) = Int_to_Lum(Imin(kk));    % min luminance
        Contrast(kk) = MichContr(Lmax(kk),Lmin(kk)); % Michelson contrast
    end
    
    % Mapping Table
    T = table(Imax , Imin , Lmax , Lmin , Contrast);
    T = sortrows(T,5,'descend');
    varargout{1} = T;

    % Create 3D interactive plot
    [X,Y] = meshgrid(Imin,Imax);
    [Z] = (Y-X)./(Y+X);
    Z(Z<0) = nan;
    figure (2) ; clf
    surf(X,Y,Z)
%     mesh(X,Y,Z)
    title('Michelson Contrast')
    xlabel('$I_{min}$','FontSize',14,'interpreter','latex')
    ylabel('$I_{max}$','FontSize',14,'interpreter','latex')
    zlabel('Contrast $\frac{I_{max}-I_{min}}{I_{max}+I_{min}}$','FontSize',18,'interpreter','latex')
    box on
    view(0,90)
    colorbar
    colormap default
    rotate3d on
else
    error('Something is wrong')
end
end


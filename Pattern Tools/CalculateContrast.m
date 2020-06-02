function [varargout] = CalculateContrast(gs,varargin)
% CalculateContrast: returns Michelson contrasts for LED arena luminance levels
%
% NOTES:    1. Luminance values source: "A modular display system for insect behavioral neuroscience"
%           2. Michelson Contrast Formula : https://www.schorsch.com/en/kbase/glossary/contrast.html
%
% USAGE: 2 modes
%   [T] = CalculateContrasts(gs)
%       - "gs" is the pattern grey scale value (must be a positive integer between 1-4)
%       - Returns table of all possible intensity combinations, and their mappings to lumiance & Michelson contrast
%   [Contrast] = CalculateContrasts(gs,I_1,I_2)
%       - Returns Michelson contrast for two intensity values using gs=4 mode (must be positive integers from 0-15)
%       - If I_1 & I_2 are arrays (of the same size), then will return an array of Michelson contrasts
%
%

if (length(gs)<1) || (round(gs)~=gs) || (gs<1) || (gs>4)
    error('Grey scale values must be a positive integer between 1-4')
end
gsLevel = 2^(gs) - 1;
INT_levels = 0:gsLevel;
Int_to_Lum  = @(x) (7*10.02/gsLevel)*x; % mapping LED intensity (gs=4) to luminance (cd*m^-2) from paper
MichContr   = @(Lmax,Lmin) (Lmax-Lmin)./(Lmax+Lmin); % mapping luminance to Michelson contrast
if nargin==3
    I1 = varargin{1}(:);
    I2 = varargin{2}(:);
    if any(size(I1)~=size(I2))
        error('Intensity arrays must be the same size')
    end
    Int = [I1,I2];
    if any(any(Int<0)) || any(any(Int>gsLevel)) || any(any(round(Int)~=Int))
        error(['Intensities must be positive integers from 0-' num2str(gsLevel)])
    end
    Lmax = Int_to_Lum(max(Int));
	Lmin = Int_to_Lum(min(Int));
    Contrast = MichContr(Lmax,Lmin);
    varargout{1} = Contrast;
elseif (nargin==2) || (nargin>2)
    error('Input options include: grey scale value OR grey scale value + two intensity values')
elseif (nargin==1)
    LUM_levels   = Int_to_Lum(INT_levels); % luminance corresponding to each intensity level for gs=4

    % Luminance vs LED Intensity Settings
    figure ; clf ; hold on ; grid on ; grid minor ; box on
    title('Luminance vs LED Intensity Settings')
    xlabel(['LED Display Intensity Level (gs=' num2str(gs) ')'],'FontSize',14,'interpreter','latex')
    ylabel('Luminance $[cd*m^{-2}]$','FontSize',16,'interpreter','latex')
    plot(INT_levels,LUM_levels,'-og','LineWidth',3,'MarkerSize',8)

    % Find all unique combinations of contrast levels
    [A,B] = meshgrid(INT_levels,INT_levels);
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
    figure ; clf
    surf(X,Y,Z)
%     mesh(X,Y,Z)
    title('Michelson Contrast')
    xlabel('$I_{min}$','FontSize',14,'interpreter','latex')
    ylabel('$I_{max}$','FontSize',14,'interpreter','latex')
    zlabel('Contrast $\frac{I_{max}-I_{min}}{I_{max}+I_{min}}$','FontSize',18,'interpreter','latex')
    box on
    grid minor
    view(0,90)
    colorbar
    colormap default
    rotate3d on
elseif nargin==0
    error('Not enough inputs, need at least the grey scale value')
else
    error('Something is wrong')
end
end


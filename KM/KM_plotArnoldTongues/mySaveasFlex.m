function filename = mySaveasFlex(varargin)

%%% 26-01-23    first commit

%%% variable arguments pairs
% 'dimXY' -> vector of two num. Default: see below. If both dimXY and size are specified, size is ignored.
% 'size' -> str: S, M, L, XL (dimXY and size mutually exclusive). Default: M
% 'res' -> num. Default resolution is 300
% 'fontSize' -> num. Default is not changing the fontsize
% 'lineWidth'  -> num. Default is not changing the lineWidth
% 'fNameNoNowStr' -> str. Default is 'plot'. A timeDateStr will be added. Saved in current dir
%                       can saved in another dir by giving a path
% 'format' -> tiff, png. Default is png


% size definitions - can easily add other sizes
% S
sDim(1).size='S';
sDim(1).XY=[8 6];

% M
sDim(2).size='M';
sDim(2).XY=[20 15];

% L
sDim(3).size='L';
sDim(3).XY=[30 16];

% XL
sDim(4).size='XL';
sDim(4).XY=[35 25];


%input parser
defaultDimXY            = [];
defaultSize             = 'M';
defaultRes              = 300;
defaultFontSize         = [];
defaultLineWidth        = [];
defaultFnameNoNowStr    = 'plot';
defaultFormat           = 'png';

p = inputParser;

isPt = @(x) (isnumeric(x) && length(x)==2);
sizeCheck = @(x) (ischar(x) && length(x)<3);

addParameter(p,'dimXY',defaultDimXY,isPt)
addParameter(p,'size',defaultSize,sizeCheck)
addParameter(p,'res',defaultRes,@isnumeric)
addParameter(p,'fontSize',defaultFontSize,@isnumeric);
addParameter(p,'lineWidth',defaultLineWidth,@isnumeric);
addParameter(p,'fNameNoNowStr',defaultFnameNoNowStr,@ischar);
addParameter(p,'format',defaultFormat,@ischar);

parse(p,varargin{:});

if ~isempty(p.Results.dimXY)
    dimX=p.Results.dimXY(1);
    dimY=p.Results.dimXY(2);
else
    sIdx=find(arrayfun(@(x)strcmp(x.size,p.Results.size),sDim));
    dimX=sDim(sIdx).XY(1);
    dimY=sDim(sIdx).XY(2);
end

nowStr=getDateTimeStr();
filename=[p.Results.fNameNoNowStr '_edited_' nowStr '.' p.Results.format];

if ~isempty(p.Results.lineWidth)
    hline = findobj(gcf, 'type', 'line');
%     hline = findall(gca, 'Type', 'Line');
    set(hline,'LineWidth',p.Results.lineWidth)
end

set(gcf,'color','w');

if ~isempty(p.Results.fontSize)
    set(gca,'FontSize',p.Results.fontSize,'fontWeight','bold')
    set(findall(gcf,'type','text'),'FontSize',p.Results.fontSize,'fontWeight','bold')
end

set(gcf,'PaperPositionMode','auto','PaperPosition',[0 0 dimX dimY])


if strcmp(p.Results.format,'tiff')
    formatFlag = '-dtiff';
elseif strcmp(p.Results.format,'png')
    formatFlag = '-dpng';
else
    error('file format not implemented');
end

print(filename,formatFlag,['-r' num2str(p.Results.res)])

end


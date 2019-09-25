function [axesH, fM, ph] = plot(inputObject, varargin)
% plot
%
% Purpose : plot channels of the given mdtsObject
%
% Syntax : plot(inputObject)
%          inputObject.plot();
%          inputObject.plot;
%          inputObject.plot(varargin);
%
% Input Parameters :
%   inputObject : mdtsObject (with multiple channels) to be plotted
%
% Return Parameters :
%
% Description : 
%   Use the plot function to plot the channels of the given object
%
% Author : 
%   Paul O'Leary
%   Roland Ritt
%   Thomas Grandl
%
% History :
% \change{1.0}{18-Dec-2017}{Original}
%
% --------------------------------------------------------
% (c) 2017 Paul O'Leary,
% Chair of Automation, University of Leoben, Leoben, Austria
% email: office@harkeroleary.org,
% url: www.harkeroleary.org
% --------------------------------------------------------

%% Parse inputs

p = inputParser();
p.KeepUnmatched=true;
addRequired(p, 'inputObject', @(x) isa(x, 'mdtsObject')); %check if input is mdtsObject
addParameter(p, 'Size', [8.8,11.7], @(x)isnumeric(x)&&isvector(x)); %higth and width
addParameter(p, 'FontSize', 10, @isnumeric);
addParameter(p, 'plotSymbolName', false, @islogical);
addParameter(p, 'plotSymbolDuration', false, @islogical);
addParameter(p, 'plotSymbolNameMinLengthRelative', 0.05, @isnumeric);
addParameter(p, 'figureH', [], @(x) isgraphics(x,'figure'));
parse(p, inputObject, varargin{:});
tmp = [fieldnames(p.Unmatched),struct2cell(p.Unmatched)];
UnmatchedArgs = reshape(tmp',[],1)';

plotSymbolNameMinLength = numel(inputObject.time) * p.Results.plotSymbolNameMinLengthRelative;

%% Interpret options

xTime = inputObject.timeInFormat;


%% Plot data

if isempty(p.Results.figureH)
    figH = figureGen(p.Results.Size(1), p.Results.Size(2), p.Results.FontSize);
    set(figH,'defaultLegendAutoUpdate','off'); %prevent outo updating legend;
    fM = FigureManager;
else
    figH = p.Results.figureH;
    if isempty(figH.UserData)
        fM = FigureManager(figH);
    else
        fM = figH.UserData;
    end
end
% 

tagsLabel = inputObject.tags;

indsUnits = ~cellfun(@isempty,inputObject.units);

tagsLabel(indsUnits) =  strcat(inputObject.tags(indsUnits), ' [', inputObject.units(indsUnits), ']');

[axesH, ph] = plotMulti(xTime, inputObject.data, 'time', tagsLabel,'yLabelsLatex',false, UnmatchedArgs{:});

shouldAddold = fM.shouldAdd;
fM.shouldAdd = false; %% otherwise it is too slow!!!
title(axesH(1), inputObject.name, 'Interpreter', 'none');

%% Plot Symbolic Representation


gObjArr = plotSymRepObjectOnAxes(axesH, inputObject.symbReps, xTime, 'plotSymbolName',p.Results.plotSymbolName, 'plotSymbolDuration',...
    p.Results.plotSymbolDuration, 'plotSymbolNameMinLength', plotSymbolNameMinLength, 'colorDismiss', get(ph(1), 'Color'));
 

for i=1:numel(ph)
         uistack(ph(i), 'top');
%         set(out(i), 'Layer', 'top');
end




%% Plot Events

[ph2]= inputObject.plotEventsOnAxes(axesH);


%%
fM.shouldAdd = shouldAddold;

end


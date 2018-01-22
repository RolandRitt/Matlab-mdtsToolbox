function [out, fM, ph] = plotmdtsObject(inputObject, varargin)
% plot
%
% Purpose : plot channels of the given mdtsObject
%
% Syntax : plotmdtsObject(inputObject)
%
% Input Parameters :
%   inputObject : mdtsObject (with multiple channels) to be plotted
%
% Return Parameters :
%
% Description : 
%   Use the plotMulti function to plot the channels of the given object
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
addParameter(p, 'Range', [], @(x)isvector(x) && (isequal(size(x), [2,1])|| isequal(size(x), [1,2]))); %index range 2x1 array with start und end index
addParameter(p, 'IndsSelected', [], @isnumeric); %
addParameter(p, 'TagsSelected', [], @(x) isnumeric(x) || iscellstr(x) || ischar(x));
addParameter(p, 'Size', [8.8,11.7], @(x)isnumeric(x)&&isvector(x)); %higth and width
addParameter(p, 'FontSize', 10, @isnumeric);
addParameter(p, 'bUseDatetime', true, @islogical);
addParameter(p, 'plotSymbolName', false, @islogical);
addParameter(p, 'plotSymbolDuration', false, @islogical);
addParameter(p, 'plotSymbolNameMinLengthRelative', 0.05, @isnumeric);
parse(p, inputObject, varargin{:});
tmp = [fieldnames(p.Unmatched),struct2cell(p.Unmatched)];
UnmatchedArgs = reshape(tmp',[],1)';

inds = p.Results.IndsSelected;
indsTags = p.Results.TagsSelected;
bDatetime = p.Results.bUseDatetime;

if ~isempty(indsTags)
    
    inds = inputObject.getTagIndices(indsTags);
    
end

if isempty(inds)
    
    inds = 1 : numel(inputObject.tags);
    
end

if isempty(p.Results.Range)
    
    Range = 1 : numel(inputObject.time);
    
else
    
    [Startind, Stopind] = getTimeRangeInds(inputObject,  p.Results.Range(1), p.Results.Range(2));
    Range = Startind:Stopind;
    
end

plotSymbolNameMinLength = numel(inputObject.time) * p.Results.plotSymbolNameMinLengthRelative;

%% Plot data

figH = figureGen(p.Results.Size(1), p.Results.Size(2), p.Results.FontSize);

fM = FigureManager;

if bDatetime
    
    [out, ph] = plotMulti(inputObject.timeDateTime(Range), inputObject.data(Range,inds), 'time', inputObject.tags(inds), UnmatchedArgs{:});
    
else
    
    [out, ph] = plotMulti(inputObject.time(Range), inputObject.data(Range,inds), 'time', inputObject.tags(inds), UnmatchedArgs{:});
    
end

shouldAddold = fM.shouldAdd;
fM.shouldAdd = false; %% otherwise it is too slow!!!
title(out(1), inputObject.name, 'Interpreter', 'none');

%% Plot Symbolic Representation

allSymbols = {};

for i = 1 : numel(inputObject.symbReps)
    
    if~isempty(inputObject.symbReps{i})
        
        addSymbols = categories(inputObject.symbReps{i}.symbols);
        allSymbols = [allSymbols; addSymbols];
        
    end
    
end

uniqueSymbols = unique(allSymbols);
nSymbols = numel(uniqueSymbols);
symbolColors = distinguishable_colors(nSymbols, {'w', get(ph(1), 'Color')});
alphCol = 0.3;

for i = 1 : numel(out)
    
    hold(out(i), 'on');
    
    ymin = min(min(ph(i).YData), -1);
    ymax = max(max(ph(i).YData), 1);
    
    if~isempty(inputObject.symbReps{i})
        
        for j = 1 : nSymbols
            
            [startInds, durations] = inputObject.symbReps{i}.findSymbol(uniqueSymbols{j});
            
            for k = 1 : numel(startInds)
                
                if bDatetime
                    
                    xStart = inputObject.timeDateTime(startInds(k));
                    xEnd = inputObject.timeDateTime(startInds(k) + durations(k) - 1);
                    
                else
                    
                    xStart = inputObject.time(startInds(k));
                    xEnd = inputObject.time(startInds(k) + durations(k) - 1);
                    
                end
                
                fill([xStart, xEnd, xEnd, xStart], [ymin, ymin, ymax, ymax], symbolColors(j, :), 'FaceAlpha', alphCol, 'EdgeColor', symbolColors(j, :), 'Parent', out(i));
                
                if(p.Results.plotSymbolName && durations(k) > plotSymbolNameMinLength)
                    
                    yText = ymin + (ymax - ymin) * 0.25;
                    
                    if(~p.Results.plotSymbolDuration)
                        
                        symbolText = uniqueSymbols{j};
                        
                    else
                        
                        symbolText = {uniqueSymbols{j}; num2str(durations(k))};
                        
                    end
                    
                    if bDatetime
                        
                        xSymbol = inputObject.timeDateTime(startInds(k) + round(durations(k) / 2));
                        
                    else
                        
                        xSymbol = inputObject.time(startInds(k) + round(durations(k) / 2));
                        
                    end
                    
                    text(out(i), xSymbol, yText, symbolText, 'Color', 'k', 'HorizontalAlignment', 'center', 'clipping', 'on', 'Interpreter', 'latex');
                
                end
                
            end
            
        end
        
        uistack(ph(i), 'top');
        set(out(i), 'Layer', 'top')
        
    end
    
end

%% Plot Events
eventKeys = keys(inputObject.tsEvents);
nEvents = length(eventKeys);
colors = distinguishable_colors(nEvents, {'w', get(ph(1), 'Color')});
phLegend = [];
    
for i = 1 : nEvents
    
    eventInfo = inputObject.tsEvents(eventKeys{i});
    
    if bDatetime
        
        xev = datetime(eventInfo.eventTime, 'ConvertFrom', 'datenum');
        
    else
        
        xev = eventInfo.eventTime;
        
    end
    
    ph2 = plotvline(xev, 'Axes', out, 'Color', colors(i, :));
    
    phLegend = [phLegend, ph2(end)];
    
end

legend(out(1), phLegend, cellfun(@num2str, eventKeys, 'UniformOutput', false));

fM.shouldAdd = shouldAddold;

end


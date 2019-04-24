function [out, fM, ph] = plot(inputObject, varargin)
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
addParameter(p, 'bUseDatetime', true, @islogical);
addParameter(p, 'bUseTimeRelative', false, @islogical);
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

% if(bTimeRelative)
%     
%     if(bDatetime)
%     
%         xTime = inputObject.timeDateTimeRelative;
%         
%     else
%         
%         xTime = inputObject.timeRelative;
%         
%     end
%     
% else
%     
%     if(bDatetime)
%     
%         xTime = inputObject.timeDateTime;
%         
%     end
%     
% end
% 
% if(~inputObject.absoluteTS)
%     
%     xTime = (0 : datetime(datestr(inputObject.time(2))) - datetime(datestr(inputObject.time(1))) : datetime(datestr(inputObject.time(end))) - datetime(datestr(inputObject.time(1))))';
%     
% end

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
% figH = figureGen(p.Results.Size(1), p.Results.Size(2), p.Results.FontSize);
% 
% fM = FigureManager;

tagsLabel = inputObject.tags;

indsUnits = ~cellfun(@isempty,inputObject.units);

tagsLabel(indsUnits) =  strcat(inputObject.tags(indsUnits), ' [', inputObject.units(indsUnits), ']');

[out, ph] = plotMulti(xTime, inputObject.data, 'time', tagsLabel,'yLabelsLatex',false, UnmatchedArgs{:});

shouldAddold = fM.shouldAdd;
fM.shouldAdd = false; %% otherwise it is too slow!!!
title(out(1), inputObject.name, 'Interpreter', 'none');

%% Plot Symbolic Representation

% gObjArr = plotSymRepObjectOnAllAxes(out, inputObject.symbReps{1}, xTime, p.Results.plotSymbolName, p.Results.plotSymbolDuration, plotSymbolNameMinLength, get(ph(1), 'Color'));

gObjArr = plotSymRepObjectOnAxes(out, inputObject.symbReps, xTime, 'plotSymbolName',p.Results.plotSymbolName, 'plotSymbolDuration',...
    p.Results.plotSymbolDuration, 'plotSymbolNameMinLength', plotSymbolNameMinLength, 'colorDismiss', get(ph(1), 'Color'));
 

for i=1:numel(ph)
         uistack(ph(i), 'top');
%         set(out(i), 'Layer', 'top');
end


% allSymbols = {};
% 
% for i = 1 : numel(inputObject.symbReps)
%     
%     if~isempty(inputObject.symbReps{i})
%         
%         addSymbols = categories(inputObject.symbReps{i}.symbols);
%         allSymbols = [allSymbols; addSymbols];
%         
%     end
%     
% end
% 
% uniqueSymbols = unique(allSymbols);
% nSymbols = numel(uniqueSymbols);
% symbolColors = distinguishable_colors(nSymbols, {'w', get(ph(1), 'Color')});
% alphCol = 0.3;
% 
% for i = 1 : numel(out)
%     
%     hold(out(i), 'on');
%     
%     ymin = min(min(ph(i).YData), -1);
%     ymax = max(max(ph(i).YData), 1);
%     
%     if~isempty(inputObject.symbReps{i})
%         
%         for j = 1 : nSymbols
%             
%             [startInds, durations] = inputObject.symbReps{i}.findSymbol(uniqueSymbols{j});
%             
%             for k = 1 : numel(startInds)
%                 
%                 xStart = xTime(startInds(k));
%                 xEnd = xTime(startInds(k) + durations(k) - 1);
%                 
%                 fill([xStart, xEnd, xEnd, xStart], [ymin, ymin, ymax, ymax], symbolColors(j, :), 'FaceAlpha', alphCol, 'EdgeColor', symbolColors(j, :), 'Parent', out(i));
%                 
%                 if(p.Results.plotSymbolName && durations(k) > plotSymbolNameMinLength)
%                     
%                     yText = ymin + (ymax - ymin) * 0.25;
%                     symbolText = uniqueSymbols{j};
%                     symbolText = strrep(symbolText, '{', '\{');
%                     symbolText = strrep(symbolText, '}', '\}');
%                     
%                     if(~p.Results.plotSymbolDuration)
%                         
%                         symbRepText = symbolText;
%                         
%                     else
%                         
%                         symbRepText = ['\begin{tabular}{c} ', symbolText, '\\', num2str(durations(k)), ' \end{tabular}'];
%                         
%                     end
% 
%                     xSymbol = xTime(startInds(k) + round(durations(k) / 2));
%                     
%                     text(out(i), xSymbol, yText, symbRepText, 'Color', 'k', 'HorizontalAlignment', 'center', 'clipping', 'on', 'Interpreter', 'latex');
%                 
%                 end
%                 
%             end
%             
%         end
%         
%         uistack(ph(i), 'top');
%         set(out(i), 'Layer', 'top')
%         
%     end
%     
% end

% for i=1:numel(ph)
%         uistack(ph(i), 'top');
%         set(out(i), 'Layer', 'top');
% end

%% Plot Events

[ph2]= inputObject.plotEventsOnAxes(out);
% 
% eventKeys = keys(inputObject.tsEvents);
% nEvents = length(eventKeys);
% legendEntries = [];
% 
% xevAll = {};    
% for i = 1 : nEvents
%     xev = [];
%     eventInfo = inputObject.tsEvents(eventKeys{i});
%     eventTimeDatenumAllEv = inputObject.convert2Datenum(eventInfo.eventTime);
%     for j =1:numel(eventTimeDatenumAllEv)
%         eventTimeDatenum = eventTimeDatenumAllEv(j);
%         if(eventTimeDatenum >= inputObject.time(1) && eventTimeDatenum <= inputObject.time(end))
%             
%             if(inputObject.timeType == 2)
%                 
%                 eventTime = datetime(datestr(eventTimeDatenum));
%                 
%             elseif(inputObject.timeType == 3)
%                 
%                 eventTime = seconds(eventTimeDatenum);
%                 
%             else
%                 
%                 eventTime = eventTimeDatenum;
%                 
%             end
%             
%             xev = [xev; eventTime];
%             
%             %         if(~inputObject.absoluteTS)
%             %
%             %             xev = [xev; datetime(datestr(eventInfo.eventTime)) - datetime(datestr(inputObject.time(1)))];
%             %
%             %         elseif bDatetime
%             %
%             %             if bTimeRelative
%             %
%             %                 xev = [xev; datetime(eventInfo.eventTime - inputObject.time(1), 'ConvertFrom', 'datenum')];
%             %
%             %             else
%             %
%             %                 xev = [xev; datetime(eventInfo.eventTime, 'ConvertFrom', 'datenum')];
%             %
%             %             end
%             %
%             %         else
%             %
%             %             if bTimeRelative
%             %
%             %                 xev = [xev; eventInfo.eventTime - inputObject.time(1)];
%             %
%             %             else
%             %
%             %                 xev = [xev; eventInfo.eventTime];
%             %
%             %             end
%             %
%             %         end
%         end
%        
%     end
%     xevAll = [xevAll; {xev}];
%     legendEntries = [legendEntries, eventKeys(i)];
%         
% end
% 
% nEventsToPlot = numel(legendEntries);
% eventColors = distinguishable_colors(nEventsToPlot, {'w', get(ph(1), 'Color')});
% phLegend = [];
% 
% for i = 1 : nEventsToPlot
%     
%     ph2 = plotvline(xevAll{i}, 'Axes', out, 'Color', eventColors(i, :));
%     phLegend = [phLegend, ph2(end)];
%     
% end
% 
% if~isempty(phLegend)
%     
%     leg = legend(out(1), phLegend, cellfun(@num2str, legendEntries, 'UniformOutput', false));
%     title(leg, 'Events');
%     uistack(out(1), 'top');
% 
% end

%%
fM.shouldAdd = shouldAddold;

end

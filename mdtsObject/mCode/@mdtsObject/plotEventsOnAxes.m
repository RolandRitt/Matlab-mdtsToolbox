function [ph ]= plotEventsOnAxes(obj, axesIn, varargin)
% <keywords>
%
% Purpose : plots event on given axes
%
% Syntax :
%
% Input Parameters :
%
% Return Parameters :
%
% Description :
%
% Author : 
%    Roland Ritt
%
% History :
% \change{1.0}{21-Apr-2019}{Original}
%
% --------------------------------------------------
% (c) 2019, Roland Ritt
% Chair of Automation, University of Leoben, Austria
% email: automation@unileoben.ac.at
% url: automation.unileoben.ac.at
% --------------------------------------------------
%
%%
%%
figH = ancestor(axesIn(1),'figure');
fM = figH.UserData;
bfM = true;
ph = [];

if ~isa(fM, 'FigureManager');
    bfM = false;
end
if bfM
    shouldAddold = fM.shouldAdd;
    fM.shouldAdd = false; %% otherwise it is too slow!!!
    
end



%%
%%%%%%%%%%%%%%%


%% Plot Events
eventKeys = keys(obj.tsEvents);
nEvents = length(eventKeys);
legendEntries = {};

xevAll = {};    
for i = 1 : nEvents
    xev = [];
    eventInfo = obj.tsEvents(eventKeys{i});
    eventTimeDatenumAllEv = obj.convert2Datenum(eventInfo.eventTime);
    for j =1:numel(eventTimeDatenumAllEv)
        eventTimeDatenum = eventTimeDatenumAllEv(j);
        if(eventTimeDatenum >= obj.time(1) && eventTimeDatenum <= obj.time(end))
            
            if(obj.timeType == 2)
                
                eventTime = datetime(datestr(eventTimeDatenum));
                
            elseif(obj.timeType == 3)
                
                eventTime = seconds(eventTimeDatenum);
                
            else
                
                eventTime = eventTimeDatenum;
                
            end
            
            xev = [xev; eventTime];
            

        end

    end
%        if isempty(xev)
%            xevAdd ={};
%            evTagAdd = {};
%        else
%            xevAdd = {xev};
%            evTagAdd = eventKeys(i);
%        end
    xevAll = [xevAll; {xev}];
    legendEntries = [legendEntries; eventKeys(i)];
        
end

nEventsToPlot = numel(legendEntries);
%eventColors = distinguishable_colors(nEventsToPlot, {'w', get(ph(1), 'Color')});
eventColors = distinguishable_colors(nEventsToPlot, {'w', [0    0.4470    0.7410]});
phLegend = [];
legEntriesPlot = {};
for i = 1 : nEventsToPlot
    if isempty(xevAll{i})
        continue;
    end
    ph = plotvline(xevAll{i}, 'Axes', axesIn, 'Color', eventColors(i, :));
    phLegend = [phLegend, ph(end)];
    legEntriesPlot = [legEntriesPlot, legendEntries(i)];
end

if~isempty(phLegend)
    
    leg = legend(axesIn(1), phLegend, cellfun(@num2str, legEntriesPlot, 'UniformOutput', false));
    title(leg, 'Events');
    uistack(axesIn(1), 'top');

end

%%%%%%%%%%%%%%%%%

for i=1:numel(ph)
         uistack(ph(i), 'top');
%         set(out(i), 'Layer', 'top');
end
%%

if bfM
    fM.shouldAdd = shouldAddold;
end
function pa = plotSegmentsOnAxes(inputObject, axesIn,segmentTag, varargin)
% <keywords
%
% Purpose :
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
% \change{1.0}{19-Oct-2018}{Original}
%
% --------------------------------------------------
% (c) 2018, Roland Ritt
% Chair of Automation, University of Leoben, Austria
% email: automation@unileoben.ac.at
% url: automation.unileoben.ac.at
% --------------------------------------------------
%
%%
figH = ancestor(axesIn(1),'figure');
fM = figH.UserData;
bfM = true;

if ~isa(fM, 'FigureManager');
    bfM = false;
end
if bfM
    shouldAddold = fM.shouldAdd;
    fM.shouldAdd = false; %% otherwise it is too slow!!!
    
end
%% Highlight Segments

% segmentsObj = inputObject.segments;
%
% tagNo = find(ismember(segmentsObj.tags, segmentTag));


paAll=[];
timeIn = inputObject.timeInFormat;
for j = 1 : numel(axesIn)
    pa = [];
    segmentsObj = inputObject.segments{j};
    if ~isempty(segmentsObj)
       
        pa = segmentsObj.plotOnAxes(axesIn(j),timeIn, varargin{:});
%         tagNo = find(ismember(segmentsObj.tags, segmentTag));
%         starts = segmentsObj.starts{tagNo};
%         durations = segmentsObj.durations{tagNo};
%         xStart = inputObject.timeInFormat(starts);
%         xEnd = inputObject.timeInFormat(starts + durations - 1);
%         XStart = [xStart';xEnd'; xEnd'; xStart'];
%         yLim = axesIn(j).YLim;
%         yMin = yLim(1);
%         yMax = yLim(2);
%         
%         hold(axesIn(j), 'on');
%         
%         pa = fill(axesIn(j), XStart, [yMin, yMin, yMax, yMax], 'r', 'FaceAlpha', 0.3, 'EdgeColor', 'r', varargin{:});
    end
    paAll = [paAll;pa];
end

if ~isempty(paAll)
    for i=1:numel(paAll)
        
        uistack(paAll(i), 'bottom');
        
%         set(axesIn(i), 'Layer', 'bottom');
    end
end
if bfM
    fM.shouldAdd = shouldAddold;
end
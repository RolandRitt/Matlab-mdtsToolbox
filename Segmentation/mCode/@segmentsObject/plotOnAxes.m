function [paAll, tHandleAll] = plotOnAxes(obj, axes_in, xTime, varargin)
% plot
%
% Purpose : plot segments on given axes
%
% Syntax : plotOnAxes(axes_in, xTime, varargin)
%
% Input Parameters :
%   axes_in : the axes on which the segments should be plotted
%   xTime : the abscissae values used for plotting the patches and the 
%       indexes are referring to
%   segmentTags : optional key-value pair;  the names (nameIDs) of the 
%       segments to be plotted on all of the axes
%   colorDismiss : optional key-value pair;  color to be not used as patch color
%   plotSegName : optional key-value pair;  boolean flag indicating if the 
%       segment name (segTag) should be annotated as text within the patch
%   plotSegDuration : optional key-value pair;  boolean flag indicating if 
%       the segment duration should be annotated as text within the patch
%   plotSegNameMinLength : optional key-value pair;  minimum number of 
%       datapoints (duration) within a segment to annotate the segment name
%       and/or duration
%   additional key-value pairs : these are forwarded to the Matlab fill command.
%
% Return Parameters :
%   paAll := the handles to the plotted segments (handles to the patches objects objects).
%   tHandleAll := handle to the plotted text annotations
%
% Description :
%   Use the plotMulti function to plot the segments of the given object
%
% Author :
%   Paul O'Leary
%   Roland Ritt
%   Thomas Grandl
%
% History :
% \change{1.0}{08-May-2018}{Original}
%
% --------------------------------------------------------
% (c) 2018 Paul O'Leary,
% Chair of Automation, University of Leoben, Leoben, Austria
% email: office@harkeroleary.org,
% url: www.harkeroleary.org
% --------------------------------------------------------

%% Parse inputs
plotSegNameDef = false;
plotSegDurationDef = false;
plotSegNameMinLength = 0;
p = inputParser();
p.KeepUnmatched=true;

addRequired(p, 'obj', @(x) isa(x, 'segmentsObject')); %check if input is mdtsObject
addRequired(p, 'axes_in', @(x)isa(x, 'matlab.graphics.axis.Axes')|| all(ishghandle(x))); %check if input is axes or handle object
addRequired(p, 'xTime', @(x) isdatetime(x)|| isreal(x)); %check if input is SymbRepObject
addParameter(p, 'segmentTags', [],@(x) isa(x, 'char')|| iscell(x)); %check if tag is a char array
addParameter(p, 'colorDismiss', [], @(x)(isreal(x)&& isequal(size(x),[1,3]))|| ischar(x));
addParameter(p, 'plotSegName', plotSegNameDef, @islogical);
addParameter(p, 'plotSegDuration', plotSegDurationDef, @islogical);
addParameter(p, 'plotSegNameMinLength', plotSegNameMinLength, @(x)isreal(x)&& isequal(size(x),[1,1]));
parse(p, obj,axes_in, xTime, varargin{:});
tmp = [fieldnames(p.Unmatched),struct2cell(p.Unmatched)];
UnmatchedArgs = reshape(tmp',[],1)';

segmentTags = p.Results.segmentTags;

if ischar(segmentTags)
    segmentTags= {segmentTags};
end

segmentsObj = obj;

if isempty(segmentTags)
    segmentTags = segmentsObj.tags;
end

plotSegName = p.Results.plotSegName;
plotSegDuration = p.Results.plotSegDuration;
plotSegNameMinLength = p.Results.plotSegNameMinLength;

nSymbols = numel(segmentTags);
if isempty(p.Results.colorDismiss)
    symbolColors = distinguishable_colors(nSymbols, {'w'});
else
    symbolColors = distinguishable_colors(nSymbols, {'w', p.Results.colorDismiss});
end

alphCol = 0.3;

nAxes = numel(axes_in);
gObjArr = axes_in;
paAll = [];
tHandleAll = [];
tHandle = [];
pa=[];
for i = 1 : nAxes
    if  isa( gObjArr(i), 'matlab.graphics.axis.Axes')
        tempAx{i} = gObjArr(i);
        bishggroup = false;
    elseif ishghandle(gObjArr(i))
        bishggroup = true;
        tempAx{i} = ancestor(gObjArr(i), {'axes'});
        
    else
        error('something went wrong in visu Ranges');
    end
    
    
    if ishold(tempAx{i})
        hold_old{i} = 'on';
    else
        hold_old{i} = 'off';
    end
    hold(tempAx{i}, 'on');
    ylim_temp = get(tempAx{i}, 'YLim');
    ymin(i) = ylim_temp(1);
    ymax(i) = ylim_temp(2);
    
end


for j = 1 : nSymbols
    segmentTag = segmentTags{j};
    
    tagNo = find(ismember(obj.tags, segmentTag));
    if isempty(tagNo)
        warningID = 'plotOnAxes:InvalidInputtagName';
        warningMessage = ['The tag ''', segmentTag, ''' is not defined'];
        warning(warningID, warningMessage);
        continue;
    end
    starts = segmentsObj.starts{tagNo};
    if isempty(starts)
        continue;
    end
    starts = [starts(:)];
    durations = obj.durations{tagNo};
    durations = [durations(:)];
    xStart = xTime(starts);
    xEnd = xTime(starts + durations - 1);
    XStart = [xStart';xEnd'; xEnd'; xStart'];
    
    
    if(plotSegName || plotSegDuration)
        bTextPrint = durations > plotSegNameMinLength;
        xText = xTime(starts(bTextPrint) + round(durations(bTextPrint) ./ 2));
        
        if (plotSegName)
            segText = segmentTag;
            segText = strrep(segText, '{', '\{');
            segText = strrep(segText, '}', '\}');
        end
        if (plotSegDuration&&plotSegName)
            segRepText = cellstr(strcat('\begin{tabular}{c} ', segText, '\\', num2str(durations(bTextPrint)), ' \end{tabular}'));
        elseif(plotSegDuration)
            segRepText = cellstr(num2str(durations(bTextPrint)));
        elseif(plotSegName)
            segRepText = segText;
        end
        
    end
    
    
    for i=1:nAxes
        tHandle = [];
        pa=[];
        pa = fill(XStart, [ymin(i), ymin(i), ymax(i), ymax(i)]',...
            symbolColors(j, :), 'FaceAlpha', alphCol, 'EdgeColor', symbolColors(j, :), 'Parent', gObjArr(i), UnmatchedArgs{:});

        if plotSegName||plotSegDuration
            yText = (ymin(i) + (ymax(i) - ymin(i)) * 0.25) * ones(size(xText));
            
            tHandle = text(tempAx{i}, xText, yText, segRepText, 'FontSize', tempAx{i}.FontSize, 'Color', 'k', 'HorizontalAlignment', 'center', 'clipping', 'on', 'Interpreter', 'latex');
            if bishggroup
                set(tHandle, 'Parent', gObjArr(i));
            end
        end
        if bishggroup
            set(pa, 'Parent', gObjArr(i));
        end
        paAll = [paAll; pa];
        tHandleAll = [tHandleAll; tHandle];
    end
    
end


for i = 1 : nAxes
    hold(tempAx{i}, hold_old{i});
end


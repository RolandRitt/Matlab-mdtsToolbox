function plotOnAxes(obj, axes_in, xTime, varargin)
% plot
%
% Purpose : plot segments of the given mdtsObject
%
% Syntax : plotSegments(inputObject, varargin)
%
% Input Parameters :
%   inputObject : mdtsObject (with multiple channels) to be plotted
%
%   segmentTag : tag of the required segment as string (character array)
%
% Return Parameters :
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

p = inputParser();
p.KeepUnmatched=true;

addRequired(p, 'obj', @(x) isa(x, 'segmentsObject')); %check if input is mdtsObject
addRequired(p, 'axes_in', @(x)isa(x, 'matlab.graphics.axis.Axes')|| all(ishghandle(x))); %check if input is axes or handle object
addRequired(p, 'xTime', @(x) isdatetime(x)|| isreal(x)); %check if input is SymbRepObject
addParameter(p, 'Size', [8.8,11.7], @(x)isnumeric(x)&&isvector(x)); %higth and width
addParameter(p, 'FontSize', 10, @isnumeric);
addParameter(p, 'segmentTags', [],@(x) isa(x, 'char')|| iscell(x)); %check if tag is a char array
addParameter(p, 'colorDismiss', [], @(x)(isreal(x)&& isequal(size(x),[1,3]))|| ischar(x));
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


nSymbols = numel(segmentTags);
if isempty(p.Results.colorDismiss)
    symbolColors = distinguishable_colors(nSymbols, {'w'});
else
    symbolColors = distinguishable_colors(nSymbols, {'w', p.Results.colorDismiss});
end

alphCol = 0.3;

nAxes = numel(axes_in);
gObjArr = axes_in;

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



%         tagNo = find(ismember(segmentsObj.tags, segmentTag));


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
    durations = obj.durations{tagNo};
    xStart = xTime(starts);
    xEnd = xTime(starts + durations - 1);
    XStart = [xStart';xEnd'; xEnd'; xStart'];  
%     if(plotSymbolName || plotSymbolDuration)
%         bTextPrint = durations > plotSymbolNameMinLength;
%         xSymbol = xTime(startInds(bTextPrint) + round(durations(bTextPrint) ./ 2));
%         
%         if (plotSymbolName)
%                 symbolText = allSymbols{j};
%                 symbolText = strrep(symbolText, '{', '\{');
%                 symbolText = strrep(symbolText, '}', '\}');
%         end
%         if (plotSymbolDuration&&plotSymbolName)
%             symbRepText = cellstr(strcat('\begin{tabular}{c} ', symbolText, '\\', num2str(durations(bTextPrint)), ' \end{tabular}'));
%         elseif(plotSymbolDuration)
%             symbRepText = cellstr(num2str(durations(bTextPrint)));
%         elseif(plotSymbolName)
%             symbRepText = symbolText;
%         end
% 
%     end
    
    
    for i=1:nAxes
        pa = fill(XStart, [ymin(i), ymin(i), ymax(i), ymax(i)]',...
            symbolColors(j, :), 'FaceAlpha', alphCol, 'EdgeColor', symbolColors(j, :), 'Parent', gObjArr(i), UnmatchedArgs{:});
%         
%         if plotSymbolName||plotSymbolDuration
%             yText = (ymin(i) + (ymax(i) - ymin(i)) * 0.25) * ones(size(xSymbol));
%             
%             tHandle = text(tempAx{i}, xSymbol, yText, symbRepText, 'Color', 'k', 'HorizontalAlignment', 'center', 'clipping', 'on', 'Interpreter', 'latex');
%             if bishggroup
%                 set(tHandle, 'Parent', gObjArr(i));
%             end
%         end
        
        if bishggroup
                set(pa, 'Parent', gObjArr(i));  
        end
        
    end
    
end


for i = 1 : nAxes
    hold(tempAx{i}, hold_old{i});
end


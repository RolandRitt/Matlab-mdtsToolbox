function [pa, tHandleAll] = markRangeOnAxes_givenIndexStatic(xVals, axes_in, startInds,stopInds, colorSpec, varargin)
% plot
%
% Purpose : marks a given range as path on the given axes
%
% Syntax : markRangeOnAxes_givenIndex(obj, axes_in, startInds,stopInds, varargin)
%
% Input Parameters :
%   obj : mdtsObject (with multiple channels), this is used to extract the
%       x values to be used for plotting
%   axes_in : the axes which should be marked
%   startInds: the start inds of the range to be marked
%   stopInds: the stop inds of the range to be marked
%   colorSpec: colorSpec of the patches
%   textToShow: (optional key-value pair) a char or cell-array with text to
%   be shown within the patch
%   varargin := (other key-value pairs) will be forwarded to the fill command
%   
% Return Parameters :
%   pa:= the handles to the patches objects
%   tHandleAll := the handles to all text objects
%
% Description :
%   given the start and stop values, the y-limits are automatically fetched
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

addRequired(p, 'xVals',  @(x) isnumeric(x)|| isduration(x) || isdatetime(x)); %check if input is mdtsObject
addRequired(p, 'axes_in', @(x)isa(x, 'matlab.graphics.axis.Axes')|| all(ishghandle(x))); %check if input is axes or handle object
addRequired(p, 'startInds', @isnumeric); %check if input is numeric
addRequired(p, 'stopInds', @isnumeric); %check if input is numeric
addRequired(p, 'colorSpec'); %check if input is numeric
addParameter(p, 'textToShow', [], @(x)ischar(x)||iscellstr(x));
% addParameter(p, 'plotSegName', plotSegNameDef, @islogical);
% addParameter(p, 'plotSegDuration', plotSegDurationDef, @islogical);
% addParameter(p, 'plotSegNameMinLength', plotSegNameMinLength, @(x)isreal(x)&& isequal(size(x),[1,1]));
parse(p, xVals,axes_in, startInds, stopInds, colorSpec,varargin{:});
tmp = [fieldnames(p.Unmatched),struct2cell(p.Unmatched)];
UnmatchedArgs = reshape(tmp',[],1)';

%%check size of textToShow

bShowText = false;
textToShow = p.Results.textToShow;

if ~isempty(textToShow)
    bShowText = true;
end

xTime = xVals;
nMarkers = numel(startInds);

if bShowText
    if ischar(textToShow)
        textToShowTemp = cell(size(startInds));
        textToShowTemp(1:nMarkers) = {textToShow};
        textToShow = textToShowTemp;
    else
        if ~isequal(size(startInds), size(textToShow))
            errID = 'mdtsObject:markRangeOnAxes_givenIndes:InvalidInputSize';
            errMsg = 'The given text to show must be either a char or cellstr of the same size as startInds';
            error(errID, errMsg);
        end
    end
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



%         tagNo = find(ismember(segmentsObj.tags, segmentTag));


% for j = 1 : nMarkers
    xStart = xTime(startInds);
    xEnd = xTime(stopInds);
    XStart = [xStart';xEnd'; xEnd'; xStart'];
    
    
%     if(plotSegName || plotSegDuration)
%         bTextPrint = durations > plotSegNameMinLength;
%         xText = xTime(starts(bTextPrint) + round(durations(bTextPrint) ./ 2));
%         
%         if (plotSegName)
%             segText = segmentTag;
%             segText = strrep(segText, '{', '\{');
%             segText = strrep(segText, '}', '\}');
%         end
%         if (plotSegDuration&&plotSegName)
%             segRepText = cellstr(strcat('\begin{tabular}{c} ', segText, '\\', num2str(durations(bTextPrint)), ' \end{tabular}'));
%         elseif(plotSegDuration)
%             segRepText = cellstr(num2str(durations(bTextPrint)));
%         elseif(plotSegName)
%             segRepText = segText;
%         end
%         
%     end
    
    
    for i=1:nAxes
        tHandle = [];
        pa=[];
        pa = fill(XStart, [ymin(i), ymin(i), ymax(i), ymax(i)]',colorSpec,...
            'FaceAlpha', alphCol, 'EdgeColor', colorSpec, 'Parent', gObjArr(i), UnmatchedArgs{:});

        if bShowText
            xText =xStart+  (xEnd - xStart)./2;
            yText = (ymin(i) + (ymax(i) - ymin(i)) * 0.25) * ones(size(xText));
            
            tHandle = text(tempAx{i}, xText, yText, textToShow, 'FontSize', tempAx{i}.FontSize, 'Color', 'k', 'HorizontalAlignment', 'center', 'clipping', 'on', 'Interpreter', 'latex');
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
    
% end
for i=1:numel(paAll)
         uistack(paAll(i), 'bottom');
%         set(out(i), 'Layer', 'top');
end

for i = 1 : nAxes
    hold(tempAx{i}, hold_old{i});
end
function [out, fM, ph] = plotSegments(inputObject, segmentTag, varargin)
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
addRequired(p, 'inputObject', @(x) isa(x, 'mdtsObject')); %check if input is mdtsObject
addRequired(p, 'segmentTag', @(x) isa(x, 'char')); %check if tag is a char array
addParameter(p, 'Size', [8.8,11.7], @(x)isnumeric(x)&&isvector(x)); %higth and width
addParameter(p, 'FontSize', 10, @isnumeric);
parse(p, inputObject, segmentTag, varargin{:});
tmp = [fieldnames(p.Unmatched),struct2cell(p.Unmatched)];
UnmatchedArgs = reshape(tmp',[],1)';

segmentTag = p.Results.segmentTag;

xTime = inputObject.timeInFormat;

%% Plot data

figH = figureGen(p.Results.Size(1), p.Results.Size(2), p.Results.FontSize);

fM = FigureManager;

[out, ph] = plotMulti(xTime, inputObject.data, 'time', inputObject.tags,'yLabelsLatex',false, UnmatchedArgs{:});

shouldAddold = fM.shouldAdd;
fM.shouldAdd = false; %% otherwise it is too slow!!!
title(out(1), inputObject.name, 'Interpreter', 'none');

%% Highlight Segments

segmentsObj = inputObject.segments;

tagNo = find(ismember(segmentsObj.tags, segmentTag));

starts = segmentsObj.starts{tagNo};
durations = segmentsObj.durations{tagNo};

for i = 1 : numel(starts)
    
    xStart = inputObject.timeInFormat(starts(i));
    xEnd = inputObject.timeInFormat(starts(i) + durations(i) - 1);
    
    for j = 1 : numel(out)
        
        yLim = out(j).YLim;
        yMin = yLim(1);
        yMax = yLim(2);
        
        hold(out(j), 'on');
        
        pa = fill(out(j), [xStart, xEnd, xEnd, xStart], [yMin, yMin, yMax, yMax], 'r', 'FaceAlpha', 0.5, 'EdgeColor', 'r');   
    
    end

end
%%
 for i=1:numel(ph)
         uistack(ph(i), 'top');
         set(out(i), 'Layer', 'top');
 end

fM.shouldAdd = shouldAddold;

end


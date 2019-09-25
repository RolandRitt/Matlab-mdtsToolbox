function [axesOut, fM, ph] = plotSegments(inputObject, segmentTag, varargin)
%
% Purpose : plot segments of the given mdtsObject, a new figure will be
% generated which shows the time series as line plots and the according
% segments as semi-transparent patches; this will maybe deprecated in
% future
%
% Syntax : plotSegments(inputObject, segmentTag, varargin)
%
% Input Parameters :
%   inputObject : mdtsObject (with multiple channels) to be plotted
%
%   segmentTag := tag of the required segment as string (character array)
%
%   Size (optional key-value pair) := the size (height, width) of the plot 
%       im centimeters. Default Value: [8.8cm, 11.7cm] 
%
%   FontSize (optional key-value pair) :=   the font Size in pt used for
%       figure. Default value: 10pt
%
% Return Parameters :
%       axesH := the handles to the axes
%       fM :=   the figureManager used on the figure to handle large data sets (figureManager-toolbox)
%       ph :=  the handles to the plotted segments (patches objects).

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
warning('the function plotSegment of the mdtsObject will be deprecated in future. please use the plotting function of the SegmentsObject');
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

[axesOut, ph] = plotMulti(xTime, inputObject.data, 'time', inputObject.tags,'yLabelsLatex',false, UnmatchedArgs{:});
title(axesOut(1), inputObject.name, 'Interpreter', 'none');


pa = plotSegmentsOnAxes(inputObject, axesOut, segmentTag);

%%
%%
for i=1:numel(ph)
    uistack(ph(i), 'top');
    set(axesOut(i), 'Layer', 'top');
end



end


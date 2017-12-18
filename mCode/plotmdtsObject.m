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

p = inputParser();
p.KeepUnmatched=true;
addRequired(p, 'inputObject', @(x) isa(x, 'mdtsObject')); %check if input is mdtsObject
addParameter(p, 'Range', [], @(x)isvector(x) && (isequal(size(x), [2,1])|| isequal(size(x), [1,2]))); %index range 2x1 array with start und end index
addParameter(p, 'IndsSelected', [], @isnumeric); %
addParameter(p, 'TagsSelected', [], @(x) isnumeric(x) || iscellstr(x) || ischar(x));
addParameter(p, 'Size', [8.8,11.7], @(x)isnumeric(x)&&isvector(x)); %higth and width
addParameter(p, 'FontSize', 10, @isnumeric);
addParameter(p, 'bUseDatetime', true, @islogical);
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

figH = figureGen(p.Results.Size(1), p.Results.Size(2), p.Results.FontSize);

fM = FigureManager;

if bDatetime
    
%     if ~inputObject.bXdatetimeCalculated
%         
%         inputObject.recalcXDatetime();
%         
%     end
    
    [out, ph] = plotMulti(inputObject.timeDateTime(Range), inputObject.data(Range,inds), 'time', inputObject.tags(inds), UnmatchedArgs{:});
    
else
    
    [out, ph] = plotMulti(inputObject.timeDateTime(Range),inputObject.data(Range,inds), 'time', inputObject.tags(inds), UnmatchedArgs{:});
    
end

shouldAddold = fM.shouldAdd;
fM.shouldAdd = false; %% otherwise it is too slow!!!
title(out(1), inputObject.name);
fM.shouldAdd = shouldAddold;

end


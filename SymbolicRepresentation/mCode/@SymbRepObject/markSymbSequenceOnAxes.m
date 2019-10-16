function [pa, tHandleAll] = markSymbSequenceOnAxes(obj,xVals, axes_in, SymbSequence, colorSpec, varargin)
% <keywords>
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
% \change{1.0}{07-Aug-2019}{Original}
%
% --------------------------------------------------
% (c) 2019, Roland Ritt
% Chair of Automation, University of Leoben, Austria
% email: automation@unileoben.ac.at
% url: automation.unileoben.ac.at
% --------------------------------------------------
%
%%
p = inputParser();
p.KeepUnmatched=true;
addRequired(p, 'obj', @(x) isa(x, 'SymbRepObject')); %check if input is mdtsObject
addRequired(p, 'xVals', @(x) isnumeric(x)|| isduration(x) || isdatetime(x));
addRequired(p, 'axes_in', @(x)isa(x, 'matlab.graphics.axis.Axes')|| all(ishghandle(x))); %check if input is axes or handle object
addRequired(p, 'SymbSequence', @(x)ischar(x)||iscellstr(x)); %check if input is numeric
addRequired(p, 'colorSpec'); %check if input is numeric
addParameter(p, 'bShowText', true, @islogical);
addParameter(p, 'bShowCompressed', false, @islogical);
% addParameter(p, 'plotSegName', plotSegNameDef, @islogical);
% addParameter(p, 'plotSegDuration', plotSegDurationDef, @islogical);
% addParameter(p, 'plotSegNameMinLength', plotSegNameMinLength, @(x)isreal(x)&& isequal(size(x),[1,1]));
parse(p, obj, xVals, axes_in, SymbSequence,colorSpec,varargin{:});
tmp = [fieldnames(p.Unmatched),struct2cell(p.Unmatched)];
UnmatchedArgs = reshape(tmp',[],1)';


if p.Results.bShowCompressed
    
   
else
    
    [~, ~, compressedStartInds, compressedStopInds] = obj.findSequence(SymbSequence);
    
    startInds = obj.startInds(compressedStartInds);
    stopInds = obj.stopInds(compressedStopInds);
    textToShow = cell(size(startInds));
    textToShow(1:numel(startInds)) = join(SymbSequence, '');
    
    mdtsObject.markRangeOnAxes_givenIndexStatic(xVals, axes_in, startInds, stopInds,p.Results.colorSpec, 'textToShow',textToShow );
end

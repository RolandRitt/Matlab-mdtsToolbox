function [startInds, durations, compressedStartInds, compressedStopInds] = findSequence(obj, symbSequence)
% <keywords>
%
% Purpose : Find start indices of a given
%   sequence
%
% Syntax :
%
% Input Parameters :
%   symbSequence : Sequence (cell array) of symbols, which is to be
%       found within the compressed symbolic time series. Must be
%       given as one dimensional cell an arbitrary number of elements
% Return Parameters :
%   startInds : index in the original uncompressed time series where the sequences
%       start;
%   durations : the number of samples in the original uncompressed time series the
%       sequence lasts;
%   compressedStartInds : the indices where the symbSequence starts in the
%       compressed symbolic representation
%   compressedEndInds : the indices  where the symbSequence stops in the
%       compressed symbolic representation
% Description :
%
% Author :
%    Roland Ritt
%
% History :
% \change{1.0}{25-Jul-2019}{Original}
%
% --------------------------------------------------
% (c) 2019, Roland Ritt
% Chair of Automation, University of Leoben, Austria
% email: automation@unileoben.ac.at
% url: automation.unileoben.ac.at
% --------------------------------------------------
%
%%
if(isa(symbSequence, 'cell') && size(symbSequence, 2) == 1)
    
    symbSequence = symbSequence';
    
elseif~(isa(symbSequence, 'cell') && size(symbSequence, 1) == 1)
    
    errID = 'mergeSequence:InvalidInput';
    errMsg = 'The input symbSeqence must be a 1 x n cell array of strings, contining the symbols which are to be merged in a sequence!';
    error(errID, errMsg);
    
end
startInds = [];
durations = [];
compressedStartInds = [];
compressedStopInds = [];

nSymbSequence = numel(symbSequence);

indArray = ones(numel(obj.symbols) + nSymbSequence - 1, 1);
symbols = obj.symbols;
try
    for i = 1 : nSymbSequence
        
        indArray = indArray .* [false(nSymbSequence - i, 1); symbols == symbSequence{i}; false(i - 1, 1)];
        
    end
catch
    error('what is going on?');
    return
end
symbInd = find(indArray(nSymbSequence:end));
startInds = obj.getStartInd(symbInd);
durations = nan(length(symbInd),1);
for i=1:length(symbInd)
    durations(i) = sum(obj.durations(symbInd(i):(symbInd(i) +nSymbSequence-1)));
end
compressedStartInds = symbInd;
compressedStopInds = compressedStartInds + nSymbSequence -1;


end

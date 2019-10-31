function obj = mergeSequence(obj, symbSequence, varargin)
% Purpose : Merges all occurences of a given sequence of symbols within the
%   SymbRepObject.
%
% Syntax :
%   SymbRepObject = SymbRepObject.mergeSequence(symbSequence, varargin)
%
% Input Parameters :
%   symbSequence : Sequence which is supposed to be merged to
%       one new symbol (categorical). Must be given as one dimensional cell
%       array of strings with an arbitrary number of elements
%
%   bAllowOverlapping : (optional key-value pair, default: false) A boolean
%       flag indicating if overlapping sequences are seen as one occurence.
%       Given a symbolic time series 'ababababa' with durations = [1,1,1,1,1,1,1,1,1]
%       and repetitions = [1,1,1,1,1,1,1,1,1] and merge the sequence 
%       'aba'--> with the new name 'c': if the flag is set to false, the 
%       result would be 'cbcba' with durations = [3,1,3,1,1] and 
%       repetitions = [1,1,1,1,1]. If the flag is set to true it would 
%       result in the symbolic series 'c' with durations = [9], repetitions = [4].
%
%   newSymbol : (optional key-value pair, default: 'concatenation of symbSequence')
%       A string (char) which should replace the found symbSequence
%
%   bCompress : (optional key-value pair, default: true) A boolean flag,
%       indicating if SymbObj.compressSymbols should be called after merging
%       the sequences. Given a symbolic sequence 'ababab' and the sequence
%       to be merged 'ab'-->'c': if bCompress=true the resulting symbolic
%       sequence would be 'c'. If bCompress=false the resulting symbolic
%       sequence would be 'ccc'.
% Return Parameters :
%   SymbRepObject : Instance of SymbRepObject with merged symbolic
%       representation
p = inputParser;
addParameter(p,'bAllowOverlapping',false,@islogical);
addParameter(p,'newSymbol',[],@ischar);
addParameter(p,'bCompress',true,@islogical);

% overwrite p.Results.startTime, p.Results.endTime with variable arguments
% if given
parse(p,varargin{:});

if (~p.Results.bCompress) &&  p.Results.bAllowOverlapping
    errID = 'mergeSymbols:bCompress';
    errMsg = 'bCompress = false can only be used if bAllowPverlapping == false!';
    error(errID, errMsg);
end

[startInds, durations, allSequenceStarts, compressedStopInds] = obj.findSequence(symbSequence);

% automatically name
if p.Results.newSymbol
    newSequence = {p.Results.newSymbol};
else
    
    addedBrackets = cellfun(@(x) ['{', x, '}'], symbSequence, 'UniformOutput', false);
    removedBrackets = cellfun(@(x) strrep(x, '{[', '['), addedBrackets, 'UniformOutput', false);
    removedBrackets = cellfun(@(x) strrep(x, '{(', '('), removedBrackets, 'UniformOutput', false);
    removedBrackets = cellfun(@(x) strrep(x, ']}', ']'), removedBrackets, 'UniformOutput', false);
    removedBrackets = cellfun(@(x) strrep(x, ')}', ')'), removedBrackets, 'UniformOutput', false);
    modifiedSequence = removedBrackets;
    
    joinedSequence = join(modifiedSequence, '');
    newSequence = {['[', joinedSequence{1}, ']']};
end
%% do not allow overlapping sequences for example find aba in ababababa would result in [aba]b[aba]ba --> the method is greedy from the beginning
nSymbSequence = length(symbSequence);
if ~p.Results.bAllowOverlapping
    overlapping = (diff(allSequenceStarts))<nSymbSequence;
    
    allSequenceStarts = allSequenceStarts(~[0; overlapping]);
end

%%
tempRemoving = {'TempRemoving'};
tempRemovingCat = categorical(tempRemoving);
obj.symbols = addcats(obj.symbols, [newSequence, tempRemoving]);
newSequenceCat = categorical(newSequence);


modSequenceStarts = [allSequenceStarts; inf];

for i = 1 : numel(allSequenceStarts)
    
    symbRange = min(nSymbSequence - 1, modSequenceStarts(i + 1) - modSequenceStarts(i) - 1);
    
    obj.symbols(allSequenceStarts(i)) = newSequenceCat;
    obj.symbols(allSequenceStarts(i) + 1 : allSequenceStarts(i) + symbRange) = tempRemovingCat;
    
    obj.durations(allSequenceStarts(i)) = sum(obj.durations(allSequenceStarts(i) : allSequenceStarts(i) + symbRange));
    obj.durations(allSequenceStarts(i) + 1 : allSequenceStarts(i) + symbRange) = -1;
    obj.repetitions(allSequenceStarts(i)) = 1;
    obj.repetitions(allSequenceStarts(i)+1:compressedStopInds(i)) = 0;
end
% delete empty fields
obj.symbols = obj.symbols(~(obj.symbols == tempRemoving));
obj.symbols = removecats(obj.symbols, tempRemoving);
removeInds = ~(obj.durations == -1);
obj.durations = obj.durations(removeInds);
obj.repetitions=obj.repetitions(removeInds);
% delete not used cats
cats2remove = ~ismember(symbSequence, obj.symbols);
obj.symbols = removecats(obj.symbols, symbSequence(cats2remove));

if p.Results.bCompress
    obj = obj.compressSymbols(newSequence);
end
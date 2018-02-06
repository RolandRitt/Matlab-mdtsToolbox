function mclaSymbRepObject = applyMCLA(symbRepObjectsList)
% object oriented, symbolic representation
%
% Purpose : merge symbolic representations of different channel to one
% representation
%
% Syntax : 
%   mclaSymbRepObject = applyMCLA(symbRepObjectsList)
%
% Input Parameters :
%   symbRepObjectsList : List of all SymbRepObjects, which are supposed to
%   be merged, as cell array
%
% Return Parameters :
%   mclaSymbRepObject : SymbRepObject with merged symbolic representation
%
% Description :
%   Combines the symbols at every time stamp of an arbitrary number of
%   channels to one symbolic representation
%
% Author : 
%   Paul O'Leary
%   Roland Ritt
%   Thomas Grandl
%
% History :
% \change{1.0}{16-Jan-2018}{Original}
%
% --------------------------------------------------
% (c) 2018, Paul O'Leary
% Chair of Automation, University of Leoben, Austria
% email: automation@unileoben.ac.at
% url: automation.unileoben.ac.at
% --------------------------------------------------
%
%% Validate Inputs

nSymbRepObjects = numel(symbRepObjectsList);
stdLength = numel(symbRepObjectsList{1}.symbRepVec);

for i = 2 : nSymbRepObjects
    
    if~(numel(symbRepObjectsList{i}.symbRepVec) == stdLength)
        
        errID = 'applyMCLA:UnequalChannelLength';
        errMsg = 'The length of all combined channels must be the same!';
        error(errID, errMsg);
        
    end
    
end

%% Execute computations

allCategories = {};

for i = 1 : nSymbRepObjects
    
    symbolsInObject = categories(symbRepObjectsList{i}.symbols);
    addedBrackets = cellfun(@(x) ['{', x, '}'], symbolsInObject, 'UniformOutput', false);
    removedBrackets = cellfun(@(x) strrep(x, '{[', '['), addedBrackets, 'UniformOutput', false);
    removedBrackets = cellfun(@(x) strrep(x, '{(', '('), removedBrackets, 'UniformOutput', false);
    removedBrackets = cellfun(@(x) strrep(x, ']}', ']'), removedBrackets, 'UniformOutput', false);
    removedBrackets = cellfun(@(x) strrep(x, ')}', ')'), removedBrackets, 'UniformOutput', false);
    
    allCategories = [allCategories, {removedBrackets}];

end

allCombinationsMat = allcomb(allCategories{:});
nCombinations = size(allCombinationsMat, 1);

allCombinations = cell(nCombinations, 1);

for i = 1 : nCombinations
    
    tempText = join(allCombinationsMat(i, :), '');
    allCombinations{i} = ['(', tempText{1}, ')'];
    
end

% channelLength = numel(symbRepObjectsList{1}.symbRepVec);
% allSymbols = cell(channelLength, nSymbRepObjects);
% 
% for i = 1 : nSymbRepObjects
%     
%     tempSymbols = cellstr(symbRepObjectsList{i}.symbRepVec);
%     addedBrackets = cellfun(@(x) ['{', x, '}'], tempSymbols, 'UniformOutput', false);
%     removedBrackets = cellfun(@(x) strrep(x, '{[', '['), addedBrackets, 'UniformOutput', false);
%     removedBrackets = cellfun(@(x) strrep(x, '{(', '('), removedBrackets, 'UniformOutput', false);
%     removedBrackets = cellfun(@(x) strrep(x, ']}', ']'), removedBrackets, 'UniformOutput', false);
%     removedBrackets = cellfun(@(x) strrep(x, ')}', ')'), removedBrackets, 'UniformOutput', false);
%     allSymbols(:, i) = removedBrackets;
%     
% end
% 
% mergedSymbols = cell(channelLength, 1);
% 
% for i = 1 : channelLength
%     
%     tempSymbol = join(allSymbols(i, :), '');
%     mergedSymbols{i} = ['(', tempSymbol{1}, ')'];
%     
% end
% 
% numRepr = int32(categorical(mergedSymbols));
% symbolChange = [true; diff(numRepr) ~= 0];
% mclaSymbols = categorical(mergedSymbols(symbolChange), allCombinations);
% mclaDurations = diff(find([symbolChange; 1]));
% 
% mclaSymbRepObject = SymbRepObject(mclaDurations, mclaSymbols);

initialSymbolLength = sum(cell2mat(cellfun(@(x) numel(x.symbols), symbRepObjectsList, 'UniformOutput', false)));
maxNSymbols = max(cell2mat(cellfun(@(x) numel(x.symbols), symbRepObjectsList, 'UniformOutput', false)));

allSymbols = cell(maxNSymbols + 1, nSymbRepObjects);
allDurations = Inf(maxNSymbols + 1, nSymbRepObjects);

for i = 1 : nSymbRepObjects
       
    tempSymbols = cellstr(symbRepObjectsList{i}.symbols);
    addedBrackets2 = cellfun(@(x) ['{', x, '}'], tempSymbols, 'UniformOutput', false);
    removedBrackets2 = cellfun(@(x) strrep(x, '{[', '['), addedBrackets2, 'UniformOutput', false);
    removedBrackets2 = cellfun(@(x) strrep(x, '{(', '('), removedBrackets2, 'UniformOutput', false);
    removedBrackets2 = cellfun(@(x) strrep(x, ']}', ']'), removedBrackets2, 'UniformOutput', false);
    removedBrackets2 = cellfun(@(x) strrep(x, ')}', ')'), removedBrackets2, 'UniformOutput', false);
    allSymbols(1 : numel(removedBrackets2), i) = removedBrackets2;
    
    allDurations(1 : numel(symbRepObjectsList{i}.durations), i) = symbRepObjectsList{i}.durations;
    
end

initialSymbolCellArray = cell(initialSymbolLength, 1);
initialDurationsArray = zeros(initialSymbolLength, 1);

ind = ones(1, nSymbRepObjects);
matrixSize = size(allDurations);

atEnd = false;
iter = 1;

while ~atEnd
    
    tempInds = sub2ind(matrixSize, ind, 1 : nSymbRepObjects);
    
    stepSize = min(allDurations(tempInds));
        
    if(stepSize == Inf)
        
        atEnd = true;
        
    else       
        
        %tempSymbol = strjoin(allSymbols(tempInds), '');
        %initialSymbolCellArray{iter} = ['(', tempSymbol, ')'];        
        tempSymbol = join([{'('}, allSymbols(tempInds), {')'}], '');
        initialSymbolCellArray(iter) = tempSymbol;   
        
        steppingIndex = find(allDurations(tempInds) == stepSize);
        
        initialDurationsArray(iter) = stepSize;
        
        allDurations(tempInds) = allDurations(tempInds) - stepSize;        
                
        ind(steppingIndex) = ind(steppingIndex) + 1;
        
        iter = iter + 1;
        
    end
    
end

mclaSymbols = categorical(initialSymbolCellArray(~cellfun(@isempty, initialSymbolCellArray)), allCombinations);
mclaDurations = initialDurationsArray(initialDurationsArray ~= 0);

mclaSymbRepObject = SymbRepObject(mclaDurations, mclaSymbols);

end


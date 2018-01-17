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
    
    allCategories = [allCategories, {categories(symbRepObjectsList{i}.symbols)}];
    
end

allCombinationsMat = allcomb(allCategories{:});
nCombinations = size(allCombinationsMat, 1);

allCombinations = cell(nCombinations, 1);

for i = 1 : nCombinations
    
    allCombinations{i} = join(allCombinationsMat(i, :), '');
    
end

channelLength = numel(symbRepObjectsList{1}.symbRepVec);
allSymbols = cell(channelLength, nSymbRepObjects);

for i = 1 : nSymbRepObjects
    
    allSymbols(:, i) = cellstr(symbRepObjectsList{i}.symbRepVec);
    
end

mergedSymbols = cell(channelLength, 1);

for i = 1 : channelLength
    
    tempSymbol = join(allSymbols(i, :), '');
    mergedSymbols{i} = tempSymbol{1};
    
end

numRepr = int32(categorical(mergedSymbols));
symbolChange = [true; diff(numRepr) ~= 0];
mclaSymbols = mergedSymbols(symbolChange);
mclaDurations = diff(find([symbolChange; 1]));

mclaSymbRepObject = SymbRepObject(mclaDurations, mclaSymbols);

end


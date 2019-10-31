function obj = compressSymbols(obj, listOfSymbolsToCheck)
% SymbRepObject
%
% Purpose : This methods of the SymbRepObject finds run-length of the same symbol
% and replaced it with a single symbol. Additionally, the
% durations and repetitions are updated by summing up.
%
% Syntax :
%   SymbRepObject = SymbRepObject.compressSymbols
%   SymbRepObject = SymbRepObject.compressSymbols(listOfSymbolsToCheck);
% Input Parameters :
%   listOfSymbolsToCheck : A cell array of symbols to be checkt
%   and updated. By default all different symbols in the
%   symbolic time series are checked.
% Return Parameters :
%   SymbRepObject : a version of the updated SymbRepObject
% Description :
%
% Author :
%    Roland Ritt
%
% History :
% \change{1.0}{24-Jul-2019}{Original}
%
% --------------------------------------------------
% (c) 2019, Roland Ritt
% Chair of Automation, University of Leoben, Austria
% email: automation@unileoben.ac.at
% url: automation.unileoben.ac.at
% --------------------------------------------------
%
%%



% Syntax :

%
% Input Parameters :

%
% Return Parameters :
if nargin>1
    if ischar(listOfSymbolsToCheck)
        listOfSymbolsToCheck = {listOfSymbolsToCheck};
    end
    if size(listOfSymbolsToCheck,1)~=1
        if size(listOfSymbolsToCheck,2)~=1
            
            errID = 'SymbRepObject:compressSymbols:listOfSymbolsToCheck:wrongSize';
            errMsg = 'Input listOfSymbolsToCheck must be either be of dimension 1xn or nx1';
            error(errID, errMsg);
        end
        listOfSymbolsToCheck = listOfSymbolsToCheck';
    end
    
    if ~iscellstr(listOfSymbolsToCheck)
        errID = 'SymbRepObject:compressSymbols:listOfSymbolsToCheck:wrongType';
        errMsg = 'Input listOfSymbolsToCheck must be a of type cellstr';
        error(errID, errMsg);
    end
else
    listOfSymbolsToCheck = categories(obj.symbols)'; % take by default every value
end

% sequenctial version - low memory - slower processing
for i = numel(obj.symbols) : -1 : 2
    if sum(ismember(obj.symbols(i), listOfSymbolsToCheck))
        if(isequal(obj.symbols(i), obj.symbols(i - 1)))
            obj.repetitions(i-1) = obj.repetitions(i) + obj.repetitions(i - 1);
            obj.durations(i - 1) = obj.durations(i) + obj.durations(i - 1);
            
            obj.durations(i) = [];
            obj.symbols(i) = [];
            obj.repetitions(i) = [];
            
        end
    else
        continue;
    end  
end

end
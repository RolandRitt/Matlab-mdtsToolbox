classdef SymbRepObject 
    %
    % Description : Represents one channel of an mdtsObject as symbols
    %
    % Author :
    %    Paul O'Leary
    %    Roland Ritt
    %    Thomas Grandl
    %
    % History :
    % \change{1.0}{09-Jan-2018}{Original}
    %
    % --------------------------------------------------
    % (c) 2018, Paul O'Leary
    % Chair of Automation, University of Leoben, Austria
    % email: automation@unileoben.ac.at
    % url: automation.unileoben.ac.at
    % --------------------------------------------------
    %
    
    properties 
        durations
        symbols
        name
    end
    
    properties(Dependent)
        symbolDurations
        startInds
        stopInds
    end
    methods
        
        function obj = SymbRepObject(durations, symbols)
            
            if~iscategorical(symbols)
                
                errID = 'SymbRepObject:SymbolsNotCategorical';
                errMsg = 'The symbols input must be of type categorical!';
                error(errID, errMsg);
                
            elseif~isa(durations, 'numeric')
                
                errID = 'SymbRepObject:DurationsNotNumeric';
                errMsg = 'The durations as input must be numeric!';
                error(errID, errMsg);
                
            elseif~(numel(symbols) == numel(durations))
                
                errID = 'SymbRepObject:InvalidInputLength';
                errMsg = 'The length of both inputs (symbols and durations) must be of the same length!';
                error(errID, errMsg);
                
            end
            
            if(isprotected(symbols) && ~isordinal(symbols))
                
                obj.symbols = symbols;
                
            else
                
                obj.symbols = categorical(symbols, 'Protected', true, 'Ordinal', false);
                
            end
            
            obj.durations = durations;
            obj.name = [];
        end
        
        function obj = setName(obj, name)
            if ischar(name)||isstring(name)
                obj.name = name;
            else
                error('InputChk:setName:notaString', 'input must be a String');
            end

        end
        function symbolDurations = get.symbolDurations(obj)
            allCat = categories(obj.symbols);
            symbolDurations = NaN(size(allCat));
            for i=1:length(allCat)
                symbolDurations(i) = sum(obj.durations(obj.symbols==allCat{i}));
            end
        end
        
        
        
        function symbRepVec = symbRepVec(obj)
            % Purpose : return complete symbol vector. NOTE: If symbRepVec
            % is implemented as dependent variable, it will be recalculated
            % after every loop execution in every function!
            %
            % Syntax : symbRepVec = SymbRepObject.symbRepVec
            %
            % Input Parameters :
            %
            % Return Parameters :
            %   symbRepVec : symbolic representation of a channel in full
            %   length (no compression)
            
            symbRepVec = repelem(obj.symbols, obj.durations);
            
            if(size(symbRepVec, 2) > 1)
                
                symbRepVec = symbRepVec';
                
            end
            
        end
        
        function [startInds, durations] = findSymbol(obj, symbol)
            % Purpose : find indices of symbol
            %
            % Syntax : [startInd durations] = SymbRepObject.findSymbol(symbol)
            %
            % Input Parameters :
            %   symbol : required symbol as character array
            %
            % Return Parameters :
            %   startInd : all start indices of occurrances of the symbol
            %   durations : all durations of occurrances of the symbol
            
            if ~ischar(symbol)
                
                errID = 'findSymbol:InputNoString';
                errMsg = 'The input symbol must be given as character array!';
                error(errID, errMsg);
                
            end
            
            symbInd = findSymbolVec(obj, symbol);
            
            symbolChange = [symbInd(1); diff(symbInd) == 1];
            startInds = find(symbolChange);
            
            newSymbols = categorical(obj.symbols, 'Protected', false, 'Ordinal', false);
            requiredSymbolInd = find(newSymbols == symbol);
            durations = obj.durations(requiredSymbolInd);
            
        end
        function symbInd = findSymbolVec(obj, symbol)
            % Purpose : find indices of symbol
            %
            % Syntax : symbInd = SymbRepObject.findSymbolVec(symbol)
            %
            % Input Parameters :
            %   symbol : required symbol as character array
            %
            % Return Parameters :
            %   symbInd : boolean vector which indicates all occurrances
            %   of the symbol specified in the input
            
            if ~ischar(symbol)
                
                errID = 'findSymbolVec:InputNoString';
                errMsg = 'The input symbol must be given as character array!';
                error(errID, errMsg);
                
            end
            
            newSymbols = categorical(obj.symbRepVec, 'Protected', false, 'Ordinal', false);
            symbInd = newSymbols == symbol;
            
        end
        function startIndUncompressed = getStartInd(obj, indSymbCompressed)
            % Purpose : given the index of a symbol from the compressed
            % return the start index of the uncompressed
            % sequence
            %
            % Syntax :
            %   startIndUncompressed = getStartInd(obj, indSymbCompressed)
            %
            % Input Parameters :
            %   indSymbCompressed : the index of the symbol(s) of the
            %   compressed symbol series
            %
            % Return Parameters :
            %   startIndUncompressed : the start index of the uncompressed
            %   series
            maxInd = max(indSymbCompressed);
            cuSum = cumsum(obj.durations(1:maxInd));
            startIndUncompressed = cuSum(indSymbCompressed) - obj.durations(indSymbCompressed) + 1;
            
            
        end
        
        function [startInds, durations] = findSequence(obj, symbSequence)
            % Purpose : Find indices of a given
            % sequence
            %
            % Syntax :
            %   SymbRepObject = SymbRepObject.mergeSequence(symbSequence)
            %
            % Input Parameters :
            %   symbSequence : Sequence which is supposed to be merged to
            %   one new categorical. Must be given as one dimensional cell
            %   array of strings with an arbitrary number of elements
            %
            % Return Parameters :
            %   SymbRepObject : Original object with merged symbolic
            %   representation
            warning('only a propetary function, maybe completle removed later');
            if(isa(symbSequence, 'cell') && size(symbSequence, 2) == 1)
                
                symbSequence = symbSequence';
                
            elseif~(isa(symbSequence, 'cell') && size(symbSequence, 1) == 1)
                
                errID = 'mergeSequence:InvalidInput';
                errMsg = 'The input symbSeqence must be a 1 x n cell array of strings, contining the symbols which are to be merged in a sequence!';
                error(errID, errMsg);
                
            end
            startInds = [];
            durations = [];
                
            nSymbSequence = numel(symbSequence);
            
            addedBrackets = cellfun(@(x) ['{', x, '}'], symbSequence, 'UniformOutput', false);
            removedBrackets = cellfun(@(x) strrep(x, '{[', '['), addedBrackets, 'UniformOutput', false);
            removedBrackets = cellfun(@(x) strrep(x, '{(', '('), removedBrackets, 'UniformOutput', false);
            removedBrackets = cellfun(@(x) strrep(x, ']}', ']'), removedBrackets, 'UniformOutput', false);
            removedBrackets = cellfun(@(x) strrep(x, ')}', ')'), removedBrackets, 'UniformOutput', false);
            modifiedSequence = removedBrackets;
            
            joinedSequence = join(modifiedSequence, '');
            newSequence = {['[', joinedSequence{1}, ']']};
            tempRemoving = {'TempRemoving'};
            tempRemovingCat = categorical(tempRemoving);
            symbols = addcats(obj.symbols, [newSequence, tempRemoving]);
            indArray = ones(numel(obj.symbols) + nSymbSequence - 1, 1);
            
            try
                for i = 1 : nSymbSequence
                    
                    indArray = indArray .* [false(nSymbSequence - i, 1); symbols == symbSequence{i}; false(i - 1, 1)];
                    
                end
            catch
                
                return
            end
            symbInd = find(indArray(nSymbSequence:end));
            startInds = obj.getStartInd(symbInd);
            durations = nan(length(symbInd),1);
            for i=1:length(symbInd)
                durations(i) = sum(obj.durations(symbInd(i):(symbInd(i) +nSymbSequence-1)));
            end
            
 
        end
        
        function obj = mergeSequence(obj, symbSequence)
            % Purpose : Merge symbols of one channel according to a given
            % sequence
            %
            % Syntax :
            %   SymbRepObject = SymbRepObject.mergeSequence(symbSequence)
            %
            % Input Parameters :
            %   symbSequence : Sequence which is supposed to be merged to
            %   one new categorical. Must be given as one dimensional cell
            %   array of strings with an arbitrary number of elements
            %
            % Return Parameters :
            %   SymbRepObject : Original object with merged symbolic
            %   representation
            
            if(isa(symbSequence, 'cell') && size(symbSequence, 2) == 1)
                
                symbSequence = symbSequence';
                
            elseif~(isa(symbSequence, 'cell') && size(symbSequence, 1) == 1)
                
                errID = 'mergeSequence:InvalidInput';
                errMsg = 'The input symbSeqence must be a 1 x n cell array of strings, contining the symbols which are to be merged in a sequence!';
                error(errID, errMsg);
                
            end
            
            nSymbSequence = numel(symbSequence);
            
            addedBrackets = cellfun(@(x) ['{', x, '}'], symbSequence, 'UniformOutput', false);
            removedBrackets = cellfun(@(x) strrep(x, '{[', '['), addedBrackets, 'UniformOutput', false);
            removedBrackets = cellfun(@(x) strrep(x, '{(', '('), removedBrackets, 'UniformOutput', false);
            removedBrackets = cellfun(@(x) strrep(x, ']}', ']'), removedBrackets, 'UniformOutput', false);
            removedBrackets = cellfun(@(x) strrep(x, ')}', ')'), removedBrackets, 'UniformOutput', false);
            modifiedSequence = removedBrackets;
            
            joinedSequence = join(modifiedSequence, '');
            newSequence = {['[', joinedSequence{1}, ']']};
            tempRemoving = {'TempRemoving'};
            tempRemovingCat = categorical(tempRemoving);
            obj.symbols = addcats(obj.symbols, [newSequence, tempRemoving]);
            indArray = ones(numel(obj.symbols) + nSymbSequence - 1, 1);
            
            for i = 1 : nSymbSequence
                
                indArray = indArray .* [false(nSymbSequence - i, 1); obj.symbols == symbSequence{i}; false(i - 1, 1)];
                
            end
            
            allSequenceStarts = find(indArray) - nSymbSequence + 1;
            %             symbolLengthClearance = ones(numel(obj.symbols), 1);
            %             for i = 1 : nSymbSequence - 1
            %
            %                 symbolLengthClearance(allSequenceStarts + i) = false;
            %
            %             end
            %             symbolLengthClearance(allSequenceStarts + 1 : allSequenceStarts + nSymbSequence - 1) = false;
            %             clearedIndArray = zeros(numel(obj.symbols), 1);
            %             clearedIndArray(allSequenceStarts) = true;
            %             clearedIndArray = clearedIndArray .* symbolLengthClearance;
            %             sequenceInd = find(clearedIndArray);
            newSequenceCat = categorical(newSequence);
            
            %             for i = 1 : numel(sequenceInd)
            %
            %                 obj.symbols(sequenceInd(i)) = newSequenceCat;
            %                 obj.symbols(sequenceInd(i) + 1 : sequenceInd(i) + nSymbSequence - 1) = tempRemovingCat;
            %
            %                 obj.durations(sequenceInd(i)) = sum(obj.durations(sequenceInd(i) : sequenceInd(i) + nSymbSequence - 1));
            %                 obj.durations(sequenceInd(i) + 1 : sequenceInd(i) + nSymbSequence - 1) = -1;
            %
            %             end
            
            modSequenceStarts = [allSequenceStarts; inf];
            
            for i = 1 : numel(allSequenceStarts)
                
                symbRange = min(nSymbSequence - 1, modSequenceStarts(i + 1) - modSequenceStarts(i) - 1);
                
                obj.symbols(allSequenceStarts(i)) = newSequenceCat;
                obj.symbols(allSequenceStarts(i) + 1 : allSequenceStarts(i) + symbRange) = tempRemovingCat;
                
                obj.durations(allSequenceStarts(i)) = sum(obj.durations(allSequenceStarts(i) : allSequenceStarts(i) + symbRange));
                obj.durations(allSequenceStarts(i) + 1 : allSequenceStarts(i) + symbRange) = -1;
                
            end
            
            obj.symbols = obj.symbols(~(obj.symbols == tempRemoving));
            obj.symbols = removecats(obj.symbols, tempRemoving);
            obj.durations = obj.durations(~(obj.durations == -1));
            
            cats2remove = ~ismember(symbSequence, obj.symbols);
            obj.symbols = removecats(obj.symbols, symbSequence(cats2remove));
            
            completeSymbVec = obj.symbRepVec;
            numRepr = int32(completeSymbVec);
            symbolChange = [true; diff(numRepr) ~= 0];
            obj.symbols = completeSymbVec(symbolChange);
            obj.durations = diff(find([symbolChange; 1]));
            
        end
        
        function obj = renameSymbol(obj, oldSymbol, newSymbol)
            % Purpose : Rename a symbol in the symbolic representation
            %
            % Syntax :
            %   SymbRepObject = SymbRepObject.rename(oldSymbol, newSymbol)
            %
            % Input Parameters :
            %   oldSymbol : Symbol existent in the symbolic representation,
            %   which has to be renamed. Input given as string.
            %   newSymbol : New symbol name for the old symbol, given as
            %   string
            %
            % Return Parameters :
            %   SymbRepObject : Original object with renamed symbol
            
            if~(ischar(oldSymbol) && ischar(newSymbol))
                
                errID = 'renameSymbol:InvalidInputs';
                errMsg = 'The inputs oldSymbol and newSymbol must be given as strings!';
                error(errID, errMsg);
                
            end
            
            obj.symbols = renamecats(obj.symbols, oldSymbol, newSymbol);
            
        end
        
        function obj = mergeSymbols(obj, oldSymbols, newSymbol)
            % Purpose : Merge given symbols in the symbolic representation
            %
            % Syntax :
            %   SymbRepObject = SymbRepObject.mergeSymbols(oldSymbols, newSymbol)
            %
            % Input Parameters :
            %   oldSymbols : Symbols existent in the symbolic representation,
            %   which have to be merged. Input given as cell array of strings.
            %
            %   newSymbol : New symbol name for the old symbols, given as
            %   string
            %
            % Return Parameters :
            %   SymbRepObject : Original object with merged symbols
            
            if ~(isa(oldSymbols, 'cell') && ischar(newSymbol))
                
                errID = 'mergeSymbols:InvalidInputs';
                errMsg = 'Input oldSymbols must be given as cell array of strings and newSymbol must be given as string!';
                error(errID, errMsg);
                
            else
                
                obj.symbols = mergecats(obj.symbols, oldSymbols, newSymbol);
                
                for i = numel(obj.symbols) : -1 : 2
                    
                    if(isequal(obj.symbols(i), obj.symbols(i - 1)))
                        
                        obj.durations(i - 1) = obj.durations(i) + obj.durations(i - 1);
                        
                        obj.durations(i) = [];
                        obj.symbols(i) = [];
                        
                    end
                    
                end
                
            end
            
        end
        
        function obj = setSymbolsInRange(obj, newSymbol, range)
            % Purpose : Set symbols in the given range manually
            %
            % Syntax :
            %   SymbRepObject = SymbRepObject.setSymbolsInRange(newSymbol, range)
            %
            % Input Parameters :
            %   newSymbol : Symbol to be set on the specified range, given
            %   as character array
            %
            %   range : Range on which the new symbol has to be set, given
            %   as 1 x 2 array containing start and end index of the range
            %
            % Return Parameters :
            %   SymbRepObject : Original object with removed short symbols
            
            if ~(ischar(newSymbol))
                
                errID = 'setSymbolsInRange:NonStringInputs';
                errMsg = 'The input newSymbol must be given as string!';
                error(errID, errMsg);
                
            elseif ~(isnumeric(range) && (isequal(size(range), [1, 2])))
                
                errID = 'setSymbolsInRange:InvalidRange';
                errMsg = 'The input range must be a numeric 1 x 2 array!';
                error(errID, errMsg);
                
            else
                
                %                 newSymbRepVec = cellstr(obj.symbRepVec);
                %                 newSymbRepVec(range(1) : range(2)) = {newSymbol};
                %
                %                 numRepr = grp2idx(newSymbRepVec);
                %                 symbolChange = [true; diff(numRepr) ~= 0];
                %                 compressedSymbols = newSymbRepVec(symbolChange);
                %                 symbolLength = diff(find([symbolChange; 1]));
                %
                %                 allCats = unique(compressedSymbols);
                %                 allCats(strcmp(allCats, '<undefined>')) = [];
                %                 obj.symbols = categorical(compressedSymbols, allCats, 'Protected', true);
                %                 obj.durations = symbolLength;
                
                cumDurations = cumsum(obj.durations);
                
                allEnds = cumDurations;
                allStarts = [1; allEnds(1 : end - 1) + 1];
                
                lowerStartInd = find(allStarts <= range(1), 1, 'last');
                upperStartInd = find(allStarts >= range(1), 1);
                lowerEndInd = find(allEnds <= range(2), 1, 'last');
                upperEndInd = find(allEnds >= range(2), 1);
                
                if(lowerStartInd == upperStartInd)
                    
                    preSymbol = {};
                    preDuration = [];
                    
                else
                    
                    preSymbol = cellstr(obj.symbols(lowerStartInd));
                    preDuration = range(1) - allStarts(lowerStartInd);
                    
                end
                
                if(lowerEndInd == upperEndInd)
                    
                    postSymbol = {};
                    postDuration = [];
                    
                else
                    
                    postSymbol = cellstr(obj.symbols(upperEndInd));
                    postDuration = allEnds(upperEndInd) - range(2);
                    
                end
                
                insertSymbol = {newSymbol};
                insertDuration = range(2) - range(1) + 1;
                
                if(isequal(preSymbol, insertSymbol))
                    
                    insertDuration = insertDuration + preDuration;
                    
                    preSymbol = {};
                    preDuration = [];
                    
                end
                
                if(isequal(postSymbol, insertSymbol))
                    
                    insertDuration = insertDuration + postDuration;
                    
                    postSymbol = {};
                    postDuration = [];
                    
                end
                
                completeInsertSymbol = [preSymbol; insertSymbol; postSymbol];
                completeInsertDurations = [preDuration; insertDuration; postDuration];
                
                if(lowerStartInd == 1)
                    
                    firstSymbolPart = categorical({});
                    firstDurationsPart = [];
                    
                else
                    
                    if(strcmp(cellstr(obj.symbols(lowerStartInd - 1)), completeInsertSymbol{1}))
                        
                        completeInsertDurations(1) = completeInsertDurations(1) + obj.durations(lowerStartInd - 1);
                        
                        firstSymbolPart = obj.symbols(1 : lowerStartInd - 2);
                        firstDurationsPart = obj.durations(1 : lowerStartInd - 2);
                        
                    else
                        
                        firstSymbolPart = obj.symbols(1 : lowerStartInd - 1);
                        firstDurationsPart = obj.durations(1 : lowerStartInd - 1);
                        
                    end
                    
                end
                
                if(upperEndInd == numel(allEnds))%allEnds(end))
                    
                    lastSymbolPart = categorical({});
                    lastDurationsPart = [];
                    
                else
                    
                    if(strcmp(cellstr(obj.symbols(upperEndInd + 1)), completeInsertSymbol{end}))
                        
                        completeInsertDurations(end) = completeInsertDurations(end) + obj.durations(upperEndInd + 1);
                        
                        lastSymbolPart = obj.symbols(upperEndInd + 2 : end);
                        lastDurationsPart = obj.durations(upperEndInd + 2 : end);
                        
                    else
                        
                        lastSymbolPart = obj.symbols(upperEndInd + 1 : end);
                        lastDurationsPart = obj.durations(upperEndInd + 1 : end);
                        
                    end
                    
                end
                
                availableCats = unique([categories(obj.symbols); insertSymbol]);
                
                obj.symbols = addcats(obj.symbols, insertSymbol);
                firstSymbolPart = addcats(firstSymbolPart, insertSymbol);
                lastSymbolPart = addcats(lastSymbolPart, insertSymbol);
                obj.symbols = [firstSymbolPart; categorical(completeInsertSymbol, availableCats); lastSymbolPart];
                obj.durations = [firstDurationsPart; completeInsertDurations; lastDurationsPart];
                
            end
            
        end
        
        function obj = removeShortSymbols(obj, varargin)
            % Purpose : Remove short symbols within the symbolic
            % representation
            %
            % Syntax :
            %   SymbRepObject = SymbRepObject.removeShortSymbols()
            %   SymbRepObject = SymbRepObject.removeShortSymbols(shortSymbolLength)
            %   SymbRepObject = SymbRepObject.removeShortSymbols(___, maxNumberShortSymbols)
            %   SymbRepObject = SymbRepObject.removeShortSymbols(___, maxShortSymbolSequenceLength)
            %   SymbRepObject = SymbRepObject.removeShortSymbols(___, 'splittingMode', splittingMode)
            %
            % Input Parameters :
            %   shortSymbolLength : Length up to which a symbol sequence is
            %   considered 'short', default is 1
            %
            %   maxNumberShortSymbols : Maximum number of consecutive short
            %   symbols. If this length is exceeded by a
            %   sequence of short symbols, this sequence is denominated
            %   unknown. Default is 5.
            %
            %   maxShortSymbolSequenceLength : Maximum length of
            %   consecutive short symbols. If this length is exceeded by a
            %   sequence of short symbols, this sequence is denominated
            %   unknown. Default is 10.
            %
            %   splittingMode : Decision wether the range of a short symbol
            %   is splitted to the enclosing symbols equally or weighted
            %
            % Return Parameters :
            %   SymbRepObject : Original object with removed short symbols
            
            p = inputParser;
            
            defaultshortSymbolLength = 1;
            defaultMaxNumberShortSymbols = 5;
            defaultMaxShortSymbolSequenceLength = 10;
            defaultSplittingMode = 'equal';
            
            addParameter(p, 'shortSymbolLength', defaultshortSymbolLength, @(x)validateattributes(x, {'numeric', 'nonempty'}, {'size', [1, 1]}));
            addParameter(p, 'maxNumberShortSymbols', defaultMaxNumberShortSymbols, @(x)validateattributes(x, {'numeric', 'nonempty'}, {'size', [1, 1]}));
            addParameter(p, 'maxShortSymbolSequenceLength', defaultMaxShortSymbolSequenceLength, @(x)validateattributes(x, {'numeric', 'nonempty'}, {'size', [1, 1]}));
            addParameter(p, 'splittingMode', defaultSplittingMode, @(x)validateattributes(x, {'char'}, {'nonempty'}));
            
            parse(p, varargin{:});
            
            shortSymbolLength = p.Results.shortSymbolLength;
            maxNumberShortSymbols = p.Results.maxNumberShortSymbols;
            splittingMode = p.Results.splittingMode;
            maxShortSymbolSequenceLength = p.Results.maxShortSymbolSequenceLength;
            
            allSymbols = cellstr(obj.symbols);
            allDurations = obj.durations;
            allShortSymbolsInd = allDurations <= shortSymbolLength;
            allNonShortSymbolsInd = (allShortSymbolsInd -1) * -1;
            cumStartInd = cumsum([1; allDurations(1 : end - 1)]);
            
            cumsumSymb = cumsum(allShortSymbolsInd');
            index  = strfind([allShortSymbolsInd', 0] ~= 0, [true, false]);
            
            if isempty(index)
                
                return;
                
            end
            
            allNumberShortSymbols = [cumsumSymb(index(1)), diff(cumsumSymb(index))]';
            allEndInd = index';
            allStartInd = allEndInd - allNumberShortSymbols + 1;
            
            allShortSymbolsLength = zeros(numel(allStartInd), 1);
            
            for i = 1 : numel(allStartInd)
                
                allShortSymbolsLength(i) = sum(obj.durations(allStartInd(i) : allEndInd(i)));
                
            end
            
            shortLongSeparationNumber = allNumberShortSymbols <= maxNumberShortSymbols;
            
            shortLongSeparationLength = allShortSymbolsLength <= maxShortSymbolSequenceLength;
            
            shortLongSeparation = shortLongSeparationNumber .* shortLongSeparationLength;
            
            tempWildcard = 'NotDefined'; % Wildcard - will be removed from the categorical at the end of the method
            
            for i = 1 : numel(allStartInd)
                
                % Wildcard - will be removed from the categorical at the end of the method
                % Used for all short and undefined symbols
                tempSymbol = tempWildcard;
                
                if(allStartInd(i) == 1)
                    
                    if(shortLongSeparation(i))
                        
                        tempSymbol = allSymbols{find(allNonShortSymbolsInd, 1)};
                        
                    end
                    
                    tempRange = [cumStartInd(allStartInd(1)), cumStartInd(allEndInd(1)) + allDurations(allEndInd(1)) - 1];
                    
                    obj = obj.setSymbolsInRange(tempSymbol, tempRange);
                    
                elseif(allEndInd(i) == numel(allSymbols))
                    
                    if(shortLongSeparation(i))
                        
                        tempSymbol = allSymbols{find(allNonShortSymbolsInd, 1, 'last')};
                        
                    end
                    
                    tempRange = [cumStartInd(allStartInd(end)), cumStartInd(allEndInd(end)) + allDurations(allEndInd(end)) - 1];
                    
                    obj = obj.setSymbolsInRange(tempSymbol, tempRange);
                    
                else
                    
                    if(shortLongSeparation(i) && strcmp(allSymbols{allStartInd(i) - 1}, '<undefined>') && strcmp(allSymbols{allEndInd(i) + 1}, '<undefined>'))
                        
                        tempRange = [cumStartInd(allStartInd(i)), cumStartInd(allEndInd(i)) + allDurations(allEndInd(i)) - 1];
                        
                        obj = obj.setSymbolsInRange(tempSymbol, tempRange);
                        
                    elseif(shortLongSeparation(i) && strcmp(allSymbols{allStartInd(i) - 1}, '<undefined>'))
                        
                        tempSymbol = allSymbols{allEndInd(i) + 1};
                        
                        startPoint = cumStartInd(allStartInd(i));
                        endPoint = cumStartInd(allEndInd(i)) + allDurations(allEndInd(i)) - 1;
                        
                        tempRange = [startPoint, endPoint];
                        
                        obj = obj.setSymbolsInRange(tempSymbol, tempRange);
                        
                    elseif(shortLongSeparation(i) && strcmp(allSymbols{allEndInd(i) + 1}, '<undefined>'))
                        
                        tempSymbol = allSymbols{allStartInd(i) - 1};
                        
                        startPoint = cumStartInd(allStartInd(i));
                        endPoint = cumStartInd(allEndInd(i)) + allDurations(allEndInd(i)) - 1;
                        
                        tempRange = [startPoint, endPoint];
                        
                        obj = obj.setSymbolsInRange(tempSymbol, tempRange);
                        
                    elseif(shortLongSeparation(i))
                        
                        tempSymbol1 = allSymbols{allStartInd(i) - 1};
                        tempSymbol2 = allSymbols{allEndInd(i) + 1};
                        
                        if(strcmp(splittingMode, 'equal'))
                            
                            startPoint = cumStartInd(allStartInd(i));
                            endPoint = cumStartInd(allEndInd(i)) + allDurations(allEndInd(i)) - 1;
                            
                            splittingPoint = floor((cumStartInd(allStartInd(i)) + cumStartInd(allEndInd(i)) + allDurations(allEndInd(i)) - 1) / 2);
                            
                            tempRange1 = [startPoint, splittingPoint];
                            tempRange2 = [splittingPoint + 1, endPoint];
                            
                        elseif(strcmp(splittingMode, 'weighted'))
                            
                            startPoint = cumStartInd(allStartInd(i));
                            endPoint = cumStartInd(allEndInd(i)) + allDurations(allEndInd(i)) - 1;
                            
                            weightingFactor = allDurations(allStartInd(i) - 1) / (allDurations(allStartInd(i) - 1) + allDurations(allEndInd(i) + 1));
                            splittingPoint = round(startPoint + (endPoint - startPoint + 1) * weightingFactor - 1);
                            
                            tempRange1 = [startPoint, splittingPoint];
                            tempRange2 = [splittingPoint + 1, endPoint];
                            
                        else
                            
                            errID = 'removeShortSymbols:InvalidSplittingMode';
                            errMsg = 'Input SplittingMode must be either equal or weighted!';
                            error(errID, errMsg);
                            
                        end
                        
                        obj = obj.setSymbolsInRange(tempSymbol1, tempRange1);
                        obj = obj.setSymbolsInRange(tempSymbol2, tempRange2);
                        
                    else
                        
                        tempRange = [cumStartInd(allStartInd(i)), cumStartInd(allEndInd(i)) + allDurations(allEndInd(i)) - 1];
                        
                        obj = obj.setSymbolsInRange(tempSymbol, tempRange);
                        
                    end
                    
                end
                
            end
            
            obj.symbols = removecats(obj.symbols, tempWildcard);
            
        end
        
        function [occurenceM, markovM] = genSymbMarkov(obj, varargin)
            % Purpose : Generate a markov matrix for all symbolic
            % combinations
            %
            % Syntax :
            %   [occurenceM, markovM] = SymbRepObject.genSymbMarkov
            %   [occurenceM, markovM] = SymbRepObject.genSymbMarkov('Absolute',
            %   true);
            %
            % Input Parameters :
            %   'Absolute' : Set to true if result shall represent the
            %   absolute number of transitions from one state to another,
            %   set to false (default) if matrix shall represent transition
            %   probabilities
            %
            % Return Parameters :
            %   occurenceM : matrix, which counts the occurences of symbol i
            %   is followed by symbol j in the entry occurenceM(j,i)
            %   markovM:= matrix cotaining a value for the occurence of two
            %   symbols in a row
            
            p = inputParser;
            
            defaultAbsolute = false;
            
            addParameter(p, 'Absolute', defaultAbsolute, @(x)validateattributes(x, {'logical'}, {'size', [1, 1]}));
            
            parse(p, varargin{:});
            
            abosluteOption = p.Results.Absolute;
            
            symbolsString = cellstr(obj.symbols);
            nSymbols = numel(symbolsString);
            
            allCat = categories(obj.symbols);
            nCat = numel(allCat);
            
            occurenceM = zeros(nCat, nCat);
            
            
            
            for i = 1 : nSymbols - 1
                
                fromInd = find(strcmp(allCat, symbolsString{i}));
                toInd = find(strcmp(allCat, symbolsString{i + 1}));
                
                occurenceM(fromInd, toInd) = occurenceM(fromInd, toInd) + 1;
                
            end
            
            occurenceM = occurenceM';
            
            % Transpose result, such that x1 = P * x0 instead of x1^T =
            % x0^T * P
            
            markovM = occurenceM;
            
            %% if absolut option is given
            if(~abosluteOption)
                markovM = SymbRepObject.occurenceM2markovM(markovM);
                markovM = SymbRepObject.clearMarkovM(markovM,occurenceM);
            end
            
            
            
        end
        
        function symbMarkov3D = genTrigramMatrix(obj)
            % Purpose : Generate a 3d markov matrix for all permutations of
            % 3 symbols
            %
            % Syntax :
            %   symbMarkov3D = SymbRepObject.genTrigramMatrix
            %
            % Input Parameters :
            %
            % Return Parameters :
            %   symbMarkov3D : 3d markov transition matrix
            
            symbolsString = cellstr(obj.symbols);
            nSymbols = numel(symbolsString);
            
            allCat = categories(obj.symbols);
            nCat = numel(allCat);
            
            symbMarkov3D = zeros(nCat, nCat, nCat);
            
            for i = 1 : nSymbols - 2
                
                ind1 = find(strcmp(allCat, symbolsString{i}));
                ind2 = find(strcmp(allCat, symbolsString{i + 1}));
                ind3 = find(strcmp(allCat, symbolsString{i + 2}));
                
                symbMarkov3D(ind1, ind2, ind3) = symbMarkov3D(ind1, ind2, ind3) + 1;
                
            end
            
        end
        
        function [occurenceM, markovM, SumLength1M, sumLength2M] = genLengthWeightedMatrix(obj, varargin)
            % Purpose : Generate a markov matrix for all symbolic
            % combinations with weighted length difference
            %
            % Syntax :
            %   SymbRepObject = SymbRepObject.genLengthWeightedMatrix
            %   SymbRepObject = SymbRepObject.genLengthWeightedMatrix('Absolute',
            %   true);
            %
            % Input Parameters :
            %   'Absolute' : Set to true if result shall represent the
            %   absolute number of transitions from one state to another,
            %   set to false (default) if matrix shall represent transition
            %   probabilities
            %
            % Return Parameters :
            %   occurenceM := matrix, which counts the occurences of symbol i
            %   is followed by symbol j in the entry occurenceM(j,i);
            
            p = inputParser;
            
            defaultAbsolute = false;
            
            addParameter(p, 'Absolute', defaultAbsolute, @(x)validateattributes(x, {'logical'}, {'size', [1, 1]}));
            
            parse(p, varargin{:});
            
            abosluteOption = p.Results.Absolute;
            
            symbolsString = cellstr(obj.symbols);
            nSymbols = numel(symbolsString);
            
            allCat = categories(obj.symbols);
            nCat = numel(allCat);
            
            
            occurenceM = zeros(nCat, nCat);
            SumLength1M = zeros(nCat, nCat);
            sumLength2M = zeros(nCat, nCat);
            
            
            
            for i = 1 : nSymbols - 1
                
                fromInd = find(strcmp(allCat, symbolsString{i}));
                toInd = find(strcmp(allCat, symbolsString{i + 1}));
                
                occurenceM(fromInd, toInd) = occurenceM(fromInd, toInd) + 1;
                SumLength1M(fromInd, toInd) = SumLength1M(fromInd, toInd) + obj.durations(i);
                sumLength2M(fromInd, toInd) = sumLength2M(fromInd, toInd) + obj.durations(i+1);
            end
            
            
            occurenceM = occurenceM';
            SumLength1M = SumLength1M';
            sumLength2M = sumLength2M';
            % Transpose result, such that x1 = P * x0 instead of x1^T =
            % x0^T * P
            
            markovM = occurenceM;
            
            %% if absolut option is given
            if(~abosluteOption)
                markovM = SymbRepObject.occurenceM2markovM(markovM);
                markovM = SymbRepObject.clearMarkovM(markovM,occurenceM);
            end
            
            
            %
            %              diffMat = abs( SumLength1M - sumLength2M)./(SumLength1M + sumLength2M -2);
            diffMat = 1 - abs( SumLength1M - sumLength2M)./(SumLength1M + sumLength2M);
            markovM = markovM.* diffMat;
            
        end
        
        
        
        function [occurenceM, markovM, sumLength1M, sumLength2M,lengthSyms] = genWeightedMatrixChangedLength(obj, varargin)
            % Purpose : Generate a markov matrix for all symbolic
            % combinations with weighted change of length
            %
            % Syntax :
            %   SymbRepObject = SymbRepObject.genSymbMarkov
            %   SymbRepObject = SymbRepObject.genSymbMarkov('Absolute',
            %   true);
            %
            % Input Parameters :
            %   'Absolute' : Set to true if result shall represent the
            %   absolute number of transitions from one state to another,
            %   set to false (default) if matrix shall represent transition
            %   probabilities
            %
            % Return Parameters :
            %   symbMarkov : Markov transition matrix
            
            p = inputParser;
            
            defaultAbsolute = false;
            
            addParameter(p, 'Absolute', defaultAbsolute, @(x)validateattributes(x, {'logical'}, {'size', [1, 1]}));
            
            parse(p, varargin{:});
            
            abosluteOption = p.Results.Absolute;
            
            symbolsString = cellstr(obj.symbols);
            nSymbols = numel(symbolsString);
            
            allCat = categories(obj.symbols);
            nCat = numel(allCat);
            %             symbolVec = cellstr(obj.symbols);
            %             symbolVecString = [symbolVec{:}];
            
            occurenceM = zeros(nCat, nCat);
            sumLength1M = zeros(nCat, nCat);
            sumLength2M = zeros(nCat, nCat);
            %             lengthSyms = zeros(nCat,1);
            
            %%
            for i = 1 : nSymbols - 1
                
                fromInd = find(strcmp(allCat, symbolsString{i}));
                %                 lengthSyms(fromInd) = lengthSyms(fromInd) +obj.durations(i);
                toInd = find(strcmp(allCat, symbolsString{i + 1}));
                
                occurenceM(fromInd, toInd) = occurenceM(fromInd, toInd) + 1;
                sumLength1M(fromInd, toInd) = sumLength1M(fromInd, toInd) + obj.durations(i);
                sumLength2M(fromInd, toInd) = sumLength2M(fromInd, toInd) + obj.durations(i+1);
            end
            
            %             lengthSyms(toInd) =  lengthSyms(toInd) + obj.durations(i+1);
            lengthSyms = obj.symbolDurations;
            sumLength1M = sumLength1M./lengthSyms;
            sumLength2M = sumLength2M./lengthSyms;
            
            % Transpose result, such that x1 = P * x0 instead of x1^T =
            % x0^T * P
            
            occurenceM = occurenceM';
            sumLength1M = sumLength1M';
            sumLength2M = sumLength2M';
            
            
            markovM = occurenceM;
            
            %% if absolut option is given
            if(~abosluteOption)
                markovM = SymbRepObject.occurenceM2markovM(markovM);
                markovM = SymbRepObject.clearMarkovM(markovM,occurenceM);
            end
            
            
            markovM = markovM.* sumLength1M.*sumLength2M;
            
        end
        
        function newObj = getTimeInterval(obj, intervalIndices)
            
            endInds = obj.stopInds;
            startInds = obj.startInds;
            
            firstElementInd = find(startInds <= intervalIndices(1), 1, 'last');
            lastElementInd = find(endInds >= intervalIndices(2), 1, 'first');
            middleElementsInds = firstElementInd + 1 : lastElementInd - 1;
            
            firstSymbol = obj.symbols(firstElementInd);
            firstDuration = endInds(firstElementInd) - intervalIndices(1) + 1;
            
            lastSymbol = obj.symbols(lastElementInd);
            lastDuration = intervalIndices(2) - startInds(lastElementInd) + 1;
            
            middleSymbols = obj.symbols(middleElementsInds);
            middleDurations = obj.durations(middleElementsInds);
            
            if(isempty(middleSymbols) && firstSymbol == lastSymbol)
                
                newSymbols = firstSymbol;
                newDurations = intervalIndices(2) - intervalIndices(1) + 1;
                
            else
                
                newSymbols = [firstSymbol; middleSymbols; lastSymbol];
                newDurations = [firstDuration; middleDurations; lastDuration];
                
            end
            
            newObj = SymbRepObject(newDurations, newSymbols);
            
        end
        
        function [allSymbRepObjects, imageMatrix, compressionData, evalRecord] = genHierarchicalCompounding(SymbObj, varargin)
            
            p = inputParser;
            p.addRequired('SymbObj', @(x) isa(x, 'SymbRepObject'));
            p.addOptional('maxLevel', 0, @(x) isnumeric(x)&& isequal(size(x), [1,1]));
            
            p.parse(SymbObj, varargin{:});
            SymbObj = p.Results.SymbObj;
            bLim = p.Results.maxLevel;
            
            imageMatrix = zeros(bLim, numel(SymbObj.symbRepVec));
            imageMatrix(1, :) = grp2idx(SymbObj.symbRepVec);
            
            nSymbolsProgress = nan(bLim,1);
            symbolReductionProgress = nan(bLim-1,1);
            nCatsProgress = nan(bLim,1);
            catsReductionProgress = nan(bLim-1,1);
            symbolReductionRate = nan(bLim-1,1);
            
            nSymbolsProgress(1) = numel(SymbObj.symbols);
            nCatsProgress(1) = numel(categories(SymbObj.symbols));
            
            allSymbRepObjects = cell(bLim, 1);
            allSymbRepObjects{1} = SymbObj;
            
            evalRecord = table;
            
            i = 2;
            bContinou = true;
            
            while bContinou
                
                if nSymbolsProgress(i-1) <= nCatsProgress(i-1)
                    break;
                end
                
                disp(['Run ', num2str(i), '/', num2str(bLim)]);
                
                markovM = SymbObj.genSymbMarkov('Absolute', true);
                
                [maxM, Ind] = max(markovM(:));
                [I, J] = ind2sub(size(markovM), Ind);
                
                allCats = categories(SymbObj.symbols);
                
                mostFrequentFrom = cellstr(allCats(J));
                mostFrequentTo = cellstr(allCats(I));
                
                newWord = [mostFrequentFrom; mostFrequentTo];
                
                SymbObj = SymbObj.mergeSequence(newWord);
                
                nSymbols = numel(SymbObj.symbols);
                nCats = numel(categories(SymbObj.symbols));
                
                nSymbolsProgress(i) = nSymbols;
                symbolReductionProgress(i - 1) = nSymbolsProgress(i - 1) - nSymbolsProgress(i);
                
                nCatsProgress(i) = nCats;
                catsReductionProgress(i - 1) = nCatsProgress(i - 1) - nCatsProgress(i);
                
                allSymbRepObjects{i} = SymbObj;
                imageMatrix(i, :) = grp2idx(SymbObj.symbRepVec);
                symbolReductionRate(i-1) = symbolReductionProgress(i-1)/ nSymbolsProgress(i-1);
                
                compressionRate = symbolReductionRate(i-1);
                nMergedSyms = symbolReductionProgress(i-1);
                Run = i - 1;
                nTransitions = maxM;
                Word = {strjoin(newWord, '')};
                recordLine = table(Run, nTransitions, nSymbols,nMergedSyms,compressionRate, Word);
                evalRecord = [evalRecord; recordLine];
                
                if bLim
                    
                    if i>bLim
                        
                        bContinou = false;
                        
                    end
                end
                
                i = i+1;
                
            end
            
            compressionData.nSymbols = nSymbolsProgress;
            compressionData.nCats = nCatsProgress;
            compressionData.nMergedSymbols = symbolReductionProgress;
            compressionData.symbolReductionRate = symbolReductionRate;
            
        end
        
        
        
        
        function [allSymbRepObjects, imageMatrix, compressionData, evalRecord] = genHierarchicalCompounding2(SymbObj,SymbObjFunStrg, varargin)
            
            p = inputParser;
            p.addRequired('SymbObj', @(x) isa(x, 'SymbRepObject'));
            p.addRequired('SymbObjFunStrg', @(x) ischar(x));
            p.addOptional('maxLevel', 0, @(x) isnumeric(x)&& isequal(size(x), [1,1]));
            
            p.parse(SymbObj,SymbObjFunStrg, varargin{:});
            SymbObj = p.Results.SymbObj;
            nameOrigSymbRep = SymbObj.name;
            SymbObj = SymbObj.setName(strtrim([nameOrigSymbRep, ' Level 1']));
            bLim = p.Results.maxLevel;
            
            imageMatrix = zeros(bLim, numel(SymbObj.symbRepVec));
            imageMatrix(1, :) = grp2idx(SymbObj.symbRepVec);
            
            nSymbolsProgress = nan(bLim,1);
            symbolReductionProgress = nan(bLim-1,1);
            nCatsProgress = nan(bLim,1);
            catsReductionProgress = nan(bLim-1,1);
            symbolReductionRate = nan(bLim-1,1);
            
            nSymbolsProgress(1) = numel(SymbObj.symbols);
            nCatsProgress(1) = numel(categories(SymbObj.symbols));
            
            allSymbRepObjects = cell(bLim, 1);
            allSymbRepObjects{1} = SymbObj;
            
            evalRecord = table;
            
            i = 2;
            bContinou = true;
            funH = str2func(['@(SymbObj)SymbObj.', SymbObjFunStrg]);
            while bContinou
                
                if nSymbolsProgress(i-1) <= nCatsProgress(i-1)
                    break;
                end
                
                disp(['Run ', num2str(i), '/', num2str(bLim)]);
                
                [occurenceM, markovM] = funH(SymbObj);
                
                [maxRel, Ind] = max(markovM(:));
                
                
                
                indsMax = find(markovM==maxRel);
                
                if length(indsMax)>1
                    
                    [~, IndMaxTemp]  = max(occurenceM(indsMax));
                    Ind = indsMax(IndMaxTemp);
                    %         disp('mehr maxima gefunden');
                end
                
                %%%
                maxM = occurenceM(Ind);

                [I, J] = ind2sub(size(markovM), Ind);
                
                allCats = categories(SymbObj.symbols);
                
                mostFrequentFrom = cellstr(allCats(J));
                mostFrequentTo = cellstr(allCats(I));
                
                newWord = [mostFrequentFrom; mostFrequentTo];
                
                SymbObj = SymbObj.mergeSequence(newWord);
                SymbObj = SymbObj.setName(strtrim([nameOrigSymbRep, ' Level ', int2str(i)]));
                
                nSymbols = numel(SymbObj.symbols);
                nCats = numel(categories(SymbObj.symbols));
                
                nSymbolsProgress(i) = nSymbols;
                symbolReductionProgress(i - 1) = nSymbolsProgress(i - 1) - nSymbolsProgress(i);
                
                nCatsProgress(i) = nCats;
                catsReductionProgress(i - 1) = nCatsProgress(i - 1) - nCatsProgress(i);
                
                allSymbRepObjects{i} = SymbObj;
                imageMatrix(i, :) = grp2idx(SymbObj.symbRepVec);
                symbolReductionRate(i-1) = symbolReductionProgress(i-1)/ nSymbolsProgress(i-1);
                
                compressionRate = symbolReductionRate(i-1);
                nMergedSyms = symbolReductionProgress(i-1);
                Run = i - 1;
                nTransitions = maxM;
                Word = {strjoin(newWord, '')};
                recordLine = table(Run, nTransitions, nSymbols,nMergedSyms,compressionRate, Word);
                evalRecord = [evalRecord; recordLine];
                
                if bLim
                    
                    if i>bLim
                        
                        bContinou = false;
                        
                    end
                end
                
                i = i+1;
                
            end
            
            compressionData.nSymbols = nSymbolsProgress;
            compressionData.nCats = nCatsProgress;
            compressionData.nMergedSymbols = symbolReductionProgress;
            compressionData.symbolReductionRate = symbolReductionRate;
            
        end
        function startInds = get.startInds(obj)
            startInds = obj.stopInds - obj.durations + 1; 
        end
        
        function stopInds = get.stopInds(obj)
            stopInds =cumsum(obj.durations);
        end
            
    end
    
    methods (Static)
        function markovM = occurenceM2markovM(occurenceM)
            markovM = occurenceM ./ sum(occurenceM, 1);
        end
        
        function markovMcleared = clearMarkovM(markovM, occurenceM)
            sumOccurances = sum(occurenceM, 1);
            markovMcleared = markovM;
            %                 sumOccurances(sumOccurances==1) = Inf;
            markovMcleared(:,sumOccurances==1) = 0;
            markovMcleared(isnan(markovMcleared)) = 0;
        end
    end
    
end

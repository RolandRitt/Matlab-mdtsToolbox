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
            
            sequenceInd = find(indArray) - nSymbSequence + 1;
            newSequenceCat = categorical(newSequence);            
            
            for i = 1 : numel(sequenceInd)
                
                obj.symbols(sequenceInd(i)) = newSequenceCat;
                obj.symbols(sequenceInd(i) + 1 : sequenceInd(i) + nSymbSequence - 1) = tempRemovingCat;
                
                obj.durations(sequenceInd(i)) = sum(obj.durations(sequenceInd(i) : sequenceInd(i) + nSymbSequence - 1));
                obj.durations(sequenceInd(i) + 1 : sequenceInd(i) + nSymbSequence - 1) = -1;
                
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
            
            if ~(ischar(oldSymbol) && ischar(newSymbol))
                
                errID = 'renameSymbol:NonStringInputs';
                errMsg = 'The inputs oldSymbol and newSymbol must be given as strings!';
                error(errID, errMsg);
                
            else
                
                obj.symbols = renamecats(obj.symbols, oldSymbol, newSymbol);
                
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
                
                if~(shortLongSeparation(i))
                    
                    tempSymbol = tempWildcard; % Wildcard - will be removed from the categorical at the end of the method
                    
                end
                
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
                    
                    if(shortLongSeparation(i))
                        
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
        
        function symbMarkov = genSymbMarkov(obj, varargin)
            % Purpose : Generate a markov matrix for all symbolic
            % combinations
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
            
            symbMarkov = zeros(nCat, nCat);
            
            %             for i = 1 : nCat
            %
            %                 for j = 1 : nCat
            %
            %                     % Subtract '[word]' to avoid double counting of already merged
            %                     % words
            %                     symbMarkov(i, j) = numel(strfind(symbolVecString, [allCat{i}, allCat{j}])) - numel(strfind(symbolVecString, ['[', allCat{i}, allCat{j}, ']']));
            %
            %                 end
            %
            %                 totalChanges = sum(symbMarkov(i, :));
            %
            %                 if(totalChanges > 0 && ~abosluteOption)
            %
            %                     symbMarkov(i, :) = symbMarkov(i, :) / totalChanges;
            %
            %                 end
            %
            %             end
            
            for i = 1 : nSymbols - 1
                
                fromInd = find(strcmp(allCat, symbolsString{i}));
                toInd = find(strcmp(allCat, symbolsString{i + 1}));
                                
                symbMarkov(fromInd, toInd) = symbMarkov(fromInd, toInd) + 1;
                
            end
            
            if(~abosluteOption)
                
                symbMarkov = symbMarkov ./ sum(symbMarkov, 2);
                
            end

        end
        
    end
    
end


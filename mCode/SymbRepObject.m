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
    
    properties(Dependent)
        
        symbRepVec
        
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
            
            if(isprotected(symbols))
                
                obj.symbols = symbols;
                
            else
                
                obj.symbols = categorical(symbols, 'Protected', true);
                
            end
            
            obj.durations = durations;            
            
        end
        
        function symbRepVec = get.symbRepVec(obj)
            % Purpose : return dependent variable symbRepVec
            %
            % Syntax : symbRepVec = mdtsObject.symbRepVec
            %
            % Input Parameters :
            %
            % Return Parameters :
            %   symbRepVec : symbolic representation of a channel in full
            %   length (no compression)
            
            symbRepVec = repelem(obj.symbols, obj.durations);
            
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
            joinedSequence = join(symbSequence, '');
            newSequence = {['[', joinedSequence{1}, ']']};
            obj.symbols = addcats(obj.symbols, newSequence);
            indArray = ones(numel(obj.symbols) + nSymbSequence - 1, 1);
            
            for i = 1 : nSymbSequence
                
                indArray = indArray .* [false(nSymbSequence - i, 1); obj.symbols == symbSequence{i}; false(i - 1, 1)];
                
            end
            
            sequenceInd = find(indArray) - nSymbSequence + 1;
            
            for i = numel(sequenceInd) : -1 : 1
                
                obj.symbols(sequenceInd(i)) = categorical(newSequence);
                obj.symbols(sequenceInd(i) + 1 : sequenceInd(i) + nSymbSequence - 1) = [];
                
                obj.durations(sequenceInd(i)) = sum(obj.durations(sequenceInd(i) : sequenceInd(i) + nSymbSequence - 1));
                obj.durations(sequenceInd(i) + 1 : sequenceInd(i) + nSymbSequence - 1) = [];
                
            end
            
            numRepr = int32(obj.symbRepVec);            
            symbolChange = [true; diff(numRepr) ~= 0];
            obj.symbols = obj.symbRepVec(symbolChange);
            obj.durations = diff(find([symbolChange; 1]));
            
        end
    end
    
end


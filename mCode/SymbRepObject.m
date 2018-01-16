classdef SymbRepObject
    %
    % Description : Represents a full segmentation set for one channel of
    % an mdtsObject
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
            
            obj.durations = durations;
            obj.symbols = symbols;
            
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
            indArray = ones(numel(obj.symbols) + nSymbSequence - 1, 1);
            
            for i = 1 : nSymbSequence
                
                indArray = indArray .* [false(nSymbSequence - 1, 1); obj.symbols == symbSequence{1}];
                
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


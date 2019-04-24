function parseCommands(objectList, parseString)
% parsing, string operations
%
% Purpose : parse string and execute all operations
%
% Syntax :
%   parse(objectList, parseString)
%
% Input Parameters :
%   objectList : cell array of mdtsObject handles
%
%   parseString : string which represents all computations. Every
%   computation must be represented by a line with an ending ';'. Line
%   breaks at the end of the line are optional
%
% Return Parameters :
%
% Description : 
%   Parses the given string and executes all computations. Results will be
%   stored in the objects in objectList if specified in paresString
%
% Author : 
%   Paul O'Leary
%   Roland Ritt
%   Thomas Grandl
%
% History :
% \change{1.0}{02-Jan-2017}{Original}
%
% --------------------------------------------------------
% (c) 2017 Paul O'Leary,
% Chair of Automation, University of Leoben, Leoben, Austria
% email: office@harkeroleary.org,
% url: www.harkeroleary.org
% --------------------------------------------------------
%
%% Settings

ruleOperators = {'&', '|'};
conditionOperators = {'>', '<', '==', '~='};

%% Computations

commandLines = strtrim(strsplit(parseString, ';'));
commandLines = commandLines(~cellfun('isempty', commandLines));

intermediateLineResults = struct;

for i = 1 : numel(commandLines)
    
    conditionedLine = commandLines{i};
    conditionedLine = strrep(conditionedLine, '==', 'equalSign');
    conditionedLine = strrep(conditionedLine, '~=', 'NotEqualSign');
    LineElements = strtrim(strsplit(conditionedLine, '='));
    outputVariable = LineElements{1};
    command = LineElements{2};
    command = strrep(command, 'equalSign', '==');
    command = strrep(command, 'NotEqualSign', '~=');
    
    [usedConditions, usedRules] = strsplit(command, ruleOperators);
    usedConditions = strtrim(usedConditions);
    
    if~isempty(usedRules)
        
        theCondition = usedConditions{1};
        intermediateConditionResult = getConditionResult(theCondition, conditionOperators, objectList, intermediateLineResults);
        
        for j = 1 : numel(usedRules)
            
            theCondition = usedConditions{j + 1};
            conditionResult = getConditionResult(theCondition, conditionOperators, objectList, intermediateLineResults);
            
            intermediateConditionResult = computeRule(usedRules{j}, intermediateConditionResult, conditionResult);
            
        end
        
        theIntermediateResult = intermediateConditionResult;
        addResult;
        
    else
        
        theCondition = usedConditions{1};
        theIntermediateResult = getConditionResult(theCondition, conditionOperators, objectList, intermediateLineResults);
        addResult;
        
    end
    
end

    function conditionResult = getConditionResult(theCondition, conditionOperators, objectList, intermediateLineResults)
        
        [conditionElements, operator] = strsplit(theCondition, conditionOperators);
                
        if(contains(conditionElements{1}, '.'))
            
            operator = operator{1};
            
            nameElements = strsplit(strtrim(conditionElements{1}), '.');
            
            for i = 1 : numel(objectList)
                
                if(eq(objectList{i}.name, nameElements{1}))
                    
                    theObject = objectList{i};
                    break;
                    
                end
                
            end
            
            theTag = nameElements{2};
            
            input.object = theObject;
            input.tag = theTag;
            
            value = str2double(strtrim(conditionElements{2}));
            
            conditionResult = computeFind(operator, input, value);
            
        else
            
            conditionResult = intermediateLineResults.(strtrim(conditionElements{1}));
            
        end        

    end

    function addResult
        
        if(contains(outputVariable, '.'))
            
            nameElements = strsplit(strtrim(outputVariable), '.');
            
            for k = 1 : numel(objectList)
                
                if(eq(objectList{k}.name, nameElements{1}))
                    
                    theObject = objectList{k};
                    break;
                    
                end
                
            end
            
            theTag = nameElements{2};
            
            theObject.expandDataSet(double(theIntermediateResult), theTag);
            
        else
            
            intermediateLineResults.(outputVariable) = theIntermediateResult;
            
        end
        
    end

end


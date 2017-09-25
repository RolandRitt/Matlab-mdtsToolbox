classdef mdtsObject < CoreObject
    %
    % Description : Based on the core object, checks validity of input data
    % and passes it to the core object
    %
    % Author :
    %    Paul O'Leary
    %    Roland Ritt
    %    Thomas Grandl
    %
    % History :
    % \change{1.0}{31-Aug-2017}{Original}
    %
    % --------------------------------------------------
    % (c) 2017, Paul O'Leary
    % Chair of Automation, University of Leoben, Austria
    % email: automation@unileoben.ac.at
    % url: automation.unileoben.ac.at
    % --------------------------------------------------
    %
    
    properties
    end
    
    methods
        
        function obj = mdtsObject(timeIn, dataIn, tagsIn, varargin)
            
            p = inputParser;
            defaultUnits = cell(1, numel(tagsIn));
            defaultUnits(:) = {'-'};
            defaultts = [];
            defaultName = 'Time Series';
            defaultWho = 'Author';
            defaultWhen = 'Now';
            defaultDescription = 'No description available';
            defaultComment = 'No comment available';
            
            addRequired(p, 'timeIn', @(x)validateattributes(x, {'numeric'}, {'nonempty'}));
            addRequired(p, 'dataIn', @(x)validateattributes(x, {'numeric'}, {'nonempty'}));
            addRequired(p, 'tagsIn', @(x)validateattributes(x, {'cell'}, {'nonempty'}));
            
            addParameter(p, 'units', defaultUnits);
            addParameter(p, 'ts', defaultts);
            addParameter(p, 'name', defaultName);
            addParameter(p, 'who', defaultWho);
            addParameter(p, 'when', defaultWhen);
            addParameter(p, 'description', defaultDescription);
            addParameter(p, 'comment', defaultComment);
            
            parse(p, timeIn, dataIn, tagsIn, varargin{:});
            
            obj@CoreObject(p.Results.timeIn, p.Results.dataIn, p.Results.tagsIn, p.Results.units, p.Results.ts, p.Results.name, p.Results.who, p.Results.when, p.Results.description, p.Results.comment);
            
        end
        
        function expandDataSet(obj, addData, addTags)
            
            timeSize = numel(obj.time);
            addTagSize = numel(addTags);
            
            if~isnumeric(addData)
                
                errID = 'expandDataSet:DataNotNumeric';
                errMsg = 'The given data matrix is not numeric!';
                error(errID, errMsg);
                
            elseif~(size(addData, 1) == timeSize)
                
                errID = 'expandDataSet:InvalideDataSize1';
                errMsg = 'The given data matrix has a different number of time stamps than the original data!';
                error(errID, errMsg);
                
            elseif~(size(addData, 2) == addTagSize)
                
                errID = 'expandDataSet:InvalideDataSize2';
                errMsg = 'The given data matrix has a different number of time stamps than the original data!';
                error(errID, errMsg);
                
            elseif~(iscell(addTags))
                
                errID = 'expandDataSet:InvalidTags';
                errMsg = 'The given tags are no cell array!';
                error(errID, errMsg);
                              
            end
            
            expandDataSet@CoreObject(obj, addData, addTags); 
            
        end
        
        function obj = calc(obj, calcObj, tagNameInput, tagNameOutput)
            
            p = inputParser();
            addRequired(p, 'calcObj', @(x) isa(x, 'calcObjectInterface'));
            addRequired(p, 'tagNameInput', @(x) iscell(x) && ischar(x{1}));
            addRequired(p, 'tagNameOutput', @(x) iscell(x) && ischar(x{1}));
            parse(p, calcObj, tagNameInput, tagNameOutput);
            
            tagI = getTagIndices(obj, p.Results.tagNameInput);
            
            dataOut = calcObj.apply(obj.data(:, tagI));
            
            expandDataSet(obj, dataOut, p.Results.tagNameOutput);
            
        end
        
        function obj = localDerivative(obj, tagNameInput, ls, noBfs)
            
            p = inputParser();
            addRequired(p, 'tagNameInput', @(x) iscell(x) && ischar(x{1}));
            addRequired(p, 'ls', @(x) isnumeric(x) && isequal(size(x),[1 1]));
            addRequired(p, 'noBfs', @(x) isnumeric(x) && isequal(size(x),[1 1]));
            parse(p, tagNameInput, ls, noBfs);
            
            L = dopD(obj.time(1 : p.Results.ls), p.Results.noBfs);
            LDOobj = LDO(L);
            
            tagNameOutput = {['LD_', p.Results.tagNameInput{1}]};
            obj = obj.calc(LDOobj, p.Results.tagNameInput, tagNameOutput);
            
        end
            
    end
    
end


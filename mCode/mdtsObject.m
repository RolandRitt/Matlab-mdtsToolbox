classdef mdtsObject < mdtsCoreObject
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
            
            addRequired(p, 'timeIn', @(x)validateattributes(x, {'numeric', 'nonempty'}, {'size', [size(dataIn, 1), 1]}));            
            addRequired(p, 'dataIn', @(x)validateattributes(x, {'numeric'}, {'nonempty'}));
            addRequired(p, 'tagsIn', @(x)validateattributes(x, {'cell', 'nonempty'}, {'size', [1, size(dataIn, 2)]}));
            
            addParameter(p, 'units', defaultUnits, @(x)validateattributes(x, {'cell', 'nonempty'}, {'size', [1, size(dataIn, 2)]}));
            addParameter(p, 'ts', defaultts, @(x)validateattributes(x, {'duration', 'nonempty'}, {'size', [1, 1]}));
            addParameter(p, 'name', defaultName, @(x)validateattributes(x, {'char'}, {'nonempty'}));
            addParameter(p, 'who', defaultWho, @(x)validateattributes(x, {'char'}, {'nonempty'}));
            addParameter(p, 'when', defaultWhen, @(x)validateattributes(x, {'char'}, {'nonempty'}));
            addParameter(p, 'description', defaultDescription, @(x)validateattributes(x, {'char', 'cell'}, {'nonempty'}));
            addParameter(p, 'comment', defaultComment, @(x)validateattributes(x, {'char', 'cell'}, {'nonempty'}));
            
            parse(p, timeIn, dataIn, tagsIn, varargin{:});
            
            obj@mdtsCoreObject(p.Results.timeIn, p.Results.dataIn, p.Results.tagsIn, p.Results.units, p.Results.ts, p.Results.name, p.Results.who, p.Results.when, p.Results.description, p.Results.comment);
            
        end
        
        function returnObject = getData(obj, varargin)
            
            nArguments = numel(varargin);
    
            if(nArguments > 2 || nArguments == 0)
            
                    errID = 'getData:InvalidNumberOfInputs';
                    errMsg = 'Invalid number of input arguments!';
                    error(errID, errMsg);
                    
            else
                
                returnObject = getData@mdtsCoreObject(obj, varargin); 
                
            end
            
        end
        
        function tagIndices = getTagIndices(obj, tagList)
                       
            correctTagInput = ismember(tagList, obj.tags);
                       
            if(correctTagInput)
                
                tagIndices = getTagIndices@mdtsCoreObject(obj, tagList); 
                               
            else
                
                notIncludedTags = tagList(~correctTagInput);
                
                errID = 'getTagIndices:TagNotAvailable';
                errMsg = ['Tag(s) ', strjoin(notIncludedTags, ', '), ' not available within the data!'];
                error(errID, errMsg);
                
            end
            
        end
        
        function intervalIndices = getIntervalIndices(obj, timeInterval)
            
            if(timeInterval(1) >= obj.time(1) && timeInterval(end) <= obj.time(end))
                
                intervalIndices = getIntervalIndices@mdtsCoreObject(obj, timeInterval); 
                
            else
                
                errID = 'getIntervalIndices:IntervalOutOfBoundaries';
                errMsg = 'Specified interval exceeds the boundaries of the data!';
                error(errID, errMsg);
                
            end
            
        end
        
        function obj = expandDataSet(obj, addData, addTags)
            
            if(ischar(addTags))
                
                addTags = {addTags};
                
            end
            
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
                
            elseif(checkTags(obj, addTags))
                
                errID = 'expandDataSet:NonUniqueTags';
                errMsg = 'Given tags for data expansion are already existend in the data set!';
                error(errID, errMsg);
                
            end
            
            obj = expandDataSet@mdtsCoreObject(obj, addData, addTags);
            
        end
                    
    end
    
end


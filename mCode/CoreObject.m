classdef CoreObject < matlab.mixin.Copyable
    %
    % Description : Core object to store time series data together with
    % relevant additional information
    %
    % Author :
    %    Paul O'Leary
    %    Roland Ritt
    %    Thomas Grandl
    %
    % History :
    % \change{1.0}{31-Jul-2017}{Original}
    %
    % --------------------------------------------------
    % (c) 2017, Paul O'Leary
    % Chair of Automation, University of Leoben, Austria
    % email: automation@unileoben.ac.at
    % url: automation.unileoben.ac.at
    % --------------------------------------------------
    %
    
    properties
        
        %Core data
        
        time
        data
        tags
        exData = [];
        exTags = [];
        
        %Meta data
        
        name
        who
        when
        description
        comment        
        units
        uniform
        ts
        isSubset = false;
        
    end
    
    properties(Dependent)
        
        fs
        timeRelative
        timeDateTime
        
    end
    
    methods
        
        function obj = CoreObject(timeIn, dataIn, tagsIn, unitsIn, tsIn, nameIn, whoIn, whenIn, descriptionIn, commentIn)
            
            % Core data
            
            obj.time = timeIn;
            obj.data = dataIn;
            
            % Meta data
            
            obj.tags = tagsIn;
            obj.units = unitsIn;
            
            if(isempty(tsIn))
                obj.uniform = 0;
                obj.ts = [];
            else
                obj.uniform = 1;
                obj.ts = tsIn;
            end
            
            obj.name = nameIn;
            obj.who = whoIn;
            obj.when = whenIn;
            obj.description = descriptionIn;
            obj.comment = commentIn;
            
        end
        
        function fs = get.fs(obj)            
            
            ts_s = seconds(obj.ts);
            fs_s = 1 / ts_s;
            fs = duration(0, 0, fs_s);
            
        end
        
        function timeDateTime = get.timeDateTime(obj)
            
            timeDateTime = datetime(obj.time, 'ConvertFrom', 'datenum'); 
            
        end
        
        function timeRelative = get.timeRelative(obj)  
            
            timeRelative = obj.time - obj.time(1);
            
        end
        
        function varargout = subsref(obj, s)
            
            if isequal(s(1).type, '()')
                
                extractRows = 0;
                extractTags = 0;
                
                s1subs = s(1).subs{1};
                
                if isnumeric(s1subs) %direct indexing
                    
                    intervalI(1) = min(s1subs);
                    intervalI(2) =  max(s1subs);
                    extractRows = 1;
                    
                elseif iscell(s1subs) %time indexing
                    
                    if (isequal(size(s1subs),[2 1]) || isequal(size(s1subs), [1 2]))
                        
                        intervalI = obj.getIntervalIndices([s1subs{1}; s1subs{2}]);
                        extractRows = 1;
                        
                    else
                        
                        error('wrong time indexing');
                        
                    end
                    
                elseif isequal(s1subs, ':')
                    
                    % nothing, no indexing --> all rows returned
                    
                else
                    
                    error('wrong row indexing');
                    
                end
                
                if numel(s(1).subs) >= 2
                    
                    tagsInput = s(1).subs{2};
                    
                    if isnumeric(tagsInput) % direct index = column index
                        
                        tagsIndices = tagsInput;
                        extractTags = 1;
                        
                    elseif isequal(tagsInput, ':')
                        
                         % nothing, no indexing --> all tags returned
                        
                    elseif ischar(tagsInput) % one string given --> extract only one tag
                        
                        tagsIndices = obj.getTagIndices({tagsInput});
                        extractTags = 1;
                        
                    elseif iscellstr(tagsInput) %% if cell array --> extract all tags
                        
                        tagsIndices = obj.getTagIndices(tagsInput);
                        extractTags = 1;
                        
                    else
                        error('wrong tag indexing');
                    end
                end              
                
                returnObject = copy(obj);
                                
                if extractTags && extractRows
                    
                    returnObject.keepRowsOfData(intervalI);
                    returnObject.keepTagsOfData(tagsIndices);
                    
                elseif extractTags && ~extractRows
                    
                    returnObject.keepTagsOfData(tagsIndices);
                    
                elseif ~extractTags && extractRows
                    
                    returnObject.keepRowsOfData(intervalI);
                    
                end
                
                if length(s) == 1
                    
                    varargout = {returnObject};
                    
                else
                    
                    % Use built-in for any other expression
                    [varargout{1 : nargout}] = builtin('subsref', returnObject, s(2:end));
                    
                end
                
            else
                
                [varargout{1 : nargout}] = builtin('subsref', obj, s);
                
            end
        end
    
        function returnObject = getData(obj, varargin)
            
            nArguments = numel(varargin);
    
            tagList = obj.tags;
            intervalIndices = [1; numel(obj.time)];
    
            switch nArguments
        
                case 0 %getData()
            
                case 1 %getData(tagList)
            
                    tagList = varargin{1};
            
                case 2 %getData(tagList, timeInterval)
            
                    tagList = varargin{1};
                    
                    if ischar(varargin{2})
                        
                        dateString = varargin{2};
                        [timeInterval(1), timeInterval(2)] = obj.endStartOfDate(dateString);
                        
                    else
                        
                        timeInterval = varargin{2};
                        
                    end
                    
                    intervalIndices = obj.getIntervalIndices(timeInterval);
                   
                otherwise
            
                    errID = 'getData:InvalidNumberOfInputs';
                    errMsg = 'Invalid number of input arguments!';
                    error(errID, errMsg);
            
            end
    
            s = struct;
            s.type = '()';
            s.subs = {intervalIndices(1) : intervalIndices(end), tagList};
            
            returnObject = obj.subsref(s);
    
            if(numel(tagList) < numel(obj.tags) || intervalIndices(1) > 1 || intervalIndices(end) < numel(obj.time))
        
                returnObject.isSubset = true;
                
            end
             
        end
        
        function tagIndices = getTagIndices(obj, tagList)
            
            correctTagInput = ismember(tagList, obj.tags);
            
            if(correctTagInput)
                
                tagIndices = find(ismember(obj.tags, tagList) == 1);
                
            else
                
                notIncludedTags = tagList(~correctTagInput);
                
                errID = 'getTagIndices:TagNotAvailable';
                errMsg = ['Tag(s) ', strjoin(notIncludedTags, ', '), ' not available within the data!'];
                error(errID, errMsg);
                
            end
            
        end
        
        function intervalIndices = getIntervalIndices(obj, timeInterval)
            
            if(timeInterval(1) >= obj.time(1) && timeInterval(end) <= obj.time(end))
                
                startI = find(obj.time >= timeInterval(1), 1);
                endI = find(obj.time <= timeInterval(end), 1, 'last');
                
                intervalIndices = [startI; endI];
                
            else
                
                errID = 'getIntervalIndices:IntervalOutOfBoundaries';
                errMsg = 'Specified interval exceeds the boundaries of the data!';
                error(errID, errMsg);
                
            end
            
        end
        
        function correctTags = checkTags(obj, tagList)
                       
            memberships = ismember(tagList, obj.tags);
            correctTags = logical(prod(memberships));
            
        end
        
        function [startDateNum, endDateNum] = endStartOfDate(obj, dateString)
            
            defVec = zeros(1, 6); %for Year, Month, Day, Hour, Minutes, Seconds
            defVec([2,3]) = 1; %day and month start with 1
            
            delimiter = '_';
            
            dateParts = strsplit(dateString, delimiter);
            dateVec = cellfun(@str2double, dateParts)';
            
            n = length(dateVec);
            
            startVec = defVec;    
            startVec(1:n) = dateVec;
            endVec = startVec; 
            endVec(n) = endVec(n) + 1;
            
            startDateNum = datenum(startVec);
            endDateNum = datenum(endVec) - 1;
            
        end
        
        function expandDataSet(obj, addData, addTags)
            
            obj.exData = [obj.exData, addData];
            obj.exTags = [obj.exTags, addTags];
            
        end
                
    end
    
    methods(Access = protected)
        
        function keepRowsOfData(obj, intervalIndices)
            
            obj.time = obj.time(intervalIndices(1) : intervalIndices(end));
            obj.data = obj.data(intervalIndices(1) : intervalIndices(end), :);
        
        end
        
        function keepTagsOfData(obj, tagsI)
        
            obj.data = obj.data(:, tagsI);
            obj.tags = obj.tags(tagsI);
            obj.units = obj.units(tagsI);
        
        end
        
    end
        
end


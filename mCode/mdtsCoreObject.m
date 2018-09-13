classdef mdtsCoreObject < matlab.mixin.Copyable
    %
    % Description : Core object to store time series data together with
    % relevant additional information (meta data)
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
        tsEvents
        symbReps
        segments
        
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
        timeDateTimeRelative
        
    end
    
    methods
        
        function obj = mdtsCoreObject(time, data, tags, units, ts, name, who, when, description, comment, tsEvents, symbReps, segments)
            
            % Core data
            
            obj.time = time;
            obj.data = data;
            obj.tags = tags;
            obj.tsEvents = tsEvents;
            obj.symbReps = symbReps;
            obj.segments = segments;
            
            % Meta data            
            
            obj.units = units;
            
            if(isempty(ts))
                obj.uniform = 0;
                obj.ts = [];
            else
                obj.uniform = 1;
                obj.ts = ts;
            end
            
            obj.name = name;
            obj.who = who;
            obj.when = when;
            obj.description = description;
            obj.comment = comment;  
            
        end
        
        function fs = get.fs(obj)
            % Purpose : return dependent variable fs
            %
            % Syntax : fs = mdtsObject.fs
            %
            % Input Parameters :
            %
            % Return Parameters :
            %   fs : sampling frequency
            
            if(isempty(obj.ts))
                
                errID = 'fs:dataNotUniform';
                errMsg = 'Data is not uniform, no fs existent!';
                error(errID, errMsg);
                
            else
                
                ts_s = seconds(obj.ts);
                fs = 1 / ts_s;
                
            end
            
        end
        
        function timeDateTime = get.timeDateTime(obj)
            % Purpose : return dependent variable timeDateTime
            %
            % Syntax : timeDateTime = mdtsObject.timeDateTime
            %
            % Input Parameters :
            %
            % Return Parameters :
            %   timeDateTime : time stamps in 'datetime' format
            
            timeDateTime = datetime(obj.time, 'ConvertFrom', 'datenum'); 
            
        end
        
        function timeRelative = get.timeRelative(obj)
            % Purpose : return dependent variable timeRelative
            %
            % Syntax : timeRelative = mdtsObject.timeRelative
            %
            % Input Parameters :
            %
            % Return Parameters :
            %   timeRelative : time stamps relative to first time stamp,
            %   which starts with time 0
            
            timeRelative = obj.time - obj.time(1);
            
        end
        
        function timeDateTimeRelative = get.timeDateTimeRelative(obj)
            % Purpose : return dependent variable timeDateTimeRelative
            %
            % Syntax : timeDateTimeRelative = mdtsObject.timeDateTimeRelative
            %
            % Input Parameters :
            %
            % Return Parameters :
            %   timeDateTimeRelative : time stamps relative to first time stamp,
            %   which starts with time 0, in 'datetime' format
            
            timeDateTimeRelative = datetime(obj.timeRelative, 'ConvertFrom', 'datenum'); 
            
        end
        
        function varargout = subsref(obj, s)
            % Purpose : subsref function will be called automatically,
            % everytime a function is called. Subsref passes the parameter
            % to the according function or returns the required variable.
            % Developed by Roland Ritt
            %
            % Syntax : No specific syntax available. This function is
            % executed when a user calls any function or accesses any
            % variable of this object
            %
            % Input Parameters :
            %   s : struct containing all information. Will be generated
            %   automatically by matlab during a function call.
            %
            % Return Parameters :
            %   varargout : output of the according function or the
            %   required variable
            
            if isequal(s(1).type, '()')
                
                extractRows = 0;
                extractTags = 0;
                
                s1subs = s(1).subs{1};
                
                if isnumeric(s1subs) %direct indexing
                    
                    intervalI(1) = min(s1subs);
                    intervalI(2) =  max(s1subs);
                    extractRows = 1;
                    
                elseif iscell(s1subs) % time indexing
                    
                    if (isequal(size(s1subs),[2 1]) || isequal(size(s1subs), [1 2]))
                        
                        intervalI = obj.getIntervalIndices([s1subs{1}; s1subs{2}]);
                        extractRows = 1;
                        
                    else
                        
                        errID = 'subsref:IncorrectTagCellSize';
                        errMsg = 'Incorrect indexing of time interval! Interval must be of dimensions [1, 2] or [2, 1], if given as cell!';
                        error(errID, errMsg);
                        
                    end
                    
                elseif isequal(s1subs, ':')
                    
                    % nothing, no indexing -> all rows returned
                    
                else
                    
                    errID = 'subsref:UnknownTimeIntervalFormat';
                    errMsg = 'Incorrect indexing of time interval - unknown format!';
                    error(errID, errMsg);
                    
                end
                
                if numel(s(1).subs) >= 2
                    
                    tagsInput = s(1).subs{2};
                    
                    if isnumeric(tagsInput) % direct index = column index
                        
                        tagsIndices = tagsInput;
                        extractTags = 1;
                        
                    elseif isequal(tagsInput, ':')
                        
                         % nothing, no indexing -> all tags returned
                        
                    elseif ischar(tagsInput) % one string given -> extract only one tag
                        
                        tagsIndices = obj.getTagIndices({tagsInput});
                        extractTags = 1;
                        
                    elseif iscellstr(tagsInput) % if cell array -> extract all tags
                        
                        tagsIndices = obj.getTagIndices(tagsInput);
                        extractTags = 1;
                        
                    else
                        
                        errID = 'subsref:IncorrectTagIndexing';
                        errMsg = 'Incorrect tag indexing! Tags must be given as direct index, '':'', string or cell array of strings!';
                        error(errID, errMsg);
                        
                    end
                end              
                
                returnObject = copy(obj);
                                
                if extractTags && extractRows
                    
                    returnObject.keepRowsOfData(intervalI);
                    returnObject.keepTagsOfData(tagsIndices);
                    returnObject.extractRowsOfSymbReps(intervalI);
                    returnObject.extractRowsOfSegsReps(intervalI);
%                     if~isempty(returnObject.segments)
%                         
%                         returnObject.segments = returnObject.segments.extractRows(intervalI);
%                         
%                     end
                    
                elseif extractTags && ~extractRows
                    
                    returnObject.keepTagsOfData(tagsIndices);
                    
                elseif ~extractTags && extractRows
                    
                    returnObject.keepRowsOfData(intervalI);
                    returnObject.extractRowsOfSymbReps(intervalI);
                    returnObject.extractRowsOfSegsReps(intervalI);
%                     if~isempty(returnObject.segments)
%                         
%                         returnObject.segments = returnObject.segments.extractRows(intervalI);
%                         
%                     end
                    
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
            % Purpose : Extract a subset of the data in the object and
            % return it as new object
            %
            % Syntax :
            %   returnObject = mdtsObject.getData(tagList)
            %   returnObject = mdtsObject.getData(tagList, timeInterval)
            %
            % Input Parameters :
            %   tagList : All tags of the required data subset as cell
            %   array of strings
            %
            %   timeInterval : time interval of the required data subset as
            %   vector with two elements, where the first element
            %   represents the start of the interval and the second element
            %   represents the end of the interval
            %
            % Return Parameters :
            %   returnObject : mdtsObject with the extracted data
            
            nArguments = numel(varargin);
    
            intervalIndices = [1; numel(obj.time)];
    
            switch nArguments
                   
                case 1 %getData(tagList)
            
                    tagList = varargin{1};
            
                case 2 %getData(tagList, timeInterval)
            
                    tagList = varargin{1};
                    
                    if ischar(varargin{2})
                        
                        dateString = varargin{2};
                        [timeInterval(1), timeInterval(2)] = obj.startEndOfDate(dateString);
                        
                    else
                        
                        timeInterval = varargin{2};
                        
                    end
                    
                    intervalIndices = obj.getIntervalIndices(timeInterval);
            
            end
    
            s = struct;
            s.type = '()';
            s.subs = {intervalIndices(1) : intervalIndices(end), tagList};
            
            returnObject = obj.subsref(s);
    
            if(numel(tagList) < numel(obj.tags) || intervalIndices(1) > 1 || intervalIndices(end) < numel(obj.time))
        
                returnObject.isSubset = true;
                
            end
             
        end
        
        function dataMat = getRawData(obj, varargin)
            % Purpose : Extract data according to the given inputs
            %
            % Syntax :
            %   dataMat = mdtsCoreObject.getRawData(tagList)
            %   dataMat = mdtsCoreObject.getRawData(tagList, timeInterval)
            %
            % Input Parameters :
            %   tagList : All tags of the required data subset as cell
            %   array of strings
            %
            %   timeInterval : time interval of the required data subset as
            %   vector with two elements, where the first element
            %   represents the start of the interval and the second element
            %   represents the end of the interval
            %
            % Return Parameters :
            %   dataMat : matrix with the data
            
            extractedObject = getData(obj, varargin{:});
            
            dataMat = extractedObject.data;
            
        end
        
        function tagIndices = getTagIndices(obj, tagList)
            % Purpose : Return the indices of the given tags
            %
            % Syntax :
            %   tagIndices = mdtsObject.getTagIndices(tagList)
            %
            % Input Parameters :
            %   tagList : All tags of the required data subset as cell
            %   array of strings
            %
            % Return Parameters :
            %   tagIndices : Indices of the required tags as array 
            
            [Lia, idx] = ismember(obj.tags, tagList);
            indVec = 1 : numel(obj.tags);
            indVec = indVec(Lia);
            idx = idx(Lia);
            [~, idxSort] = sort(idx);
            tagIndices = indVec(idxSort);
            
        end
        
        function intervalIndices = getIntervalIndices(obj, timeInterval)
            % Purpose : Return the indices of the given interval
            %
            % Syntax :
            %   intervalIndices = mdtsObject.getIntervalIndices(timeInterval)
            %
            % Input Parameters :
            %   timeInterval : Two time stamps as datenum, given as vector
            %   with two elements
            %
            % Return Parameters :
            %   intervalIndices : Indices of the required time interval.
            %   The returned indices include the given interval.
            
            startI = find(obj.time >= timeInterval(1), 1);
            endI = find(obj.time <= timeInterval(end), 1, 'last');
            
            intervalIndices = [startI; endI];
            
        end
        
        function correctTags = checkTags(obj, tagList)
            % Purpose : Check if all given tags are available within the
            % object
            %
            % Syntax :
            %   correctTags = mdtsObject.checkTags(tagList)
            %
            % Input Parameters :
            %   tagList : All tags of the required data subset as cell
            %   array of strings
            %
            % Return Parameters :
            %   correctTags : True if ALL given tags are available within
            %   the object, False otherwise
                       
            memberships = ismember(tagList, obj.tags);
            correctTags = logical(prod(memberships));
            
        end
        
        function [startDateNum, endDateNum] = startEndOfDate(obj, dateString)
            % Purpose : Return start and end of a time interval given as
            % string as datenum time stamps
            %
            % Syntax :
            %   [startDateNum, endDateNum] = mdtsObject.startEndOfDate(dateString)
            %
            % Input Parameters :
            %   dateString : Time interval given as string, e.g. '2016-08',
            %   '2017', '2018-01-12', etc.
            %
            % Return Parameters :
            %   startDateNum : First available time stamp of the given time
            %   interval as datenum
            %   endDateNum : Last available time stamp of the given time
            %   interval as datenum
            
            defVec = zeros(1, 6); %for Year, Month, Day, Hour, Minutes, Seconds
            defVec([2,3]) = 1; %day and month start with 1
            
            n = numel(strsplit(dateString, {' ', '-', ':'}));
            
            if(regexpi(dateString, '^[a-zA-Z]{3}-\d{4}$'))
                
                monthName = regexpi(dateString, '[a-zA-Z]{3}', 'match');
                theMonth = strfind({'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'}, monthName{1});
                monthNum = find(not(cellfun('isempty', theMonth)));
                
                dateParts = strsplit(dateString, '-');
                year = str2double(dateParts{2});
                dateVec = defVec;
                dateVec(1) = year;
                dateVec(2) = monthNum;
                
            elseif(regexpi(dateString, '^\d{4}$'))
                
                dateVec = str2double(dateString);
                dateVec(numel(dateVec) + 1 : 6) = defVec(numel(dateVec) + 1 : 6);
                
            else
                
                dateVec = datevec(dateString);
                
            end      
            
            startVec = dateVec;
            endVec = dateVec;
            endVec(n) = endVec(n) + 1;
            
            startDateNum = datenum(startVec);
            endDateNum = datenum(endVec) - 1;
            
        end
        
        function obj = expandDataSet(obj, addData, addTags)
            % Purpose : Expand the data set of the object by the given data
            % in the given tags
            %
            % Syntax :
            %   mdtsObject = mdtsObject.expandDataSet(addData, addTags)
            %
            % Input Parameters :
            %   addData : Data set to be added to the objects data set,
            %   given as numeric n x m matrix
            %   addTags : Tags of the data set to be added to the objects
            %   data set, given as 1 x m cell array of strings
            %
            % Return Parameters :
            %   mdtsObject : Original object with the expanded data set
            
            addUnits = cell(1, numel(addTags));
            addUnits(:) = {'-'};
            
            obj.data = [obj.data, addData];
            obj.tags = [obj.tags, addTags];
            obj.units = [obj.units, addUnits];
            obj.symbReps = [obj.symbReps, cell(1, numel(addTags))];
            
        end
        
        function obj = addEvent(obj, eventID, eventTime, eventDuration)
            % Purpose : Add event to the object
            %
            % Syntax :
            %   mdtsObject = mdtsObject.addEvent(eventID, eventTime, eventDuration)
            %
            % Input Parameters :
            %   eventID : Identification of the event as string
            %
            %   eventTime : Time stamp of the event as datenum
            %
            %   eventDuration : duration of the event as number of time
            %   stamps
            %
            % Return Parameters :
            %   mdtsObject : Original object with the added event
            
            eventInfo.eventTime = eventTime;
            eventInfo.eventDuration = eventDuration;
            
            obj.tsEvents(eventID) = eventInfo;
            
        end
        
        function obj = addSymbRepToChannel(obj, channelNumber, symbObj)
            % Purpose : Add symbolic representation to channel
            %
            % Syntax :
            %   mdtsCoreObject = mdtsCoreObject.addSymbRepToChannel(channelNumber, symbObj)
            %
            % Input Parameters :
            %   channelNumber : channel number or tag indices of the
            %   according channel/tag
            %
            %   symbObj : symbolicObject with the corresponding symbolic
            %   representation
            %
            % Return Parameters :
            %   mdtsObject : Original object with the added symbolic
            %   representation
            
            obj.symbReps{channelNumber} = symbObj;
            
        end
        
        function obj = addSymbRepToAllChannels(obj, symbObj, keepExistentSymbReps)
            % Purpose : Add symbolic representation to all channels which
            % do not have a symbolic representation assigned
            %
            % Syntax :
            %   mdtsCoreObject = mdtsCoreObject.addSymbRepToAllChannels(symbObj)
            %
            % Input Parameters :
            %   symbObj : symbolicObject with the corresponding symbolic
            %   representation
            %
            %   keepExistentSymbReps : Flag to indicate if existent
            %   symbolic representations in the mdtsObject shall be
            %   preserved. All existen symbolic representations are
            %   overwritten when false and preserved when true.
            %
            % Return Parameters :
            %   mdtsObject : Original object with the added symbolic
            %   representations
            
            if(keepExistentSymbReps)
                
                nonEmtpySymbReps = find(cellfun(@isempty, obj.symbReps));
                
                for i = nonEmtpySymbReps
                    
                    obj.symbReps{i} = symbObj;
                    
                end
                
            else
                
                for i = 1 : numel(obj.symbReps)
                    
                    obj.symbReps{i} = symbObj;
                    
                end
                
            end
            
        end
        
        function obj = addSegments(obj, segmentsObj)
            % Purpose : Add segmentsObject to mdtsCoreObject
            %
            % Syntax :
            %   mdtsCoreObject = mdtsCoreObject.addSegments(segmentsObj)
            %
            % Input Parameters :
            %   segmentsObj : segmentsObject to be added to the mdtsObject
            %
            % Return Parameters :
            %   mdtsObject : Original object with the added segmentsObject
            
%             obj.segments = segmentsObj;a
            obj = obj.addSegmentsToAllChannels(segmentsObj,false );
            
        end
        
        function obj = addSegmentsToAllChannels(obj,segmentsObj, keepExistentSegReps)
            if(keepExistentSegReps)
                
                nonEmtpySegReps = find(cellfun(@isempty, obj.segments));
                for i = nonEmtpySegReps 
                    obj.segments{i} = segmentsObj;         
                end
            else
                for i = 1 : numel(obj.segments) 
                    obj.segments{i} = segmentsObj;
                end
            end
        end
        
        function obj = addSegmentsToChannels(obj,segmentsObj, channelNumber)
            obj.segments{channelNumber} = segmentsObj;
        end
                
    end
    
    methods(Access = protected)
        
        function keepRowsOfData(obj, intervalIndices)
            % Purpose : Delete all data of time stamps which are not given
            %
            % Syntax :
            %   keepRowsOfData(intervalIndices)
            %
            % Input Parameters :
            %   intervalIndices : All indices of the time stamps which are
            %   supposed to remain in the data set
            %
            % Return Parameters :
            
            obj.time = obj.time(intervalIndices(1) : intervalIndices(end));
            obj.data = obj.data(intervalIndices(1) : intervalIndices(end), :);
        
        end
        
        function keepTagsOfData(obj, tagsI)
            % Purpose : Delete all data of tags which are not given
            %
            % Syntax :
            %   keepTagsOfData(tagsI)
            %
            % Input Parameters :
            %   tagsI : All indices of the tags which are supposed to
            %   remain in the data set
            %
            % Return Parameters :
                   
            obj.data = obj.data(:, tagsI);
            obj.tags = obj.tags(tagsI);
            obj.units = obj.units(tagsI);
            obj.symbReps = obj.symbReps(tagsI);
        
        end
        
        function extractRowsOfSymbReps(obj, intervalIndices)
            % Purpose : Extract all symbols and druations from the
            % symbRepObjects of all channels, according to the input
            %
            % Syntax :
            %   extractRowsOfSymbReps(intervalIndices)
            %
            % Input Parameters :
            %   intervalIndices : All indices of the time stamps which have
            %   to be extracted
            %
            % Return Parameters :
            
            for i = 1 : numel(obj.symbReps)
                
                if ~isempty(obj.symbReps{i})
                    
                    obj.symbReps{i} = obj.symbReps{i}.getTimeInterval(intervalIndices);
                    
                end
                
            end
            
        end
        
        
        function extractRowsOfSegsReps(obj, intervalIndices)
            % Purpose : Extract all segments and druations from the
            % segmentsObject of all channels, according to the input
            %
            % Syntax :
            %   extractRowsOfSegsReps(intervalIndices)
            %
            % Input Parameters :
            %   intervalIndices : All indices of the time stamps which have
            %   to be extracted
            %
            % Return Parameters :
            
            for i = 1 : numel(obj.segments)
                
                if ~isempty(obj.segments{i})
                    
                    obj.segments{i} = obj.segments{i}.extractRows(intervalIndices);
                    
                end
                
            end
            
        end
        
    end
        
end


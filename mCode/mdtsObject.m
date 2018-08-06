classdef mdtsObject < mdtsCoreObject
    %
    % Description : Inherits from the core object, checks validity of input
    % data and passes it to the core object
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
        
        timeType
        
    end
    
    properties(Dependent)
        
        timeInFormat
        
    end
    
    methods
        
        function obj = mdtsObject(time, data, tags, varargin)
            
            p = inputParser;
            defaultUnits = cell(1, numel(tags));
            defaultUnits(:) = {'-'};
            defaultts = [];
            defaultName = 'Time Series';
            defaultWho = 'Author';
            defaultWhen = 'Now';
            defaultDescription = 'No description available';
            defaultComment = 'No comment available';
            defaulttsEvents = containers.Map;
            defaultSymbRep = cell(1, numel(tags));
            defaultSegments = {};
            
            if(isa(time, 'numeric'))
                
                if(time(1) <= 1)
                    
                    timeType = 0;
                    
                else
                    
                    timeType = 1;
                    
                end
            
                addRequired(p, 'timeIn', @(x)validateattributes(x, {'numeric', 'nonempty'}, {'size', [size(data, 1), 1]}));            
                
                
            elseif(isa(time, 'datetime'))                
                
                addRequired(p, 'timeIn', @(x)validateattributes(x, {'datetime', 'nonempty'}, {'size', [size(data, 1), 1]}));            
                timeType = 2;
                
            elseif(isa(time, 'duration'))                
                
                addRequired(p, 'timeIn', @(x)validateattributes(x, {'duration', 'nonempty'}, {'size', [size(data, 1), 1]}));            
                timeType = 3;
                
            else
                
                errID = 'mdtsObject:InvalidTimeFormat';
                errMsg = 'Invalid format of time vector! Time vector must be given as numeric, datenum, datetime or duration!';
                error(errID, errMsg);
                
            end
                
            addRequired(p, 'dataIn', @(x)validateattributes(x, {'numeric'}, {'nonempty'}));
            addRequired(p, 'tagsIn', @(x)validateattributes(x, {'cell', 'nonempty'}, {'size', [1, size(data, 2)]}));
            
            addParameter(p, 'units', defaultUnits, @(x)validateattributes(x, {'cell', 'nonempty'}, {'size', [1, size(data, 2)]}));
            addParameter(p, 'ts', defaultts, @(x)validateattributes(x, {'duration', 'nonempty'}, {'size', [1, 1]}));
            addParameter(p, 'name', defaultName, @(x)validateattributes(x, {'char'}, {'nonempty'}));
            addParameter(p, 'who', defaultWho, @(x)validateattributes(x, {'char'}, {'nonempty'}));
            addParameter(p, 'when', defaultWhen, @(x)validateattributes(x, {'char'}, {'nonempty'}));
            addParameter(p, 'description', defaultDescription, @(x)validateattributes(x, {'char', 'cell'}, {'nonempty'}));
            addParameter(p, 'comment', defaultComment, @(x)validateattributes(x, {'char', 'cell'}, {'nonempty'}));
            addParameter(p, 'tsEvents', defaulttsEvents, @(x)validateattributes(x, {'containers.Map'}, {'nonempty'}));
            addParameter(p, 'symbReps', defaultSymbRep, @(x)validateattributes(x, {'cell', 'nonempty'}, {'size', [1, size(data, 2)]}));
            addParameter(p, 'segments', defaultSegments, @(x)validateattributes(x, {'segmentsObject'}, {'nonempty'}));
            
            parse(p, time, data, tags, varargin{:});
            
            if(timeType == 0 || timeType == 1)
                
                timeVector = p.Results.timeIn;
                
            elseif(timeType == 2)
                
                timeVector = datenum(p.Results.timeIn);
                
            elseif(timeType == 3)
                
                timeVector = seconds(p.Results.timeIn);
                
            end
            
            obj@mdtsCoreObject(timeVector, p.Results.dataIn, p.Results.tagsIn, p.Results.units, p.Results.ts, p.Results.name, p.Results.who, p.Results.when, p.Results.description, p.Results.comment, p.Results.tsEvents, p.Results.symbReps, p.Results.segments);
            
            obj.timeType = timeType;
            
        end
        
        function timeInFormat = get.timeInFormat(obj)
            % Purpose : convert time of the core object into the correct
            % format (according to the input given to the construtctor)
            %
            % Syntax : timeInFormat = mdtsObject.timeInFormat
            %
            % Input Parameters :
            %
            % Return Parameters :
            %   timeInFormat : time vector in correct format
            
            if(obj.timeType == 0 || obj.timeType == 1)
                
                timeInFormat = obj.time;
                
            elseif(obj.timeType == 2)
                
                timeInFormat = datetime(datestr(obj.time));
                
            elseif(obj.timeType == 3)

                timeInFormat = duration(0, 0, obj.time);
                
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
    
            if(nArguments > 2 || nArguments == 0)
            
                    errID = 'getData:InvalidNumberOfInputs';
                    errMsg = 'Invalid number of input arguments!';
                    error(errID, errMsg);
                    
            elseif(nArguments == 2)
                
                tags = varargin{1};
                timeInterval = obj.convert2Datenum(varargin{2});
                
                returnObject = getData@mdtsCoreObject(obj, tags, timeInterval); 
                
            elseif(nArguments == 1)
                
                tags = varargin{1};
                
                returnObject = getData@mdtsCoreObject(obj, tags); 
                
            end
            
        end
        
        function dataMat = getRawData(obj, varargin)
            % Purpose : Extract data according to the given inputs
            %
            % Syntax :
            %   dataMat = mdtsObject.getRawData(tagList)
            %   dataMat = mdtsObject.getRawData(tagList, timeInterval)
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
            
            nArguments = numel(varargin);
    
            if(nArguments > 2 || nArguments == 0)
            
                    errID = 'getRawData:InvalidNumberOfInputs';
                    errMsg = 'Invalid number of input arguments!';
                    error(errID, errMsg);
                    
            elseif(nArguments == 2)
                
                tags = varargin{1};
                timeInterval = obj.convert2Datenum(varargin{2});
                
                dataMat = getRawData@mdtsCoreObject(obj, tags, timeInterval); 
                
            elseif(nArguments == 1)
                
                tags = varargin{1};
                
                dataMat = getRawData@mdtsCoreObject(obj, tags); 
                
            end
            
        end
        
        function tagIndices = getTagIndices(obj, tagList)
            % Purpose : Return the indices of the given tags
            %
            % Syntax :
            %   tagIndices = mdtsObject.getTagIndices(tagList)
            %
            % Input Parameters :
            %   tagList : All tags of the required data subset as cell
            %   array of strings or string (in case of one tag)
            %
            % Return Parameters :
            %   tagIndices : Indices of the required tags as array 
            
            validateattributes( tagList, {'cell', 'char'}, {'nonempty'}, '', 'tagList');
            
            if~iscell(tagList)
                
                tagList = {tagList};
                
            end
                       
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
            
            timeIntervalDatenum = obj.convert2Datenum(timeInterval);
            
            if(timeIntervalDatenum(1) >= obj.time(1) && timeIntervalDatenum(end) <= obj.time(end))
                
                intervalIndices = getIntervalIndices@mdtsCoreObject(obj, timeIntervalDatenum); 
                
            else
                
                errID = 'getIntervalIndices:IntervalOutOfBoundaries';
                errMsg = 'Specified interval exceeds the boundaries of the data!';
                error(errID, errMsg);
                
            end
            
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
        
        function obj = addEvent(obj, eventID, eventTime, eventDuration)
            % Purpose : Add event to the object
            %
            % Syntax :
            %   mdtsObject = mdtsObject.addEvent(eventID, eventTime, eventDuration)
            %
            % Input Parameters :
            %   eventID : Identification of the event as string
            %
            %   eventTime : Time stamp of the event as datenum. Multiple
            %   occurrence of the event can be given as vector including
            %   all time stamps.
            %
            %   eventDuration : duration of the event as (integer) number
            %   of time stamps. Multiple occurrence of the event can be
            %   given as vector including all durations.
            %
            % Return Parameters :
            %   mdtsObject : Original object with the added event
            
            eventTimeDatenum = obj.convert2Datenum(eventTime);
            
            if~isa(eventID, 'char')
                
                errID = 'addEvent:InvalidEventID';
                errMsg = 'Variable eventID must be a string!';
                error(errID, errMsg);
                
            elseif~(numel(eventTimeDatenum) == numel(eventDuration))
                
                errID = 'addEvent:TimesInconsistent';
                errMsg = 'eventTime and eventDuration must have the same number of elements!';
                error(errID, errMsg);
                
            elseif~isa(eventDuration, 'integer')
                
                errID = 'addEvent:InvalidEventDuration';
                errMsg = 'Event duration must be an integer (array)!';
                error(errID, errMsg);
                
            elseif~prod(ismember(eventTimeDatenum, obj.time))
                
                errID = 'addEvent:EventTimeNotAvailable';
                errMsg = 'Only time stemps available within the data set are permitted as eventTime!';
                error(errID, errMsg);
                
            end
            
            obj = addEvent@mdtsCoreObject(obj, eventID, eventTimeDatenum, eventDuration);
            
        end
        
        function obj = addSymbRepToChannel(obj, channelNumber, symbObj)
            % Purpose : Add symbolic representation to channel
            %
            % Syntax :
            %   mdtsObject = mdtsObject.addSymbRepToChannel(channelNumber, symbObj)
            %
            % Input Parameters :
            %   channelNumber : channel number or tag indices of the
            %   according channel/tag
            %
            %   symbObj : SymbRepObject with the corresponding symbolic
            %   representation
            %
            % Return Parameters :
            %   mdtsObject : Original object with the added symbolic
            %   representation
            
            if~isa(symbObj, 'SymbRepObject')
                
                errID = 'addSymbRepToChannel:NotASymbRepObject';
                errMsg = 'The input symbObj must be of class SymbRepObject!';
                error(errID, errMsg);
                
            elseif~isa(channelNumber, 'numeric')
                
                errID = 'addSymbRepToChannel:InvalidChannelNumber';
                errMsg = 'Channel number must be numeric!';
                error(errID, errMsg);
                
            end
                                   
            obj = addSymbRepToChannel@mdtsCoreObject(obj, channelNumber, symbObj);
            
        end
        
        function obj = addSymbRepToAllChannels(obj, symbObj, varargin)
            % Purpose : Add symbolic representation to all channels which
            % do not have a symbolic representation assigned
            %
            % Syntax :
            %   mdtsCoreObject = mdtsObject.addSymbRepToAllChannels(symbObj)
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
            
            p = inputParser;
            defaultKeepExistentSymbReps = false;
            addParameter(p, 'keepExistentSymbReps', defaultKeepExistentSymbReps, @(x)validateattributes(x, {'logical'}, {'nonempty'}));
            parse(p, varargin{:});
            
            keepExistentSymbReps = p.Results.keepExistentSymbReps;
            
            if~isa(symbObj, 'SymbRepObject')
                
                errID = 'addSymbRepToAllChannels:NotASymbRepObject';
                errMsg = 'The input symbObj must be of class SymbRepObject!';
                error(errID, errMsg);
                
            end
                                   
            obj = addSymbRepToAllChannels@mdtsCoreObject(obj, symbObj, keepExistentSymbReps);
            
        end
        
        function obj = addSegments(obj, segmentsObj)
            % Purpose : Add segmentsObject to mdtsObject
            %
            % Syntax :
            %   mdtsObject = mdtsObject.addSegments(segmentsObj)
            %
            % Input Parameters :
            %   segmentsObj : segmentsObject to be added to the mdtsObject
            %
            % Return Parameters :
            %   mdtsObject : Original object with the added segmentsObject
            
            if~isa(segmentsObj, 'segmentsObject')
                
                errID = 'addSegments:NotASegmentsObject';
                errMsg = 'The input segmentsObj must be of class segmentsObject!';
                error(errID, errMsg);
                
            elseif~isempty(obj.segments)
                
                errID = 'addSegments:SegmentsAlreadyAdded';
                errMsg = 'A segmentsObject was already added to the mdtsObject!';
                error(errID, errMsg);
                
            elseif~(segmentsObj.nTimestamps == numel(obj.time))
                
                errID = 'addSegments:InvalidNumberOfTimestamps';
                errMsg = 'The input segmentsObj must be of the same size as the time vector of the mdtsObject!';
                error(errID, errMsg);
                
            end
            
            obj = addSegments@mdtsCoreObject(obj, segmentsObj);
            
        end
        
        function timeDateNum = convert2Datenum(obj, timeInput)
            % Purpose : Convert timeInput to datenum
            %
            % Syntax :
            %   timeDateNum = mdtsObject.convert2Datenum(timeInput)
            %
            % Input Parameters :
            %   timeInput : time in input format
            %
            % Return Parameters :
            %   timeDateNum : Time in datenum format
            %
            
            if(isa(timeInput, 'numeric'))
            
                timeDateNum = timeInput;            
                
                
            elseif(isa(timeInput, 'datetime'))                
                
                timeDateNum = datenum(timeInput);
                
            elseif(isa(timeInput, 'duration'))                
                
                timeDateNum = seconds(timeInput);
                
            else
                
                errID = 'convert2Datenum:InvalidTimeFormat';
                errMsg = 'Invalid format of time vector! Time vector must be given as numeric, datenum, datetime or duration!';
                error(errID, errMsg);
                
            end
            
        end
        
    end
    
end


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
            defaultSegmentations = cell(1, numel(tags));
            
            addRequired(p, 'timeIn', @(x)validateattributes(x, {'numeric', 'nonempty'}, {'size', [size(data, 1), 1]}));            
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
            addParameter(p, 'symbReps', defaultSegmentations, @(x)validateattributes(x, {'cell', 'nonempty'}, {'size', [1, size(data, 2)]}));
            
            parse(p, time, data, tags, varargin{:});
            
            obj@mdtsCoreObject(p.Results.timeIn, p.Results.dataIn, p.Results.tagsIn, p.Results.units, p.Results.ts, p.Results.name, p.Results.who, p.Results.when, p.Results.description, p.Results.comment, p.Results.tsEvents, p.Results.symbReps);
            
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
                    
            else
                
                returnObject = getData@mdtsCoreObject(obj, varargin); 
                
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
            
            if(~isa(timeInterval, 'double'))
                
                errID = 'getIntervalIndices:InputNoDatenum';
                errMsg = 'Given input is not a datenum vector!';
                error(errID, errMsg);
            
            elseif(timeInterval(1) >= obj.time(1) && timeInterval(end) <= obj.time(end))
                
                intervalIndices = getIntervalIndices@mdtsCoreObject(obj, timeInterval); 
                
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
            
            if~isa(eventID, 'char')
                
                errID = 'addEvent:InvalidEventID';
                errMsg = 'Variable eventID must be a string!';
                error(errID, errMsg);
                
            elseif~(numel(eventTime) == numel(eventDuration))
                
                errID = 'addEvent:TimesInconsistent';
                errMsg = 'eventTime and eventDuration must have the same number of elements!';
                error(errID, errMsg);
                
            elseif~isa(eventTime, 'numeric')
                
                errID = 'addEvent:InvalidEventTime';
                errMsg = 'Event time must be a datenum (array)!';
                error(errID, errMsg);
                
            elseif~isa(eventDuration, 'integer')
                
                errID = 'addEvent:InvalidEventDuration';
                errMsg = 'Event duration must be an integer (array)!';
                error(errID, errMsg);
                
            elseif~prod(ismember(eventTime, obj.time))
                
                errID = 'addEvent:EventTimeNotAvailable';
                errMsg = 'Only time stemps available within the data set are permitted as eventTime!';
                error(errID, errMsg);
                
            end
            
            obj = addEvent@mdtsCoreObject(obj, eventID, eventTime, eventDuration);
            
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
                
                errID = 'addSymbRepToChanne:InvalidChannelNumber';
                errMsg = 'Event duration must be numeric!';
                error(errID, errMsg);
                
            end
                                   
            obj = addSymbRepToChannel@mdtsCoreObject(obj, channelNumber, symbObj);
            
        end
        
    end
    
end


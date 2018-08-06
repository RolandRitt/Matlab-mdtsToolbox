classdef segmentsObject
    %
    % Description : Holds logical vectors which represent segments with
    % different meaning in different channels
    %
    % Author :
    %    Paul O'Leary
    %    Roland Ritt
    %    Thomas Grandl
    %
    % History :
    % \change{1.0}{08-May-2018}{Original}
    %
    % --------------------------------------------------
    % (c) 2018, Paul O'Leary
    % Chair of Automation, University of Leoben, Austria
    % email: automation@unileoben.ac.at
    % url: automation.unileoben.ac.at
    % --------------------------------------------------
    %
    
    properties
        
        nTimestamps
        
        tags
        starts
        durations        
        
    end
    
    methods
        
        function obj = segmentsObject(nTimestamps)
            
            if~isnumeric(nTimestamps)
                
                errID = 'segmentsObject:InvalidInputnTimestamps';
                errMsg = 'Input nTimestamps must be numeric!';
                error(errID, errMsg);
                
            end
            
            obj.nTimestamps = nTimestamps;
            
            obj.tags = {};
            obj.starts = {};
            obj.durations = {};
            
        end
        
        function obj = addSegmentVector(obj, tagName, bVec)
            % Purpose : add a logical vector to the object
            %
            % Syntax : obj = addSegmentVector(tagName, bVec)
            %
            % Input Parameters :
            %   tagName : Name of the channel to be added
            %   bVec : logical vector representing the segments
            %
            % Return Parameters :
            %
            
            if~ischar(tagName)
                
                errID = 'addSegmentVector:InvalidInputtagName';
                errMsg = 'Input tagName must be a string (char array)!';
                error(errID, errMsg);
                
            end
            
            if~islogical(bVec)
                
                errID = 'addSegmentVector:InvalidInputbVec';
                errMsg = 'Input bVec must be a logical vector!';
                error(errID, errMsg);
                
            end
            
            obj.tags = [obj.tags, tagName];
            
            valueChange = [bVec(1); diff(bVec) ~= 0];
            changeInds = find(valueChange);
            durationInds = diff(find([valueChange; 1]));
            
            obj.starts = [obj.starts, {changeInds(1 : 2 : end)}];
            obj.durations = [obj.durations, {durationInds(1 : 2 : end)}];
                        
        end
        
        function bVec = getLogicalVector(obj, tagName)
            % Purpose : return logical vector which represents all segments
            % of channel tagName
            %
            % Syntax : bVec = segmentsObject.getLogicalVector(tagName)
            %
            % Input Parameters :
            %   tagName : Name of the required channel
            %
            % Return Parameters :
            %   bVec : logical (boolean) vector which represents the
            %   segments
            
            if~ischar(tagName)
                
                errID = 'getLogicalVector:InvalidInputtagName';
                errMsg = 'Input tagName must be a string (char array)!';
                error(errID, errMsg);
                
            end
            
            tagNo = find(ismember(obj.tags, tagName));
            
            bVec = false(obj.nTimestamps, 1);
            
            for i = 1 : numel(obj.starts{tagNo})
                
                bVec(obj.starts{tagNo}(i) : obj.starts{tagNo}(i) + obj.durations{tagNo}(i) - 1) = true;
                
            end
            
        end
        
        function lVec = getLabeledVector(obj, tagName)
            % Purpose : return labeled vector which represents all segments
            % of channel tagName with according labels
            %
            % Syntax : lVec = segmentsObject.getLabeledVector(tagName)
            %
            % Input Parameters :
            %   tagName : Name of the required channel
            %
            % Return Parameters :
            %   lVec : numerical vector which represents the labeled
            %   segments
            
            if~ischar(tagName)
                
                errID = 'getLabeledVector:InvalidInputtagName';
                errMsg = 'Input tagName must be a string (char array)!';
                error(errID, errMsg);
                
            end
            
            lVec = bwlabel(obj.getLogicalVector(tagName));
            
        end
        
        function newObj = extractRows(obj, intervalIndices)
            % Purpose : extract time stamps from all channels
            %
            % Syntax : obj = extractRows(intervalIndices)
            %
            % Input Parameters :
            %   intervalIndices : All indices of the time stamps which have
            %   to be extracted
            %
            % Return Parameters :
            %
            
            if~(isnumeric(intervalIndices) && isequal(size(intervalIndices), [1, 2]))
                
                errID = 'extractRows:InvalidInputintervalIndices';
                errMsg = 'Input intervalIndices must be a numerical vector of size [1, 2]!';
                error(errID, errMsg);
                
            end
            
            newNTimestamps = sum(intervalIndices(2) - intervalIndices(1) + 1);
            
            newObj = segmentsObject(newNTimestamps);
            
            for i = 1 : numel(obj.tags)
                
                tempTagName = obj.tags{i};
                
                tempVec = obj.getLogicalVector(tempTagName);
                
                newObj = newObj.addSegmentVector(tempTagName, tempVec(intervalIndices(1) : intervalIndices(2)));
                
            end
            
        end

    end
end


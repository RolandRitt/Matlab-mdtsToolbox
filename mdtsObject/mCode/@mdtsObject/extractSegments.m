function arrayOfmdtsObjects = extractSegments(inputObject, segmentTag, tagName, varargin)
% data handling
%
% Purpose : extract segments of the given mdtsObject
%
% Syntax : plotSegments(inputObject, varargin)
%
% Input Parameters :
%   inputObject : mdtsObject (with multiple channels)
%
%   segmentTag : Tag of the required segment as string (character array)
%   tagName : tag/channel name to which the segments are assigned
%   frameLength : (optional key-value pair, default = 0) defining how much 
%   data points should be additionally returned to the beginning and at the
%   end of each segment.
%   
%
% Return Parameters :
%   arrayOfmdtsObjects : Cell array of mdtsObject
%
% Description : 
%   Use the 'getData' function of the mdtsObject to extract every occurance
%   of true values in 'segmentTag'. 
%
% Author : 
%   Paul O'Leary
%   Roland Ritt
%   Thomas Grandl
%
% History :
% \change{1.0}{14-May-2018}{Original}
%
% --------------------------------------------------------
% (c) 2018 Paul O'Leary,
% Chair of Automation, University of Leoben, Leoben, Austria
% email: office@harkeroleary.org,
% url: www.harkeroleary.org
% --------------------------------------------------------

%% Parse inputs

defaultFrameLength = 0;

p = inputParser();
addRequired(p, 'inputObject', @(x) isa(x, 'mdtsObject')); %check if input is mdtsObject
addRequired(p, 'segmentTag', @(x) isa(x, 'char')); %check if tag is a char array
addRequired(p, 'tagName', @(x) isa(x, 'char')); %check if tag is a char array
addParameter(p, 'frameLength', defaultFrameLength, @(x)isnumeric(x));

parse(p, inputObject, segmentTag, tagName, varargin{:});

inputObject = p.Results.inputObject;
segmentTag = p.Results.segmentTag;
frameLength = p.Results.frameLength;
tagName = p.Results.tagName;

%% Extract Data
ChannelNr = inputObject.getTagIndices(tagName);
segmentsObj = inputObject.segments{ChannelNr};



tagNo = find(ismember(segmentsObj.tags, segmentTag));

starts = segmentsObj.starts{tagNo};
durations = segmentsObj.durations{tagNo};

nObj = numel(starts);

allTags = inputObject.tags;

arrayOfmdtsObjects = cell(nObj , 1);

for i = 1 : nObj
    
    xStart = inputObject.timeInFormat(max(starts(i) - frameLength, 1));
    xEnd = inputObject.timeInFormat(min(starts(i) + durations(i) - 1 + frameLength, numel(inputObject.time)));
    timeInterval = [xStart, xEnd];
    
    arrayOfmdtsObjects{i} = inputObject.getData(allTags, timeInterval);

end

end


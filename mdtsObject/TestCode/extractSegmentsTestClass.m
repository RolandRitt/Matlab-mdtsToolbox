classdef extractSegmentsTestClass < matlab.unittest.TestCase
    %
    % Description : Test the extractSegments function
    %
    % Author :
    %    Paul O'Leary
    %    Roland Ritt
    %    Thomas Grandl
    %
    % History :
    % \change{1.0}{14-May-2018}{Original}
    %
    % --------------------------------------------------
    % (c) 2018, Paul O'Leary
    % Chair of Automation, University of Leoben, Austria
    % email: automation@unileoben.ac.at
    % url: automation.unileoben.ac.at
    % --------------------------------------------------
    %
    
    properties
    end
    
    methods (Test)
        
        function testFunctionality(testCase)
            
            nX = 1000;
            nChannels = 4;
            
            ts = duration(0, 0, 1, 0);
            time = zeros(nX, 1);
            data = zeros(nX, nChannels);
            
            for i = 1 : nX
                
                time(i) = datenum(datetime(2017, 7, 31, 14, 3, 3 + i - 1 * seconds(ts)));
                
                data(i, 1) = sin(2 * pi * (2 * i) / (nX)) * 10;
                data(i, 2) = cos(4 * pi * (2 * i) / (nX)) * 5;
                data(i, 3) = exp(5 * i / nX);
                data(i, 4) = round(10 * i / nX);
                
            end
            
            tags = {'Channel 1', 'Channel 2', 'Channel 3', 'Channel 4'};
            units = {'s', 'min', 'Elephants', 'Giraffs'};
            name = 'mdtsPlot Test';
            who = 'Operator';
            when = 'Now';
            description = {'This is a mdtsPlot Test'; 'with two text lines'};
            comment = {'This is'; 'a comment'};
            eventInfo1.eventTime = time(10);
            eventInfo1.eventDuration = int32(0);
            eventInfo2.eventTime = time(100);
            eventInfo2.eventDuration = int32(0);
            eventInfo3.eventTime = time(750);
            eventInfo3.eventDuration = int32(0);
            eventInfo4.eventTime = time(end) + 10 / (60 *60 * 24);
            eventInfo4.eventDuration = int32(0);
            keys = {'Start', 'Middle', 'End', 'Outer'};
            tsEvents = containers.Map(keys, {eventInfo1, eventInfo2, eventInfo3, eventInfo4});
            
            bVec1 = false(nX, 1);
            bVec1(1 : 100) = true;
            bVec1(800 : end) = true;
            tagName1 = 'FirstSegments';
            bVec2 = false(nX, 1);
            bVec2(400 : 600) = true;
            tagName2 = 'SecondSegments';
            bVec3 = false(nX, 1);
            bVec3(1 : 100) = true;
            bVec3(200 : 250) = true;
            bVec3(465 : 589) = true;
            bVec3(800 : end) = true;
            tagName3 = 'ThirdSegments';
            
            segmentsObj = segmentsObject(nX);
            segmentsObj = segmentsObj.addSegmentVector(tagName1, bVec1);
            segmentsObj = segmentsObj.addSegmentVector(tagName2, bVec2);
            segmentsObj = segmentsObj.addSegmentVector(tagName3, bVec3);
            for i = 1:numel(tags)
                segments{i} = segmentsObj;
            end
            
            returns = mdtsObject(time, data, tags, 'units', units, 'ts', ts, 'name', name, 'who', who, 'when', when, 'description', description, 'comment', comment, 'tsEvents', tsEvents, 'segments', segments);
            
            extractTag = tagName3;
            frameLength = 15;
            extractChannel = 'Channel 1';
            arrayOfmdtsObjects = extractSegments(returns, extractTag,extractChannel, 'frameLength', frameLength);
            
            expectedReturn1 = returns.getData(tags, [time(1), time(115)]);
            expectedReturn2 = returns.getData(tags, [time(185), time(265)]);
            expectedReturn3 = returns.getData(tags, [time(450), time(604)]);
            expectedReturn4 = returns.getData(tags, [time(785), time(end)]);
            
            testCase.verifyEqual(arrayOfmdtsObjects{1}, expectedReturn1);
            testCase.verifyEqual(arrayOfmdtsObjects{2}, expectedReturn2);
            testCase.verifyEqual(arrayOfmdtsObjects{3}, expectedReturn3);
            testCase.verifyEqual(arrayOfmdtsObjects{4}, expectedReturn4);
            
        end
        
        
        function testFunctionalitydifferentSegments(testCase)
            
            nX = 1000;
            nChannels = 4;
            
            ts = duration(0, 0, 1, 0);
            time = zeros(nX, 1);
            data = zeros(nX, nChannels);
            
            for i = 1 : nX
                
                time(i) = datenum(datetime(2017, 7, 31, 14, 3, 3 + i - 1 * seconds(ts)));
                
                data(i, 1) = sin(2 * pi * (2 * i) / (nX)) * 10;
                data(i, 2) = cos(4 * pi * (2 * i) / (nX)) * 5;
                data(i, 3) = exp(5 * i / nX);
                data(i, 4) = round(10 * i / nX);
                
            end
            
            tags = {'Channel 1', 'Channel 2', 'Channel 3', 'Channel 4'};
            units = {'s', 'min', 'Elephants', 'Giraffs'};
            name = 'mdtsPlot Test';
            who = 'Operator';
            when = 'Now';
            description = {'This is a mdtsPlot Test'; 'with two text lines'};
            comment = {'This is'; 'a comment'};
            eventInfo1.eventTime = time(10);
            eventInfo1.eventDuration = int32(0);
            eventInfo2.eventTime = time(100);
            eventInfo2.eventDuration = int32(0);
            eventInfo3.eventTime = time(750);
            eventInfo3.eventDuration = int32(0);
            eventInfo4.eventTime = time(end) + 10 / (60 *60 * 24);
            eventInfo4.eventDuration = int32(0);
            keys = {'Start', 'Middle', 'End', 'Outer'};
            tsEvents = containers.Map(keys, {eventInfo1, eventInfo2, eventInfo3, eventInfo4});
            segments = cell(1, numel(tags));
            bVec1 = false(nX, 1);
            bVec1(1 : 100) = true;
            bVec1(800 : end) = true;
            tagName1 = 'FirstSegments';
            bVec2 = false(nX, 1);
            bVec2(400 : 600) = true;
            tagName2 = 'SecondSegments';
            bVec3 = false(nX, 1);
            bVec3(1 : 100) = true;
            bVec3(200 : 250) = true;
            bVec3(465 : 589) = true;
            bVec3(800 : end) = true;
            tagName3 = 'ThirdSegments';
            
            segmentsObj1 = segmentsObject(nX);
            segmentsObj1 = segmentsObj1.addSegmentVector(tagName1, bVec1);
            segmentsObj1 = segmentsObj1.addSegmentVector(tagName2, bVec2);
            segmentsObj1 = segmentsObj1.addSegmentVector(tagName3, bVec3);
            
            segmentsObj2 = segmentsObject(nX);
%             segmentsObj2 = segmentsObj.addSegmentVector(tagName1, bVec1);
            segmentsObj2 = segmentsObj2.addSegmentVector(tagName2, bVec2);
            segmentsObj2 = segmentsObj2.addSegmentVector(tagName3, bVec3);
            
            
            segmentsObj3 = segmentsObject(nX);
            segmentsObj3 = segmentsObj3.addSegmentVector(tagName1, bVec1);
            segmentsObj3 = segmentsObj3.addSegmentVector(tagName2, bVec2);
%             segmentsObj3 = segmentsObj3.addSegmentVector(tagName3, bVec3);
            segments{1} = segmentsObj1;
            segments{2} = segmentsObj2;
            segments{3} = segmentsObj3;
            
            returns = mdtsObject(time, data, tags, 'units', units, 'ts', ts, 'name', name, 'who', who, 'when', when, 'description', description, 'comment', comment, 'tsEvents', tsEvents, 'segments', segments);
            
            extractTag = tagName3;
            frameLength = 15;
            extractChannel = 'Channel 1';
            arrayOfmdtsObjects = extractSegments(returns, extractTag,extractChannel, 'frameLength', frameLength);
            
            expectedReturn1 = returns.getData(tags, [time(1), time(115)]);
            expectedReturn2 = returns.getData(tags, [time(185), time(265)]);
            expectedReturn3 = returns.getData(tags, [time(450), time(604)]);
            expectedReturn4 = returns.getData(tags, [time(785), time(end)]);
            
            testCase.verifyEqual(arrayOfmdtsObjects{1}, expectedReturn1);
            testCase.verifyEqual(arrayOfmdtsObjects{2}, expectedReturn2);
            testCase.verifyEqual(arrayOfmdtsObjects{3}, expectedReturn3);
            testCase.verifyEqual(arrayOfmdtsObjects{4}, expectedReturn4);
            
        end
        
    end
end


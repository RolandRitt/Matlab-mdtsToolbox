classdef mdtsObjectTestClass < matlab.unittest.TestCase
    %
    % Description : Test the mdtsObject class
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
    
    methods (Test)
        
        function testConstructor(testCase)
            
            ts = duration(0, 0, 0, 50);
            time = [datenum(datetime(2017, 7, 31, 14, 3, 3, 123 + 0 * seconds(ts)));
                    datenum(datetime(2017, 7, 31, 14, 3, 3, 123 + 1 * seconds(ts)));
                    datenum(datetime(2017, 7, 31, 14, 3, 3, 123 + 2 * seconds(ts)));
                    datenum(datetime(2017, 7, 31, 14, 3, 3, 123 + 3 * seconds(ts)))];
            data = [9, 8;
                    7, 6;
                    8, 7;
                    6, 5];
            tags = {'Channel 1', 'Channel2'};
            units = {'s', 'min'};
            name = 'TS-Test';
            who = 'Operator';
            when = 'Now';
            description = {'This is a TS-Test'; 'with two text lines'};
            comment = {'This is'; 'a comment'};
            eventInfo.eventTime = datenum('09/01/2018 16:05:06');
            eventInfo.eventDuration = int32(0);
            tsEvents = containers.Map('key1', eventInfo);
            durations = [4; 5];
            symbols = categorical({'a'; 'b'}, 'Ordinal', true);
            segObj = SymbRepObject(durations, symbols);
            symbReps = cell(1, numel(tags));
            symbReps{2} = segObj;
            segments = segmentsObject(100);
            
            returns = mdtsObject(time, data, tags, 'units', units, 'ts', ts, 'name', name, 'who', who, 'when', when, 'description', description, 'comment', comment, 'tsEvents', tsEvents, 'symbReps', symbReps, 'segments', segments);
            returns2 = mdtsObject(time, data, tags);
            
            testCase.verifyEqual(returns.time, time);
            testCase.verifyEqual(returns.data, data);
            testCase.verifyEqual(returns.tags, tags);
            testCase.verifyEqual(returns.units, units);
            testCase.verifyEqual(returns.ts, ts);
            testCase.verifyEqual(returns.uniform, 1);
            testCase.verifyEqual(returns.name, name);
            testCase.verifyEqual(returns.who, who);
            testCase.verifyEqual(returns.when, when);
            testCase.verifyEqual(returns.description, description);
            testCase.verifyEqual(returns.comment, comment);
            testCase.verifyEqual(returns.tsEvents, tsEvents);
            testCase.verifyEqual(returns.symbReps, symbReps);
            testCase.verifyEqual(returns.segments, segments);
            
            testCase.verifyEqual(returns.fs, 1 / seconds(ts));
            testCase.verifyEqual(returns.timeRelative, time - time(1));
            testCase.verifyEqual(returns.timeDateTime, datetime(time, 'ConvertFrom', 'datenum'));
            
            testCase.verifyEqual(returns2.time, time);
            testCase.verifyEqual(returns2.data, data);
            testCase.verifyEqual(returns2.tags, tags);
            testCase.verifyEqual(returns2.units, {'-', '-'});
            testCase.verifyEqual(returns2.ts, []);
            testCase.verifyEqual(returns2.uniform, 0);
            testCase.verifyEqual(returns2.name, 'Time Series');
            testCase.verifyEqual(returns2.who, 'Author');
            testCase.verifyEqual(returns2.when, 'Now');
            testCase.verifyEqual(returns2.description, 'No description available');
            testCase.verifyEqual(returns2.comment, 'No comment available');
            testCase.verifyEqual(returns2.tsEvents, containers.Map);
            testCase.verifyEqual(returns2.symbReps, cell(1, numel(tags)));
            testCase.verifyEqual(returns2.segments, {});
            
            testCase.verifyEqual(returns2.timeRelative, time - time(1));
            testCase.verifyEqual(returns2.timeDateTime, datetime(time, 'ConvertFrom', 'datenum'));
            
        end
        
        function testEqualDistribution(testCase)
            
            ts = duration(0, 0, 0, 50);
            time = [datenum(datetime(2017, 7, 31, 14, 3, 3, 123 + 0 * seconds(ts)));
                datenum(datetime(2017, 7, 31, 14, 3, 3, 123 + 1 * seconds(ts)));
                datenum(datetime(2017, 7, 31, 14, 3, 3, 123 + 2 * seconds(ts)));
                datenum(datetime(2017, 7, 31, 14, 3, 3, 123 + 3 * seconds(ts)))];
            data = [9, 8;
                7, 6;
                8, 7;
                6, 5];
            tags = {'Channel 1', 'Channel2'};
            units = {'s', 'min'};
            name = 'TS-Test';
            who = 'Operator';
            when = 'Now';
            description = {'This is a TS-Test'; 'with two text lines'};
            comment = {'This is'; 'a comment'};
            eventInfo.eventTime = datenum('09/01/2018 16:05:06');
            eventInfo.eventDuration = int32(0);
            tsEvents = containers.Map('key1', eventInfo);
            durations = [4; 5];
            symbols = categorical({'a'; 'b'}, 'Ordinal', true);
            segObj = SymbRepObject(durations, symbols);
            symbReps = cell(1, numel(tags));
            symbReps{2} = segObj;
            
            returns = mdtsObject(time, data, tags, 'units', units, 'ts', ts, 'name', name, 'who', who, 'when', when, 'description', description, 'comment', comment, 'tsEvents', tsEvents, 'symbReps', symbReps);
            
            testCase.verifyEqual(returns.time, time);
            testCase.verifyEqual(returns.data, data);
            testCase.verifyEqual(returns.tags, tags);
            testCase.verifyEqual(returns.units, units);
            testCase.verifyEqual(returns.ts, ts);
            testCase.verifyEqual(returns.uniform, 1);
            testCase.verifyEqual(returns.name, name);
            testCase.verifyEqual(returns.who, who);
            testCase.verifyEqual(returns.when, when);
            testCase.verifyEqual(returns.description, description);
            testCase.verifyEqual(returns.comment, comment);
            
            testCase.verifyEqual(returns.fs, 1 / seconds(ts));
            testCase.verifyEqual(returns.timeRelative, time - time(1));
            testCase.verifyEqual(returns.timeDateTime, datetime(time, 'ConvertFrom', 'datenum'));
            
        end
        
        function testsubsref(testCase)
            
            ts = duration(0, 0, 0, 50);
            time = [datenum(datetime(2017, 7, 31, 14, 3, 3, 123 + 0 * seconds(ts)));
                datenum(datetime(2017, 7, 31, 14, 3, 3, 123 + 1 * seconds(ts)));
                datenum(datetime(2017, 7, 31, 14, 3, 3, 123 + 2 * seconds(ts)));
                datenum(datetime(2017, 7, 31, 14, 3, 3, 123 + 3 * seconds(ts)));
                datenum(datetime(2017, 7, 31, 14, 3, 3, 123 + 4 * seconds(ts)));
                datenum(datetime(2017, 7, 31, 14, 3, 3, 123 + 5 * seconds(ts)))];
            data = [9, 8, 7, 6;
                7, 6, 5, 4;
                8, 7, 6, 5;
                6, 5, 4, 3;
                4, 3, 2, 1;
                5, 4, 3, 2];
            tags = {'Channel 1', 'Channel 2', 'Channel 3', 'Channel 4'};
            units = {'s', 'min', 'elephants', 'giraffes'};
            name = 'TS-Test';
            who = 'Operator';
            when = 'Now';
            description = {'This is a TS-Test'; 'with two text lines'};
            comment = {'This is'; 'a comment'};
            eventInfo.eventTime = datenum('09/01/2018 16:05:06');
            eventInfo.eventDuration = int32(0);
            tsEvents = containers.Map('key1', eventInfo);
            durations = [4; 5];
            symbols = categorical({'a'; 'b'}, 'Ordinal', true);
            segObj = SymbRepObject(durations, symbols);
            symbReps = cell(1, numel(tags));
            symbReps{2} = segObj;
            nTimestamps = numel(time);
            tagName1 = 'newChannel';
            bVec1 = false(nTimestamps, 1);
            bVec1(4 : 5) = true;            
            tagName2 = 'secondChannel';
            bVec2 = false(nTimestamps, 1);
            bVec2(2 : 6) = true;
            segments = segmentsObject(nTimestamps);
            segments = segments.addSegmentVector(tagName1, bVec1);
            segments = segments.addSegmentVector(tagName2, bVec2);
            
            returns = mdtsObject(time, data, tags, 'units', units, 'ts', ts, 'name', name, 'who', who, 'when', when, 'description', description, 'comment', comment, 'tsEvents', tsEvents, 'symbReps', symbReps, 'segments', segments);
            
            extraction1 = returns(1, 1);
            extraction2 = returns(3, 2);
            extraction3 = returns(:, 4);
            extraction4 = returns(3, :);
            extraction5 = returns(2 : 4, 2 : 3);
            extraction6 = returns(2 : 4, tags{2});
            extraction7 = returns(3 : 5, tags(2 : 3));
            
            testCase.verifyEqual(data(1, 1), extraction1.data);
            testCase.verifyEqual(time(1), extraction1.time);
            testCase.verifyEqual(tags(1), extraction1.tags);
            testCase.verifyEqual(units(1), extraction1.units);
            testCase.verifyEqual(name, extraction1.name);
            testCase.verifyEqual(who, extraction1.who);
            testCase.verifyEqual(when, extraction1.when);
            testCase.verifyEqual(description, extraction1.description);
            testCase.verifyEqual(comment, extraction1.comment);
            testCase.verifyEqual(extraction1.segments.starts{1}, zeros(1, 0));
            testCase.verifyEqual(extraction1.segments.durations{1}, zeros(1, 0));
            
            testCase.verifyEqual(data(3, 2), extraction2.data);
            testCase.verifyEqual(time(3), extraction2.time);
            testCase.verifyEqual(tags(2), extraction2.tags);
            testCase.verifyEqual(units(2), extraction2.units);
            testCase.verifyEqual(extraction2.segments.starts{1}, zeros(1, 0));
            testCase.verifyEqual(extraction2.segments.durations{1}, zeros(1, 0));
               
            testCase.verifyEqual(data(:, 4), extraction3.data);
            testCase.verifyEqual(time, extraction3.time);
            testCase.verifyEqual(tags(4), extraction3.tags);
            testCase.verifyEqual(units(4), extraction3.units);
            testCase.verifyEqual(extraction3.segments.starts{1}, 4);
            testCase.verifyEqual(extraction3.segments.durations{1}, 2);
            
            testCase.verifyEqual(data(3, :), extraction4.data);
            testCase.verifyEqual(time(3), extraction4.time);
            testCase.verifyEqual(tags, extraction4.tags);
            testCase.verifyEqual(units, extraction4.units);
            testCase.verifyEqual(extraction4.segments.starts{1}, zeros(1, 0));
            testCase.verifyEqual(extraction4.segments.durations{1}, zeros(1, 0));
            
            testCase.verifyEqual(data(2 : 4, 2 : 3), extraction5.data);
            testCase.verifyEqual(time(2 : 4), extraction5.time);
            testCase.verifyEqual(tags(2 : 3), extraction5.tags);
            testCase.verifyEqual(units(2 : 3), extraction5.units);
            testCase.verifyEqual(extraction5.segments.starts{1}, 3);
            testCase.verifyEqual(extraction5.segments.durations{1}, 1);
            
            testCase.verifyEqual(data(2 : 4, 2), extraction6.data);
            testCase.verifyEqual(time(2 : 4), extraction6.time);
            testCase.verifyEqual(tags(2), extraction6.tags);
            testCase.verifyEqual(units(2), extraction6.units);
            testCase.verifyEqual(extraction6.segments.starts{1}, 3);
            testCase.verifyEqual(extraction6.segments.durations{1}, 1);
            
            testCase.verifyEqual(data(3 : 5, 2 : 3), extraction7.data);
            testCase.verifyEqual(time(3 : 5), extraction7.time);
            testCase.verifyEqual(tags(2 : 3), extraction7.tags);
            testCase.verifyEqual(units(2 : 3), extraction7.units);
            testCase.verifyEqual(extraction7.segments.starts{1}, 2);
            testCase.verifyEqual(extraction7.segments.durations{1}, 2);
            
        end
        
        function testgetDataNargin0(testCase)
            
            ts = duration(0, 0, 0, 50);
            time = [datenum(datetime(2017, 7, 31, 14, 3, 3, 123 + 0 * seconds(ts)));
                    datenum(datetime(2017, 7, 31, 14, 3, 3, 123 + 1 * seconds(ts)));
                    datenum(datetime(2017, 7, 31, 14, 3, 3, 123 + 2 * seconds(ts)));
                    datenum(datetime(2017, 7, 31, 14, 3, 3, 123 + 3 * seconds(ts)))];
            data = [9, 8, 7, 6;
                    7, 6, 5, 4;
                    8, 7, 6, 5;
                    6, 5, 4, 3];
            tags = {'Channel 1', 'Channel 2', 'Channel 3', 'Channel 4'};
            units = {'s', 'min', 'elephants', 'giraffes'};
            name = 'TS-Test';
            who = 'Operator';
            when = 'Now';
            description = {'This is a TS-Test'; 'with two text lines'};
            comment = {'This is'; 'a comment'};
            eventInfo.eventTime = datenum('09/01/2018 16:05:06');
            eventInfo.eventDuration = int32(0);
            tsEvents = containers.Map('key1', eventInfo);
            durations = [4; 5];
            symbols = categorical({'a'; 'b'}, 'Ordinal', true);
            segObj = SymbRepObject(durations, symbols);
            symbReps = cell(1, numel(tags));
            symbReps{2} = segObj;
            
            returns = mdtsObject(time, data, tags, 'units', units, 'ts', ts, 'name', name, 'who', who, 'when', when, 'description', description, 'comment', comment, 'tsEvents', tsEvents, 'symbReps', symbReps);
            
            testCase.verifyError(@()returns.getData(), 'getData:InvalidNumberOfInputs');  

        end
        
        function testgetDataNargin1(testCase)
            
            ts = duration(0, 0, 0, 50);
            time = [datenum(datetime(2017, 7, 31, 14, 3, 3, 123 + 0 * seconds(ts)));
                    datenum(datetime(2017, 7, 31, 14, 3, 3, 123 + 1 * seconds(ts)));
                    datenum(datetime(2017, 7, 31, 14, 3, 3, 123 + 2 * seconds(ts)));
                    datenum(datetime(2017, 7, 31, 14, 3, 3, 123 + 3 * seconds(ts)))];
            data = [9, 8, 7, 6;
                    7, 6, 5, 4;
                    8, 7, 6, 5;
                    6, 5, 4, 3];
            tags = {'Channel 1', 'Channel 2', 'Channel 3', 'Channel 4'};
            units = {'s', 'min', 'elephants', 'giraffes'};
            name = 'TS-Test';
            who = 'Operator';
            when = 'Now';
            description = {'This is a TS-Test'; 'with two text lines'};
            comment = {'This is'; 'a comment'};
            eventInfo.eventTime = datenum('09/01/2018 16:05:06');
            eventInfo.eventDuration = int32(0);
            tsEvents = containers.Map('key1', eventInfo);
            symbReps = cell(1, numel(tags));
            
            columnsToExtract = [2, 4];
            tagsToExtract = tags(columnsToExtract);
            dataToExtract = data(:, columnsToExtract);
            unitsToExtract = units(:, columnsToExtract);
            
            returns = mdtsObject(time, data, tags, 'units', units, 'ts', ts, 'name', name, 'who', who, 'when', when, 'description', description, 'comment', comment, 'tsEvents', tsEvents, 'symbReps', symbReps);
            returnObject = returns.getData(tagsToExtract);
            
            testCase.verifyEqual(returnObject.time, time);
            testCase.verifyEqual(returnObject.data, dataToExtract);
            testCase.verifyEqual(returnObject.tags, tagsToExtract);
            testCase.verifyEqual(returnObject.units, unitsToExtract);
            testCase.verifyEqual(returnObject.isSubset, true);
            
            testCase.verifyEqual(returns.timeDateTime, datetime(time, 'ConvertFrom', 'datenum'));

        end
        
        function testgetDataNargin2(testCase)
            
            ts = duration(0, 0, 0, 50);
            time = [datenum(datetime(2017, 7, 31, 14, 3, 3, 123 + 0 * seconds(ts)));
                    datenum(datetime(2017, 7, 31, 14, 3, 3, 123 + 1 * seconds(ts)));
                    datenum(datetime(2017, 7, 31, 14, 3, 3, 123 + 2 * seconds(ts)));
                    datenum(datetime(2017, 7, 31, 14, 3, 3, 123 + 3 * seconds(ts)))];
            data = [9, 8, 7, 6;
                    7, 6, 5, 4;
                    8, 7, 6, 5;
                    6, 5, 4, 3];
            tags = {'Channel 1', 'Channel 2', 'Channel 3', 'Channel 4'};
            units = {'s', 'min', 'elephants', 'giraffes'};
            name = 'TS-Test';
            who = 'Operator';
            when = 'Now';
            description = {'This is a TS-Test'; 'with two text lines'};
            comment = {'This is'; 'a comment'};
            eventInfo.eventTime = datenum('09/01/2018 16:05:06');
            eventInfo.eventDuration = int32(0);
            tsEvents = containers.Map('key1', eventInfo);
            symbReps = cell(1, numel(tags));
            
            columnsToExtract = [2, 4];
            linesToExtract1 = [2 : 3];
            linesToExtract2 = [2 : 4];
            linesToExtract2StartEnd = [linesToExtract2(1); linesToExtract2(end)];
            timeToExtract1 = time(linesToExtract1);
            timeToExtract2 = time(linesToExtract2);
            timeToExtract2StartEnd = time(linesToExtract2StartEnd);
            tagsToExtract = tags(columnsToExtract);
            dataToExtract1 = data(linesToExtract1, columnsToExtract);
            dataToExtract2 = data(linesToExtract2, columnsToExtract);
            unitsToExtract = units(:, columnsToExtract);
            
            returns = mdtsObject(time, data, tags, 'units', units, 'ts', ts, 'name', name, 'who', who, 'when', when, 'description', description, 'comment', comment, 'tsEvents', tsEvents, 'symbReps', symbReps);
            returnObject1 = returns.getData(tagsToExtract, timeToExtract1);
            returnObject2 = returns.getData(tagsToExtract, timeToExtract2);
            returnObject3 = returns.getData(tagsToExtract, timeToExtract2StartEnd);
            
            testCase.verifyEqual(returnObject1.time, timeToExtract1);
            testCase.verifyEqual(returnObject1.data, dataToExtract1);
            testCase.verifyEqual(returnObject1.tags, tagsToExtract);
            testCase.verifyEqual(returnObject1.units, unitsToExtract);
            testCase.verifyEqual(returnObject1.isSubset, true);
            testCase.verifyEqual(returnObject1.timeDateTime, datetime(timeToExtract1, 'ConvertFrom', 'datenum'));

            testCase.verifyEqual(returnObject2.time, timeToExtract2);
            testCase.verifyEqual(returnObject2.data, dataToExtract2);
            testCase.verifyEqual(returnObject2.isSubset, true);
            testCase.verifyEqual(returnObject2.timeDateTime, datetime(timeToExtract2, 'ConvertFrom', 'datenum'));

            testCase.verifyEqual(returnObject3.time, timeToExtract2);
            testCase.verifyEqual(returnObject3.data, dataToExtract2);
            testCase.verifyEqual(returnObject3.isSubset, true);
            testCase.verifyEqual(returnObject3.timeDateTime, datetime(timeToExtract2, 'ConvertFrom', 'datenum'));

        end
        
        function testgetDataNarginN(testCase)
            
            ts = duration(0, 0, 0, 50);
            time = [datenum(datetime(2017, 7, 31, 14, 3, 3, 123 + 0 * seconds(ts)));
                    datenum(datetime(2017, 7, 31, 14, 3, 3, 123 + 1 * seconds(ts)));
                    datenum(datetime(2017, 7, 31, 14, 3, 3, 123 + 2 * seconds(ts)));
                    datenum(datetime(2017, 7, 31, 14, 3, 3, 123 + 3 * seconds(ts)))];
            data = [9, 8, 7, 6;
                    7, 6, 5, 4;
                    8, 7, 6, 5;
                    6, 5, 4, 3];
            tags = {'Channel 1', 'Channel 2', 'Channel 3', 'Channel 4'};
            units = {'s', 'min', 'elephants', 'giraffes'};
            name = 'TS-Test';
            who = 'Operator';
            when = 'Now';
            description = {'This is a TS-Test'; 'with two text lines'};
            comment = {'This is'; 'a comment'};
            eventInfo.eventTime = datenum('09/01/2018 16:05:06');
            eventInfo.eventDuration = int32(0);
            tsEvents = containers.Map('key1', eventInfo);
            durations = [4; 5];
            symbols = categorical({'a'; 'b'}, 'Ordinal', true);
            segObj = SymbRepObject(durations, symbols);
            symbReps = cell(1, numel(tags));
            symbReps{2} = segObj;
            
            returns = mdtsObject(time, data, tags, 'units', units, 'ts', ts, 'name', name, 'who', who, 'when', when, 'description', description, 'comment', comment, 'tsEvents', tsEvents, 'symbReps', symbReps);
            
            testCase.verifyError(@()returns.getData(1, 2, 3), 'getData:InvalidNumberOfInputs');
            
        end
        
        function testgetTagIndices(testCase)
            
            ts = duration(0, 0, 0, 50);
            time = [datenum(datetime(2017, 7, 31, 14, 3, 3, 123 + 0 * seconds(ts)));
                    datenum(datetime(2017, 7, 31, 14, 3, 3, 123 + 1 * seconds(ts)));
                    datenum(datetime(2017, 7, 31, 14, 3, 3, 123 + 2 * seconds(ts)));
                    datenum(datetime(2017, 7, 31, 14, 3, 3, 123 + 3 * seconds(ts)))];
            data = [9, 8, 7, 6;
                    7, 6, 5, 4;
                    8, 7, 6, 5;
                    6, 5, 4, 3];
            tags = {'Channel 1', 'Channel 2', 'Channel 3', 'Channel 4'};
            units = {'s', 'min', 'elephants', 'giraffes'};
            name = 'TS-Test';
            who = 'Operator';
            when = 'Now';
            description = {'This is a TS-Test'; 'with two text lines'};
            comment = {'This is'; 'a comment'};
            eventInfo.eventTime = datenum('09/01/2018 16:05:06');
            eventInfo.eventDuration = int32(0);
            tsEvents = containers.Map('key1', eventInfo);
            durations = [4; 5];
            symbols = categorical({'a'; 'b'}, 'Ordinal', true);
            segObj = SymbRepObject(durations, symbols);
            symbReps = cell(1, numel(tags));
            symbReps{2} = segObj;
            
            returns = mdtsObject(time, data, tags, 'units', units, 'ts', ts, 'name', name, 'who', who, 'when', when, 'description', description, 'comment', comment, 'tsEvents', tsEvents, 'symbReps', symbReps);

            testCase.verifyError(@()returns.getTagIndices({'Channel 5'}), 'getTagIndices:TagNotAvailable');    
        
        end
        
        function testgetIntervalIndices(testCase)
            
            ts = duration(0, 0, 0, 50);
            time = [datenum(datetime(2017, 7, 31, 14, 3, 3, 123 + 0 * seconds(ts)));
                    datenum(datetime(2017, 7, 31, 14, 3, 3, 123 + 1 * seconds(ts)));
                    datenum(datetime(2017, 7, 31, 14, 3, 3, 123 + 2 * seconds(ts)));
                    datenum(datetime(2017, 7, 31, 14, 3, 3, 123 + 3 * seconds(ts)));
                    datenum(datetime(2017, 7, 31, 14, 3, 3, 123 + 4 * seconds(ts)));
                    datenum(datetime(2017, 7, 31, 14, 3, 3, 123 + 5 * seconds(ts)))];
            data = [9, 8, 7, 6;
                    7, 6, 5, 4;
                    8, 7, 6, 5;
                    6, 5, 4, 3;
                    4, 3, 2, 1;
                    5, 4, 3, 2];
            tags = {'Channel 1', 'Channel 2', 'Channel 3', 'Channel 4'};
            units = {'s', 'min', 'elephants', 'giraffes'};
            name = 'TS-Test';
            who = 'Operator';
            when = 'Now';
            description = {'This is a TS-Test'; 'with two text lines'};
            comment = {'This is'; 'a comment'};
            eventInfo.eventTime = datenum('09/01/2018 16:05:06');
            eventInfo.eventDuration = int32(0);
            tsEvents = containers.Map('key1', eventInfo);
            durations = [4; 5];
            symbols = categorical({'a'; 'b'}, 'Ordinal', true);
            segObj = SymbRepObject(durations, symbols);
            symbReps = cell(1, numel(tags));
            symbReps{2} = segObj;
            
            tooLargeInterval = [time(2); time(end) + 1 / (60 * 60 * 24)];
            
            returns = mdtsObject(time, data, tags, 'units', units, 'ts', ts, 'name', name, 'who', who, 'when', when, 'description', description, 'comment', comment, 'tsEvents', tsEvents, 'symbReps', symbReps);            
 
            testCase.verifyError(@()returns.getIntervalIndices(tooLargeInterval), 'getIntervalIndices:IntervalOutOfBoundaries');
            
        end
        
        function testExpandDataSet(testCase)
            
            ts = duration(0, 0, 0, 50);
            time = [datenum(datetime(2017, 7, 25, 14, 3, 3, 123));
                    datenum(datetime(2017, 7, 30, 14, 3, 3, 123));
                    datenum(datetime(2017, 7, 31, 14, 3, 3, 123));
                    datenum(datetime(2017, 8, 5, 14, 3, 3, 123));
                    datenum(datetime(2017, 8, 15, 14, 3, 3, 123));
                    datenum(datetime(2017, 9, 5, 14, 3, 3, 123))];
            data = [9, 8, 7, 6;
                    7, 6, 5, 4;
                    8, 7, 6, 5;
                    6, 5, 4, 3;
                    4, 3, 2, 1;
                    5, 4, 3, 2];
            tags = {'Channel 1', 'Channel 2', 'Channel 3', 'Channel 4'};
            units = {'s', 'min', 'elephants', 'giraffes'};
            name = 'TS-Test';
            who = 'Operator';
            when = 'Now';
            description = {'This is a TS-Test'; 'with two text lines'};
            comment = {'This is'; 'a comment'};
            eventInfo.eventTime = datenum('09/01/2018 16:05:06');
            eventInfo.eventDuration = int32(0);
            tsEvents = containers.Map('key1', eventInfo);
            durations = [4; 5];
            symbols = categorical({'a'; 'b'}, 'Ordinal', true);
            segObj = SymbRepObject(durations, symbols);
            symbReps = cell(1, numel(tags));
            symbReps{2} = segObj;
            
            addData = [2, 3;
                       3, 4;
                       4, 5;
                       5, 6;
                       6, 7;
                       7, 8];
            addTags1 = {'AddedTag1', 'AddedTag2'};
            addTags2 = {'AddedTag3', 'AddedTag4'};
            
            returns = mdtsObject(time, data, tags, 'units', units, 'ts', ts, 'name', name, 'who', who, 'when', when, 'description', description, 'comment', comment, 'tsEvents', tsEvents, 'symbReps', symbReps);
            returns.expandDataSet(addData, addTags1);
            
            testCase.verifyEqual(returns.data(:, end - 1 : end), addData);
            testCase.verifyEqual(returns.tags(end - 1 : end), addTags1);
            
            returns.expandDataSet(addData, addTags2);
            
            testCase.verifyEqual(returns.data(:, end - 3 : end), [addData, addData]);
            testCase.verifyEqual(returns.tags(end - 3 : end), [addTags1, addTags2]);            
            
            testCase.verifyError(@()returns.expandDataSet({'No numeric dataset'}, addTags1), 'expandDataSet:DataNotNumeric');
            testCase.verifyError(@()returns.expandDataSet(addData(1 : end - 1, :), addTags1), 'expandDataSet:InvalideDataSize1');
            testCase.verifyError(@()returns.expandDataSet(addData(:, 1), addTags1), 'expandDataSet:InvalideDataSize2');
            testCase.verifyError(@()returns.expandDataSet(addData, [1, 2]), 'expandDataSet:InvalidTags');
            testCase.verifyError(@()returns.expandDataSet(addData, addTags1), 'expandDataSet:NonUniqueTags');
            
        end
        
        function testAddEvent(testCase)
            
            ts = duration(0, 0, 0, 50);
            time = [datenum(datetime(2017, 7, 25, 14, 3, 3, 123));
                    datenum(datetime(2017, 7, 30, 14, 3, 3, 123));
                    datenum(datetime(2017, 7, 31, 14, 3, 3, 123));
                    datenum(datetime(2017, 8, 5, 14, 3, 3, 123));
                    datenum(datetime(2017, 8, 15, 14, 3, 3, 123));
                    datenum(datetime(2017, 9, 5, 14, 3, 3, 123))];
            data = [9, 8, 7, 6;
                    7, 6, 5, 4;
                    8, 7, 6, 5;
                    6, 5, 4, 3;
                    4, 3, 2, 1;
                    5, 4, 3, 2];
            tags = {'Channel 1', 'Channel 2', 'Channel 3', 'Channel 4'};
            units = {'s', 'min', 'elephants', 'giraffes'};
            name = 'TS-Test';
            who = 'Operator';
            when = 'Now';
            description = {'This is a TS-Test'; 'with two text lines'};
            comment = {'This is'; 'a comment'};
            eventInfo.eventTime = datenum('09/01/2018 16:05:06');
            eventInfo.eventDuration = int32(0);
            tsEvents = containers.Map('key1', eventInfo);
            durations = [4; 5];
            symbols = categorical({'a'; 'b'}, 'Ordinal', true);
            segObj = SymbRepObject(durations, symbols);
            symbReps = cell(1, numel(tags));
            symbReps{2} = segObj;
            
            eventName1 = 'MyEvent1';
            eventName2 = 123;
            
            eventInfo1.eventTime = time(2);
            eventInfo2.eventTime = [time(2); time(3); time(4)];
            eventInfo3.eventTime = 'A';
            eventInfo4.eventTime = time(2);
            eventInfo5.eventTime = time(end) + 1;
            
            eventInfo1.eventDuration = int32(3);
            eventInfo2.eventDuration = [int32(3); int32(4)];
            eventInfo3.eventDuration = int32(3);
            eventInfo4.eventDuration = 3;
            eventInfo5.eventDuration = int32(3);
            
            returns = mdtsObject(time, data, tags, 'units', units, 'ts', ts, 'name', name, 'who', who, 'when', when, 'description', description, 'comment', comment, 'tsEvents', tsEvents, 'symbReps', symbReps);
            
            returns.addEvent(eventName1, eventInfo1.eventTime, eventInfo1.eventDuration);
            
            testCase.verifyEqual(returns.tsEvents(eventName1), eventInfo1);
            
            testCase.verifyError(@()returns.addEvent(eventName2, eventInfo1.eventTime, eventInfo1.eventDuration), 'addEvent:InvalidEventID');
            testCase.verifyError(@()returns.addEvent(eventName1, eventInfo2.eventTime, eventInfo2.eventDuration), 'addEvent:TimesInconsistent');
            testCase.verifyError(@()returns.addEvent(eventName1, eventInfo4.eventTime, eventInfo4.eventDuration), 'addEvent:InvalidEventDuration');
            testCase.verifyError(@()returns.addEvent(eventName1, eventInfo5.eventTime, eventInfo5.eventDuration), 'addEvent:EventTimeNotAvailable');
          
        end
        
        function testAddSymbRepToChannel(testCase)
            
            ts = duration(0, 0, 0, 50);
            time = [datenum(datetime(2017, 7, 31, 14, 3, 3, 123 + 0 * seconds(ts)));
                    datenum(datetime(2017, 7, 31, 14, 3, 3, 123 + 1 * seconds(ts)));
                    datenum(datetime(2017, 7, 31, 14, 3, 3, 123 + 2 * seconds(ts)));
                    datenum(datetime(2017, 7, 31, 14, 3, 3, 123 + 3 * seconds(ts)));
                    datenum(datetime(2017, 7, 31, 14, 3, 3, 123 + 4 * seconds(ts)));
                    datenum(datetime(2017, 7, 31, 14, 3, 3, 123 + 5 * seconds(ts)));
                    datenum(datetime(2017, 7, 31, 14, 3, 3, 123 + 6 * seconds(ts)));
                    datenum(datetime(2017, 7, 31, 14, 3, 3, 123 + 7 * seconds(ts)));
                    datenum(datetime(2017, 7, 31, 14, 3, 3, 123 + 8 * seconds(ts)))];
            data = [1, 8, -1;
                    2, 6, 1;
                    3, 7, 1;
                    3, 5, 1;
                    3, 1, 1;
                    2, 1, 2;
                    1, 1, 2;
                    1, 1, 2;
                    3, 1, 2];
            tags = {'Channel 1', 'Channel2', 'Channel 3'};
            units = {'s', 'min', 'elephants'};
            name = 'TS-Test';
            who = 'Operator';
            when = 'Now';
            description = {'This is a TS-Test'; 'with two text lines'};
            comment = {'This is'; 'a comment'};
            eventInfo.eventTime = datenum('09/01/2018 16:05:06');
            eventInfo.eventDuration = int32(0);
            tsEvents = containers.Map('key1', eventInfo);
            durations = [4; 5];
            symbols = categorical({'a'; 'b'}, 'Ordinal', true);
            symbObj = SymbRepObject(durations, symbols);
            symbReps = cell(1, numel(tags));
            symbReps{2} = symbObj;
            
            returns = mdtsObject(time, data, tags, 'units', units, 'ts', ts, 'name', name, 'who', who, 'when', when, 'description', description, 'comment', comment, 'tsEvents', tsEvents, 'symbReps', symbReps);
            
            input1.object = returns;
            input1.tag = 'Channel 1';
            alphabet1 = {'a', 'b', 'c'};
            edges1 = [-inf, 1.5, 2.5, inf];
            
            input3.object = returns;
            input3.tag = 'Channel 3';
            alphabet3 = {'a', 'b', 'c'};
            edges3 = [-inf, 0, 1.5, inf];
            
            expectedReturn1.durations = [1; 1; 3; 1; 2; 1];
            expectedReturn1.symbols = categorical({'a', 'b', 'c', 'b', 'a', 'c'})';
            
            expectedReturn3.durations = [1; 4; 4];
            expectedReturn3.symbols = categorical({'a', 'b', 'c'})';
            
            symbObj1 = symbRepChannel(input1, edges1, alphabet1);     
            symbObj3 = symbRepChannel(input3, edges3, alphabet3); 
            
            returns.addSymbRepToChannel(1, symbObj1);
            returns.addSymbRepToChannel(3, symbObj3);
            
            testCase.verifyEqual(returns.symbReps{1}.durations, expectedReturn1.durations);
            testCase.verifyEqual(returns.symbReps{1}.symbols, expectedReturn1.symbols);
            
            testCase.verifyEqual(returns.symbReps{3}.durations, expectedReturn3.durations);
            testCase.verifyEqual(returns.symbReps{3}.symbols, expectedReturn3.symbols);
            
            testCase.verifyError(@()returns.addSymbRepToChannel(2, 'test1'), 'addSymbRepToChannel:NotASymbRepObject');
            testCase.verifyError(@()returns.addSymbRepToChannel('abc', symbObj1), 'addSymbRepToChannel:InvalidChannelNumber');
            
        end        
        
        function testAddSymbRepToAllChannels(testCase)
            
            ts = duration(0, 0, 0, 50);
            time = [datenum(datetime(2017, 7, 31, 14, 3, 3, 123 + 0 * seconds(ts)));
                    datenum(datetime(2017, 7, 31, 14, 3, 3, 123 + 1 * seconds(ts)));
                    datenum(datetime(2017, 7, 31, 14, 3, 3, 123 + 2 * seconds(ts)));
                    datenum(datetime(2017, 7, 31, 14, 3, 3, 123 + 3 * seconds(ts)));
                    datenum(datetime(2017, 7, 31, 14, 3, 3, 123 + 4 * seconds(ts)));
                    datenum(datetime(2017, 7, 31, 14, 3, 3, 123 + 5 * seconds(ts)));
                    datenum(datetime(2017, 7, 31, 14, 3, 3, 123 + 6 * seconds(ts)));
                    datenum(datetime(2017, 7, 31, 14, 3, 3, 123 + 7 * seconds(ts)));
                    datenum(datetime(2017, 7, 31, 14, 3, 3, 123 + 8 * seconds(ts)))];
            data = [1, 8, -1, 5;
                    2, 6, 1, 5;
                    3, 7, 1, 5;
                    3, 5, 1, 5;
                    3, 1, 1, 5;
                    2, 1, 2, 5;
                    1, 1, 2, 5;
                    1, 1, 2, 5;
                    3, 1, 2, 5];
            tags = {'Channel 1', 'Channel2', 'Channel 3', 'Channel 4'};
            units = {'s', 'min', 'elephants', 'giraffs'};
            name = 'TS-Test';
            who = 'Operator';
            when = 'Now';
            description = {'This is a TS-Test'; 'with two text lines'};
            comment = {'This is'; 'a comment'};
            eventInfo.eventTime = datenum('09/01/2018 16:05:06');
            eventInfo.eventDuration = int32(0);
            tsEvents = containers.Map('key1', eventInfo);
            symbReps = cell(1, numel(tags));
            
            returns = mdtsObject(time, data, tags, 'units', units, 'ts', ts, 'name', name, 'who', who, 'when', when, 'description', description, 'comment', comment, 'tsEvents', tsEvents, 'symbReps', symbReps);
            
            durations1 = [4; 5];
            symbols1 = categorical({'a'; 'b'}, {'a'; 'b'});
            symbObj1 = SymbRepObject(durations1, symbols1);
            
            durations2 = [4; 5];
            symbols2 = categorical({'a'; 'b'}, {'a'; 'b'});
            symbObj2 = SymbRepObject(durations2, symbols2);
            
            returns.addSymbRepToChannel(2, symbObj1);
            returns.addSymbRepToChannel(4, symbObj2);
            
            returns.addSymbRepToAllChannels(symbObj1);
            
            retSymbObj1a = returns.symbReps{2};
            retSymbObj1b = returns.symbReps{4};
            retSymbObj2a = returns.symbReps{1};
            retSymbObj2b = returns.symbReps{3};
            
            testCase.verifyEqual(retSymbObj1a.durations, durations1);
            testCase.verifyEqual(retSymbObj1a.symbols, symbols1);
            testCase.verifyEqual(retSymbObj1b.durations, durations1);
            testCase.verifyEqual(retSymbObj1b.symbols, symbols1);
            testCase.verifyEqual(retSymbObj2a.durations, durations2);
            testCase.verifyEqual(retSymbObj2a.symbols, symbols2);
            testCase.verifyEqual(retSymbObj2b.durations, durations2);
            testCase.verifyEqual(retSymbObj2b.symbols, symbols2);
            
            testCase.verifyError(@()returns.addSymbRepToAllChannels('test1'), 'addSymbRepToAllChannels:NotASymbRepObject');
            
        end        
        
        function testAddSegments(testCase)
            
            ts = duration(0, 0, 0, 50);
            time = [datenum(datetime(2017, 7, 31, 14, 3, 3, 123 + 0 * seconds(ts)));
                    datenum(datetime(2017, 7, 31, 14, 3, 3, 123 + 1 * seconds(ts)));
                    datenum(datetime(2017, 7, 31, 14, 3, 3, 123 + 2 * seconds(ts)));
                    datenum(datetime(2017, 7, 31, 14, 3, 3, 123 + 3 * seconds(ts)));
                    datenum(datetime(2017, 7, 31, 14, 3, 3, 123 + 4 * seconds(ts)));
                    datenum(datetime(2017, 7, 31, 14, 3, 3, 123 + 5 * seconds(ts)));
                    datenum(datetime(2017, 7, 31, 14, 3, 3, 123 + 6 * seconds(ts)));
                    datenum(datetime(2017, 7, 31, 14, 3, 3, 123 + 7 * seconds(ts)));
                    datenum(datetime(2017, 7, 31, 14, 3, 3, 123 + 8 * seconds(ts)))];
            data = [1, 8, -1;
                    2, 6, 1;
                    3, 7, 1;
                    3, 5, 1;
                    3, 1, 1;
                    2, 1, 2;
                    1, 1, 2;
                    1, 1, 2;
                    3, 1, 2];
            tags = {'Channel 1', 'Channel2', 'Channel 3'};
            units = {'s', 'min', 'elephants'};
            name = 'TS-Test';
            who = 'Operator';
            when = 'Now';
            description = {'This is a TS-Test'; 'with two text lines'};
            comment = {'This is'; 'a comment'};
            eventInfo.eventTime = datenum('09/01/2018 16:05:06');
            eventInfo.eventDuration = int32(0);
            tsEvents = containers.Map('key1', eventInfo);
            durations = [4; 5];
            symbols = categorical({'a'; 'b'}, 'Ordinal', true);
            symbObj = SymbRepObject(durations, symbols);
            symbReps = cell(1, numel(tags));
            symbReps{2} = symbObj;
            nTimestamps = numel(time);
            segments1 = segmentsObject(nTimestamps);
            tagName1 = 'newChannel';
            bVec1 = false(nTimestamps, 1);
            tagName2 = 'secondChannel';
            bVec2 = true(nTimestamps, 1);
            segments1 = segments1.addSegmentVector(tagName1, bVec1);
            segments1 = segments1.addSegmentVector(tagName2, bVec2);
            segments2 = segmentsObject(123);
            
            returns = mdtsObject(time, data, tags, 'units', units, 'ts', ts, 'name', name, 'who', who, 'when', when, 'description', description, 'comment', comment, 'tsEvents', tsEvents, 'symbReps', symbReps);
            returns2 = mdtsObject(time, data, tags, 'units', units, 'ts', ts, 'name', name, 'who', who, 'when', when, 'description', description, 'comment', comment, 'tsEvents', tsEvents, 'symbReps', symbReps);
            
            returns.addSegments(segments1);
            
            retSegments = returns.segments;
            
            testCase.verifyEqual(retSegments.tags{1}, tagName1);
            testCase.verifyEqual(retSegments.tags{2}, tagName2);
            testCase.verifyEqual(retSegments.starts{1}, zeros(0, 1));
            testCase.verifyEqual(retSegments.starts{2}, [1]);
            testCase.verifyEqual(retSegments.durations{1}, zeros(1, 0));
            testCase.verifyEqual(retSegments.durations{2}, [nTimestamps]);
            
            testCase.verifyError(@()returns2.addSegments('test1'), 'addSegments:NotASegmentsObject');
            testCase.verifyError(@()returns.addSegments(segments1), 'addSegments:SegmentsAlreadyAdded');
            testCase.verifyError(@()returns2.addSegments(segments2), 'addSegments:InvalidNumberOfTimestamps');
          
        end        
        
        function testDifferentTimeInputs(testCase)
            
            ts = duration(0, 0, 1);
            time0 = (0 : 8)';
            time1 = [datetime(2017, 7, 31, 14, 3, 0 * seconds(ts));
                     datetime(2017, 7, 31, 14, 3, 1 * seconds(ts));
                     datetime(2017, 7, 31, 14, 3, 2 * seconds(ts));
                     datetime(2017, 7, 31, 14, 3, 3 * seconds(ts));
                     datetime(2017, 7, 31, 14, 3, 4 * seconds(ts));
                     datetime(2017, 7, 31, 14, 3, 5 * seconds(ts));
                     datetime(2017, 7, 31, 14, 3, 6 * seconds(ts));
                     datetime(2017, 7, 31, 14, 3, 7 * seconds(ts));
                     datetime(2017, 7, 31, 14, 3, 8 * seconds(ts))];
            time2 = [datenum(datetime(2017, 7, 31, 14, 3, 0 * seconds(ts)));
                     datenum(datetime(2017, 7, 31, 14, 3, 1 * seconds(ts)));
                     datenum(datetime(2017, 7, 31, 14, 3, 2 * seconds(ts)));
                     datenum(datetime(2017, 7, 31, 14, 3, 3 * seconds(ts)));
                     datenum(datetime(2017, 7, 31, 14, 3, 4 * seconds(ts)));
                     datenum(datetime(2017, 7, 31, 14, 3, 5 * seconds(ts)));
                     datenum(datetime(2017, 7, 31, 14, 3, 6 * seconds(ts)));
                     datenum(datetime(2017, 7, 31, 14, 3, 7 * seconds(ts)));
                     datenum(datetime(2017, 7, 31, 14, 3, 8 * seconds(ts)))];
            time3 = (0 : 8)' * ts;
            data = [1, 8, -1;
                    2, 6, 1;
                    3, 7, 1;
                    3, 5, 1;
                    3, 1, 1;
                    2, 1, 2;
                    1, 1, 2;
                    1, 1, 2;
                    3, 1, 2];
            tags = {'Channel 1', 'Channel2', 'Channel 3'};
            units = {'s', 'min', 'elephants'};
            name = 'TS-Test';
            who = 'Operator';
            when = 'Now';
            description = {'This is a TS-Test'; 'with two text lines'};
            comment = {'This is'; 'a comment'};
            eventInfo.eventTime = datenum('09/01/2018 16:05:06');
            eventInfo.eventDuration = int32(0);
            tsEvents = containers.Map('key1', eventInfo);
            durations = [4; 5];
            symbols = categorical({'a'; 'b'}, 'Ordinal', true);
            symbObj = SymbRepObject(durations, symbols);
            symbReps = cell(1, numel(tags));
            symbReps{2} = symbObj;
            
            returns0 = mdtsObject(time0, data, tags, 'units', units, 'ts', ts, 'name', name, 'who', who, 'when', when, 'description', description, 'comment', comment, 'tsEvents', tsEvents, 'symbReps', symbReps);
            returns1 = mdtsObject(time1, data, tags, 'units', units, 'ts', ts, 'name', name, 'who', who, 'when', when, 'description', description, 'comment', comment, 'tsEvents', tsEvents, 'symbReps', symbReps);
            returns2 = mdtsObject(time2, data, tags, 'units', units, 'ts', ts, 'name', name, 'who', who, 'when', when, 'description', description, 'comment', comment, 'tsEvents', tsEvents, 'symbReps', symbReps);
            returns3 = mdtsObject(time3, data, tags, 'units', units, 'ts', ts, 'name', name, 'who', who, 'when', when, 'description', description, 'comment', comment, 'tsEvents', tsEvents, 'symbReps', symbReps);
              
            expectedReturn0 = time0;
            expectedReturn1 = time1;
            expectedReturn2 = time2;
            expectedReturn3 = time3;
            
            linesToExtract = [2; 4];
            timeInterval0 = time0(linesToExtract);
            timeInterval1 = time1(linesToExtract);
            timeInterval2 = time2(linesToExtract);
            timeInterval3 = time3(linesToExtract);
            
            testCase.verifyEqual(returns0.timeInFormat, expectedReturn0);
            testCase.verifyEqual(returns1.timeInFormat, expectedReturn1);
            testCase.verifyEqual(returns2.timeInFormat, expectedReturn2);
            testCase.verifyEqual(returns3.timeInFormat, expectedReturn3);
            
            testCase.verifyError(@()mdtsObject('test1', data, tags), 'mdtsObject:InvalidTimeFormat');
            
            testCase.verifyEqual(returns0.convert2Datenum(time0), time0);
            testCase.verifyEqual(returns0.convert2Datenum(time1), datenum(time1));
            testCase.verifyEqual(returns0.convert2Datenum(time2), time2);
            testCase.verifyEqual(returns0.convert2Datenum(time3), seconds(time3));
            
            testCase.verifyEqual(returns0.getIntervalIndices(timeInterval0), linesToExtract);
            testCase.verifyEqual(returns1.getIntervalIndices(timeInterval1), linesToExtract);
            testCase.verifyEqual(returns2.getIntervalIndices(timeInterval2), linesToExtract);
            testCase.verifyEqual(returns3.getIntervalIndices(timeInterval3), linesToExtract);
          
        end
    end
end
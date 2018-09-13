classdef mdtsCoreObjectTestClass < matlab.unittest.TestCase
    %
    % Description : Test the mdtsCoreObject class
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
    end
    
    methods (Test)
        
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
            tags = {'Channel 1'; 'Channel2'};
            units = {'s', 'min'};
            name = 'TS-Test';
            who = 'Operator';
            when = 'Now';
            description = {'This is a TS-Test'; 'with two text lines'};
            comment = {'This is'; 'a comment'};
            tsEvents = containers.Map;
            symbReps = {};
            nTimestamps = numel(time);
            segments = segmentsObject(nTimestamps);
            
            returns = mdtsCoreObject(time, data, tags, units, ts, name, who, when, description, comment, tsEvents, symbReps, segments);
            
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
            testCase.verifyEqual(returns.symbReps, symbReps);
            testCase.verifyEqual(returns.segments, segments);
            
            testCase.verifyEqual(returns.fs, 1 / seconds(ts));
            testCase.verifyEqual(returns.timeRelative, time - time(1));
            testCase.verifyEqual(returns.timeDateTime, datetime(time, 'ConvertFrom', 'datenum'));
            testCase.verifyEqual(returns.timeDateTimeRelative, datetime(time - time(1), 'ConvertFrom', 'datenum'));
            
        end
        
        function testNonEqualDistribution(testCase)
            
            ts = [];
            time = [datenum(datetime(2017, 7, 31, 14, 3, 3, 123));
                datenum(datetime(2017, 7, 31, 14, 3, 3, 123 + 50));
                datenum(datetime(2017, 7, 31, 14, 3, 3, 123 + 62));
                datenum(datetime(2017, 7, 31, 14, 3, 3, 123 + 99))];
            data = [9, 8;
                7, 6;
                8, 7;
                6, 5];
            tags = {'Channel 1'; 'Channel2'};
            units = {'s', 'min'};
            name = 'TS-Test';
            who = 'Operator';
            when = 'Now';
            description = {'This is a TS-Test'; 'with two text lines'};
            comment = {'This is'; 'a comment'};
            tsEvents = containers.Map;
            symbReps = {};
            nTimestamps = numel(time);
            segments = segmentsObject(nTimestamps);
            
            returns = mdtsCoreObject(time, data, tags, units, ts, name, who, when, description, comment, tsEvents, symbReps, segments);
            
            testCase.verifyEqual(returns.time, time);
            testCase.verifyEqual(returns.data, data);
            testCase.verifyEqual(returns.tags, tags);
            testCase.verifyEqual(returns.units, units);
            testCase.verifyEqual(returns.ts, ts);
            testCase.verifyEqual(returns.uniform, 0);
            testCase.verifyEqual(returns.name, name);
            testCase.verifyEqual(returns.who, who);
            testCase.verifyEqual(returns.when, when);
            testCase.verifyEqual(returns.description, description);
            testCase.verifyEqual(returns.comment, comment);
            testCase.verifyEqual(returns.symbReps, symbReps);
            testCase.verifyEqual(returns.segments, segments);
            
            testCase.verifyEqual(returns.timeRelative, time - time(1));
            testCase.verifyEqual(returns.timeDateTime, datetime(time, 'ConvertFrom', 'datenum'));
            testCase.verifyEqual(returns.timeDateTimeRelative, datetime(time - time(1), 'ConvertFrom', 'datenum'));
            
            testCase.verifyError(@()returns.fs, 'fs:dataNotUniform');
            
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
            tsEvents = containers.Map;
            durations = [3; 3];
            symbols = categorical({'a'; 'b'}, 'Ordinal', true);
            segObj = SymbRepObject(durations, symbols);
            symbReps = cell(1, numel(tags));
            symbReps{2} = segObj;
            symbReps{3} = segObj;
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
            
            for i=1:numel(tags)
                segmentsIn{i} = segments;
            end
            returns = mdtsCoreObject(time, data, tags, units, ts, name, who, when, description, comment, tsEvents, symbReps, segmentsIn);
            
            extraction1 = returns(1, 1);
            extraction2 = returns(3, 2);
            extraction3 = returns(:, 4);
            extraction4 = returns(3, :);
            extraction5 = returns(2 : 4, 2 : 3);
            extraction6 = returns(2 : 4, tags{2});
            extraction7 = returns(3 : 5, tags(2 : 3));
            
            for i=1:numel(tags)
                testCase.verifyEqual(data(1, 1), extraction1.data);
                testCase.verifyEqual(time(1), extraction1.time);
                testCase.verifyEqual(tags(1), extraction1.tags);
                testCase.verifyEqual(units(1), extraction1.units);
                testCase.verifyEqual(name, extraction1.name);
                testCase.verifyEqual(who, extraction1.who);
                testCase.verifyEqual(when, extraction1.when);
                testCase.verifyEqual(description, extraction1.description);
                testCase.verifyEqual(comment, extraction1.comment);
                testCase.verifyEqual(extraction1.symbReps, {[]});
                testCase.verifyEqual(extraction1.segments{i}.starts{1}, zeros(1, 0));
                testCase.verifyEqual(extraction1.segments{i}.durations{1}, zeros(1, 0));
                
                testCase.verifyEqual(data(3, 2), extraction2.data);
                testCase.verifyEqual(time(3), extraction2.time);
                testCase.verifyEqual(tags(2), extraction2.tags);
                testCase.verifyEqual(units(2), extraction2.units);
                testCase.verifyEqual(numel(extraction2.symbReps{:}), 1);
                testCase.verifyEqual(extraction2.symbReps{1}.symbols, categorical({'a'}));
                testCase.verifyEqual(extraction2.symbReps{1}.durations, [1]);
                testCase.verifyEqual(extraction2.segments{i}.starts{1}, zeros(1, 0));
                testCase.verifyEqual(extraction2.segments{i}.durations{1}, zeros(1, 0));
                
                testCase.verifyEqual(data(:, 4), extraction3.data);
                testCase.verifyEqual(time, extraction3.time);
                testCase.verifyEqual(tags(4), extraction3.tags);
                testCase.verifyEqual(units(4), extraction3.units);
                testCase.verifyEqual(numel(extraction3.symbReps{:}), 0);
                testCase.verifyEqual(extraction3.segments{i}.starts{1}, 4);
                testCase.verifyEqual(extraction3.segments{i}.durations{1}, 2);
                
                testCase.verifyEqual(data(3, :), extraction4.data);
                testCase.verifyEqual(time(3), extraction4.time);
                testCase.verifyEqual(tags, extraction4.tags);
                testCase.verifyEqual(units, extraction4.units);
                testCase.verifyEqual(size(extraction4.symbReps, 2), 4);
                testCase.verifyEqual(extraction4.symbReps{2}.symbols, categorical({'a'}));
                testCase.verifyEqual(extraction4.symbReps{2}.durations, [1]);
                testCase.verifyEqual(extraction4.symbReps{3}.symbols, categorical({'a'}));
                testCase.verifyEqual(extraction4.symbReps{3}.durations, [1]);
                testCase.verifyEqual(extraction4.segments{i}.starts{1}, zeros(1, 0));
                testCase.verifyEqual(extraction4.segments{i}.durations{1}, zeros(1, 0));
                
                testCase.verifyEqual(data(2 : 4, 2 : 3), extraction5.data);
                testCase.verifyEqual(time(2 : 4), extraction5.time);
                testCase.verifyEqual(tags(2 : 3), extraction5.tags);
                testCase.verifyEqual(units(2 : 3), extraction5.units);
                testCase.verifyEqual(size(extraction5.symbReps, 2), 2);
                testCase.verifyEqual(extraction5.symbReps{1}.symbols, categorical({'a'; 'b'}));
                testCase.verifyEqual(extraction5.symbReps{1}.durations, [2; 1]);
                testCase.verifyEqual(extraction5.symbReps{2}.symbols, categorical({'a'; 'b'}));
                testCase.verifyEqual(extraction5.symbReps{2}.durations, [2; 1]);
                testCase.verifyEqual(extraction5.segments{i}.starts{1}, 3);
                testCase.verifyEqual(extraction5.segments{i}.durations{1}, 1);
                
                testCase.verifyEqual(data(2 : 4, 2), extraction6.data);
                testCase.verifyEqual(time(2 : 4), extraction6.time);
                testCase.verifyEqual(tags(2), extraction6.tags);
                testCase.verifyEqual(units(2), extraction6.units);
                testCase.verifyEqual(size(extraction6.symbReps, 2), 1);
                testCase.verifyEqual(extraction6.symbReps{1}.symbols, categorical({'a'; 'b'}));
                testCase.verifyEqual(extraction6.symbReps{1}.durations, [2; 1]);
                testCase.verifyEqual(extraction6.segments{i}.starts{1}, 3);
                testCase.verifyEqual(extraction6.segments{i}.durations{1}, 1);
                
                testCase.verifyEqual(data(3 : 5, 2 : 3), extraction7.data);
                testCase.verifyEqual(time(3 : 5), extraction7.time);
                testCase.verifyEqual(tags(2 : 3), extraction7.tags);
                testCase.verifyEqual(units(2 : 3), extraction7.units);
                testCase.verifyEqual(size(extraction7.symbReps, 2), 2);
                testCase.verifyEqual(extraction7.symbReps{1}.symbols, categorical({'a'; 'b'}));
                testCase.verifyEqual(extraction7.symbReps{1}.durations, [1; 2]);
                testCase.verifyEqual(extraction7.symbReps{2}.symbols, categorical({'a'; 'b'}));
                testCase.verifyEqual(extraction7.symbReps{2}.durations, [1; 2]);
                testCase.verifyEqual(extraction7.segments{i}.starts{1}, 2);
                testCase.verifyEqual(extraction7.segments{i}.durations{1}, 2);
            end
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
            tags = {'Channel 1'; 'Channel 2'; 'Channel 3'; 'Channel 4'};
            units = {'s', 'min', 'elephants', 'giraffes'};
            name = 'TS-Test';
            who = 'Operator';
            when = 'Now';
            description = {'This is a TS-Test'; 'with two text lines'};
            comment = {'This is'; 'a comment'};
            tsEvents = containers.Map;
            symbReps = cell(1, numel(tags));
            nTimestamps = numel(time);
            segments = segmentsObject(nTimestamps);
            for i=1:numel(tags)
                segmentsIn{i} = segments;
            end
            columnsToExtract = [2, 4];
            tagsToExtract = tags(columnsToExtract);
            dataToExtract = data(:, columnsToExtract);
            unitsToExtract = units(:, columnsToExtract);
            
            returns = mdtsCoreObject(time, data, tags, units, ts, name, who, when, description, comment, tsEvents, symbReps, segmentsIn);
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
            tags = {'Channel 1'; 'Channel 2'; 'Channel 3'; 'Channel 4'};
            units = {'s', 'min', 'elephants', 'giraffes'};
            name = 'TS-Test';
            who = 'Operator';
            when = 'Now';
            description = {'This is a TS-Test'; 'with two text lines'};
            comment = {'This is'; 'a comment'};
            tsEvents = containers.Map;
            symbReps = cell(1, numel(tags));
            nTimestamps = numel(time);
            segments = segmentsObject(nTimestamps);
            
            for i=1:numel(tags)
                segmentsIn{i} = segments;
            end
            
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
            
            returns = mdtsCoreObject(time, data, tags, units, ts, name, who, when, description, comment, tsEvents, symbReps, segmentsIn);
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
        
        function testgetRawData(testCase)
            
            ts = duration(0, 0, 0, 50);
            time = [datenum(datetime(2017, 7, 31, 14, 3, 3, 123 + 0 * seconds(ts)));
                datenum(datetime(2017, 7, 31, 14, 3, 3, 123 + 1 * seconds(ts)));
                datenum(datetime(2017, 7, 31, 14, 3, 3, 123 + 2 * seconds(ts)));
                datenum(datetime(2017, 7, 31, 14, 3, 3, 123 + 3 * seconds(ts)))];
            data = [9, 8, 7, 6;
                7, 6, 5, 4;
                8, 7, 6, 5;
                6, 5, 4, 3];
            tags = {'Channel 1'; 'Channel 2'; 'Channel 3'; 'Channel 4'};
            units = {'s', 'min', 'elephants', 'giraffes'};
            name = 'TS-Test';
            who = 'Operator';
            when = 'Now';
            description = {'This is a TS-Test'; 'with two text lines'};
            comment = {'This is'; 'a comment'};
            tsEvents = containers.Map;
            symbReps = cell(1, numel(tags));
            nTimestamps = numel(time);
            segments = segmentsObject(nTimestamps);
            for i=1:numel(tags)
                segmentsIn{i} = segments;
            end
            
            columnsToExtract = [2, 4];
            rowsToExtract = [2, 3];
            tagsToExtract = tags(columnsToExtract);
            timeToExtract = time(rowsToExtract);
            expectedReturn1 = data(:, columnsToExtract);
            expectedReturn2 = data(rowsToExtract, columnsToExtract);
            
            returns = mdtsCoreObject(time, data, tags, units, ts, name, who, when, description, comment, tsEvents, symbReps, segmentsIn);
            returnMat1 = returns.getRawData(tagsToExtract);
            returnMat2 = returns.getRawData(tagsToExtract, timeToExtract);
            
            testCase.verifyEqual(returnMat1, expectedReturn1);
            testCase.verifyEqual(returnMat2, expectedReturn2);
            
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
            tsEvents = containers.Map;
            symbReps = cell(1, numel(tags));
            nTimestamps = numel(time);
            segments = segmentsObject(nTimestamps);
            
            columnsToExtract1 = [2, 4];
            tagsToExtract1 = tags(columnsToExtract1);
            
            columnsToExtract2 = [4, 3];
            tagsToExtract2 = tags(columnsToExtract2);
            
            returns = mdtsCoreObject(time, data, tags, units, ts, name, who, when, description, comment, tsEvents, symbReps, segments);
            
            tagIndices1 = returns.getTagIndices(tagsToExtract1);
            tagIndices2 = returns.getTagIndices(tagsToExtract2);
            
            testCase.verifyEqual(tagIndices1, columnsToExtract1);
            testCase.verifyEqual(tagIndices2, columnsToExtract2);
            
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
            tsEvents = containers.Map;
            symbReps = cell(1, numel(tags));
            nTimestamps = numel(time);
            segments = segmentsObject(nTimestamps);
            
            linesToExtract = [2; 4];
            timeInterval = time(linesToExtract);
            
            returns = mdtsCoreObject(time, data, tags, units, ts, name, who, when, description, comment, tsEvents, symbReps, segments);
            timeIndices = returns.getIntervalIndices(timeInterval);
            
            testCase.verifyEqual(timeIndices, linesToExtract);
            
        end
        
        function testcheckTags(testCase)
            
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
            tsEvents = containers.Map;
            symbReps = cell(1, numel(tags));
            nTimestamps = numel(time);
            segments = segmentsObject(nTimestamps);
            
            tagListCorrect = {'Channel 1', 'Channel 2', 'Channel 3', 'Channel 4'};
            tagListInCorrect1 = {'Channel 1', 'Channel 2', 'Channel 3', 'SomeChannel'};
            tagListInCorrect2 = {'Channel 1', 'Channel 2', 'Channel 3', 'Channel 5'};
            
            returns = mdtsCoreObject(time, data, tags, units, ts, name, who, when, description, comment, tsEvents, symbReps, segments);
            
            testCase.verifyEqual(true, returns.checkTags(tagListCorrect));
            testCase.verifyEqual(false, returns.checkTags(tagListInCorrect1));
            testCase.verifyEqual(false, returns.checkTags(tagListInCorrect2));
            
        end
        
        function testDateInputAsString(testCase)
            
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
            tsEvents = containers.Map;
            symbReps = cell(1, numel(tags));
            nTimestamps = numel(time);
            segments = segmentsObject(nTimestamps);
            
            for i=1:numel(tags)
                segmentsIn{i} = segments;
            end
            
            %             date1 = '2017_7_25_14_3';
            %             date2 = '2017_7_25_14';
            %             date3 = '2017_7_25';
            %             date4 = '2017_8';
            
            date1 = '25-Jul-2017 14:03';
            date2 = '25-Jul-2017 2pm';
            date3 = '25-Jul-2017';
            date4 = 'Aug-2017';
            
            returns = mdtsCoreObject(time, data, tags, units, ts, name, who, when, description, comment, tsEvents, symbReps, segmentsIn);
            extractedReturns = returns.getData(tags, date4);
            
            [start1, end1] = returns.startEndOfDate(date1);
            [start2, end2] = returns.startEndOfDate(date2);
            [start3, end3] = returns.startEndOfDate(date3);
            [start4, end4] = returns.startEndOfDate(date4);
            
            testCase.verifyEqual(datenum(2017, 7, 25, 14, 3, 0), start1);
            testCase.verifyEqual(datenum(2017, 7, 25, 14, 4, 0) - 1, end1);
            testCase.verifyEqual(datenum(2017, 7, 25, 14, 0, 0), start2);
            testCase.verifyEqual(datenum(2017, 7, 25, 15, 0, 0) - 1, end2);
            testCase.verifyEqual(datenum(2017, 7, 25, 0, 0, 0), start3);
            testCase.verifyEqual(datenum(2017, 7, 26, 0, 0, 0) - 1, end3);
            testCase.verifyEqual(datenum(2017, 8, 1, 0, 0, 0), start4);
            testCase.verifyEqual(datenum(2017, 9, 1, 0, 0, 0) - 1, end4);
            
            testCase.verifyEqual(extractedReturns.time, time(4 : 5));
            
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
            tsEvents = containers.Map;
            symbReps = cell(1, numel(tags));
            nTimestamps = numel(time);
            segments = segmentsObject(nTimestamps);
            
            addData = [2, 3;
                3, 4;
                4, 5;
                5, 6;
                6, 7;
                7, 8];
            addTags1 = {'AddedTag1', 'AddedTag2'};
            addTags2 = {'AddedTag3', 'AddedTag4'};
            
            returns = mdtsCoreObject(time, data, tags, units, ts, name, who, when, description, comment, tsEvents, symbReps, segments);
            returns2 = mdtsCoreObject(time, data, tags, units, ts, name, who, when, description, comment, tsEvents, symbReps, segments);
            
            returns.expandDataSet(addData, addTags1);
            returns2.expandDataSet(addData, addTags1).expandDataSet(addData, addTags2);
            
            testCase.verifyEqual(returns.data(:, 5 : end), addData);
            testCase.verifyEqual(returns.tags(:, 5 : end), addTags1);
            
            returns.expandDataSet(addData, addTags2);
            
            testCase.verifyEqual(returns.data(:, 5 : end), [addData, addData]);
            testCase.verifyEqual(returns.tags(:, 5 : end), [addTags1, addTags2]);
            
            testCase.verifyEqual(returns2.data(:, 5 : end), [addData, addData]);
            testCase.verifyEqual(returns2.tags(:, 5 : end), [addTags1, addTags2]);
            
        end
        
        function testGetDataFromExpandedSet(testCase)
            
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
            tsEvents = containers.Map;
            symbReps = cell(1, numel(tags));
            nTimestamps = numel(time);
            segments = segmentsObject(nTimestamps);
            
            addData = [2, 3;
                3, 4;
                4, 5;
                5, 6;
                6, 7;
                7, 8];
            addTags = {'AddedTag1', 'AddedTag2'};
            
            returns = mdtsCoreObject(time, data, tags, units, ts, name, who, when, description, comment, tsEvents, symbReps, segments);
            returns.expandDataSet(addData, addTags);
            
            extraction1 = returns(:, :);
            extraction2 = returns(:, 3 : 6);
            extraction3 = returns(:, tags(2 : 4));
            extraction4 = returns(:, [tags(2 : 4), addTags(1)]);
            
            testCase.verifyEqual(data(:, :), extraction1.data(:, 1 : 4));
            testCase.verifyEqual(tags(:, :), extraction1.tags(:, 1 : 4));
            testCase.verifyEqual(addData(:, :), extraction1.data(:, 5 : end));
            testCase.verifyEqual(addTags(:, :), extraction1.tags(:, 5 : end));
            
            testCase.verifyEqual(data(:, 3 : 4), extraction2.data(:, 1 : 2));
            testCase.verifyEqual(tags(:, 3 : 4), extraction2.tags(:, 1 : 2));
            testCase.verifyEqual(addData(:, :), extraction2.data(:, 3 : 4));
            testCase.verifyEqual(addTags(:, :), extraction2.tags(:, 3 : 4));
            
            testCase.verifyEqual(data(:, 2 : 4), extraction3.data);
            testCase.verifyEqual(tags(:, 2 : 4), extraction3.tags);
            
            testCase.verifyEqual(data(:, 2 : 4), extraction4.data(:, 1 : 3));
            testCase.verifyEqual(tags(:, 2 : 4), extraction4.tags(:, 1 : 3));
            testCase.verifyEqual(addData(:, 1), extraction4.data(:, 4 : end));
            testCase.verifyEqual(addTags(:, 1), extraction4.tags(:, 4 : end));
            
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
            tsEvents = containers.Map;
            symbReps = cell(1, numel(tags));
            nTimestamps = numel(time);
            segments = segmentsObject(nTimestamps);
            
            returns = mdtsCoreObject(time, data, tags, units, ts, name, who, when, description, comment, tsEvents, symbReps, segments);
            
            eventInfo.eventTime = time(2);
            eventInfo.eventDuration = 5 * ts;
            
            returns.addEvent('event1', eventInfo.eventTime, eventInfo.eventDuration);
            
            testCase.verifyEqual(returns.tsEvents('event1'), eventInfo);
            
        end
        
        function testAddSymbRepToChannel(testCase)
            
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
            tsEvents = containers.Map;
            symbReps = cell(1, numel(tags));
            nTimestamps = numel(time);
            segments = segmentsObject(nTimestamps);
            
            returns = mdtsCoreObject(time, data, tags, units, ts, name, who, when, description, comment, tsEvents, symbReps, segments);
            
            durations = [4; 5];
            symbols = categorical({'a'; 'b'}, {'a'; 'b'});
            symbObj = SymbRepObject(durations, symbols);
            
            returns.addSymbRepToChannel(2, symbObj);
            
            retSymbObj = returns.symbReps{2};
            
            testCase.verifyEqual(retSymbObj.durations, durations);
            testCase.verifyEqual(retSymbObj.symbols, symbols);
            
        end
        
        function testAddSymbRepToAllChannels(testCase)
            
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
            tsEvents = containers.Map;
            symbReps = cell(1, numel(tags));
            nTimestamps = numel(time);
            segments = segmentsObject(nTimestamps);
            
            returns1 = mdtsCoreObject(time, data, tags, units, ts, name, who, when, description, comment, tsEvents, symbReps, segments);
            returns2 = mdtsCoreObject(time, data, tags, units, ts, name, who, when, description, comment, tsEvents, symbReps, segments);
            
            durations1 = [4; 5];
            symbols1 = categorical({'a'; 'b'}, {'a'; 'b'});
            symbObj1 = SymbRepObject(durations1, symbols1);
            
            durations2 = [8; 1];
            symbols2 = categorical({'c'; 'd'}, {'c'; 'd'});
            symbObj2 = SymbRepObject(durations2, symbols2);
            
            durations3 = [3; 6];
            symbols3 = categorical({'e'; 'f'}, {'e'; 'f'});
            symbObj3 = SymbRepObject(durations3, symbols3);
            
            keepExistentSymbReps1 = true;
            keepExistentSymbReps2 = false;
            
            returns1.addSymbRepToChannel(2, symbObj1);
            returns1.addSymbRepToChannel(4, symbObj2);
            
            returns1.addSymbRepToAllChannels(symbObj3, keepExistentSymbReps1);
            
            retSymbObj1a = returns1.symbReps{2};
            retSymbObj1b = returns1.symbReps{4};
            retSymbObj2a = returns1.symbReps{1};
            retSymbObj2b = returns1.symbReps{3};
            
            returns2.addSymbRepToChannel(2, symbObj1);
            returns2.addSymbRepToChannel(4, symbObj2);
            
            returns2.addSymbRepToAllChannels(symbObj3, keepExistentSymbReps2);
            
            retSymbObj3a = returns2.symbReps{1};
            retSymbObj3b = returns2.symbReps{2};
            retSymbObj3c = returns2.symbReps{3};
            retSymbObj3d = returns2.symbReps{4};
            
            testCase.verifyEqual(retSymbObj1a.durations, durations1);
            testCase.verifyEqual(retSymbObj1a.symbols, symbols1);
            testCase.verifyEqual(retSymbObj1b.durations, durations2);
            testCase.verifyEqual(retSymbObj1b.symbols, symbols2);
            testCase.verifyEqual(retSymbObj2a.durations, durations3);
            testCase.verifyEqual(retSymbObj2a.symbols, symbols3);
            testCase.verifyEqual(retSymbObj2b.durations, durations3);
            testCase.verifyEqual(retSymbObj2b.symbols, symbols3);
            
            testCase.verifyEqual(retSymbObj3a.durations, durations3);
            testCase.verifyEqual(retSymbObj3a.symbols, symbols3);
            testCase.verifyEqual(retSymbObj3b.durations, durations3);
            testCase.verifyEqual(retSymbObj3b.symbols, symbols3);
            testCase.verifyEqual(retSymbObj3c.durations, durations3);
            testCase.verifyEqual(retSymbObj3c.symbols, symbols3);
            testCase.verifyEqual(retSymbObj3d.durations, durations3);
            testCase.verifyEqual(retSymbObj3d.symbols, symbols3);
            
        end
        
        function testAddSegmentsToAllChannels(testCase)
            
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
            tsEvents = containers.Map;
            symbReps = cell(1, numel(tags));
            segReps = cell(1, numel(tags));
            nTimestamps = 100;
            segments = segmentsObject(nTimestamps);
            tagName1 = 'newChannel';
            bVec1 = false(nTimestamps, 1);
            tagName2 = 'secondChannel';
            bVec2 = true(nTimestamps, 1);
            segments = segments.addSegmentVector(tagName1, bVec1);
            segments = segments.addSegmentVector(tagName2, bVec2);
            
            returns = mdtsCoreObject(time, data, tags, units, ts, name, who, when, description, comment, tsEvents, symbReps, segReps);
            
            returns.addSegmentsToAllChannels(segments, false);
            
            retSegments = returns.segments;
            for i = 1:numel(tags)
                testCase.verifyEqual(retSegments{i}.tags{1}, tagName1);
                testCase.verifyEqual(retSegments{i}.tags{2}, tagName2);
                testCase.verifyEqual(retSegments{i}.starts{1}, zeros(0, 1));
                testCase.verifyEqual(retSegments{i}.starts{2}, [1]);
                testCase.verifyEqual(retSegments{i}.durations{1}, zeros(1, 0));
                testCase.verifyEqual(retSegments{i}.durations{2}, [nTimestamps]);
            end
            
        end
        function testAddSegmentsToChannels(testCase)
            
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
            tsEvents = containers.Map;
            symbReps = cell(1, numel(tags));
            segReps = cell(1, numel(tags));
            nTimestamps = 100;
            segments = segmentsObject(nTimestamps);
%             tagName1 = 'newChannel';
%             bVec1 = false(nTimestamps, 1);
%             tagName2 = 'secondChannel';
%             bVec2 = true(nTimestamps, 1);
%             segments = segments.addSegmentVector(tagName1, bVec1);
%             segments = segments.addSegmentVector(tagName2, bVec2);
%             
            returns = mdtsCoreObject(time, data, tags, units, ts, name, who, when, description, comment, tsEvents, symbReps, segReps);
            
%             returns.addSegmentsToAllChannels(segments, false);
            
           
            
            segs = {};
            for i=1:4
                segTemp = segmentsObject(nTimestamps);
                tagName1{i} = ['Seg', int2str(i), '_SegTag1'];
                tagName2{i} = ['Seg', int2str(i), '_SegTag2'];
                bVecs1{i} = logical(randi([0,1],nTimestamps,1));
                bVect2{i} = logical(randi([0,1],nTimestamps,1));
                segTemp = segTemp.addSegmentVector(tagName1{i},bVecs1{i} );
                segTemp = segTemp.addSegmentVector(tagName2{i},  bVect2{i});
                segs{i} = segTemp;
                returns.addSegmentsToChannels(segTemp,i);
            end
            
            
            
            retSegments = returns.segments;
            for i = 1:numel(tags)
                testCase.verifyEqual(retSegments{i}.tags{1}, tagName1{i});
                testCase.verifyEqual(retSegments{i}.tags{2}, tagName2{i});
                
                bVec = bVecs1{i};
                valueChange = [bVec(1); diff(bVec) ~= 0];
                changeInds = find(valueChange);
                durationInds = diff(find([valueChange; 1]));
                
                starts1 = changeInds(1 : 2 : end);
                durations1 = durationInds(1 : 2 : end);
                
                bVec = bVect2{i};
                valueChange = [bVec(1); diff(bVec) ~= 0];
                changeInds = find(valueChange);
                durationInds = diff(find([valueChange; 1]));
                
                starts2 = changeInds(1 : 2 : end);
                durations2 = durationInds(1 : 2 : end);
                
                testCase.verifyEqual(retSegments{i}.starts{1},starts1);
                testCase.verifyEqual(retSegments{i}.starts{2}, starts2);
                testCase.verifyEqual(retSegments{i}.durations{1},durations1);
                testCase.verifyEqual(retSegments{i}.durations{2},durations2);
            end
            
        end
        
        function testAddSegments(testCase)
            
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
            tsEvents = containers.Map;
            symbReps = cell(1, numel(tags));
            segReps = cell(1, numel(tags));
            nTimestamps = 100;
            segments = segmentsObject(nTimestamps);
            tagName1 = 'newChannel';
            bVec1 = false(nTimestamps, 1);
            tagName2 = 'secondChannel';
            bVec2 = true(nTimestamps, 1);
            segments = segments.addSegmentVector(tagName1, bVec1);
            segments = segments.addSegmentVector(tagName2, bVec2);
            
            returns = mdtsCoreObject(time, data, tags, units, ts, name, who, when, description, comment, tsEvents, symbReps, segReps);
            
            returns.addSegments(segments);
            
            retSegments = returns.segments;
            for i = 1:numel(tags)
                testCase.verifyEqual(retSegments{i}.tags{1}, tagName1);
                testCase.verifyEqual(retSegments{i}.tags{2}, tagName2);
                testCase.verifyEqual(retSegments{i}.starts{1}, zeros(0, 1));
                testCase.verifyEqual(retSegments{i}.starts{2}, [1]);
                testCase.verifyEqual(retSegments{i}.durations{1}, zeros(1, 0));
                testCase.verifyEqual(retSegments{i}.durations{2}, [nTimestamps]);
            end
            
        end
        
    end
    
end


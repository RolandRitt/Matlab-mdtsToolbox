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
        defaultObj;
        defaultAliasTable;
        defaultAliasTable2;
        defaultTags;
        defaultTags2;
    end
    methods(TestMethodSetup)
        function createDefaultTags(testCase)
            testCase.defaultTags = {'Channel 1', 'Channel2'};
            testCase.defaultTags2 = {'Channel 1', 'Channel 2', 'Channel 3', 'Channel 4'};
        end
        function createDefaultObj(testCase)
            ts = duration(0, 0, 0, 50);
            time = [datenum(datetime(2017, 7, 31, 14, 3, 3, 123 + 0 * seconds(ts)));
                datenum(datetime(2017, 7, 31, 14, 3, 3, 123 + 1 * seconds(ts)));
                datenum(datetime(2017, 7, 31, 14, 3, 3, 123 + 2 * seconds(ts)));
                datenum(datetime(2017, 7, 31, 14, 3, 3, 123 + 3 * seconds(ts)))];
            data = [9, 8;
                7, 6;
                8, 7;
                6, 5];
            tags = testCase.defaultTags;
            testCase.defaultObj = mdtsObject(time, data, tags);
        end
        function createDeafaultAliasTable(testCase)
            tags = testCase.defaultTags;
            AliasTable = array2table(cell(0,1));
            AliasTable.Properties.VariableNames = {'OrigTag'};
            AliasTable({'alias1', 'al 2'},:) = tags([2,1])';
            testCase.defaultAliasTable = AliasTable;
            
            tags2 = testCase.defaultTags2;
            AliasTable2 = array2table(cell(0,1));
            AliasTable2.Properties.VariableNames = {'OrigTag'};
            AliasTable2({'alias 1', 'alias 2', 'alias 3', 'alias 4'},:) = tags2([2,1,4,3])';
            testCase.defaultAliasTable2 = AliasTable2;
        end
    end
    methods (Test)
        
        function testMinimumconstructor(testCase)
            ts = duration(0, 0, 0, 50);
            time = [datenum(datetime(2017, 7, 31, 14, 3, 3, 123 + 0 * seconds(ts)));
                datenum(datetime(2017, 7, 31, 14, 3, 3, 123 + 1 * seconds(ts)));
                datenum(datetime(2017, 7, 31, 14, 3, 3, 123 + 2 * seconds(ts)));
                datenum(datetime(2017, 7, 31, 14, 3, 3, 123 + 3 * seconds(ts)))];
            data = [9, 8;
                7, 6;
                8, 7;
                6, 5];
            tags = testCase.defaultTags;
            defaultAliasTable = array2table(cell(0,1));
            defaultAliasTable.Properties.VariableNames = {'OrigTag'};
            
            
            returns2 = mdtsObject(time, data, tags);
                        
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
            testCase.verifyEqual(returns2.segments, cell(1, numel(tags)));
            testCase.verifyEqual(returns2.aliasTable, defaultAliasTable);
            
            
            testCase.verifyEqual(returns2.timeRelative, time - time(1));
            testCase.verifyEqual(returns2.timeDateTime, datetime(time, 'ConvertFrom', 'datenum'));
        end
        
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
            tags = testCase.defaultTags;
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
            segments = cell(1, numel(tags));
            segments{2} = segmentsObject(100);
            defaultAliasTable = array2table(cell(0,1));
            defaultAliasTable.Properties.VariableNames = {'OrigTag'};
            defaultAliasTable({'alias1', 'al 2'},:) = tags([2,1])';
            
            returns = mdtsObject(time, data, tags, 'units', units, 'ts', ts, ...
                'name', name, 'who', who, 'when', when, 'description', description,...
                'comment', comment, 'tsEvents', tsEvents, 'symbReps', symbReps, 'segments', segments, 'aliasTable',defaultAliasTable );
            
            
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
            testCase.verifyEqual(returns.aliasTable, defaultAliasTable);
            
            testCase.verifyEqual(returns.fs, 1 / seconds(ts));
            testCase.verifyEqual(returns.timeRelative, time - time(1));
            testCase.verifyEqual(returns.timeDateTime, datetime(time, 'ConvertFrom', 'datenum'));
            

            
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
            tags = testCase.defaultTags;
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
            
            for i = 1:numel(tags)
                segmentsIn{i} =segments;
            end
            returns = mdtsObject(time, data, tags, 'units', units, 'ts', ts, 'name', name, 'who', who, 'when', when, 'description', description, 'comment', comment, 'tsEvents', tsEvents, 'symbReps', symbReps, 'segments', segmentsIn);
            returns.addAliases('alias1', 'Channel 2');
            
            extraction1 = returns(1, 1);
            extraction2 = returns(3, 2);
            extraction3 = returns(:, 4);
            extraction4 = returns(3, :);
            extraction5 = returns(2 : 4, 2 : 3);
            extraction6 = returns(2 : 4, tags{2});
            extraction7 = returns(3 : 5, tags(2 : 3));
            extraction8 = returns(:, 'alias1');
            
            for i = 1:numel(tags)
                testCase.verifyEqual(data(1, 1), extraction1.data);
                testCase.verifyEqual(time(1), extraction1.time);
                testCase.verifyEqual(tags(1), extraction1.tags);
                testCase.verifyEqual(units(1), extraction1.units);
                testCase.verifyEqual(name, extraction1.name);
                testCase.verifyEqual(who, extraction1.who);
                testCase.verifyEqual(when, extraction1.when);
                testCase.verifyEqual(description, extraction1.description);
                testCase.verifyEqual(comment, extraction1.comment);
                testCase.verifyEqual(extraction1.segments{i}.starts{1}, zeros(1, 0));
                testCase.verifyEqual(extraction1.segments{i}.durations{1}, zeros(1, 0));
                
                testCase.verifyEqual(data(3, 2), extraction2.data);
                testCase.verifyEqual(time(3), extraction2.time);
                testCase.verifyEqual(tags(2), extraction2.tags);
                testCase.verifyEqual(units(2), extraction2.units);
                testCase.verifyEqual(extraction2.segments{i}.starts{1}, zeros(1, 0));
                testCase.verifyEqual(extraction2.segments{i}.durations{1}, zeros(1, 0));
                
                testCase.verifyEqual(data(:, 4), extraction3.data);
                testCase.verifyEqual(time, extraction3.time);
                testCase.verifyEqual(tags(4), extraction3.tags);
                testCase.verifyEqual(units(4), extraction3.units);
                testCase.verifyEqual(extraction3.segments{i}.starts{1}, 4);
                testCase.verifyEqual(extraction3.segments{i}.durations{1}, 2);
                
                testCase.verifyEqual(data(3, :), extraction4.data);
                testCase.verifyEqual(time(3), extraction4.time);
                testCase.verifyEqual(tags, extraction4.tags);
                testCase.verifyEqual(units, extraction4.units);
                testCase.verifyEqual(extraction4.segments{i}.starts{1}, zeros(1, 0));
                testCase.verifyEqual(extraction4.segments{i}.durations{1}, zeros(1, 0));
                
                testCase.verifyEqual(data(2 : 4, 2 : 3), extraction5.data);
                testCase.verifyEqual(time(2 : 4), extraction5.time);
                testCase.verifyEqual(tags(2 : 3), extraction5.tags);
                testCase.verifyEqual(units(2 : 3), extraction5.units);
                testCase.verifyEqual(extraction5.segments{i}.starts{1}, 3);
                testCase.verifyEqual(extraction5.segments{i}.durations{1}, 1);
                
                testCase.verifyEqual(data(2 : 4, 2), extraction6.data);
                testCase.verifyEqual(time(2 : 4), extraction6.time);
                testCase.verifyEqual(tags(2), extraction6.tags);
                testCase.verifyEqual(units(2), extraction6.units);
                testCase.verifyEqual(extraction6.segments{i}.starts{1}, 3);
                testCase.verifyEqual(extraction6.segments{i}.durations{1}, 1);
                
                testCase.verifyEqual(data(3 : 5, 2 : 3), extraction7.data);
                testCase.verifyEqual(time(3 : 5), extraction7.time);
                testCase.verifyEqual(tags(2 : 3), extraction7.tags);
                testCase.verifyEqual(units(2 : 3), extraction7.units);
                testCase.verifyEqual(extraction7.segments{i}.starts{1}, 2);
                testCase.verifyEqual(extraction7.segments{i}.durations{1}, 2);
            end
            testCase.verifyEqual(extraction8, returns(:,'Channel 2'));
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
            
            returnObject4 = returns.getData(tagsToExtract, timeToExtract2+datenum(minutes(30)));
            testCase.verifyEqual(returnObject4.time, []);
            testCase.verifyEqual(returnObject4.data, double.empty(0,2));
            testCase.verifyEqual(returnObject4.isSubset, true);
            testCase.verifyEqual(returnObject4.timeDateTime, datetime([],[],[]));
            
            
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
            dataToExtract4 = data(:, columnsToExtract);
            
            returns = mdtsObject(time, data, tags, 'units', units, 'ts', ts, 'name', name, 'who', who, 'when', when, 'description', description, 'comment', comment, 'tsEvents', tsEvents, 'symbReps', symbReps);
            returnMat1 = returns.getRawData(tagsToExtract, timeToExtract1);
            returnMat2 = returns.getRawData(tagsToExtract, timeToExtract2);
            returnMat3 = returns.getRawData(tagsToExtract, timeToExtract2StartEnd);
            returnMat4 = returns.getRawData(tagsToExtract);
            
            testCase.verifyEqual(returnMat1, dataToExtract1);
            testCase.verifyEqual(returnMat2, dataToExtract2);
            testCase.verifyEqual(returnMat3, dataToExtract2);
            testCase.verifyEqual(returnMat4, dataToExtract4);
            
            testCase.verifyError(@()returns.getRawData(1, 2, 3), 'getRawData:InvalidNumberOfInputs');
            
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
            
            indStart = find(time>=tooLargeInterval(1), 1);
            indStop = find(time<=tooLargeInterval(2), 1,'last');
            
            testCase.verifyEqual(returns.getIntervalIndices(tooLargeInterval),[indStart, indStop]');
            
            
            OutsideInterval = [time(end) + seconds(1); time(end) + seconds(5)];
            
            indStart = find(time>=OutsideInterval(1), 1);
            indStop = find(time<=OutsideInterval(2), 1,'last');
            
            testCase.verifyEqual(returns.getIntervalIndices(OutsideInterval),double.empty(2,0));
            
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
            tags = testCase.defaultTags2;
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
            returns.setAliasTable(testCase.defaultAliasTable2);
            aliases = testCase.defaultAliasTable2.Properties.RowNames;
            testCase.verifyError(@()returns.expandDataSet(addData, aliases([1,2])'), 'expandDataSet:NonUniqueTagsAlias');
            testCase.verifyError(@()returns.expandDataSet(addData, [aliases([1]),addTags1(1)]'), 'expandDataSet:NonUniqueTagsAlias');
            returns.expandDataSet(logical(randi([0,1], size(time))), 'logical');
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
            eventInfo6.eventTime = time(2);
            
            eventInfo1.eventDuration = 3;
            eventInfo2.eventDuration = [3; 4];
            eventInfo3.eventDuration = int32(3);
            eventInfo4.eventDuration = 3.3;
            eventInfo5.eventDuration = 3;
            eventInfo6.eventDuration = seconds(3);
            
            returns = mdtsObject(time, data, tags, 'units', units, 'ts', ts, 'name', name, 'who', who, 'when', when, 'description', description, 'comment', comment, 'tsEvents', tsEvents, 'symbReps', symbReps);
            
            returns.addEvent(eventName1, eventInfo1.eventTime, eventInfo1.eventDuration);
            testCase.verifyEqual(returns.tsEvents(eventName1), eventInfo1);
            
            returns.addEvent(eventName1, eventInfo6.eventTime, eventInfo6.eventDuration);
            testCase.verifyEqual(returns.tsEvents(eventName1), eventInfo6);
            
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
            
            returns1 = mdtsObject(time, data, tags, 'units', units, 'ts', ts, 'name', name, 'who', who, 'when', when, 'description', description, 'comment', comment, 'tsEvents', tsEvents, 'symbReps', symbReps);
            returns2 = mdtsObject(time, data, tags, 'units', units, 'ts', ts, 'name', name, 'who', who, 'when', when, 'description', description, 'comment', comment, 'tsEvents', tsEvents, 'symbReps', symbReps);
            
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
            
            returns1.addSymbRepToAllChannels(symbObj3, 'keepExistentSymbReps', keepExistentSymbReps1);
            
            retSymbObj1a = returns1.symbReps{2};
            retSymbObj1b = returns1.symbReps{4};
            retSymbObj2a = returns1.symbReps{1};
            retSymbObj2b = returns1.symbReps{3};
            
            returns2.addSymbRepToChannel(2, symbObj1);
            returns2.addSymbRepToChannel(4, symbObj2);
            
            returns2.addSymbRepToAllChannels(symbObj3, 'keepExistentSymbReps', keepExistentSymbReps2);
            
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
            
            testCase.verifyError(@()returns1.addSymbRepToAllChannels('test1'), 'addSymbRepToAllChannels:NotASymbRepObject');
            
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
            for i = 1:numel(tags)
                testCase.verifyEqual(retSegments{i}.tags{1}, tagName1);
                testCase.verifyEqual(retSegments{i}.tags{2}, tagName2);
                testCase.verifyEqual(retSegments{i}.starts{1}, zeros(0, 1));
                testCase.verifyEqual(retSegments{i}.starts{2}, [1]);
                testCase.verifyEqual(retSegments{i}.durations{1}, zeros(1, 0));
                testCase.verifyEqual(retSegments{i}.durations{2}, [nTimestamps]);
            end
            
            testCase.verifyError(@()returns2.addSegments('test1'), 'addSegments:NotASegmentsObject');
            %             testCase.verifyError(@()returns.addSegments(segments1), 'addSegments:SegmentsAlreadyAdded');
            testCase.verifyError(@()returns2.addSegments(segments2), 'addSegments:InvalidNumberOfTimestamps');
            
        end
        
        
        function testAddSegmentsToAllChannels(testCase)
            
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
            
            returns.addSegmentsToAllChannels(segments1);
            
            retSegments = returns.segments;
            for i = 1:numel(tags)
                testCase.verifyEqual(retSegments{i}.tags{1}, tagName1);
                testCase.verifyEqual(retSegments{i}.tags{2}, tagName2);
                testCase.verifyEqual(retSegments{i}.starts{1}, zeros(0, 1));
                testCase.verifyEqual(retSegments{i}.starts{2}, [1]);
                testCase.verifyEqual(retSegments{i}.durations{1}, zeros(1, 0));
                testCase.verifyEqual(retSegments{i}.durations{2}, [nTimestamps]);
            end
            
            testCase.verifyError(@()returns2.addSegmentsToAllChannels('test1'), 'addSegmentsToAllChannels:NotASegmentsObject');
            %             testCase.verifyError(@()returns.addSegments(segments1), 'addSegments:SegmentsAlreadyAdded');
            testCase.verifyError(@()returns2.addSegmentsToAllChannels(segments2), 'addSegmentsToAllChannels:InvalidNumberOfTimestamps');
            
        end
        
        
      function testAddSegmentsToChannel(testCase)
            
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
            tags = {'Channel 1', 'Channel 2', 'Channel 3'};
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
%             segments1 = segmentsObject(nTimestamps);
%             tagName1 = 'newChannel';
%             bVec1 = false(nTimestamps, 1);
%             tagName2 = 'secondChannel';
%             bVec2 = true(nTimestamps, 1);
%             segments1 = segments1.addSegmentVector(tagName1, bVec1);
%             segments1 = segments1.addSegmentVector(tagName2, bVec2);
             segments2 = segmentsObject(123);
            
            returns = mdtsObject(time, data, tags, 'units', units, 'ts', ts, 'name', name, 'who', who, 'when', when, 'description', description, 'comment', comment, 'tsEvents', tsEvents, 'symbReps', symbReps);
            returns2 = mdtsObject(time, data, tags, 'units', units, 'ts', ts, 'name', name, 'who', who, 'when', when, 'description', description, 'comment', comment, 'tsEvents', tsEvents, 'symbReps', symbReps);
            
            segs = {};
            for i=1:3
                segTemp = segmentsObject(nTimestamps);
                tagName1{i} = ['Seg', int2str(i), '_SegTag1'];
                tagName2{i} = ['Seg', int2str(i), '_SegTag2'];
                bVecs1{i} = logical(randi([0,1],nTimestamps,1));
                bVect2{i} = logical(randi([0,1],nTimestamps,1));
                segTemp = segTemp.addSegmentVector(tagName1{i},bVecs1{i} );
                segTemp = segTemp.addSegmentVector(tagName2{i},  bVect2{i});
                segs{i} = segTemp;
                returns.addSegmentsToChannels(segTemp,['Channel ', int2str(i)]);
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
            
            testCase.verifyError(@()returns2.addSegmentsToChannels('test1', 'Channel 1'), 'addSegmentsToChannels:NotASegmentObject');
            %             testCase.verifyError(@()returns.addSegments(segments1), 'addSegments:SegmentsAlreadyAdded');
            testCase.verifyError(@()returns2.addSegmentsToChannels(segments2, 'Channel 2'), 'addSegmentsToChannels:InvalidNumberOfTimestamps');
            
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
        
        
        function testGetTimeInFormatms(testCase)
            
            ts = duration(0, 0,0, 1);
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
        
        function testisValidAliasTableTags(testCase)
            tags = {'tag1', 'tag2'};
            
            defaultAliasTable = array2table(cell(0,1));
            defaultAliasTable.Properties.VariableNames = {'OrigTag'};
            defaultAliasTable({'alias1', 'al 2'},:) = {'tag1', 'tag2'}';
            
            testCase.verifyTrue(mdtsObject.isValidAliasTableTags(defaultAliasTable,tags));
            
            defaultAliasTable2 = array2table(cell(0,1));
            defaultAliasTable2.Properties.VariableNames = {'OrigTag'};
            defaultAliasTable2({'alias1', 'al 2'},:) = {'tag3', 'tag2'}';
            testCase.verifyFalse(mdtsObject.isValidAliasTableTags(defaultAliasTable2,tags));
 
        end
        
        function testsetAliasTable(testCase)
            
            ts = duration(0, 0, 0, 50);
            time = [datenum(datetime(2017, 7, 31, 14, 3, 3, 123 + 0 * seconds(ts)));
                datenum(datetime(2017, 7, 31, 14, 3, 3, 123 + 1 * seconds(ts)));
                datenum(datetime(2017, 7, 31, 14, 3, 3, 123 + 2 * seconds(ts)));
                datenum(datetime(2017, 7, 31, 14, 3, 3, 123 + 3 * seconds(ts)))];
            data = [9, 8;
                7, 6;
                8, 7;
                6, 5];
            tags = testCase.defaultTags;
            defaultAliasTable = array2table(cell(0,1));
            defaultAliasTable.Properties.VariableNames = {'OrigTag'};
            defaultAliasTable({'alias1', 'al 2'},:) = tags([2,1])';
            
            defaultAliasTable2 = array2table(cell(0,1));
            defaultAliasTable2.Properties.VariableNames = {'OrigTag'};
            defaultAliasTable2({'alias1', 'al 2'},:) = {'Channel 3', 'Channel2'}';
            
            returns2 = mdtsObject(time, data, tags);
            
            returns2.setAliasTable(defaultAliasTable);
            testCase.verifyEqual(returns2.aliasTable, defaultAliasTable);
            
            testCase.verifyError(@()returns2.setAliasTable(defaultAliasTable2),'setAliasTable:InvalidAliasTable');
            
        end
        
        function testisTagWithinTagList(testCase)
            tObj = testCase.defaultObj;
            testCase.verifyTrue(mdtsObject.isTagWithinTagList('Channel 1', tObj.tags));
            testCase.verifyFalse(mdtsObject.isTagWithinTagList('Tg', tObj.tags))
            testCase.verifyEqual (mdtsObject.isTagWithinTagList({'Channel 1', 'Channel2'}, tObj.tags), [true,true])
            testCase.verifyEqual(mdtsObject.isTagWithinTagList({'Channel 1', 'Channel3'}, tObj.tags), [true,false])
            
        end
        function testisTag(testCase)
            tObj = testCase.defaultObj;
            aliases = testCase.defaultAliasTable.Properties.RowNames;
            testCase.verifyTrue(tObj.isTag('Channel 1'));
            testCase.verifyFalse(tObj.isTag('Tg'));
            testCase.verifyEqual(tObj.isTag({'Channel 1', 'Channel2'}), [true, true]);
            testCase.verifyEqual(tObj.isTag({'Channel 1', 'Channel3'}), [true, false]);
            tObj.setAliasTable(testCase.defaultAliasTable);
            %with alias
            testCase.verifyEqual(tObj.isTag({'Channel 1', 'Channel2', aliases{1}}), [true, true, true]);
            testCase.verifyEqual(tObj.isTag({'Channel 1', 'Channel2', aliases{2}}), [true, true, true]);
            testCase.verifyEqual(tObj.isTag({'Channel 1', 'Channel2', aliases{2}, aliases{1}}), [true, true, true, true]);
            testCase.verifyEqual(tObj.isTag({'Channel 1', 'Channel3', aliases{2}, aliases{1}}), [true, false, true, true]);
            
%             testCase.verifyTrue(tObj.isTag({'Channel 1', 'Channel2'}));
%             testCase.verifyFalse(tObj.isTag({'Channel 1', 'Channel3'}));
            
        end
        
        function testisTagWithinAliasTable(testCase)
            tObj = testCase.defaultObj;
            aliases = {'alias1', 'al 2'};
            AliasTable = testCase.defaultAliasTable;
            testCase.verifyTrue(mdtsObject.isTagWithinAliasTable(aliases{1}, AliasTable));
            testCase.verifyTrue(mdtsObject.isTagWithinAliasTable(aliases{2}, AliasTable));
            testCase.verifyEqual(mdtsObject.isTagWithinAliasTable(aliases, AliasTable), [true,true]);
            testCase.verifyFalse(mdtsObject.isTagWithinAliasTable('wrongAlias', AliasTable));
            testCase.verifyEqual(mdtsObject.isTagWithinAliasTable({aliases{2},'wrongAlias'}, AliasTable), [true,false]);
            testCase.verifyEqual(mdtsObject.isTagWithinAliasTable({'wrongAlias',aliases{1}}, AliasTable), [false,true]);
            testCase.verifyEqual(mdtsObject.isTagWithinAliasTable({aliases{1},aliases{1}}, AliasTable), [true,true]);
            %             testCase.verifyFalse(mdtsObject.isWithinTagList('Tg', tObj.tags))
%             testCase.verifyTrue (mdtsObject.isWithinTagList({'Channel 1', 'Channel2'}, tObj.tags))
%             testCase.verifyFalse(mdtsObject.isWithinTagList({'Channel 1', 'Channel3'}, tObj.tags))
            
            testCase.verifyFalse(mdtsObject.isTagWithinAliasTable(aliases{1}, tObj.aliasTable));
            testCase.verifyEqual(mdtsObject.isTagWithinAliasTable(aliases, tObj.aliasTable), [false, false]);
        end
        
        function testisAlias(testCase)
            tObj = testCase.defaultObj;
%             aliases = {'alias1', 'al 2'};
            AliasTable = testCase.defaultAliasTable;
            aliases = AliasTable.Properties.RowNames;
            testCase.verifyFalse(tObj.isAlias(aliases{1}));
            testCase.verifyEqual(tObj.isAlias(aliases), [false, false]');
            tObj.setAliasTable(AliasTable);
            testCase.verifyTrue(tObj.isAlias(aliases{1}));
            testCase.verifyTrue(tObj.isAlias(aliases{2}));
            testCase.verifyEqual(tObj.isAlias(aliases), [true,true]');
            testCase.verifyFalse(tObj.isAlias('wrongAlias'));
            testCase.verifyEqual(tObj.isAlias({aliases{2},'wrongAlias'}), [true,false]);
            testCase.verifyEqual(tObj.isAlias({'wrongAlias',aliases{1}}), [false,true]);
            testCase.verifyEqual(tObj.isAlias({aliases{1},aliases{1}}), [true,true]);
        end
        
        function test_addAliases(testCase)
            
            tObj = testCase.defaultObj;
            AliasTable = testCase.defaultAliasTable;
            defaultTags = testCase.defaultTags;
            tObj.setAliasTable(AliasTable);
            
            testCase.verifyError(@()tObj.addAliases('Te', {'Channel 1','Channel2','Channel 1'}), 'addAliases:InvalidInputArguments:sizeMissmach');
            testCase.verifyError(@()tObj.addAliases(4, {'Channel 1','Channel2','Channel 1'}), 'addAliases:InvalidInputArguments:aliasesWrong');
            testCase.verifyError(@()tObj.addAliases('Te', 5), 'addAliases:InvalidInputArguments:tagsWrong');
            testCase.verifyError(@()tObj.addAliases({'Te',5,'Te'}, {'Channel 1','Channel2','Channel 1'}), 'addAliases:InvalidInputArguments:aliasesWrong');
            testCase.verifyError(@()tObj.addAliases({'Te','asdf','obc'}, {'a',8,'c'}), 'addAliases:InvalidInputArguments:tagsWrong');
            testCase.verifyWarning(@()tObj.addAliases({'Te','asdf','Te'}, {'Channel 1','Channel2','Channel 1'}), 'addAliases:AliasesOverwritten:MultipleAliases');
%             tObj.addAliases({'alias1','asdf','al 2'}, {'a','u','c'})
            testCase.verifyWarning(@()tObj.addAliases({'alias1','asdf','al 2'}, {'Channel 1','Channel2','Channel 1'}), 'addAliases:AliasesOverwritten:AliasAlreadyExist');
            testCase.verifyError(@()tObj.addAliases({'test1','test2'}, {'Channel 1','Channel3'}), 'addAliases:InvalidInputArguments:TagsAreNotDefined');
            
            
            tObj.addAliases('Te', 'Channel 1');
 
            testCase.verifyEqual(tObj.aliasTable{'Te','OrigTag'}, {'Channel 1'});
            tObj.addAliases({'Te', 'Te1'}, {'Channel2', 'Channel 1'});
            testCase.verifyEqual(tObj.aliasTable{{'Te', 'Te1'},'OrigTag'},{'Channel2', 'Channel 1'}');
            
            tObj.addAliases({'Te', 'Te1'}', {'Channel 1', 'Channel2'}');
            testCase.verifyEqual(tObj.aliasTable{{'Te', 'Te1'},'OrigTag'},{'Channel 1', 'Channel2'}');
%             
%             tObj.setAliasTable(AliasTable);
            
        end
        
    end
end
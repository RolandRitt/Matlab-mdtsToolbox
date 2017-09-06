classdef CoreObjectTestClass < matlab.unittest.TestCase
    %
    % Description : Test the CoreObject class
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
            
            returns = CoreObject(time, data, tags, units, ts, name, who, when, description, comment);
            
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
            
            testCase.verifyEqual(returns.fs, duration(0, 0, 1 / seconds(ts)));
            testCase.verifyEqual(returns.timeRelative, time - time(1));
            testCase.verifyEqual(returns.timeDateTime, datetime(time, 'ConvertFrom', 'datenum'));
            
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
            
            returns = CoreObject(time, data, tags, units, ts, name, who, when, description, comment);
            
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
            
            returns = CoreObject(time, data, tags, units, ts, name, who, when, description, comment);
            
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
            
            testCase.verifyEqual(data(3, 2), extraction2.data);
            testCase.verifyEqual(time(3), extraction2.time);
            testCase.verifyEqual(tags(2), extraction2.tags);
            testCase.verifyEqual(units(2), extraction2.units);
               
            testCase.verifyEqual(data(:, 4), extraction3.data);
            testCase.verifyEqual(time, extraction3.time);
            testCase.verifyEqual(tags(4), extraction3.tags);
            testCase.verifyEqual(units(4), extraction3.units);
            
            testCase.verifyEqual(data(3, :), extraction4.data);
            testCase.verifyEqual(time(3), extraction4.time);
            testCase.verifyEqual(tags, extraction4.tags);
            testCase.verifyEqual(units, extraction4.units);
            
            testCase.verifyEqual(data(2 : 4, 2 : 3), extraction5.data);
            testCase.verifyEqual(time(2 : 4), extraction5.time);
            testCase.verifyEqual(tags(2 : 3), extraction5.tags);
            testCase.verifyEqual(units(2 : 3), extraction5.units);
            
            testCase.verifyEqual(data(2 : 4, 2), extraction6.data);
            testCase.verifyEqual(time(2 : 4), extraction6.time);
            testCase.verifyEqual(tags(2), extraction6.tags);
            testCase.verifyEqual(units(2), extraction6.units);
            
            testCase.verifyEqual(data(3 : 5, 2 : 3), extraction7.data);
            testCase.verifyEqual(time(3 : 5), extraction7.time);
            testCase.verifyEqual(tags(2 : 3), extraction7.tags);
            testCase.verifyEqual(units(2 : 3), extraction7.units);
            
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
            tags = {'Channel 1'; 'Channel 2'; 'Channel 3'; 'Channel 4'};
            units = {'s', 'min', 'elephants', 'giraffes'};
            name = 'TS-Test';
            who = 'Operator';
            when = 'Now';
            description = {'This is a TS-Test'; 'with two text lines'};
            comment = {'This is'; 'a comment'};
            
            returns = CoreObject(time, data, tags, units, ts, name, who, when, description, comment);
            returnObject = returns.getData;
            
            testCase.verifyEqual(returnObject.time, time);
            testCase.verifyEqual(returnObject.data, data);
            testCase.verifyEqual(returnObject.tags, tags);
            testCase.verifyEqual(returnObject.units, units);
            testCase.verifyEqual(returnObject.isSubset, false);
            
            testCase.verifyEqual(returns.timeDateTime, datetime(time, 'ConvertFrom', 'datenum'));

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
            
            columnsToExtract = [2, 4];
            tagsToExtract = tags(columnsToExtract);
            dataToExtract = data(:, columnsToExtract);
            unitsToExtract = units(:, columnsToExtract);
            
            returns = CoreObject(time, data, tags, units, ts, name, who, when, description, comment);
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
            
            returns = CoreObject(time, data, tags, units, ts, name, who, when, description, comment);
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
            tags = {'Channel 1'; 'Channel 2'; 'Channel 3'; 'Channel 4'};
            units = {'s', 'min', 'elephants', 'giraffes'};
            name = 'TS-Test';
            who = 'Operator';
            when = 'Now';
            description = {'This is a TS-Test'; 'with two text lines'};
            comment = {'This is'; 'a comment'};
            
            returns = CoreObject(time, data, tags, units, ts, name, who, when, description, comment);
            
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
            
            columnsToExtract = [2, 4];
            tagsToExtract = tags(columnsToExtract);
            
            returns = CoreObject(time, data, tags, units, ts, name, who, when, description, comment);
            tagIndices = returns.getTagIndices(tagsToExtract);
            
            testCase.verifyEqual(tagIndices, columnsToExtract);           
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
            
            linesToExtract = [2; 4];
            timeInterval = time(linesToExtract);
            tooLargeInterval = [time(2); time(end) + 1 / (60 * 60 * 24)];
            
            returns = CoreObject(time, data, tags, units, ts, name, who, when, description, comment);
            timeIndices = returns.getIntervalIndices(timeInterval);
            
            testCase.verifyEqual(timeIndices, linesToExtract);   
            testCase.verifyError(@()returns.getIntervalIndices(tooLargeInterval), 'getIntervalIndices:IntervalOutOfBoundaries');
            
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
            
            tagListCorrect = {'Channel 1', 'Channel 2', 'Channel 3', 'Channel 4'};
            tagListInCorrect1 = {'Channel 1', 'Channel 2', 'Channel 3', 'SomeChannel'};
            tagListInCorrect2 = {'Channel 1', 'Channel 2', 'Channel 3', 'Channel 5'};
            
            returns = CoreObject(time, data, tags, units, ts, name, who, when, description, comment);
                        
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
            
            date1 = '2017_7_25_14_3';
            date2 = '2017_7_25_14';
            date3 = '2017_7_25';
            date4 = '2017_8';
            
            returns = CoreObject(time, data, tags, units, ts, name, who, when, description, comment);
            extractedReturns = returns.getData(tags, date4);    
            
            [start1, end1] = returns.endStartOfDate(date1);
            [start2, end2] = returns.endStartOfDate(date2);
            [start3, end3] = returns.endStartOfDate(date3);
            [start4, end4] = returns.endStartOfDate(date4);
            
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
            
            addData = [2, 3;
                       3, 4;
                       4, 5;
                       5, 6;
                       6, 7;
                       7, 8];
            addTags = {'AddedTag1', 'AddedTag2'};

            returns = CoreObject(time, data, tags, units, ts, name, who, when, description, comment);
            returns2 = CoreObject(time, data, tags, units, ts, name, who, when, description, comment);
            
            returns.expandDataSet(addData, addTags);
            returns2.expandDataSet(addData, addTags).expandDataSet(addData, addTags);
            
            testCase.verifyEqual(returns.exData, addData);
            testCase.verifyEqual(returns.exTags, addTags);
            
            returns.expandDataSet(addData, addTags);
            
            testCase.verifyEqual(returns.exData, [addData, addData]);
            testCase.verifyEqual(returns.exTags, [addTags, addTags]);
            
            testCase.verifyEqual(returns2.exData, [addData, addData]);
            testCase.verifyEqual(returns2.exTags, [addTags, addTags]);
            
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
            
            addData = [2, 3;
                       3, 4;
                       4, 5;
                       5, 6;
                       6, 7;
                       7, 8];
            addTags = {'AddedTag1', 'AddedTag2'};
                      
            returns = CoreObject(time, data, tags, units, ts, name, who, when, description, comment);
            returns.expandDataSet(addData, addTags);
            
            extraction1 = returns(:, :);
            extraction2 = returns(:, 3 : 6);
            extraction3 = returns(:, tags(2 : 4));
            extraction4 = returns(:, [tags(2 : 4), addTags(1)]);
            
            testCase.verifyEqual(data(:, :), extraction1.data);
            testCase.verifyEqual(tags(:, :), extraction1.tags);
            testCase.verifyEqual(addData(:, :), extraction1.exData);
            testCase.verifyEqual(addTags(:, :), extraction1.exTags);

            testCase.verifyEqual(data(:, 3 : 4), extraction2.data);
            testCase.verifyEqual(tags(:, 3 : 4), extraction2.tags);
            testCase.verifyEqual(addData(:, :), extraction2.exData);
            testCase.verifyEqual(addTags(:, :), extraction2.exTags);

            testCase.verifyEqual(data(:, 2 : 4), extraction3.data);
            testCase.verifyEqual(tags(:, 2 : 4), extraction3.tags);
            testCase.verifyEqual([], extraction3.exData);
            testCase.verifyEqual([], extraction3.exTags);
            
            testCase.verifyEqual(data(:, 2 : 4), extraction4.data);
            testCase.verifyEqual(tags(:, 2 : 4), extraction4.tags);
            testCase.verifyEqual(addData(:, 1), extraction4.exData);
            testCase.verifyEqual(addTags(:, 1), extraction4.exTags);
            
        end
        
    end
    
end


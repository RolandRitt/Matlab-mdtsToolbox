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
            
            returns = mdtsObject(time, data, tags, 'units', units, 'ts', ts, 'name', name, 'who', who, 'when', when, 'description', description, 'comment', comment);
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
            
            testCase.verifyEqual(returns2.timeRelative, time - time(1));
            testCase.verifyEqual(returns2.timeDateTime, datetime(time, 'ConvertFrom', 'datenum'));
            
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
            addTags1 = {'AddedTag1', 'AddedTag2'};
            addTags2 = {'AddedTag3', 'AddedTag4'};
            
            returns = mdtsObject(time, data, tags, 'units', units, 'ts', ts, 'name', name, 'who', who, 'when', when, 'description', description, 'comment', comment);
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
            
        end
        
        function testCalculation(testCase)
            
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
            
            operator = 'multiply';
            calcObj = DummyCalcObject(3, operator);
            returnTagName = {'calculatedColumn'};
            
            returns = mdtsObject(time, data, tags, 'units', units, 'ts', ts, 'name', name, 'who', who, 'when', when, 'description', description, 'comment', comment);
                        
            returns.calc(calcObj, tags(2), returnTagName);
            
            testCase.verifyEqual(returns.data(:, end), data(:, 2) .* 3);
            testCase.verifyEqual(returns.tags(end), returnTagName);
            
        end
        
        function testCascading(testCase)
            
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
            
            operator = 'multiply';
            calcObj = DummyCalcObject(3, operator);
            returnTagName1 = {'calculatedColumn_1'};
            returnTagName2 = {'calculatedColumn_2'};
            
            returns = mdtsObject(time, data, tags, 'units', units, 'ts', ts, 'name', name, 'who', who, 'when', when, 'description', description, 'comment', comment);
                        
            returns.calc(calcObj, tags(2), returnTagName1).calc(DummyCalcObject(4, 'subtract'), tags(3), returnTagName2);
            
            testCase.verifyEqual(returns.data(:, end - 1), data(:, 2) .* 3);
            testCase.verifyEqual(returns.tags(end - 1), returnTagName1);
            testCase.verifyEqual(returns.data(:, end), data(:, 3) - 4);
            testCase.verifyEqual(returns.tags(end), returnTagName2);
            
        end
        
        function testCalcWithLDO(testCase)
            
            vec = [1 : 10]';
            time = 736900 + vec;
            ts = duration(0, 0, 0, 50);
            data = vec;
            tags = {'Channel 1'};
            units = {'s'};
            name = 'TS-Test';
            who = 'Operator';
            when = 'Now';
            description = {'This is a TS-Test'; 'with two text lines'};
            comment = {'This is'; 'a comment'};
            
            L = [-1,  1,  0;
                 -1,  0,  1;
                  0, -1,  1];
            calcObj = LDO(L);
            returnTagName = {'calculatedColumn'};
            expectedReturn = ones(10, 1);
            expectedReturn(2 : end - 1) = 2;
            
            returns = mdtsObject(time, data, tags, 'units', units, 'ts', ts, 'name', name, 'who', who, 'when', when, 'description', description, 'comment', comment);
                        
            returns.calc(calcObj, tags(1), returnTagName);
            
            testCase.verifyEqual(returns.data(:, end), expectedReturn);
            testCase.verifyEqual(returns.tags(end), returnTagName);
            
        end
        
        function testStandardLocalDerivative(testCase)
            
            vec = [1 : 10]';
            time = 736900 + vec;
            ts = duration(0, 0, 0, 50);
            data = vec;
            tags = {'Channel 1'};
            units = {'s'};
            name = 'TS-Test';
            who = 'Operator';
            when = 'Now';
            description = {'This is a TS-Test'; 'with two text lines'};
            comment = {'This is'; 'a comment'};
            
            ls1 = 3;
            noBfs1 = 3;
            expectedReturn1 = ones(10, 1);

            returns = mdtsObject(time, data, tags, 'units', units, 'ts', ts, 'name', name, 'who', who, 'when', when, 'description', description, 'comment', comment);
                        
            returns.localDerivative(tags(1), ls1, noBfs1);
            
            testCase.verifyLessThan(returns.data(:, end) - expectedReturn1, 1e-14);
            testCase.verifyEqual(returns.tags(end), {['LD_', tags{1}]});
            
        end
        
        function testConvCalc(testCase)
            
            vec = [1 : 10]';
            time = 736900 + vec;
            ts = duration(0, 0, 0, 50);
            data = [vec, vec * 2];
            tags = {'Channel 1', 'Channel 2'};
            units = {'s', 'min'};
            name = 'TS-Test';
            who = 'Operator';
            when = 'Now';
            description = {'This is a TS-Test'; 'with two text lines'};
            comment = {'This is'; 'a comment'};
            
            calcName = 'Test calculation';
            inputTag = 'Channel 1';
            outputTag = 'Result 1';
            convM = [-1,  1,  0;
                     -1,  0,  1;
                      0, -1,  1];
                  
            calcObj = DummyCalcObject2(calcName, inputTag, outputTag, convM);

            expectedReturn = ones(10, 1);
            expectedReturn(2 : end - 1) = 2;
            
            returns = mdtsObject(time, data, tags, 'units', units, 'ts', ts, 'name', name, 'who', who, 'when', when, 'description', description, 'comment', comment);
                        
            returns.convCalc(calcObj);
            
            testCase.verifyEqual(returns.data(:, end), expectedReturn);
            testCase.verifyEqual(returns.tags(:, end), {outputTag});
            
        end
    end
end
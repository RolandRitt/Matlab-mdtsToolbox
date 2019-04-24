classdef parseCommandsTestClass < matlab.unittest.TestCase
    %
    % Description : Test the parseCommands function
    %
    % Author :
    %    Paul O'Leary
    %    Roland Ritt
    %    Thomas Grandl
    %
    % History :
    % \change{1.0}{02-Jan-2018}{Original}
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
        
        function testBatch1(testCase)
            
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
            data1 = [1, 9;
                2, 8;
                3, 7;
                4, 6;
                5, 5;
                6, 4;
                7, 3;
                8, 2;
                9, 1];
            data2 = data1 + 2;
            tags = {'Channel 1', 'Channel 2'};
            units = {'s', 'min'};
            
            mdtsObject1 = mdtsObject(time, data1, tags, 'units', units, 'ts', ts, 'name', 'object1');
            mdtsObject2 = mdtsObject(time, data2, tags, 'units', units, 'ts', ts, 'name', 'object2');
            objectList = {mdtsObject1; mdtsObject2};
            
            parseString = ['object1.newTag = object1.Channel 1 < 8;'];
            
            expectedReturn1 = (data1(:, 1) < 8);
            
            parseCommands(objectList, parseString);
            
            output = mdtsObject1.getData('newTag');
            
            testCase.verifyEqual(output.data, double(expectedReturn1));
            
        end
        
        function testBatch2(testCase)
            
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
            data1 = [1, 9;
                2, 8;
                3, 7;
                4, 6;
                5, 5;
                6, 4;
                7, 3;
                8, 2;
                9, 1];
            data2 = data1 + 2;
            tags = {'Channel 1', 'Channel 2'};
            units = {'s', 'min'};
            
            mdtsObject1 = mdtsObject(time, data1, tags, 'units', units, 'ts', ts, 'name', 'object1');
            mdtsObject2 = mdtsObject(time, data2, tags, 'units', units, 'ts', ts, 'name', 'object2');
            objectList = {mdtsObject1; mdtsObject2};
            
            parseString = ['a = object1.Channel 1 < 8;', char(10),...
                'object2.newTag = object1.Channel 1 > 5 & object2.Channel 2 == 3;'];
            
            expectedReturn1 = (data1(:, 1) > 8 & data2(:, 2) == 3);
            
            parseCommands(objectList, parseString);
            
            output = mdtsObject2.getData('newTag');
            
            testCase.verifyEqual(output.data, double(expectedReturn1));
            
        end
        
        function testBatch3(testCase)
            
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
            data1 = [1, 9;
                2, 8;
                3, 7;
                4, 6;
                5, 5;
                6, 4;
                7, 3;
                8, 2;
                9, 1];
            data2 = data1 + 2;
            tags = {'Channel 1', 'Channel 2'};
            units = {'s', 'min'};
            
            mdtsObject1 = mdtsObject(time, data1, tags, 'units', units, 'ts', ts, 'name', 'object1');
            mdtsObject2 = mdtsObject(time, data2, tags, 'units', units, 'ts', ts, 'name', 'object2');
            objectList = {mdtsObject1; mdtsObject2};
            
            parseString = ['a = object1.Channel 1 < 8;', char(10),...
                'variable2 = object1.Channel 1 > 5 & object2.Channel 2 == 3;', char(10),...
                'object2.newTag = object2.Channel 1 < 5 | a & object1.Channel 2 == 10;'];
            
            a = data1(:, 1) < 8;
            expectedReturn1 = (data2(:, 1) < 5 | a) & data1(:, 2) == 10;
            
            parseCommands(objectList, parseString);
            
            output = mdtsObject2.getData('newTag');
            
            testCase.verifyEqual(output.data, double(expectedReturn1));
            
        end
        
        function testBatch4(testCase)
            
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
            data1 = [1, 9;
                2, 8;
                3, 7;
                4, 6;
                5, 5;
                6, 4;
                7, 3;
                8, 2;
                9, 1];
            data2 = data1 + 2;
            tags = {'Channel 1', 'Channel 2'};
            units = {'s', 'min'};
            
            mdtsObject1 = mdtsObject(time, data1, tags, 'units', units, 'ts', ts, 'name', 'object1');
            mdtsObject2 = mdtsObject(time, data2, tags, 'units', units, 'ts', ts, 'name', 'object2');
            objectList = {mdtsObject1; mdtsObject2};
            
            parseString = ['a = object1.Channel 1 < 8;', char(10),...
                'variable2 = object1.Channel 1 > 5 & object2.Channel 2 == 3;', char(10),...
                'b = object2.Channel 1 < 5 | a & object1.Channel 1 == 10;', char(10),...
                'object1.newTag = a | variable2 & object2.Channel 2 ~= 6 | b;'];
            
            a = data1(:, 1) < 8;
            variable2 = data1(:, 1) > 5 & data2(:, 2) == 3;
            b = (data2(:, 1) < 5 | a) & data1(:, 1) == 10;
            expectedReturn1 = (a | variable2) & data2(:, 2) ~= 6 | b;
            
            parseCommands(objectList, parseString);
            
            output = mdtsObject1.getData('newTag');
            
            testCase.verifyEqual(output.data, double(expectedReturn1));
            
        end
        
    end
    
end


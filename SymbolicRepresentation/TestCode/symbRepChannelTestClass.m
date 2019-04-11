classdef symbRepChannelTestClass < matlab.unittest.TestCase
    %
    % Description : Test the segmentChannel function
    %
    % Author :
    %    Paul O'Leary
    %    Roland Ritt
    %    Thomas Grandl
    %
    % History :
    % \change{1.0}{10-Jan-2018}{Original}
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
        
        function testSegmentation(testCase)
            
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
            units = {'s', 'min', 'Elephants'};
            name = 'TS-Test';
            who = 'Operator';
            when = 'Now';
            description = {'This is a TS-Test'; 'with two text lines'};
            comment = {'This is'; 'a comment'};
            eventInfo.eventTime = datenum('09/01/2018 16:05:06');
            eventInfo.eventDuration = int32(0);
            tsEvents = containers.Map('key1', eventInfo);
            
            returns = mdtsObject(time, data, tags, 'units', units, 'ts', ts, 'name', name, 'who', who, 'when', when, 'description', description, 'comment', comment, 'tsEvents', tsEvents);
            
            input1.object = returns;
            input1.tag = 'Channel 1';
            alphabet1 = {'a', 'b', 'c'};
            edges1 = [-inf, 1.5, 2.5, inf];
            
            input2.object = returns;
            input2.tag = 'Channel2';
            alphabet2 = {'a', 'b', 'c'};
            edges2 = [-inf, 2, 6.5, inf];
            
            input3.object = returns;
            input3.tag = 'Channel 3';
            alphabet3 = {'a', 'b', 'c'};
            edges3 = [-inf, 0, 1.5, inf];
            
            input4.object = returns;
            input4.tag = 'Channel2';
            alphabet4 = {'a', 'b', 'c'};
            edges4 = [-inf, 2, 10, inf];
            
            expectedReturn1.durations = [1; 1; 3; 1; 2; 1];
            expectedReturn1.symbols = categorical({'a', 'b', 'c', 'b', 'a', 'c'}, {'a', 'b', 'c'})';
            
            expectedReturn2.durations = [1; 1; 1; 1; 5];
            expectedReturn2.symbols = categorical({'c', 'b', 'c', 'b', 'a'}, {'a', 'b', 'c'})';
            
            expectedReturn3.durations = [1; 4; 4];
            expectedReturn3.symbols = categorical({'a', 'b', 'c'}, {'a', 'b', 'c'})';
            
            expectedReturn4.durations = [4; 5];
            expectedReturn4.symbols = categorical({'b', 'a'}, {'a', 'b', 'c'})';
            
            symbObj1 = symbRepChannel(input1, edges1, alphabet1);    
            symbObj2 = symbRepChannel(input2, edges2, alphabet2);  
            symbObj3 = symbRepChannel(input3, edges3, alphabet3); 
            symbObj4 = symbRepChannel(input4, edges4, alphabet4); 
          
            testCase.verifyEqual(symbObj1.durations, expectedReturn1.durations);
            testCase.verifyEqual(symbObj1.symbols, expectedReturn1.symbols);
            
            testCase.verifyEqual(symbObj2.durations, expectedReturn2.durations);
            testCase.verifyEqual(symbObj2.symbols, expectedReturn2.symbols);
            
            testCase.verifyEqual(symbObj3.durations, expectedReturn3.durations);
            testCase.verifyEqual(symbObj3.symbols, expectedReturn3.symbols);
            
            testCase.verifyEqual(symbObj4.durations, expectedReturn4.durations);
            testCase.verifyEqual(symbObj4.symbols, expectedReturn4.symbols);
            
        end
                
    end
end
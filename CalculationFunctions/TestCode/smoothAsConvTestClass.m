classdef smoothAsConvTestClass < matlab.unittest.TestCase
    %
    % Description : Test the smoothAsConv function
    %
    % Author :
    %    Paul O'Leary
    %    Thomas Grandl
    %    Roland Ritt
    %
    % History :
    % \change{1.0}{06-Mar-2018}{Original}
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
        
        function testFunctionFull(testCase)
            
            nPoints = 200;
            
            ts = duration(0, 0, 1);
            time = datenum(datetime(2017, 7, 31, 14, 3, seconds(ts) * (1 : nPoints)'));
            data(:, 1) = [zeros(99, 1);
                          ones(2, 1);
                          zeros(99, 1)];
            data(:, 2) = [zeros(49, 1);
                          ones(2, 1);
                          zeros(98, 1);
                          ones(2, 1);
                          zeros(49, 1)];
            tags = {'Channel 1', 'Channel 2'};
            units = {'s', 'min'};
            
            theObject = mdtsObject(time, data, tags, 'units', units, 'ts', ts);
            
            input1.object = theObject;
            input1.tag = 'Channel 1';
            
            input2.object = theObject;
            input2.tag = 'Channel 2';
            
            expectedReturn1 = [zeros(94, 1);
                               1/11;
                               ones(10, 1) * 2/11;
                               1/11;
                               zeros(94, 1)];
            expectedReturn2 = [zeros(44, 1);
                               1/11;
                               ones(10, 1) * 2/11;
                               1/11;
                               zeros(88, 1);
                               1/11;
                               ones(10, 1) * 2/11;
                               1/11;
                               zeros(44, 1)];
            
            output1a = smoothAsConv(input1);
            output1b = smoothAsConv(input1, 'ls', 11, 'noBfs', 2);
            output2a = smoothAsConv(input2);
            output2b = smoothAsConv(input2, 'ls', 11, 'noBfs', 2);
            
            testCase.verifyEqual(output1a, expectedReturn1);
            testCase.verifyEqual(output1b, expectedReturn1);
            testCase.verifyEqual(output2a, expectedReturn2);
            testCase.verifyEqual(output2b, expectedReturn2);
            
        end
        
    end
    
end
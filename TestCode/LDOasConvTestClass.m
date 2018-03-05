classdef LDOasConvTestClass < matlab.unittest.TestCase
    %
    % Description : Test the LDOasConv function
    %
    % Author :
    %    Paul O'Leary
    %    Roland Ritt
    %    Thomas Grandl
    %
    % History :
    % \change{1.0}{29-Jan-2018}{Original}
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
            
            nPoints = 500;
            
            ts = duration(0, 0, 1);
            time = datenum(datetime(2017, 7, 31, 14, 3, seconds(ts) * (1 : nPoints)'));
            data(:, 1) = sin((1 : nPoints) * 2 / nPoints * 2 * pi)';
            data(:, 2) = cos((1 : nPoints) * 2 / nPoints * 2 * pi)';
            tags = {'Channel 1', 'Channel 2'};
            units = {'s', 'min'};
            
            theObject = mdtsObject(time, data, tags, 'units', units, 'ts', ts);
            
            input1.object = theObject;
            input1.tag = 'Channel 1';
            
            input2.object = theObject;
            input2.tag = 'Channel 2';
                           
            expectedReturn1 = cos((1 : nPoints) * 2 / nPoints * 2 * pi)' * 2 / nPoints * 2 * pi / datenum(ts);
            expectedReturn2 = - sin((1 : nPoints) * 2 / nPoints * 2 * pi)' * 2 / nPoints * 2 * pi / datenum(ts);

            output1 = LDOasConv(input1);
            output2 = LDOasConv(input2);
            
            cutOff = 2 / 100;
            testCase.verifyEqual(output1(round(nPoints * cutOff) : end - round(nPoints * cutOff)), expectedReturn1(round(nPoints * cutOff) : end - round(nPoints * cutOff)), 'AbsTol', 2 / nPoints * 2 * pi / datenum(ts) / 100);
            testCase.verifyEqual(output2(round(nPoints * cutOff) : end - round(nPoints * cutOff)), expectedReturn2(round(nPoints * cutOff) : end - round(nPoints * cutOff)), 'AbsTol', 2 / nPoints * 2 * pi / datenum(ts) / 100);
            
            testCase.verifyError(@()LDOasConv('string1'), 'LDOasConv:IllegalInputFormat');
            
        end
        
        function testAdditionalInputs(testCase)
            
            nPoints = 500;
            
            ts = duration(0, 0, 1);
            time = datenum(datetime(2017, 7, 31, 14, 3, seconds(ts) * (1 : nPoints)'));
            data(:, 1) = sin((1 : nPoints) * 2 / nPoints * 2 * pi)';
            data(:, 2) = cos((1 : nPoints) * 2 / nPoints * 2 * pi)';
            tags = {'Channel 1', 'Channel 2'};
            units = {'s', 'min'};
            
            theObject = mdtsObject(time, data, tags, 'units', units, 'ts', ts);
            
            ls = 15;
            noBfs = 4;
            
            input1.object = theObject;
            input1.tag = 'Channel 1';
            
            input2.object = theObject;
            input2.tag = 'Channel 2';
                           
            expectedReturn1 = cos((1 : nPoints) * 2 / nPoints * 2 * pi)' * 2 / nPoints * 2 * pi / datenum(ts);
            expectedReturn2 = - sin((1 : nPoints) * 2 / nPoints * 2 * pi)' * 2 / nPoints * 2 * pi / datenum(ts);

            output1 = LDOasConv(input1, 'ls', ls, 'noBfs', noBfs);
            output2 = LDOasConv(input2, 'ls', ls, 'noBfs', noBfs);
            
            cutOff = 2 / 100;
            testCase.verifyEqual(output1(round(nPoints * cutOff) : end - round(nPoints * cutOff)), expectedReturn1(round(nPoints * cutOff) : end - round(nPoints * cutOff)), 'AbsTol', 2 / nPoints * 2 * pi / datenum(ts) / 100);
            testCase.verifyEqual(output2(round(nPoints * cutOff) : end - round(nPoints * cutOff)), expectedReturn2(round(nPoints * cutOff) : end - round(nPoints * cutOff)), 'AbsTol', 2 / nPoints * 2 * pi / datenum(ts) / 100);
            
        end
        
        function testMultipleDerivatives(testCase)
            
            nPoints = 500;
            
            ts = duration(0, 0, 1);
            time = datenum(datetime(2017, 7, 31, 14, 3, seconds(ts) * (1 : nPoints)'));
            data(:, 1) = sin((1 : nPoints) * 2 / nPoints * 2 * pi)';
            data(:, 2) = cos((1 : nPoints) * 2 / nPoints * 2 * pi)';
            tags = {'Channel 1', 'Channel 2'};
            units = {'s', 'min'};
            
            theObject = mdtsObject(time, data, tags, 'units', units, 'ts', ts);

            input1.object = theObject;
            input1.tag = 'Channel 1';
                           
            expectedReturn1 = cos((1 : nPoints) * 2 / nPoints * 2 * pi)' * 2 / nPoints * 2 * pi / datenum(ts);
            expectedReturn2 = - sin((1 : nPoints) * 2 / nPoints * 2 * pi)' * (2 / nPoints * 2 * pi / datenum(ts))^2;

            output1 = LDOasConv(input1);
            
            theObject.expandDataSet(output1, 'dC1');
            input2.object = theObject;
            input2.tag = 'dC1';
            
            output2 = LDOasConv(input2);
            
            %output3 = LDOasConv(input1, 'order', 2);
            
            cutOff = 2 / 100;
            testCase.verifyEqual(output1(round(nPoints * cutOff) : end - round(nPoints * cutOff)), expectedReturn1(round(nPoints * cutOff) : end - round(nPoints * cutOff)), 'AbsTol', 2 / nPoints * 2 * pi / datenum(ts) / 100);
            testCase.verifyEqual(output2(round(nPoints * cutOff) : end - round(nPoints * cutOff)), expectedReturn2(round(nPoints * cutOff) : end - round(nPoints * cutOff)), 'AbsTol', (2 / nPoints * 2 * pi / datenum(ts))^2 / 100);
            %testCase.verifyEqual(output3(round(nPoints * cutOff) : end - round(nPoints * cutOff)), expectedReturn2(round(nPoints * cutOff) : end - round(nPoints * cutOff)), 'AbsTol', (2 / nPoints * 2 * pi / datenum(ts))^2 / 100);
                       
        end
        
        function testSmoothing(testCase)
            
            nPoints = 300;
            
            ts = duration(0, 0, 1);
            time = datenum(datetime(2017, 7, 31, 14, 3, seconds(ts) * (1 : nPoints)'));
            data(:, 1) = [zeros(100, 1);
                          ones(100, 1);
                          zeros(100, 1)];
            data(:, 2) = [ones(100, 1);
                          zeros(100, 1)
                          ones(100, 1)];
            tags = {'Channel 1', 'Channel 2'};
            units = {'s', 'min'};
            
            theObject = mdtsObject(time, data, tags, 'units', units, 'ts', ts);
            
            ls = 15;
            noBfs = 4;
            
            input1.object = theObject;
            input1.tag = 'Channel 1';
            
            expectedReturn1 = [zeros(94, 1);
                               linspace(0, 1, 12)';
                               ones(88, 1);
                               linspace(1, 0, 12)';
                               zeros(94, 1)];
            
            output1 = LDOasConv(input1, 'ls', ls, 'noBfs', noBfs, 'order', 0);
            
            testCase.verifyEqual(output1, expectedReturn1, 'AbsTol', 2 / nPoints * 2 * pi / datenum(ts) / 100);
            
        end
        
    end
    
end


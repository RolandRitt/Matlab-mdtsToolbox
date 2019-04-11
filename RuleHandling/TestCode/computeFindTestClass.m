classdef computeFindTestClass < matlab.unittest.TestCase
    %
    % Description : Test the computeFind function
    %
    % Author :
    %    Paul O'Leary
    %    Roland Ritt
    %    Thomas Grandl
    %
    % History :
    % \change{1.0}{22-Dec-2017}{Original}
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
        
        function validComputation(testCase)
            
            ts = duration(0, 0, 0, 50);
            time = [datenum(datetime(2017, 7, 31, 14, 3, 3, 123 + 0 * seconds(ts)));
                    datenum(datetime(2017, 7, 31, 14, 3, 3, 123 + 1 * seconds(ts)));
                    datenum(datetime(2017, 7, 31, 14, 3, 3, 123 + 2 * seconds(ts)));
                    datenum(datetime(2017, 7, 31, 14, 3, 3, 123 + 3 * seconds(ts)))];
            data = [9, 8;
                    7, 6;
                    8, 7;
                    6, 5];
            tags = {'Channel 1', 'Channel 2'};
            units = {'s', 'min'};
            
            mdtsObject1 = mdtsObject(time, data, tags, 'units', units, 'ts', ts);
            
            input1.object = mdtsObject1;
            input1.tag = tags{1};
            
            operator1 = '>';
            value1 = 7;
            operator2 = '<';
            value2 = 7;
            operator3 = '==';
            value3 = 7;
            operator4 = '~=';
            value4 = 7;
            operator5 = '>=';
            value5 = 7;
            operator6 = '<=';
            value6 = 7;
            
            expectedReturn1 = data(:, 1) > value1;
            expectedReturn2 = data(:, 1) < value2;
            expectedReturn3 = data(:, 1) == value3;
            expectedReturn4 = data(:, 1) ~= value4;
            expectedReturn5 = data(:, 1) >= value5;
            expectedReturn6 = data(:, 1) <= value6;
            
            output1 = computeFind(operator1, input1, value1);
            output2 = computeFind(operator2, input1, value2);
            output3 = computeFind(operator3, input1, value3);
            output4 = computeFind(operator4, input1, value4);
            output5 = computeFind(operator5, input1, value5);
            output6 = computeFind(operator6, input1, value6);
            
            testCase.verifyEqual(output1, expectedReturn1);  
            testCase.verifyEqual(output2, expectedReturn2);
            testCase.verifyEqual(output3, expectedReturn3);
            testCase.verifyEqual(output4, expectedReturn4);
            testCase.verifyEqual(output5, expectedReturn5);
            testCase.verifyEqual(output6, expectedReturn6);
            
        end
        
        function invalidInputs(testCase)
            
            ts = duration(0, 0, 0, 50);
            time = [datenum(datetime(2017, 7, 31, 14, 3, 3, 123 + 0 * seconds(ts)));
                    datenum(datetime(2017, 7, 31, 14, 3, 3, 123 + 1 * seconds(ts)));
                    datenum(datetime(2017, 7, 31, 14, 3, 3, 123 + 2 * seconds(ts)));
                    datenum(datetime(2017, 7, 31, 14, 3, 3, 123 + 3 * seconds(ts)))];
            data = [9, 8;
                    7, 6;
                    8, 7;
                    6, 5];
            tags = {'Channel 1', 'Channel 2'};
            units = {'s', 'min'};
            
            mdtsObject1 = mdtsObject(time, data, tags, 'units', units, 'ts', ts);
            
            input0.object = mdtsObject1;
            input0.tag = tags{1};            
            input1 = 'test123';
            input2 = 123;
            
            operator0 = '>';
            value0 = 7;
            operator1 = 'test123';
            value1 = 'abc';
            
            testCase.verifyError(@()computeFind(operator0, input1, value0), 'computeFind:IllegalInputFormat'); 
            testCase.verifyError(@()computeFind(operator0, input2, value0), 'computeFind:IllegalInputFormat'); 
            testCase.verifyError(@()computeFind(operator1, input0, value0), 'computeFind:InvalidOperator'); 
            testCase.verifyError(@()computeFind(operator0, input0, value1), 'computeFind:IllegalValueFormat'); 
            
        end
        
        function testPreAppliedFunction(testCase)
            
            ts = duration(0, 0, 0, 50);
            time = [datenum(datetime(2017, 7, 31, 14, 3, 3, 123 + 0 * seconds(ts)));
                    datenum(datetime(2017, 7, 31, 14, 3, 3, 123 + 1 * seconds(ts)));
                    datenum(datetime(2017, 7, 31, 14, 3, 3, 123 + 2 * seconds(ts)));
                    datenum(datetime(2017, 7, 31, 14, 3, 3, 123 + 3 * seconds(ts)))];
            data = [9, -8;
                    7, 6;
                    8, -7;
                    6, 5];
            tags = {'Channel 1', 'Channel 2'};
            units = {'s', 'min'};
            
            returnObject = mdtsObject(time, data, tags, 'units', units, 'ts', ts);
            
            input1.object = returnObject;
            input1.tag = tags{2};            
            operator1 = '>';
            value1 = 5;
            preAppliedFunction1 = 'abs';
            
            input2.object = returnObject;
            input2.tag = tags{1};            
            operator2 = '>';
            value2 = 5;
            preAppliedFunction2 = [];
            
            input3.object = returnObject;
            input3.tag = tags{1};            
            operator3 = '>';
            value3 = 5;
            preAppliedFunction3 = NaN;
            
            expectedReturn1 = abs(data(:, 2)) > value1;
            expectedReturn2 = abs(data(:, 1)) > value2;
            expectedReturn3 = abs(data(:, 1)) > value3;
            
            output1 = computeFind(operator1, input1, value1, preAppliedFunction1);
            output2 = computeFind(operator2, input2, value2, preAppliedFunction2);
            output3 = computeFind(operator3, input3, value3, preAppliedFunction3);
            
            testCase.verifyEqual(output1, expectedReturn1);  
            testCase.verifyEqual(output2, expectedReturn2);  
            testCase.verifyEqual(output3, expectedReturn3);
            
            testCase.verifyError(@()computeFind(operator1, input1, value1, 123), 'computeFind:IllegalPreAppliedFunctionFormat'); 
            testCase.verifyError(@()computeFind(operator1, input1, value1, 'test'), 'computeFind:InvalidPreAppliedFunction'); 
            
        end
        
    end
    
end


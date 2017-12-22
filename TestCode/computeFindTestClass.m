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
            
            expectedReturn1 = data(:, 1) > value1;
            expectedReturn2 = data(:, 1) < value2;
            expectedReturn3 = data(:, 1) == value3;
            expectedReturn4 = data(:, 1) ~= value4;
            
            output1 = computeFind(operator1, input1, value1);
            output2 = computeFind(operator2, input1, value2);
            output3 = computeFind(operator3, input1, value3);
            output4 = computeFind(operator4, input1, value4);
            
            testCase.verifyEqual(output1, expectedReturn1);  
            testCase.verifyEqual(output2, expectedReturn2);
            testCase.verifyEqual(output3, expectedReturn3);
            testCase.verifyEqual(output4, expectedReturn4);
            
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
    end
    
end


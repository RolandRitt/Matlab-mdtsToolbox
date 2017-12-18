classdef compute2TestClass < matlab.unittest.TestCase
    %
    % Description : Test the conpute2 function
    %
    % Author :
    %    Paul O'Leary
    %    Roland Ritt
    %    Thomas Grandl
    %
    % History :
    % \change{1.0}{12-Dec-2017}{Original}
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
        
        function testFunction(testCase)
            
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
            mdtsObject2 = mdtsObject(time, data, tags, 'units', units, 'ts', ts);
            
            input1.object = mdtsObject1;
            input1.tag = 'Channel 1';
            input2.object = mdtsObject2;
            input2.tag = 'Channel 2';
            
            operator1 = '.*';
            expectedReturn1 = data(:, 1) .* data(:, 2);
            operator2 = './';
            expectedReturn2 = data(:, 1) ./ data(:, 2);
            operator3 = '+';
            expectedReturn3 = data(:, 1) + data(:, 2);
            operator4 = '-';
            expectedReturn4 = data(:, 1) - data(:, 2);
            operator5 = 'dot';
            expectedReturn5 = dot(data(:, 1), data(:, 2));
            operator6 = 'outer';
            expectedReturn6 = data(:, 1) * data(:, 2)';
            
            output1 = compute2(operator1, input1, input2);
            output2 = compute2(operator2, input1, input2);
            output3 = compute2(operator3, input1, input2);
            output4 = compute2(operator4, input1, input2);
            output5 = compute2(operator5, input1, input2);
            output6 = compute2(operator6, input1, input2);
            
            testCase.verifyEqual(output1, expectedReturn1);        
            testCase.verifyEqual(output2, expectedReturn2);  
            testCase.verifyEqual(output3, expectedReturn3);        
            testCase.verifyEqual(output4, expectedReturn4);  
            testCase.verifyEqual(output5, expectedReturn5);  
            testCase.verifyEqual(output6, expectedReturn6);  
                        
        end
        
        function testInputValidation(testCase)
            
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
            mdtsObject2 = mdtsObject(time(1 : end - 1), data(1 : end - 1, :), tags, 'units', units, 'ts', ts);
            
            input1.object = mdtsObject1;
            input1.tag = 'Channel 1';
            input2.object = mdtsObject2;
            input2.tag = 'Channel 2';
            input2a.object = mdtsObject1;
            input2a.tag = 'Channel 2';
            
            operator1 = '.*';
            operator2 = 'abcd';
            operator3 = '+';
            
            illegalInput1 = 'test123';
            illegalInput2 = {'test1', 'test2', 'test3'};
            
            testCase.verifyError(@()compute2(operator1, input1, input2), 'compute2:UnequalVectorLength');  
            testCase.verifyError(@()compute2(operator2, input1, input2a), 'compute2:InvalidOperator');  
            
            testCase.verifyError(@()compute2(operator3, illegalInput1, input2), 'compute2:IllegalInputFormat');  
            testCase.verifyError(@()compute2(operator3, input1, illegalInput2), 'compute2:IllegalInputFormat'); 
            
        end
        
        function directlyAddToObject(testCase)
            
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
            mdtsObject2 = mdtsObject(time, data, tags, 'units', units, 'ts', ts);
            
            input1.object = mdtsObject1;
            input1.tag = 'Channel 1';
            input2.object = mdtsObject2;
            input2.tag = 'Channel 2';
            
            operator1 = '.*';
            expectedReturn1 = data(:, 1) .* data(:, 2);
            
            newChannelName = 'newChannel';
            
            mdtsObject1.expandDataSet(compute2(operator1, input1, input2), newChannelName);
            
            testCase.verifyEqual(mdtsObject1.data, [data, expectedReturn1]);   
            testCase.verifyEqual(mdtsObject1.tags, [tags, newChannelName]);   
        end
        
        function useFunctionHandles(testCase)
            
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
            mdtsObject2 = mdtsObject(time, data, tags, 'units', units, 'ts', ts);
            
            input1.object = mdtsObject1;
            input1.tag = 'Channel 1';
            input2.object = mdtsObject2;
            input2.tag = 'Channel 2';
            
            operator1 = @multiplyVectorsDummy;
            expectedReturn1 = data(:, 1) .* data(:, 2);
            
            output1 = compute2(operator1, input1, input2);
            
            testCase.verifyEqual(output1, expectedReturn1);  
            
        end
        
        function nestedInputs(testCase)
            
            ts = duration(0, 0, 0, 50);
            time = [datenum(datetime(2017, 7, 31, 14, 3, 3, 123 + 0 * seconds(ts)));
                    datenum(datetime(2017, 7, 31, 14, 3, 3, 123 + 1 * seconds(ts)));
                    datenum(datetime(2017, 7, 31, 14, 3, 3, 123 + 2 * seconds(ts)));
                    datenum(datetime(2017, 7, 31, 14, 3, 3, 123 + 3 * seconds(ts)))];
            data = [2, 1;
                    3, 2;
                    4, 3;
                    5, 4];
            tags = {'Channel 1', 'Channel 2'};
            units = {'s', 'min'};
            
            mdtsObject1 = mdtsObject(time, data, tags, 'units', units, 'ts', ts);
            mdtsObject2 = mdtsObject(time, data, tags, 'units', units, 'ts', ts);
            
            input1.object = mdtsObject1;
            input1.tag = 'Channel 1';
            input2.object = mdtsObject2;
            input2.tag = 'Channel 2';
            
            operator1 = '-';
            operator2 = './';
            operator3 = '.*';
            expectedReturn3 = (data(:, 2) ./ (data(:, 1) - data(:, 2))) .* data(:, 1);
            
            output3 = compute2(operator3, compute2(operator2, input2, compute2(operator1, input1, input2)), input1);
            
            testCase.verifyEqual(output3, expectedReturn3);  
            
        end
        
    end
    
end


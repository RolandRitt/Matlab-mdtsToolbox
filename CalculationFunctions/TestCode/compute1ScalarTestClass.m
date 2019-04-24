classdef compute1ScalarTestClass < matlab.unittest.TestCase
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
            
            input1.object = mdtsObject1;
            input1.tag = 'Channel 1';
            scalar = 2;
            
            operator1 = '*';
            expectedReturn1 = data(:, 1) * scalar;
            operator2 = '/';
            expectedReturn2 = data(:, 1) / scalar;
            operator3 = '+';
            expectedReturn3 = data(:, 1) + scalar;
            operator4 = '-';
            expectedReturn4 = data(:, 1) - scalar;
            
            output1 = compute1Scalar(operator1, scalar, input1);
            output2 = compute1Scalar(operator2, scalar, input1);
            output3 = compute1Scalar(operator3, scalar, input1);
            output4 = compute1Scalar(operator4, scalar, input1);
            
            testCase.verifyEqual(output1, expectedReturn1);        
            testCase.verifyEqual(output2, expectedReturn2);  
            testCase.verifyEqual(output3, expectedReturn3);        
            testCase.verifyEqual(output4, expectedReturn4);  
                        
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
            
            input1.object = mdtsObject1;
            input1.tag = 'Channel 1';
            
            operator1 = '*';
            
            illegalOperator1 = 'abcd';
            
            scalar1 = 5;
            
            illegalScalar1 = 'test5';
            illegalScalar2 = [1, 2; 3, 4];
            
            illegalInput1 = 'test123';
            illegalInput2 = {'test1', 'test2', 'test3'};
            
            testCase.verifyError(@()compute1Scalar(operator1, scalar1, illegalInput1), 'compute1Scalar:IllegalInputFormat'); 
            testCase.verifyError(@()compute1Scalar(operator1, scalar1, illegalInput2), 'compute1Scalar:IllegalInputFormat');
            
            testCase.verifyError(@()compute1Scalar(operator1, illegalScalar1, input1), 'compute1Scalar:NoScalar'); 
            testCase.verifyError(@()compute1Scalar(operator1, illegalScalar2, input1), 'compute1Scalar:NoScalar'); 
            
            testCase.verifyError(@()compute1Scalar(illegalOperator1, scalar1, input1), 'compute1Scalar:InvalidOperator');
            
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
            
            input1.object = mdtsObject1;
            input1.tag = 'Channel 1';
            
            operator1 = '-';
            operator2 = '/';
            operator3 = '*';
            scalar1 = 5;
            scalar2 = 10;
            scalar3 = 3;
            expectedReturn3 = (data(:, 1) - scalar1) / scalar2 * scalar3;
            
            output3 = compute1Scalar(operator3, scalar3, compute1Scalar(operator2, scalar2, compute1Scalar(operator1, scalar1, input1)));
            
            testCase.verifyEqual(output3, expectedReturn3);  
            
        end
        
    end
    
end


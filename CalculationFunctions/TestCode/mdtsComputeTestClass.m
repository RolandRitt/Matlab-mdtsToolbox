classdef mdtsComputeTestClass < matlab.unittest.TestCase
    %
    % Description : Test the conpute1 function
    %
    % Author :
    %    Paul O'Leary
    %    Roland Ritt
    %    Thomas Grandl
    %
    % History :
    % \change{1.0}{18-Dec-2017}{Original}
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
        
        function testcompute2(testCase)
            
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
            operator7 = 'xcorr';
            expectedReturn7 = xcorr(data(:, 1), data(:, 2));
            
            output1 = mdtsCompute(operator1, input1, input2);
            output2 = mdtsCompute(operator2, input1, input2);
            output3 = mdtsCompute(operator3, input1, input2);
            output4 = mdtsCompute(operator4, input1, input2);
            output5 = mdtsCompute(operator5, input1, input2);
            output6 = mdtsCompute(operator6, input1, input2);
            output7 = mdtsCompute(operator7, input1, input2);
            
            testCase.verifyEqual(output1, expectedReturn1);
            testCase.verifyEqual(output2, expectedReturn2);
            testCase.verifyEqual(output3, expectedReturn3);
            testCase.verifyEqual(output4, expectedReturn4);
            testCase.verifyEqual(output5, expectedReturn5);
            testCase.verifyEqual(output6, expectedReturn6);
            testCase.verifyEqual(output7, expectedReturn7);
            
        end
        
        function testcompute1Scalar(testCase)
            
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
            
            output1 = mdtsCompute(operator1, scalar, input1);
            output2 = mdtsCompute(operator2, scalar, input1);
            output3 = mdtsCompute(operator3, scalar, input1);
            output4 = mdtsCompute(operator4, scalar, input1);
            
            testCase.verifyEqual(output1, expectedReturn1);
            testCase.verifyEqual(output2, expectedReturn2);
            testCase.verifyEqual(output3, expectedReturn3);
            testCase.verifyEqual(output4, expectedReturn4);
            
        end
        
        function testcompute1(testCase)
            
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
            
            theObject = mdtsObject(time, data, tags, 'units', units, 'ts', ts);
            
            input.object = theObject;
            input.tag = 'Channel 1';
            matrix1 = [-1,  1,  0;
                -1,  0,  1;
                0, -1,  1];
            expectedReturn1 = - ones(size(data, 1), 1) * 2;
            expectedReturn1(2 : end - 1) = - 1;
            
            output1 = mdtsCompute(matrix1, input);
            
            testCase.verifyEqual(output1, expectedReturn1);
            
        end
        
        function testInputValidationcompute2(testCase)
            
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
            
            testCase.verifyError(@()mdtsCompute(operator1, input1, input2), 'compute2:UnequalVectorLength');  
            testCase.verifyError(@()mdtsCompute(operator2, input1, input2a), 'compute2:InvalidOperator');  
            
            testCase.verifyError(@()mdtsCompute(operator3, illegalInput1, input2), 'mdtsCompute:IllegalInputs');  
            testCase.verifyError(@()mdtsCompute(operator3, input1, illegalInput2), 'mdtsCompute:IllegalInputs');            
            
        end
        
        function testInputValidationcompute1Scalar(testCase)
            
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
            
            testCase.verifyError(@()mdtsCompute(operator1, scalar1, illegalInput1), 'mdtsCompute:IllegalInputs'); 
            testCase.verifyError(@()mdtsCompute(operator1, scalar1, illegalInput2), 'mdtsCompute:IllegalInputs');
            
            testCase.verifyError(@()mdtsCompute(operator1, illegalScalar1, input1), 'mdtsCompute:IllegalInputs'); 
            testCase.verifyError(@()mdtsCompute(operator1, illegalScalar2, input1), 'mdtsCompute:IllegalInputs'); 
            
            testCase.verifyError(@()mdtsCompute(illegalOperator1, scalar1, input1), 'compute1Scalar:InvalidOperator');
            
        end
        
        function testInputValidationcompute1(testCase)
            
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
                        
            theObject = mdtsObject(time, data, tags, 'units', units, 'ts', ts);
            
            input1 = 'SomeString';
            matrix1 = [-1,  1,  0;
                       -1,  0,  1;
                        0, -1,  1];
            
            input2.object = theObject;
            input2.tag = 'Channel 1';            
            matrix2 = 'test1';
            
            matrix3 = [-1,  1,  0,  0;
                       -1,  0,  0,  1;
                       -1,  0,  0,  1;
                        0,  0, -1,  1];
            
            matrix4 = [-1,  1;
                       -1,  0;
                        0, -1];
            
            testCase.verifyError(@()mdtsCompute(matrix1, input1), 'mdtsCompute:IllegalInputs');
            testCase.verifyError(@()mdtsCompute(matrix2, input2), 'mdtsCompute:IllegalInputs');
            testCase.verifyError(@()mdtsCompute(matrix3, input2), 'compute1:EvenSupportLength');
            testCase.verifyError(@()mdtsCompute(matrix4, input2), 'compute1:IncorrectMatrixDimensions');
            
        end
        
    end
    
end


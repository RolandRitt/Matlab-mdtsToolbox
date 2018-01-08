classdef compute1TestClass < matlab.unittest.TestCase
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
        
        function testFunctionFull(testCase)
            
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
            
            output1 = compute1(matrix1, input);
            
            testCase.verifyEqual(output1, expectedReturn1);
            
        end
        
        function testInputValidationFull(testCase)
            
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
            
            testCase.verifyError(@()compute1(matrix1, input1), 'compute1:IllegalInputFormat');
            testCase.verifyError(@()compute1(matrix2, input2), 'compute1:IllegalMatrixFormat');
            testCase.verifyError(@()compute1(matrix3, input2), 'compute1:EvenSupportLength');
            testCase.verifyError(@()compute1(matrix4, input2), 'compute1:InvalidOperator');
            
        end
        
        function testFunctionSparse(testCase)
            
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
            
            matrix1 = sparse([-1,  1,  0,  0;
                              -1,  0,  1,  0;
                               0, -1,  0,  1;
                               0,  0, -1,  1]);
                           
            expectedReturn1 = - ones(size(data, 1), 1) * 2;
            expectedReturn1(2 : end - 1) = - 1;
            
            output1 = compute1(matrix1, input);
            
            testCase.verifyEqual(output1, expectedReturn1);
            
        end
        
        function testInputValidationSparse(testCase)
            
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
            
            matrix1 = sparse([-1,  1,  0,  0;
                              -1,  0,  1,  0;
                               0,  0, -1,  1]);
                           
            matrix2 = sparse([-1,  1;
                              -1,  0;
                               0,  0]);
                           
            testCase.verifyError(@()compute1(matrix1, input), 'compute1:IncorrectMatrixDimensions');
            testCase.verifyError(@()compute1(matrix2, input), 'compute1:IncorrectMatrixDimensions');
            
        end
        
        function testFunctionVector(testCase)
            
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
            
            matrix1 = [-1, 1, 1, -1];
                           
            expectedReturn1 = [8; 0; 7; -2];
            
            output1 = compute1(matrix1, input);
            
            testCase.verifyEqual(output1, expectedReturn1);
            
        end
    end
    
end


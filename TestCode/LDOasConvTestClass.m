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
            
            ts = duration(0, 0, 0, 50);
            time = [datenum(datetime(2017, 7, 31, 14, 3, 3, 123 + 1 * seconds(ts)));
                    datenum(datetime(2017, 7, 31, 14, 3, 3, 123 + 2 * seconds(ts)));
                    datenum(datetime(2017, 7, 31, 14, 3, 3, 123 + 3 * seconds(ts)));
                    datenum(datetime(2017, 7, 31, 14, 3, 3, 123 + 4 * seconds(ts)));
                    datenum(datetime(2017, 7, 31, 14, 3, 3, 123 + 5 * seconds(ts)));
                    datenum(datetime(2017, 7, 31, 14, 3, 3, 123 + 6 * seconds(ts)));
                    datenum(datetime(2017, 7, 31, 14, 3, 3, 123 + 7 * seconds(ts)));
                    datenum(datetime(2017, 7, 31, 14, 3, 3, 123 + 8 * seconds(ts)));
                    datenum(datetime(2017, 7, 31, 14, 3, 3, 123 + 9 * seconds(ts)));
                    datenum(datetime(2017, 7, 31, 14, 3, 3, 123 + 10 * seconds(ts)));
                    datenum(datetime(2017, 7, 31, 14, 3, 3, 123 + 11 * seconds(ts)));
                    datenum(datetime(2017, 7, 31, 14, 3, 3, 123 + 12 * seconds(ts)));
                    datenum(datetime(2017, 7, 31, 14, 3, 3, 123 + 13 * seconds(ts)));
                    datenum(datetime(2017, 7, 31, 14, 3, 3, 123 + 14 * seconds(ts)));
                    datenum(datetime(2017, 7, 31, 14, 3, 3, 123 + 15 * seconds(ts)));
                    datenum(datetime(2017, 7, 31, 14, 3, 3, 123 + 16 * seconds(ts)));
                    datenum(datetime(2017, 7, 31, 14, 3, 3, 123 + 17 * seconds(ts)));
                    datenum(datetime(2017, 7, 31, 14, 3, 3, 123 + 18 * seconds(ts)))];
            data = [1, 1;
                    1, 2;
                    1, 3;
                    2, 4;
                    3, 5;
                    4, 6;
                    5, 7;
                    5, 8;
                    5, 9;
                    5, 9;
                    5, 8;
                    5, 7;
                    4, 6;
                    3, 5;
                    2, 4;
                    1, 3;
                    1, 2;
                    1, 1];
            tags = {'Channel 1', 'Channel 2'};
            units = {'s', 'min'};
            
            theObject = mdtsObject(time, data, tags, 'units', units, 'ts', ts);
            
            input1.object = theObject;
            input1.tag = 'Channel 1';
            
            input2.object = theObject;
            input2.tag = 'Channel 2';
                           
            expectedReturn1 = [2.54545454545454,2.54545454545454,2.54545454545454,2.54545454545454,2.54545454545454,2.54545454545454,2.27272727272727,1.59090909090909,0.545454545454545,-0.545454545454545,-1.59090909090909,-2.27272727272727,-2.54545454545455,-2.54545454545455,-2.54545454545455,-2.54545454545455,-2.54545454545455,-2.54545454545455]';
            expectedReturn2 = [4.13636363636364,4.13636363636364,4.13636363636364,4.13636363636364,4.13636363636364,4.13636363636364,3.18181818181818,2.00000000000000,0.681818181818182,-0.681818181818182,-2.00000000000000,-3.18181818181818,-4.13636363636363,-4.13636363636364,-4.13636363636364,-4.13636363636364,-4.13636363636364,-4.13636363636364]';
            expectedReturn3 = [-2.97933884297520,-2.97933884297520,-2.97933884297520,-2.97933884297520,-2.97933884297520,-2.97933884297520,-3.84710743801653,-4.59917355371901,-4.97520661157024,-4.97520661157024,-4.59917355371901,-3.84710743801653,-2.97933884297520,-2.97933884297521,-2.97933884297521,-2.97933884297521,-2.97933884297521,-2.97933884297521]';
            
            output1 = LDOasConv(input1);
            output2 = LDOasConv(input2);
            output3 = LDOasConv(output2);
            
            testCase.verifyEqual(output1, expectedReturn1, 'RelTol', 1e-10);
            testCase.verifyEqual(output2, expectedReturn2, 'RelTol', 1e-1);
            testCase.verifyEqual(output3, expectedReturn3, 'RelTol', 1e-1);
            
            testCase.verifyError(@()LDOasConv('string1'), 'LDOasConv:IllegalInputFormat');
            
        end
        
        function testAdditionalInputs(testCase)
            
            ts = duration(0, 0, 0, 50);
            time = [datenum(datetime(2017, 7, 31, 14, 3, 3, 123 + 1 * seconds(ts)));
                    datenum(datetime(2017, 7, 31, 14, 3, 3, 123 + 2 * seconds(ts)));
                    datenum(datetime(2017, 7, 31, 14, 3, 3, 123 + 3 * seconds(ts)));
                    datenum(datetime(2017, 7, 31, 14, 3, 3, 123 + 4 * seconds(ts)));
                    datenum(datetime(2017, 7, 31, 14, 3, 3, 123 + 5 * seconds(ts)));
                    datenum(datetime(2017, 7, 31, 14, 3, 3, 123 + 6 * seconds(ts)));
                    datenum(datetime(2017, 7, 31, 14, 3, 3, 123 + 7 * seconds(ts)));
                    datenum(datetime(2017, 7, 31, 14, 3, 3, 123 + 8 * seconds(ts)));
                    datenum(datetime(2017, 7, 31, 14, 3, 3, 123 + 9 * seconds(ts)));
                    datenum(datetime(2017, 7, 31, 14, 3, 3, 123 + 10 * seconds(ts)));
                    datenum(datetime(2017, 7, 31, 14, 3, 3, 123 + 11 * seconds(ts)));
                    datenum(datetime(2017, 7, 31, 14, 3, 3, 123 + 12 * seconds(ts)));
                    datenum(datetime(2017, 7, 31, 14, 3, 3, 123 + 13 * seconds(ts)));
                    datenum(datetime(2017, 7, 31, 14, 3, 3, 123 + 14 * seconds(ts)));
                    datenum(datetime(2017, 7, 31, 14, 3, 3, 123 + 15 * seconds(ts)));
                    datenum(datetime(2017, 7, 31, 14, 3, 3, 123 + 16 * seconds(ts)));
                    datenum(datetime(2017, 7, 31, 14, 3, 3, 123 + 17 * seconds(ts)));
                    datenum(datetime(2017, 7, 31, 14, 3, 3, 123 + 18 * seconds(ts)))];
            data = [1, 1;
                    1, 2;
                    1, 3;
                    2, 4;
                    3, 5;
                    4, 6;
                    5, 7;
                    5, 8;
                    5, 9;
                    5, 9;
                    5, 8;
                    5, 7;
                    4, 6;
                    3, 5;
                    2, 4;
                    1, 3;
                    1, 2;
                    1, 1];
            tags = {'Channel 1', 'Channel 2'};
            units = {'s', 'min'};
            
            theObject = mdtsObject(time, data, tags, 'units', units, 'ts', ts);
            
            ls = 11;
            noBfs = 2;
            
            input1.object = theObject;
            input1.tag = 'Channel 1';
            
            input2.object = theObject;
            input2.tag = 'Channel 2';
                           
            expectedReturn1 = [2.54545454545454,2.54545454545454,2.54545454545454,2.54545454545454,2.54545454545454,2.54545454545454,2.27272727272727,1.59090909090909,0.545454545454545,-0.545454545454545,-1.59090909090909,-2.27272727272727,-2.54545454545455,-2.54545454545455,-2.54545454545455,-2.54545454545455,-2.54545454545455,-2.54545454545455]';
            expectedReturn2 = [4.13636363636364,4.13636363636364,4.13636363636364,4.13636363636364,4.13636363636364,4.13636363636364,3.18181818181818,2.00000000000000,0.681818181818182,-0.681818181818182,-2.00000000000000,-3.18181818181818,-4.13636363636363,-4.13636363636364,-4.13636363636364,-4.13636363636364,-4.13636363636364,-4.13636363636364]';
            expectedReturn3 = [-2.97933884297520,-2.97933884297520,-2.97933884297520,-2.97933884297520,-2.97933884297520,-2.97933884297520,-3.84710743801653,-4.59917355371901,-4.97520661157024,-4.97520661157024,-4.59917355371901,-3.84710743801653,-2.97933884297520,-2.97933884297521,-2.97933884297521,-2.97933884297521,-2.97933884297521,-2.97933884297521]';
            
            output1 = LDOasConv(input1, ls, noBfs);
            output2 = LDOasConv(input2, ls, noBfs);
            output3 = LDOasConv(output2, ls, noBfs);
            
            testCase.verifyEqual(output1, expectedReturn1, 'RelTol', 1e-10);
            testCase.verifyEqual(output2, expectedReturn2, 'RelTol', 1e-1);
            testCase.verifyEqual(output3, expectedReturn3, 'RelTol', 1e-1);
            
        end
    end
    
end


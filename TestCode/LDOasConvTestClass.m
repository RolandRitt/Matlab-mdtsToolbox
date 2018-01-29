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
                    datenum(datetime(2017, 7, 31, 14, 3, 3, 123 + 8 * seconds(ts)))
                    datenum(datetime(2017, 7, 31, 14, 3, 3, 123 + 9 * seconds(ts)))];
            data = [1, 1;
                    1, 2;
                    1, 3;
                    2, 4;
                    3, 5;
                    4, 6;
                    5, 7;
                    5, 8;
                    5, 9];
            tags = {'Channel 1', 'Channel 2'};
            units = {'s', 'min'};
            
            theObject = mdtsObject(time, data, tags, 'units', units, 'ts', ts);
            
            input.object = theObject;
            input.tag = 'Channel 1';
                           
            expectedReturn1 = gradient(data(:, 1));
            expectedReturn2 = gradient(expectedReturn1);
            
            output1 = LDOasConv(input);
            output2 = LDOasConv(output1);
            
            testCase.verifyEqual(output1, expectedReturn1);
            testCase.verifyEqual(output2, expectedReturn2);
            
        end
        
    end
    
end


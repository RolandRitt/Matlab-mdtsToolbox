classdef computeRuleTestClass < matlab.unittest.TestCase
    %
    % Description : Test the computeRule function
    %
    % Author :
    %    Paul O'Leary
    %    Roland Ritt
    %    Thomas Grandl
    %
    % History :
    % \change{1.0}{29-Dec-2017}{Original}
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
                    datenum(datetime(2017, 7, 31, 14, 3, 3, 123 + 3 * seconds(ts)));
                    datenum(datetime(2017, 7, 31, 14, 3, 3, 123 + 4 * seconds(ts)));
                    datenum(datetime(2017, 7, 31, 14, 3, 3, 123 + 5 * seconds(ts)));
                    datenum(datetime(2017, 7, 31, 14, 3, 3, 123 + 6 * seconds(ts)));
                    datenum(datetime(2017, 7, 31, 14, 3, 3, 123 + 7 * seconds(ts)));
                    datenum(datetime(2017, 7, 31, 14, 3, 3, 123 + 8 * seconds(ts)))];
            data = [1, 9;
                    2, 8;
                    3, 7;
                    4, 6;
                    5, 5;
                    6, 4;
                    7, 3;
                    8, 2;
                    9, 1];
            tags = {'Channel 1', 'Channel 2'};
            units = {'s', 'min'};
            
            mdtsObject1 = mdtsObject(time, data, tags, 'units', units, 'ts', ts);
            
            input1.object = mdtsObject1;
            input1.tag = tags{1};
            input2.object = mdtsObject1;
            input2.tag = tags{2};
            
            conditionOperator1 = '>';
            value1 = 6;
            conditionOperator2 = '<';
            value2 = 4;
            
            ruleOperator1 = '&';
            ruleOperator2 = '|';
            
            expectedReturn1 = (data(:, 1) > value1) & (data(:, 2) < value2);
            expectedReturn2 = (data(:, 1) > value1) | (data(:, 2) < value2);
            
            conformElements1 = computeFind(conditionOperator1, input1, value1);
            conformElements2 = computeFind(conditionOperator2, input2, value2);
            
            output1 = computeRule(ruleOperator1, conformElements1, conformElements2);
            output2 = computeRule(ruleOperator2, conformElements1, conformElements2);
            
            testCase.verifyEqual(output1, expectedReturn1);  
            testCase.verifyEqual(output2, expectedReturn2);
            
        end
        
        function invalidInputs(testCase)
            
            ts = duration(0, 0, 0, 50);
            time = [datenum(datetime(2017, 7, 31, 14, 3, 3, 123 + 0 * seconds(ts)));
                    datenum(datetime(2017, 7, 31, 14, 3, 3, 123 + 1 * seconds(ts)));
                    datenum(datetime(2017, 7, 31, 14, 3, 3, 123 + 2 * seconds(ts)));
                    datenum(datetime(2017, 7, 31, 14, 3, 3, 123 + 3 * seconds(ts)));
                    datenum(datetime(2017, 7, 31, 14, 3, 3, 123 + 4 * seconds(ts)));
                    datenum(datetime(2017, 7, 31, 14, 3, 3, 123 + 5 * seconds(ts)));
                    datenum(datetime(2017, 7, 31, 14, 3, 3, 123 + 6 * seconds(ts)));
                    datenum(datetime(2017, 7, 31, 14, 3, 3, 123 + 7 * seconds(ts)));
                    datenum(datetime(2017, 7, 31, 14, 3, 3, 123 + 8 * seconds(ts)))];
            data = [1, 9;
                    2, 8;
                    3, 7;
                    4, 6;
                    5, 5;
                    6, 4;
                    7, 3;
                    8, 2;
                    9, 1];
            tags = {'Channel 1', 'Channel 2'};
            units = {'s', 'min'};
            
            mdtsObject1 = mdtsObject(time, data, tags, 'units', units, 'ts', ts);
            
            input1.object = mdtsObject1;
            input1.tag = tags{1};
            input2.object = mdtsObject1;
            input2.tag = tags{2};
            
            conditionOperator1 = '>';
            value1 = 6;
            conditionOperator2 = '<';
            value2 = 4;
            
            validRuleOperator = '&';
            invalidRuleOperator1 = 'invalidOperator';
            invalidRuleOperator2 = 123;
            
            conformElements1 = computeFind(conditionOperator1, input1, value1);
            conformElements2 = computeFind(conditionOperator2, input2, value2);
            invalidConformElements1 = [1; 0; 1];
            invalidConformElements2 = [0; 0; 1];

            testCase.verifyError(@()computeRule(validRuleOperator, invalidConformElements1, conformElements2), 'computeRule:IllegalInputFormat'); 
            testCase.verifyError(@()computeRule(validRuleOperator, conformElements1, invalidConformElements2), 'computeRule:IllegalInputFormat'); 
            testCase.verifyError(@()computeRule(validRuleOperator, conformElements1(1 : end - 2), conformElements2), 'computeRule:InputsOfDifferentLength'); 
            testCase.verifyError(@()computeRule(validRuleOperator, conformElements1, conformElements2(1 : end - 2)), 'computeRule:InputsOfDifferentLength'); 
            testCase.verifyError(@()computeRule(invalidRuleOperator1, conformElements1, conformElements2), 'computeRule:InvalidOperator'); 
            testCase.verifyError(@()computeRule(invalidRuleOperator2, conformElements1, conformElements2), 'computeRule:InvalidOperator'); 
            
        end
        
    end
    
end


classdef isValidInputTestClass < matlab.unittest.TestCase
    %
    % Description : Test the isValidInput function
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
        
        function validStruct(testCase)
            
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
            
            expectedReturn1 = 1;
            
            output1 = isValidInput(input1);
            
            testCase.verifyEqual(output1, expectedReturn1);  
            
        end
        
        function invalidStruct(testCase)
            
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
            
            input1.someField = 'someField';
            input1.tag = 123;            
                        
            input2.object = 'someField';
            input2.field2 = 'Field2';
            
            input3.object = mdtsObject1;
            input3.field2 = 'Field2';
            
            input4.object = mdtsObject1;
            input4.tag = 123;
            
            input5.someField = 'someField';
            input5.tag = 'someTag';
            
            input6.object = 'someField';
            input6.tag = 'someTag'; 
            
            expectedReturn = 0;
            
            output1 = isValidInput(input1);
            output2 = isValidInput(input2);
            output3 = isValidInput(input3);
            output4 = isValidInput(input4);
            output5 = isValidInput(input5);
            output6 = isValidInput(input6);
            
            testCase.verifyEqual(output1, expectedReturn);  
            testCase.verifyEqual(output2, expectedReturn);  
            testCase.verifyEqual(output3, expectedReturn);  
            testCase.verifyEqual(output4, expectedReturn);  
            testCase.verifyEqual(output5, expectedReturn);  
            testCase.verifyEqual(output6, expectedReturn);  
            
        end
        
        function validVector(testCase)
            
            input1 = [1; 2; 3; 4; 5; 6; 7; 8; 9];
            
            expectedReturn1 = 2;
            
            output1 = isValidInput(input1);
            
            testCase.verifyEqual(output1, expectedReturn1);  
            
        end
        
        function invalidVector(testCase)
            
            input1 = [1, 2, 3, 4, 5, 6, 7, 8, 9];
            input2 = 'test1';
            
            expectedReturn = 0;
            
            output1 = isValidInput(input1);
            output2 = isValidInput(input2);
            
            testCase.verifyEqual(output1, expectedReturn);  
            testCase.verifyEqual(output2, expectedReturn);  
            
        end
    end    
end


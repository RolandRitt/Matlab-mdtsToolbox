classdef calcBatchTestClass < matlab.unittest.TestCase
    %
    % Description : Test the calcBatch class
    %
    % Author :
    %    Paul O'Leary
    %    Roland Ritt
    %    Thomas Grandl
    %
    % History :
    % \change{1.0}{16-Oct-2017}{Original}
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
        
        function testConstructor(testCase)
            
            calcProgram = calcBatch;
            
            testCase.verifyEqual(isa(calcProgram, 'calcBatch'), true);

        end        
        
        function testAddCalculations(testCase)
            
            calcName = 'Test calculation';
            inputTag = 'Channel 1';
            outputTag = 'Result 1';
            convM = [-1,  1,  0;
                     -1,  0,  1;
                      0, -1,  1];
                  
            calcObj = DummyConvCalcObject(calcName, inputTag, outputTag, convM);
            
            calcProgram = calcBatch;
            
            calcProgram.addCalculations(calcObj);
            
            testCase.verifyEqual(calcProgram.calcObjectBatch, {calcObj});
            
            calcProgram.addCalculations({calcObj, calcObj, calcObj});
            
            testCase.verifyEqual(calcProgram.calcObjectBatch, {calcObj; calcObj; calcObj; calcObj});
            
        end
        
    end
    
end

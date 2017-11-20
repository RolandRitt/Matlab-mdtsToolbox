classdef genericCalcObjectTestClass < matlab.unittest.TestCase
    %
    % Description : Test the genericCalcObject class
    %
    % Author :
    %    Paul O'Leary
    %    Roland Ritt
    %    Thomas Grandl
    %
    % History :
    % \change{1.0}{30-Oct-2017}{Original}
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
        
        function testStringGeneration(testCase)
                                   
            calcName = 'Test calculation';
            inputTag = 'Channel 1';
            outputTag = 'Result 1';
            calcType = 'Convolution';
            convM = [-1,  1,  0;
                     -1,  0,  1;
                      0, -1,  1];
                  
            calcObj = genericCalcObject(calcName, inputTag, outputTag, calcType, 'convM', convM);
            calcObj2(1 : 3) = genericCalcObject(calcName, inputTag, outputTag, calcType, 'convM', convM);
            
            testCase.verifyEqual(calcObj.getString, '{"calcName":"Test calculation","inputTag":["Channel 1"],"outputTag":["Result 1"],"calcType":"Convolution","convM":[[-1,1,0],[-1,0,1],[0,-1,1]]}');
            testCase.verifyEqual(calcObj2.getString, '[{"calcName":"Test calculation","inputTag":["Channel 1"],"outputTag":["Result 1"],"calcType":"Convolution","convM":[[-1,1,0],[-1,0,1],[0,-1,1]]},{"calcName":"Test calculation","inputTag":["Channel 1"],"outputTag":["Result 1"],"calcType":"Convolution","convM":[[-1,1,0],[-1,0,1],[0,-1,1]]},{"calcName":"Test calculation","inputTag":["Channel 1"],"outputTag":["Result 1"],"calcType":"Convolution","convM":[[-1,1,0],[-1,0,1],[0,-1,1]]}]');
            
        end
        
    end
    
end


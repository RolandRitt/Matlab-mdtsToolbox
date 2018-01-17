classdef applyMCLATestClass < matlab.unittest.TestCase
    %
    % Description : Test the applyMCLA function
    %
    % Author :
    %    Paul O'Leary
    %    Roland Ritt
    %    Thomas Grandl
    %
    % History :
    % \change{1.0}{17-Jan-2018}{Original}
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
        
        function testFunctionality(testCase)
            
            durations1 = [1; 1; 3; 1; 2; 1; 2; 3; 4];
            symbols1 = categorical({'a', 'b', 'c', 'b', 'a', 'c', 'b', 'c', 'b'})';
            durations2 = [1; 3; 1; 2; 1; 3; 4; 1; 2];
            symbols2 = categorical({'x', 'y', 'z', 'y', 'z', 'x', 'y', 'x', 'z'})';
            durations3 = [3; 2; 1; 1; 4; 2; 1; 1; 3];
            symbols3 = categorical({'u', 'w', 'v', 'u', 'w', 'u', 'v', 'w', 'v'})';
                                   
            symbObj1 = SymbRepObject(durations1, symbols1);
            symbObj2 = SymbRepObject(durations2, symbols2);  
            symbObj3 = SymbRepObject(durations3, symbols3);  
            
            symbRepObjectsList = {symbObj1, symbObj2, symbObj3};
            
            expectedReturn1.symbols = categorical({'(axu)', '(byu)', '(cyu)', '(cyw)', '(czw)', '(byv)', '(ayu)', '(azw)', '(cxw)', '(bxw)', '(cyu)', '(cyv)', '(byw)', '(bxv)', '(bzv)'})';
            expectedReturn1.durations = [1; 1; 1; 1; 1; 1; 1; 1; 1; 2; 2; 1; 1; 1; 2];           
                        
            mclaSymbRepObject = applyMCLA(symbRepObjectsList);
            
            testCase.verifyEqual(mclaSymbRepObject.durations, expectedReturn1.durations);
            testCase.verifyEqual(mclaSymbRepObject.symbols, expectedReturn1.symbols);
            
        end
        
        function testInputValidation(testCase)
            
            durations1 = [1; 1; 3; 1; 2; 1; 2; 3; 4];
            symbols1 = categorical({'a', 'b', 'c', 'b', 'a', 'c', 'b', 'c', 'b'})';
            durations2 = [1; 1; 2; 1; 3; 4; 1; 2];
            symbols2 = categorical({'x', 'z', 'y', 'z', 'x', 'y', 'x', 'z'})';
            durations3 = [3; 1; 1; 1; 4; 2; 1; 1; 3];
            symbols3 = categorical({'u', 'w', 'v', 'u', 'w', 'u', 'v', 'w', 'v'})';
            
            symbObj1 = SymbRepObject(durations1, symbols1);
            symbObj2 = SymbRepObject(durations2, symbols2); 
            symbObj3 = SymbRepObject(durations3, symbols3); 
            
            symbRepObjectsList1 = {symbObj1, symbObj2};
            symbRepObjectsList2 = {symbObj1, symbObj3};
            
            testCase.verifyError(@()applyMCLA(symbRepObjectsList1), 'applyMCLA:UnequalChannelLength');
            testCase.verifyError(@()applyMCLA(symbRepObjectsList2), 'applyMCLA:UnequalChannelLength');
            
        end
        
    end
    
end


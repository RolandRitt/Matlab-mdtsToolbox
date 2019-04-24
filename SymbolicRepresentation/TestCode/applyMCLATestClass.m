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
            
            expectedReturn1.symbols = categorical({'({a}{x}{u})', '({b}{y}{u})', '({c}{y}{u})', '({c}{y}{w})', '({c}{z}{w})', '({b}{y}{v})', '({a}{y}{u})', '({a}{z}{w})', '({c}{x}{w})', '({b}{x}{w})', '({c}{y}{u})', '({c}{y}{v})', '({b}{y}{w})', '({b}{x}{v})', '({b}{z}{v})'})';
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
        
        function testMultipleMerges(testCase)
            
            durations1 = [1; 1; 3; 1; 2; 1; 2; 3; 4];
            symbols1 = categorical({'a', 'b', 'c', 'b', 'a', 'c', 'b', 'c', 'b'})';
            durations2 = [1; 3; 1; 2; 1; 3; 4; 1; 2];
            symbols2 = categorical({'x', 'y', 'z', 'y', 'z', 'x', 'y', 'x', 'z'})';
            durations3 = [3; 2; 1; 1; 4; 2; 1; 1; 3];
            symbols3 = categorical({'u', 'w', 'v', 'u', 'w', 'u', 'v', 'w', 'v'})';
            
            symbSequence1 = {'c', 'b'};
            symbSequence2 = {'x', 'y'};
            
            symbObj1 = SymbRepObject(durations1, symbols1);
            symbObj2 = SymbRepObject(durations2, symbols2); 
            symbObj3 = SymbRepObject(durations3, symbols3); 
            
            symbObj1 = symbObj1.mergeSequence(symbSequence1);
            symbObj2 = symbObj2.mergeSequence(symbSequence2);
            
            symbRepObjectsList1 = {symbObj1, symbObj2};   
            mclaSymbRepObject1 = applyMCLA(symbRepObjectsList1);
            symbRepObjectsList2 = {mclaSymbRepObject1, symbObj3};
            mclaSymbRepObject2 = applyMCLA(symbRepObjectsList2);
            
            expectedReturn1.symbols = categorical({'({a}[{x}{y}])', '({b}[{x}{y}])', '([{c}{b}][{x}{y}])', '([{c}{b}]{z})', '([{c}{b}]{y})', '({a}{y})', '({a}{z})', '([{c}{b}][{x}{y}])', '([{c}{b}]{x})', '([{c}{b}]{z})'})';
            expectedReturn1.durations = [1; 1; 2; 1; 1; 1; 1; 7; 1; 2];  
            expectedReturn2.symbols = categorical({'(({a}[{x}{y}]){u})', '(({b}[{x}{y}]){u})', '(([{c}{b}][{x}{y}]){u})', '(([{c}{b}][{x}{y}]){w})', '(([{c}{b}]{z}){w})', '(([{c}{b}]{y}){v})', '(({a}{y}){u})', '(({a}{z}){w})', '(([{c}{b}][{x}{y}]){w})', '(([{c}{b}][{x}{y}]){u})', '(([{c}{b}][{x}{y}]){v})', '(([{c}{b}][{x}{y}]){w})', '(([{c}{b}]{x}){v})', '(([{c}{b}]{z}){v})'})';
            expectedReturn2.durations = [1; 1; 1; 1; 1; 1; 1; 1; 3; 2; 1; 1; 1; 2];  
                        
            testCase.verifyEqual(mclaSymbRepObject1.durations, expectedReturn1.durations);
            testCase.verifyEqual(mclaSymbRepObject1.symbols, expectedReturn1.symbols);
            testCase.verifyEqual(mclaSymbRepObject2.durations, expectedReturn2.durations);
            testCase.verifyEqual(mclaSymbRepObject2.symbols, expectedReturn2.symbols);
            
        end
        
    end
    
end


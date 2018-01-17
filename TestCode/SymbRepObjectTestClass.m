classdef SymbRepObjectTestClass < matlab.unittest.TestCase
    %
    % Description : Test the SymbRepObject function
    %
    % Author :
    %    Paul O'Leary
    %    Roland Ritt
    %    Thomas Grandl
    %
    % History :
    % \change{1.0}{16-Jan-2018}{Original}
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
        
        function testConstructor(testCase)
           
            expectedReturn1.durations = [1; 1; 3; 1; 2; 1];
            expectedReturn1.symbols = categorical({'a', 'b', 'c', 'b', 'a', 'c'})';
            
            symbObj1 = SymbRepObject(expectedReturn1.durations, expectedReturn1.symbols);    
            
            testCase.verifyEqual(symbObj1.durations, expectedReturn1.durations);
            testCase.verifyEqual(symbObj1.symbols, expectedReturn1.symbols);
            
        end
        
        function testInputValidation(testCase)
            
            durations1 = [1; 1; 3; 1; 2; 1; 2; 3; 4];
            symbols1 = {'a', 'b', 'c', 'b', 'a', 'c', 'b', 'c', 'b'}';
            durations2 = {'1', '2', '3', '4', '5', '6', '7', '8', '9'}';
            symbols2 = categorical({'1', '2', '3', '4', '5', '6', '7', '8', '9'})';
            durations3 = [3; 1; 1; 1; 4; 2; 1; 1];
            symbols3 = categorical({'u', 'w', 'v', 'u', 'w', 'u', 'v', 'w', 'v'})';
            
            testCase.verifyError(@()SymbRepObject(durations1, symbols1), 'SymbRepObject:SymbolsNotCategorical');
            testCase.verifyError(@()SymbRepObject(durations2, symbols2), 'SymbRepObject:DurationsNotNumeric');
            testCase.verifyError(@()SymbRepObject(durations3, symbols3), 'SymbRepObject:InvalidInputLength');
            
        end
        
        function testMergeSequence(testCase)
            
            durations = [1; 1; 3; 1; 2; 1; 2; 3; 4];
            symbols = categorical({'a', 'b', 'c', 'b', 'a', 'c', 'b', 'c', 'b'})';
            
            symbSequence = {'c', 'b'};
            
            expectedReturn1.symbols = categorical({'a', 'b', '[cb]', 'a', '[cb]'}, {'a', 'b', 'c', '[cb]'})';
            expectedReturn1.durations = [1; 1; 4; 2; 10];
            
            symbObj1 = SymbRepObject(durations, symbols);   
            
            symbObj1 = symbObj1.mergeSequence(symbSequence);
            
            testCase.verifyEqual(symbObj1.durations, expectedReturn1.durations);
            testCase.verifyEqual(symbObj1.symbols, expectedReturn1.symbols);
            testCase.verifyEqual(categories(symbObj1.symbols), categories(expectedReturn1.symbols));
            
        end
        
    end
    
end


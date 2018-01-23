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
            
            durations1 = [1; 1; 3; 1; 2; 1; 2; 3; 4];
            symbols1 = categorical({'a', 'b', 'c', 'b', 'a', 'c', 'b', 'c', 'b'})';
            durations2 = [1; 3; 1; 2; 1; 3; 4; 1; 2];
            symbols2 = categorical({'x', 'y', 'z', 'y', 'z', 'x', 'y', 'x', 'z'})';
            
            symbSequence1 = {'c', 'b'};
            symbSequence2 = {'x', 'y'};
            
            expectedReturn1.symbols = categorical({'a', 'b', '[{c}{b}]', 'a', '[{c}{b}]'}, {'a', 'b', 'c', '[{c}{b}]'})';
            expectedReturn1.durations = [1; 1; 4; 2; 10];
            expectedReturn2.symbols = categorical({'[{x}{y}]', 'z', 'y', 'z', '[{x}{y}]', 'x', 'z'}, {'x', 'y', 'z', '[{x}{y}]'})';
            expectedReturn2.durations = [4; 1; 2; 1; 7; 1; 2];
            
            symbObj1 = SymbRepObject(durations1, symbols1); 
            symbObj2 = SymbRepObject(durations2, symbols2);
            
            symbObj1 = symbObj1.mergeSequence(symbSequence1);
            symbObj2 = symbObj2.mergeSequence(symbSequence2);
            
            testCase.verifyEqual(symbObj1.durations, expectedReturn1.durations);
            testCase.verifyEqual(symbObj1.symbols, expectedReturn1.symbols);
            testCase.verifyEqual(categories(symbObj1.symbols), categories(expectedReturn1.symbols));
            testCase.verifyEqual(symbObj2.durations, expectedReturn2.durations);
            testCase.verifyEqual(symbObj2.symbols, expectedReturn2.symbols);
            testCase.verifyEqual(categories(symbObj2.symbols), categories(expectedReturn2.symbols));
            
        end
        
        function findSymbol(testCase)
            
            durations = [1; 1; 3; 1; 2; 1; 2; 3; 4];
            symbols = categorical({'a', 'b', 'c', 'b', 'a', 'c', 'b', 'c', 'b'})';
            
            expectedReturn1.startInds = [1; 7];
            expectedReturn1.durations = [1; 2];
            expectedReturn2.startInds = [2; 6; 10; 15];
            expectedReturn2.durations = [1; 1; 2; 4];
            expectedReturn3.startInds = [3; 9; 12];
            expectedReturn3.durations = [3; 1; 3];
            
            symbObj = SymbRepObject(durations, symbols); 
            
            [return1.startInds, return1.durations] = symbObj.findSymbol('a');
            [return2.startInds, return2.durations] = symbObj.findSymbol('b');
            [return3.startInds, return3.durations] = symbObj.findSymbol('c');
            
            testCase.verifyEqual(return1.startInds, expectedReturn1.startInds);
            testCase.verifyEqual(return1.durations, expectedReturn1.durations);
            testCase.verifyEqual(return2.startInds, expectedReturn2.startInds);
            testCase.verifyEqual(return2.durations, expectedReturn2.durations);
            testCase.verifyEqual(return3.startInds, expectedReturn3.startInds);
            testCase.verifyEqual(return3.durations, expectedReturn3.durations);
            
            testCase.verifyError(@()symbObj.findSymbol(123), 'findSymbol:InputNoString');
            
        end
        
        function findSymbolVec(testCase)
            
            durations = [1; 1; 3; 1; 2; 1; 2; 3; 4];
            symbols = categorical({'a', 'b', 'c', 'b', 'a', 'c', 'b', 'c', 'b'})';
            
            expectedReturn1 = boolean([1; 0; 0; 0; 0; 0; 1; 1; 0; 0; 0; 0; 0; 0; 0; 0; 0; 0]);
            expectedReturn2 = boolean([0; 1; 0; 0; 0; 1; 0; 0; 0; 1; 1; 0; 0; 0; 1; 1; 1; 1]);
            expectedReturn3 = boolean([0; 0; 1; 1; 1; 0; 0; 0; 1; 0; 0; 1; 1; 1; 0; 0; 0; 0]);
            
            symbObj = SymbRepObject(durations, symbols); 
            
            testCase.verifyEqual(symbObj.findSymbolVec('a'), expectedReturn1);
            testCase.verifyEqual(symbObj.findSymbolVec('b'), expectedReturn2);
            testCase.verifyEqual(symbObj.findSymbolVec('c'), expectedReturn3);
            
            testCase.verifyError(@()symbObj.findSymbolVec(123), 'findSymbolVec:InputNoString');
            
        end
        
    end
    
end


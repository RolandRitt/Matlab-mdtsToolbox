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
            durations3 = [1; 1; 3; 1; 2; 1; 2; 3; 4; 2; 3; 1; 2];
            symbols3 = categorical({'a', 'b', 'c', 'a', 'b', 'c', 'a', 'c', 'b', 'c', 'a', 'b', 'c'})';
            durations4 = [1; 1; 3; 1; 2; 1; 2; 3; 4; 2; 3; 1; 2];
            symbols4 = categorical({'a', 'b', 'c', 'a', 'b', 'c', 'a', 'b', 'a', 'b', 'a', 'b', 'c'})';
            durations5 = [1; 1; 3; 1; 2; 1; 2; 3; 4; 2; 3; 1; 2];
            symbols5 = categorical({'a', 'b', 'a', 'b', 'a', 'b', 'c', 'b', 'c', 'b', 'a', 'b', 'a'})';
            durations6 = [1; 1; 3; 1; 2; 1; 2; 3; 4; 2; 3; 1; 2];
            symbols6 = categorical({'a', 'b', 'c', 'a', 'b', 'c', 'a', 'b', 'a', 'b', 'a', 'b', 'c'})';
            
            symbSequence1 = {'c', 'b'};
            symbSequence2 = {'x', 'y'};
            symbSequence3 = {'a', 'b', 'c'};
            symbSequence4 = {'a', 'b', 'c'};
            symbSequence5 = {'a', 'b', 'a'};
            symbSequence6 = {'a', 'b', 'c', 'a'};
            
            expectedReturn1.symbols = categorical({'a', 'b', '[{c}{b}]', 'a', '[{c}{b}]'}, {'a', 'b', '[{c}{b}]'})';
            expectedReturn1.durations = [1; 1; 4; 2; 10];
            expectedReturn2.symbols = categorical({'[{x}{y}]', 'z', 'y', 'z', '[{x}{y}]', 'x', 'z'}, {'x', 'y', 'z', '[{x}{y}]'})';
            expectedReturn2.durations = [4; 1; 2; 1; 7; 1; 2];
            expectedReturn3.symbols = categorical({'[{a}{b}{c}]', 'a', 'c', 'b', 'c', '[{a}{b}{c}]'}, {'a', 'b', 'c', '[{a}{b}{c}]'})';
            expectedReturn3.durations = [9; 2; 3; 4; 2; 6];
            expectedReturn4.symbols = categorical({'[{a}{b}{c}]', 'a', 'b', 'a', 'b', '[{a}{b}{c}]'}, {'a', 'b', '[{a}{b}{c}]'})';
            expectedReturn4.durations = [9; 2; 3; 4; 2; 6];
            expectedReturn5.symbols = categorical({'[{a}{b}{a}]', 'b', 'c', 'b', 'c', 'b', '[{a}{b}{a}]'}, {'b', 'c', '[{a}{b}{a}]'})';
            expectedReturn5.durations = [8; 1; 2; 3; 4; 2; 6];
            expectedReturn6.symbols = categorical({'[{a}{b}{c}{a}]', 'b', 'a', 'b', 'a', 'b', 'c'}, {'a', 'b', 'c', '[{a}{b}{c}{a}]'})';
            expectedReturn6.durations = [11; 3; 4; 2; 3; 1; 2];
            
            symbObj1 = SymbRepObject(durations1, symbols1);
            symbObj2 = SymbRepObject(durations2, symbols2);
            symbObj3 = SymbRepObject(durations3, symbols3);
            symbObj4 = SymbRepObject(durations4, symbols4);
            symbObj5 = SymbRepObject(durations5, symbols5);
            symbObj6 = SymbRepObject(durations6, symbols6);
            
            symbObj1 = symbObj1.mergeSequence(symbSequence1, 'bAllowOverlapping', true);
            symbObj2 = symbObj2.mergeSequence(symbSequence2, 'bAllowOverlapping', true);
            symbObj3 = symbObj3.mergeSequence(symbSequence3, 'bAllowOverlapping', true);
            symbObj4 = symbObj4.mergeSequence(symbSequence4, 'bAllowOverlapping', true);
            symbObj5 = symbObj5.mergeSequence(symbSequence5, 'bAllowOverlapping', true);
            symbObj6 = symbObj6.mergeSequence(symbSequence6, 'bAllowOverlapping', true);
            
            testCase.verifyEqual(symbObj1.durations, expectedReturn1.durations);
            testCase.verifyEqual(symbObj1.symbols, expectedReturn1.symbols);
            testCase.verifyEqual(categories(symbObj1.symbols), categories(expectedReturn1.symbols));
            testCase.verifyEqual(symbObj2.durations, expectedReturn2.durations);
            testCase.verifyEqual(symbObj2.symbols, expectedReturn2.symbols);
            testCase.verifyEqual(categories(symbObj2.symbols), categories(expectedReturn2.symbols));
            testCase.verifyEqual(symbObj3.durations, expectedReturn3.durations);
            testCase.verifyEqual(symbObj3.symbols, expectedReturn3.symbols);
            testCase.verifyEqual(categories(symbObj3.symbols), categories(expectedReturn3.symbols));
            testCase.verifyEqual(symbObj4.durations, expectedReturn4.durations);
            testCase.verifyEqual(symbObj4.symbols, expectedReturn4.symbols);
            testCase.verifyEqual(categories(symbObj4.symbols), categories(expectedReturn4.symbols));
            testCase.verifyEqual(symbObj5.durations, expectedReturn5.durations);
            testCase.verifyEqual(symbObj5.symbols, expectedReturn5.symbols);
            testCase.verifyEqual(categories(symbObj5.symbols), categories(expectedReturn5.symbols));
            testCase.verifyEqual(symbObj6.durations, expectedReturn6.durations);
            testCase.verifyEqual(symbObj6.symbols, expectedReturn6.symbols);
            testCase.verifyEqual(categories(symbObj6.symbols), categories(expectedReturn6.symbols));
            
            testCase.verifyError(@()symbObj1.mergeSequence('test1'), 'mergeSequence:InvalidInput');
            testCase.verifyError(@()symbObj1.mergeSequence({'a', 'b'; 'c', 'd'}), 'mergeSequence:InvalidInput');
            
        end
        
        function testMergeSequenceNonOverlapping(testCase)
            
            durations1 = [1; 1; 3; 1; 2; 1; 2; 3; 4];
            symbols1 = categorical({'a', 'b', 'c', 'b', 'a', 'c', 'b', 'c', 'b'})';
            durations2 = [1; 3; 1; 2; 1; 3; 4; 1; 2];
            symbols2 = categorical({'x', 'y', 'z', 'y', 'z', 'x', 'y', 'x', 'z'})';
            durations3 = [1; 1; 3; 1; 2; 1; 2; 3; 4; 2; 3; 1; 2];
            symbols3 = categorical({'a', 'b', 'c', 'a', 'b', 'c', 'a', 'c', 'b', 'c', 'a', 'b', 'c'})';
            durations4 = [1; 1; 3; 1; 2; 1; 2; 3; 4; 2; 3; 1; 2];
            symbols4 = categorical({'a', 'b', 'c', 'a', 'b', 'c', 'a', 'b', 'a', 'b', 'a', 'b', 'c'})';
            durations5 = [1; 1; 3; 1; 2; 1; 2; 3; 4; 2; 3; 1; 2];
            symbols5 = categorical({'a', 'b', 'a', 'b', 'a', 'b', 'c', 'b', 'c', 'b', 'a', 'b', 'a'})';
            durations6 = [1; 1; 3; 1; 2; 1; 2; 3; 4; 2; 3; 1; 2];
            symbols6 = categorical({'a', 'b', 'c', 'a', 'b', 'c', 'a', 'b', 'a', 'b', 'a', 'b', 'c'})';
            
            symbSequence1 = {'c', 'b'};
            symbSequence2 = {'x', 'y'};
            symbSequence3 = {'a', 'b', 'c'};
            symbSequence4 = {'a', 'b', 'c'};
            symbSequence5 = {'a', 'b', 'a'};
            symbSequence6 = {'a', 'b', 'c', 'a'};
            
            expectedReturn1.symbols = categorical({'a', 'b', '[{c}{b}]', 'a', '[{c}{b}]'}, {'a', 'b', '[{c}{b}]'})';
            expectedReturn1.durations = [1; 1; 4; 2; 10];
            expectedReturn2.symbols = categorical({'[{x}{y}]', 'z', 'y', 'z', '[{x}{y}]', 'x', 'z'}, {'x', 'y', 'z', '[{x}{y}]'})';
            expectedReturn2.durations = [4; 1; 2; 1; 7; 1; 2];
            expectedReturn3.symbols = categorical({'[{a}{b}{c}]', 'a', 'c', 'b', 'c', '[{a}{b}{c}]'}, {'a', 'b', 'c', '[{a}{b}{c}]'})';
            expectedReturn3.durations = [9; 2; 3; 4; 2; 6];
            expectedReturn4.symbols = categorical({'[{a}{b}{c}]', 'a', 'b', 'a', 'b', '[{a}{b}{c}]'}, {'a', 'b', '[{a}{b}{c}]'})';
            expectedReturn4.durations = [9; 2; 3; 4; 2; 6];
            expectedReturn5.symbols = categorical({'[{a}{b}{a}]', 'b','a','b', 'c', 'b', 'c', 'b', '[{a}{b}{a}]'}, {'a', 'b', 'c', '[{a}{b}{a}]'})';
            expectedReturn5.durations = [5; 1;2;1; 2; 3; 4; 2; 6];
            expectedReturn6.symbols = categorical({'[{a}{b}{c}{a}]', 'b', 'c', 'a', 'b', 'a', 'b', 'a', 'b', 'c'}, {'a', 'b', 'c', '[{a}{b}{c}{a}]'})';
            expectedReturn6.durations = [6; 2; 1; 2; 3; 4; 2; 3; 1; 2];
            
            symbObj1 = SymbRepObject(durations1, symbols1);
            symbObj2 = SymbRepObject(durations2, symbols2);
            symbObj3 = SymbRepObject(durations3, symbols3);
            symbObj4 = SymbRepObject(durations4, symbols4);
            symbObj5 = SymbRepObject(durations5, symbols5);
            symbObj6 = SymbRepObject(durations6, symbols6);
            
            symbObj1 = symbObj1.mergeSequence(symbSequence1);
            symbObj2 = symbObj2.mergeSequence(symbSequence2);
            symbObj3 = symbObj3.mergeSequence(symbSequence3);
            symbObj4 = symbObj4.mergeSequence(symbSequence4);
            symbObj5 = symbObj5.mergeSequence(symbSequence5);
            symbObj6 = symbObj6.mergeSequence(symbSequence6);
            
            testCase.verifyEqual(symbObj1.durations, expectedReturn1.durations);
            testCase.verifyEqual(symbObj1.symbols, expectedReturn1.symbols);
            testCase.verifyEqual(categories(symbObj1.symbols), categories(expectedReturn1.symbols));
            testCase.verifyEqual(symbObj2.durations, expectedReturn2.durations);
            testCase.verifyEqual(symbObj2.symbols, expectedReturn2.symbols);
            testCase.verifyEqual(categories(symbObj2.symbols), categories(expectedReturn2.symbols));
            testCase.verifyEqual(symbObj3.durations, expectedReturn3.durations);
            testCase.verifyEqual(symbObj3.symbols, expectedReturn3.symbols);
            testCase.verifyEqual(categories(symbObj3.symbols), categories(expectedReturn3.symbols));
            testCase.verifyEqual(symbObj4.durations, expectedReturn4.durations);
            testCase.verifyEqual(symbObj4.symbols, expectedReturn4.symbols);
            testCase.verifyEqual(categories(symbObj4.symbols), categories(expectedReturn4.symbols));
            testCase.verifyEqual(symbObj5.durations, expectedReturn5.durations);
            testCase.verifyEqual(symbObj5.symbols, expectedReturn5.symbols);
            testCase.verifyEqual(categories(symbObj5.symbols), categories(expectedReturn5.symbols));
            testCase.verifyEqual(symbObj6.durations, expectedReturn6.durations);
            testCase.verifyEqual(symbObj6.symbols, expectedReturn6.symbols);
            testCase.verifyEqual(categories(symbObj6.symbols), categories(expectedReturn6.symbols));
            
            testCase.verifyError(@()symbObj1.mergeSequence('test1'), 'mergeSequence:InvalidInput');
            testCase.verifyError(@()symbObj1.mergeSequence({'a', 'b'; 'c', 'd'}), 'mergeSequence:InvalidInput');
            
        end
       function testMergeSequenceNonOverlappingNewSymbol(testCase)
            
            durations1 = [1; 1; 3; 1; 2; 1; 2; 3; 4];
            symbols1 = categorical({'a', 'b', 'c', 'b', 'a', 'c', 'b', 'c', 'b'})';
            durations2 = [1; 3; 1; 2; 1; 3; 4; 1; 2];
            symbols2 = categorical({'x', 'y', 'z', 'y', 'z', 'x', 'y', 'x', 'z'})';
            durations3 = [1; 1; 3; 1; 2; 1; 2; 3; 4; 2; 3; 1; 2];
            symbols3 = categorical({'a', 'b', 'c', 'a', 'b', 'c', 'a', 'c', 'b', 'c', 'a', 'b', 'c'})';
            durations4 = [1; 1; 3; 1; 2; 1; 2; 3; 4; 2; 3; 1; 2];
            symbols4 = categorical({'a', 'b', 'c', 'a', 'b', 'c', 'a', 'b', 'a', 'b', 'a', 'b', 'c'})';
            durations5 = [1; 1; 3; 1; 2; 1; 2; 3; 4; 2; 3; 1; 2];
            symbols5 = categorical({'a', 'b', 'a', 'b', 'a', 'b', 'c', 'b', 'c', 'b', 'a', 'b', 'a'})';
            durations6 = [1; 1; 3; 1; 2; 1; 2; 3; 4; 2; 3; 1; 2];
            symbols6 = categorical({'a', 'b', 'c', 'a', 'b', 'c', 'a', 'b', 'a', 'b', 'a', 'b', 'c'})';
            
            symbSequence1 = {'c', 'b'};
            symbSequence2 = {'x', 'y'};
            symbSequence3 = {'a', 'b', 'c'};
            symbSequence4 = {'a', 'b', 'c'};
            symbSequence5 = {'a', 'b', 'a'};
            symbSequence6 = {'a', 'b', 'c', 'a'};
            
            expectedReturn1.symbols = categorical({'a', 'b', 'test1', 'a', 'test1'}, {'a', 'b', 'test1'})';
            expectedReturn1.durations = [1; 1; 4; 2; 10];
            expectedReturn2.symbols = categorical({'test2', 'z', 'y', 'z', 'test2', 'x', 'z'}, {'x', 'y', 'z', 'test2'})';
            expectedReturn2.durations = [4; 1; 2; 1; 7; 1; 2];
            expectedReturn3.symbols = categorical({'test3', 'a', 'c', 'b', 'c', 'test3'}, {'a', 'b', 'c', 'test3'})';
            expectedReturn3.durations = [9; 2; 3; 4; 2; 6];
            expectedReturn4.symbols = categorical({'test4', 'a', 'b', 'a', 'b', 'test4'}, {'a', 'b', 'test4'})';
            expectedReturn4.durations = [9; 2; 3; 4; 2; 6];
            expectedReturn5.symbols = categorical({'test5', 'b','a','b', 'c', 'b', 'c', 'b', 'test5'}, {'a', 'b', 'c', 'test5'})';
            expectedReturn5.durations = [5; 1;2;1; 2; 3; 4; 2; 6];
            expectedReturn6.symbols = categorical({'test6', 'b', 'c', 'a', 'b', 'a', 'b', 'a', 'b', 'c'}, {'a', 'b', 'c', 'test6'})';
            expectedReturn6.durations = [6; 2; 1; 2; 3; 4; 2; 3; 1; 2];
            
            symbObj1 = SymbRepObject(durations1, symbols1);
            symbObj2 = SymbRepObject(durations2, symbols2);
            symbObj3 = SymbRepObject(durations3, symbols3);
            symbObj4 = SymbRepObject(durations4, symbols4);
            symbObj5 = SymbRepObject(durations5, symbols5);
            symbObj6 = SymbRepObject(durations6, symbols6);
            
            symbObj1 = symbObj1.mergeSequence(symbSequence1, 'newSymbol','test1');
            symbObj2 = symbObj2.mergeSequence(symbSequence2, 'newSymbol','test2');
            symbObj3 = symbObj3.mergeSequence(symbSequence3, 'newSymbol','test3');
            symbObj4 = symbObj4.mergeSequence(symbSequence4, 'newSymbol','test4');
            symbObj5 = symbObj5.mergeSequence(symbSequence5, 'newSymbol','test5');
            symbObj6 = symbObj6.mergeSequence(symbSequence6, 'newSymbol','test6');
            
            testCase.verifyEqual(symbObj1.durations, expectedReturn1.durations);
            testCase.verifyEqual(symbObj1.symbols, expectedReturn1.symbols);
            testCase.verifyEqual(categories(symbObj1.symbols), categories(expectedReturn1.symbols));
            testCase.verifyEqual(symbObj2.durations, expectedReturn2.durations);
            testCase.verifyEqual(symbObj2.symbols, expectedReturn2.symbols);
            testCase.verifyEqual(categories(symbObj2.symbols), categories(expectedReturn2.symbols));
            testCase.verifyEqual(symbObj3.durations, expectedReturn3.durations);
            testCase.verifyEqual(symbObj3.symbols, expectedReturn3.symbols);
            testCase.verifyEqual(categories(symbObj3.symbols), categories(expectedReturn3.symbols));
            testCase.verifyEqual(symbObj4.durations, expectedReturn4.durations);
            testCase.verifyEqual(symbObj4.symbols, expectedReturn4.symbols);
            testCase.verifyEqual(categories(symbObj4.symbols), categories(expectedReturn4.symbols));
            testCase.verifyEqual(symbObj5.durations, expectedReturn5.durations);
            testCase.verifyEqual(symbObj5.symbols, expectedReturn5.symbols);
            testCase.verifyEqual(categories(symbObj5.symbols), categories(expectedReturn5.symbols));
            testCase.verifyEqual(symbObj6.durations, expectedReturn6.durations);
            testCase.verifyEqual(symbObj6.symbols, expectedReturn6.symbols);
            testCase.verifyEqual(categories(symbObj6.symbols), categories(expectedReturn6.symbols));
            
            testCase.verifyError(@()symbObj1.mergeSequence(symbSequence1, 'newSymbol', 1), 'MATLAB:InputParser:ArgumentFailedValidation');
            
        end        
        
        function testFindSymbol(testCase)
            
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
        
        function testFindSymbolVec(testCase)
            
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
        
        function testRenameSymbol(testCase)
            
            durations1 = [1; 1; 3; 1; 2; 1; 2; 3; 4];
            symbols1 = categorical({'a', 'b', 'c', 'b', 'a', 'c', 'b', 'c', 'b'})';
            durations2 = [1; 3; 1; 2; 1; 3; 4; 1; 2];
            symbols2 = categorical({'x', 'y', 'z', 'y', 'z', 'x', 'y', 'x', 'z'})';
            
            symbSequence1 = {'c', 'b'};
            symbSequence2 = {'x', 'y'};
            
            expectedReturn1.symbols = categorical({'Word2', 'b', 'Word1', 'Word2', 'Word1'}, {'Word2', 'b', 'Word1'})';
            expectedReturn1.durations = [1; 1; 4; 2; 10];
            expectedReturn2.symbols = categorical({'Word1', 'Word2', 'y', 'Word2', 'Word1', 'x', 'Word2'}, {'x', 'y', 'Word2', 'Word1'})';
            expectedReturn2.durations = [4; 1; 2; 1; 7; 1; 2];
            
            symbObj1 = SymbRepObject(durations1, symbols1);
            symbObj2 = SymbRepObject(durations2, symbols2);
            
            symbObj1 = symbObj1.mergeSequence(symbSequence1);
            symbObj2 = symbObj2.mergeSequence(symbSequence2);
            
            symbObj1 = symbObj1.renameSymbol('[{c}{b}]', 'Word1');
            symbObj1 = symbObj1.renameSymbol('a', 'Word2');
            symbObj2 = symbObj2.renameSymbol('[{x}{y}]', 'Word1');
            symbObj2 = symbObj2.renameSymbol('z', 'Word2');
            
            testCase.verifyEqual(symbObj1.durations, expectedReturn1.durations);
            testCase.verifyEqual(symbObj1.symbols, expectedReturn1.symbols);
            testCase.verifyEqual(categories(symbObj1.symbols), categories(expectedReturn1.symbols));
            testCase.verifyEqual(symbObj2.durations, expectedReturn2.durations);
            testCase.verifyEqual(symbObj2.symbols, expectedReturn2.symbols);
            testCase.verifyEqual(categories(symbObj2.symbols), categories(expectedReturn2.symbols));
            
            testCase.verifyError(@()symbObj2.renameSymbol(123, 'Word3'), 'renameSymbol:InvalidInputs');
            testCase.verifyError(@()symbObj1.renameSymbol('b', 123), 'renameSymbol:InvalidInputs');
            
        end
        
        function testMergeCats(testCase)
            
            durations1 = [1; 1; 3; 1; 2; 1; 2; 3; 4];
            symbols1 = categorical({'a', 'b', 'c', 'b', 'a', 'c', 'b', 'c', 'b'})';
            
            symbSequence1 = {'c', 'b'};
            
            expectedReturn1.symbols = categorical({'a','b', 'Word1', '[{c}{b}]'}, {'a', 'b', '[{c}{b}]',  'Word1'})';
            expectedReturn1.durations = [1; 1; 6; 10];
            
            symbObj1 = SymbRepObject(durations1, symbols1);
            
            symbObj1 = symbObj1.mergeSequence(symbSequence1);
            
            symbObj1 = symbObj1.mergeSymbols({'[{c}{b}]', 'a'}, 'Word1');
            
            testCase.verifyEqual(symbObj1.durations, expectedReturn1.durations);
            testCase.verifyEqual(symbObj1.symbols, expectedReturn1.symbols);
            testCase.verifyEqual(categories(symbObj1.symbols), categories(expectedReturn1.symbols));
            
            testCase.verifyError(@()symbObj1.mergeSymbols('b', 123), 'mergeSymbols:InvalidInputs');
            testCase.verifyError(@()symbObj1.mergeSymbols(123, 'Word3'), 'mergeSymbols:InvalidInputs');
            
        end
        
        function testSetSymbolsInRange(testCase)
            
            durations1 = [1; 1; 3; 1; 2; 1; 1; 2; 3; 4];
            symbols1 = categorical({'a', 'b', 'c', 'b', 'a', 'c', 'a', 'b', 'c', 'b'})';
            
            newSymbol1 = 'd';
            range1 = [3, 5];
            
            newSymbol2 = 'e';
            range2 = [14, 15];
            
            newSymbol3 = 'f';
            range3 = [7, 11];
            
            expectedReturn1.symbols = categorical({'a', 'b', 'd', 'b', 'a', 'c', 'a', 'b', 'c', 'b'})';
            expectedReturn1.durations = [1; 1; 3; 1; 2; 1; 1; 2; 3; 4];
            
            expectedReturn2.symbols = categorical({'a', 'b', 'd', 'b', 'a', 'c', 'a', 'b', 'c', 'e', 'b'})';
            expectedReturn2.durations = [1; 1; 3; 1; 2; 1; 1; 2; 1; 2; 4];
            
            expectedReturn3.symbols = categorical({'a', 'b', 'd', 'b', 'f', 'b', 'c', 'e', 'b'})';
            expectedReturn3.durations = [1; 1; 3; 1; 5; 1; 1; 2; 4];
            
            symbObj1 = SymbRepObject(durations1, symbols1);
            
            symbObj1 = symbObj1.setSymbolsInRange(newSymbol1, range1);
            symbObj2 = symbObj1.setSymbolsInRange(newSymbol2, range2);
            symbObj3 = symbObj2.setSymbolsInRange(newSymbol3, range3);
            
            testCase.verifyEqual(symbObj1.symbols, expectedReturn1.symbols);
            testCase.verifyEqual(symbObj1.durations, expectedReturn1.durations);
            testCase.verifyEqual(symbObj2.symbols, expectedReturn2.symbols);
            testCase.verifyEqual(symbObj2.durations, expectedReturn2.durations);
            testCase.verifyEqual(symbObj3.symbols, expectedReturn3.symbols);
            testCase.verifyEqual(symbObj3.durations, expectedReturn3.durations);
            
        end
        
        function testRemoveShortSymbols(testCase)
            
            durations1 = [1; 1; 3; 1; 2; 1; 1; 2; 3; 4];
            symbols1 = categorical({'a', 'b', 'c', 'b', 'a', 'c', 'a', 'b', 'c', 'b'})';
            durations2 = [1; 3; 1; 2; 1; 3; 4; 1; 2];
            symbols2 = categorical({'x', 'y', 'z', 'y', 'z', 'x', 'y', 'x', 'z'})';
            durations3 = [1; 1; 3; 1; 1; 1; 1; 2; 3; 4];
            symbols3 = categorical({'a', 'b', 'c', 'b', 'a', 'c', 'a', 'b', 'c', 'b'})';
            durations4 = [15; 7; 15; 45; 7; 15; 15; 7; 45; 15];
            symbols4 = categorical({'a', 'b', 'c', 'b', 'a', 'c', 'a', 'b', 'c', 'b'})';
            durations5 = [4; 3; 4; 2; 2; 12; 2; 1; 2; 6];
            symbols5 = categorical({'a', 'b', 'c', 'd', 'e', 'f', 'g', 'h', 'i', 'j'}, {'a', 'b', 'c', 'd', 'e', 'f', 'g', 'h', 'i', 'j'})';
            durations6 = [10; 15; 20; 12];
            symbols6 = categorical({'a', 'b', 'c', 'd'}, {'a', 'b', 'c', 'd'})';
            
            shortSymbolLength1 = 1;
            shortSymbolLength4 = 7;
            shortSymbolLength5 = 3;
            shortSymbolLength6 = 5;
            maxNumberShortSymbols1 = 5;
            maxNumberShortSymbols2 = 2;
            maxNumberShortSymbols4 = 100;
            maxNumberShortSymbols5 = 4;
            maxShortSymbolSequenceLength5 = 4;
            
            expectedReturn1.symbols = categorical({'c', 'a', 'b', 'c', 'b'})';
            expectedReturn1.durations = [6; 3; 3; 3; 4];
            expectedReturn2.symbols = categorical({'y', 'x', 'y', 'z'})';
            expectedReturn2.durations = [8; 3; 5; 2];
            expectedReturn3.symbols = categorical({'c', 'NotDefined', 'b', 'c', 'b'}, {'b', 'c'})';
            expectedReturn3.durations = [5; 4; 2; 3; 4];
            expectedReturn4.symbols = categorical({'a', 'c', 'b', 'c', 'a', 'c', 'b'}, {'a', 'b', 'c'})';
            expectedReturn4.durations = [19; 18; 50; 17; 17; 50; 15];
            expectedReturn5.symbols = categorical({'a', 'c', 'f', 'NotDefined', 'j'}, {'a', 'c', 'f', 'j'})';
            expectedReturn5.durations = [6; 6; 15; 5; 6];
            expectedReturn6.symbols = categorical({'a', 'b', 'c', 'd'}, {'a', 'b', 'c', 'd'})';
            expectedReturn6.durations = [10; 15; 20; 12];
            
            symbObj1 = SymbRepObject(durations1, symbols1);
            symbObj2 = SymbRepObject(durations2, symbols2);
            symbObj3 = SymbRepObject(durations3, symbols3);
            symbObj4 = SymbRepObject(durations4, symbols4);
            symbObj5 = SymbRepObject(durations5, symbols5);
            symbObj6 = SymbRepObject(durations6, symbols6);
            
            symbObj1 = symbObj1.removeShortSymbols('shortSymbolLength', shortSymbolLength1, 'maxNumberShortSymbols', maxNumberShortSymbols1);
            symbObj2 = symbObj2.removeShortSymbols('shortSymbolLength', shortSymbolLength1, 'maxNumberShortSymbols', maxNumberShortSymbols1);
            symbObj3 = symbObj3.removeShortSymbols('shortSymbolLength', shortSymbolLength1, 'maxNumberShortSymbols', maxNumberShortSymbols2);
            symbObj4 = symbObj4.removeShortSymbols('shortSymbolLength', shortSymbolLength4, 'maxNumberShortSymbols', maxNumberShortSymbols4, 'SplittingMode', 'weighted');
            symbObj5 = symbObj5.removeShortSymbols('shortSymbolLength', shortSymbolLength5, 'maxNumberShortSymbols', maxNumberShortSymbols5, 'maxShortSymbolSequenceLength', maxShortSymbolSequenceLength5, 'SplittingMode', 'weighted');
            symbObj6 = symbObj6.removeShortSymbols('shortSymbolLength', shortSymbolLength6);
            
            testCase.verifyEqual(symbObj1.symbols, expectedReturn1.symbols);
            testCase.verifyEqual(symbObj1.durations, expectedReturn1.durations);
            testCase.verifyEqual(symbObj2.symbols, expectedReturn2.symbols);
            testCase.verifyEqual(symbObj2.durations, expectedReturn2.durations);
            testCase.verifyEqual(symbObj3.symbols, expectedReturn3.symbols);
            testCase.verifyEqual(symbObj3.durations, expectedReturn3.durations);
            testCase.verifyEqual(symbObj4.symbols, expectedReturn4.symbols);
            testCase.verifyEqual(symbObj4.durations, expectedReturn4.durations);
            testCase.verifyEqual(symbObj5.symbols, expectedReturn5.symbols);
            testCase.verifyEqual(symbObj5.durations, expectedReturn5.durations);
            testCase.verifyEqual(symbObj6.symbols, expectedReturn6.symbols);
            testCase.verifyEqual(symbObj6.durations, expectedReturn6.durations);
            
        end
        
        function testGenSymbMarkov(testCase)
            
            durations1 = [1; 1; 3; 1; 2; 1; 1; 2; 3; 4];
            symbols1 = categorical({'a', 'b', 'c', 'b', 'a', 'c', 'a', 'b', 'c', 'b'})';
            durations2 = [1; 3; 1; 2; 1; 3; 4; 1; 2];
            symbols2 = categorical({'x', 'y', 'z', 'y', 'z', 'x', 'y', 'x', 'z'})';
            
            %             expectedReturn1a = [  0, 1/3, 1/3;
            %                                 2/3,   0, 2/3;
            %                                 1/3, 2/3,   0];
            %             expectedReturn2a = [  0, 1/3, 1/2;
            %                                 2/3,   0, 1/2;
            %                                 1/3, 2/3,   0];
            expectedReturn1b = [0, 1, 1;
                2, 0, 2;
                1, 2, 0];
            expectedReturn2b = [0, 1, 1;
                2, 0, 1;
                1, 2, 0];
            
            symbObj1 = SymbRepObject(durations1, symbols1);
            symbObj2 = SymbRepObject(durations2, symbols2);
            
            %output1a = symbObj1.genSymbMarkov;
            %output2a = symbObj2.genSymbMarkov;
            output1b = symbObj1.genSymbMarkov('Absolute', true);
            output2b = symbObj2.genSymbMarkov('Absolute', true);
            
            %testCase.verifyEqual(output1a, expectedReturn1a);
            %testCase.verifyEqual(output2a, expectedReturn2a);
            testCase.verifyEqual(output1b, expectedReturn1b);
            testCase.verifyEqual(output2b, expectedReturn2b);
            
        end
        
        function testGenTrigramMatrix(testCase)
            
            durations1 = [1; 1; 3; 1; 2; 1; 1; 2; 3; 4];
            symbols1 = categorical({'a', 'b', 'c', 'b', 'a', 'c', 'a', 'b', 'c', 'b'})';
            durations2 = [1; 3; 1; 2; 1; 3; 4; 1; 2];
            symbols2 = categorical({'x', 'y', 'z', 'y', 'z', 'x', 'y', 'x', 'z'})';
            
            expectedReturn1 = zeros(3, 3, 3);
            expectedReturn1(1, 2, 3) = 2;
            expectedReturn1(2, 3, 2) = 2;
            expectedReturn1(3, 2, 1) = 1;
            expectedReturn1(2, 1, 3) = 1;
            expectedReturn1(1, 3, 1) = 1;
            expectedReturn1(3, 1, 2) = 1;
            
            expectedReturn2 = zeros(3, 3, 3);
            expectedReturn2(1, 2, 3) = 1;
            expectedReturn2(2, 3, 2) = 1;
            expectedReturn2(3, 2, 3) = 1;
            expectedReturn2(2, 3, 1) = 1;
            expectedReturn2(3, 1, 2) = 1;
            expectedReturn2(1, 2, 1) = 1;
            expectedReturn2(2, 1, 3) = 1;
            
            symbObj1 = SymbRepObject(durations1, symbols1);
            symbObj2 = SymbRepObject(durations2, symbols2);
            
            output1 = symbObj1.genTrigramMatrix;
            output2 = symbObj2.genTrigramMatrix;
            
            testCase.verifyEqual(output1, expectedReturn1);
            testCase.verifyEqual(output2, expectedReturn2);
            
        end
        
        function testGetTimeInterval(testCase)
            
            durations1 = [10];
            symbols1 = categorical({'a'})';
            durations2 = [10; 8];
            symbols2 = categorical({'a', 'b'})';
            durations3 = [10; 8; 5];
            symbols3 = categorical({'a', 'b', 'c'})';
            
            intervalIndices1 = [3, 7];
            intervalIndices2 = [7, 14];
            intervalIndices3a = [7, 19];
            intervalIndices3b = [11, 19];
            
            expectedReturn1.durations = [5];
            expectedReturn1.symbols = categorical({'a'})';
            expectedReturn2.durations = [4; 4];
            expectedReturn2.symbols = categorical({'a', 'b'})';
            expectedReturn3a.durations = [4; 8; 1];
            expectedReturn3a.symbols = categorical({'a', 'b', 'c'})';
            expectedReturn3b.durations = [8; 1];
            expectedReturn3b.symbols = categorical({'b', 'c'})';
            
            symbObj1 = SymbRepObject(durations1, symbols1);
            symbObj2 = SymbRepObject(durations2, symbols2);
            symbObj3 = SymbRepObject(durations3, symbols3);
            
            output1 = symbObj1.getTimeInterval(intervalIndices1);
            output2 = symbObj2.getTimeInterval(intervalIndices2);
            output3a = symbObj3.getTimeInterval(intervalIndices3a);
            output3b = symbObj3.getTimeInterval(intervalIndices3b);
            
            testCase.verifyEqual(output1.durations, expectedReturn1.durations);
            testCase.verifyEqual(output1.symbols, expectedReturn1.symbols);
            testCase.verifyEqual(output2.durations, expectedReturn2.durations);
            testCase.verifyEqual(output2.symbols, expectedReturn2.symbols);
            testCase.verifyEqual(output3a.durations, expectedReturn3a.durations);
            testCase.verifyEqual(output3a.symbols, expectedReturn3a.symbols);
            testCase.verifyEqual(output3b.durations, expectedReturn3b.durations);
            testCase.verifyEqual(output3b.symbols, expectedReturn3b.symbols);
            
        end
        
        function testgetstartind(testCase)
            t = SymbRepObject([1,2,3,4,5,1,4,3,2,1,5], categorical({'a','c','b','a','c','a', 'b','a','c','a','e'}));
            nSyms = length(t.symbols);
            nRand = randi(nSyms);
            cuSum = cumsum(t.durations);
            % one index
            inds = t.getStartInd(nRand);
            
            
            testCase.verifyEqual(inds, cuSum(nRand)-t.durations(nRand) + 1);
            
            % more indices
            nRep = 4;
            nRand2 = randi(nSyms, 1,nRep);
            inds2 = t.getStartInd(nRand2);
            for i=1:nRep
                out2(i) = cuSum(nRand2(i))-t.durations(nRand2(i)) + 1;
            end
            testCase.verifyEqual(inds2, out2);
        end
        function testfindSequence(testCase)
            
            t = SymbRepObject([1,2,3,4,5,1,4,3,2,1,5]', categorical({'a','c','b','a','c','a', 'b','a','c','a','e'})');
            
            % test empty
            [a,b] = t.findSequence({'b','e'});
            
            testCase.verifyEmpty(a);
            testCase.verifyEmpty(b);
            
            
            % test empty non given symbol
            [a,b] = t.findSequence({'x'});
            testCase.verifyEmpty( a);
            testCase.verifyEmpty( b);
            
            % test single symbol
            
            [a,b] = t.findSequence({'a'});
            [a1,b1] = t.findSymbol('a');
            testCase.verifyEqual(a, a1);
            testCase.verifyEqual(b, b1);
            
            % test multiple symbols
            [a,b] = t.findSequence({'a','c','a'});
            testCase.verifyEqual(a, [7;21]);
            testCase.verifyEqual(b, [10;6]);
            
        end
        
        function testPropertyRepetitions(testCase)
            lenghtVec = randi(20, 11,1);
            %lengthVec = [1,2,3,4,5,1,4,3,2,1,5]';
            symsVec = categorical({'a','c','b','a','c','a', 'b','a','c','a','e'})';
            
            t = SymbRepObject(lenghtVec, symsVec);
            testCase.verifyEqual(t.repetitions, lenghtVec);
        end
        
        function testPropertyRepetitionsMerge(testCase)
            sym1 = 'a';
            sym2 = 'b';
            symFill = 'x';
            lenghtrange= 100;
            symsVec={};
            lengthVec = [];
            randRepVec = [];
            for i =1:randi(20)
                
                randRep = randi(lenghtrange);
                for j=1:randRep
                    
                    randi1 = randi(20)+1;
                    randi2 = randi(20)+1;
                    symsVec = [symsVec, {sym1, sym2}];
                    lengthVec = [lengthVec, randi1, randi2];
                end
                randRepVec = [randRepVec, randRep];
                
                randiFill = randi(20);
                symsVec = [symsVec, {symFill}];
                lengthVec = [lengthVec, randiFill];
                randRepVec = [randRepVec, randiFill];
            end
            
            symsVecIn = categorical(symsVec)';
            
            t = SymbRepObject(lengthVec', symsVecIn);
            testCase.verifyEqual(t.repetitions, lengthVec');

            t2 = t.mergeSequence({sym1, sym2});
            testCase.verifyEqual(t2.repetitions, randRepVec');
            
            t1 = t.mergeSymbols({sym1, sym2}, [sym1, sym2]);
            testCase.verifyEqual(t1.repetitions, randRepVec');
        end
        
        function testRepetitionsWithOverlapping(testCase)
            sym1 = 'a';
            sym2 = 'b';
            nReps = randi(30)+2;
            symsVec={};
            lengthVec = [];
            for i = 1:nReps
                 randi1 = randi(20)+1;
                 randi2 = randi(20)+1;
                 symsVec = [symsVec, {sym1, sym2}];
                 lengthVec = [lengthVec, randi1, randi2];
            end
            
            symsVecIn = categorical(symsVec)';
            
            t = SymbRepObject(lengthVec', symsVecIn);
            t = t.mergeSequence({sym1, sym2, sym1}, 'bAllowOverlapping', true);
            testCase.verifyEqual(t.repetitions, [nReps-1, randi2]');
        end
        
        function testRepetitionsWithOverlapping2(testCase)
            symsVec={'a', 'b', 'c', 'a', 'b', 'c', 'a'};
            lengthVec = randi(20, 1, numel(symsVec))+1;

            
            symsVecIn = categorical(symsVec)';
            
            t = SymbRepObject(lengthVec', symsVecIn);
            t = t.mergeSequence({'a', 'b', 'c', 'a'}, 'bAllowOverlapping', true);
            testCase.verifyEqual(t.repetitions, [2]');
        end
        
        function testWithoutCompresssion(testCase)
            symsVec={'a', 'b', 'c', 'a', 'a','b', 'c', 'a'};
            lengthVec = randi(20, 1, numel(symsVec))+1;

            
            symsVecIn = categorical(symsVec)';
            
            t = SymbRepObject(lengthVec', symsVecIn);
            t1 = t.mergeSequence({'a', 'b', 'c', 'a'}, 'bCompress', false);
            testCase.verifyEqual(t1.repetitions, [1, 1]');
            testCase.verifyEqual(t1.durations, [sum(lengthVec(1:4)), sum(lengthVec(5:8))]');
            
             testCase.verifyError(@()t.mergeSequence({'a', 'b', 'c', 'a'}, 'bCompress', false, 'bAllowOverlapping', true), 'mergeSymbols:bCompress');
             testCase.verifyError(@()t.mergeSymbols({'a', 'b', 'c', 'a'}, 'abca','bCompress', false, 'bAllowOverlapping', true), 'mergeSymbols:bCompress');
        end
        
        function testStartIndStopInd(testCase)
            symsVec={'a', 'b', 'c', 'a', 'a','b', 'c', 'a'};
             
            symsVecIn = categorical(symsVec)';
            lengthVec = [1,1,1,1,1,1,1,1];          
            t = SymbRepObject(lengthVec', symsVecIn);
            
            lengthVec2 = randi(20, 1, length(lengthVec));          
            t2 = SymbRepObject(lengthVec2', symsVecIn);
            
            testCase.verifyEqual(t.startInds, [cumsum(lengthVec) - lengthVec]' + 1);
            testCase.verifyEqual(t.stopInds, cumsum(lengthVec)');
%             temp1 =  cumsum(lengthVec2);
            testCase.verifyEqual(t2.startInds,[cumsum(lengthVec2) - lengthVec2]' + 1);
            testCase.verifyEqual(t2.stopInds, cumsum(lengthVec2)');
       
        end
        
    end
    
end


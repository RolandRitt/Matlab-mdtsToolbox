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
        
        function testMergeSequence(testCase)
            
            durations = [1; 1; 3; 1; 2; 1; 2; 3; 4];
            symbols = categorical({'a', 'b', 'c', 'b', 'a', 'c', 'b', 'c', 'b'})';
            
            symbSequence = {'c', 'b'};
            
            expectedReturn1.symbols = categorical({'a', 'b', 'cb', 'a', 'cb'})';
            expectedReturn1.durations = [1; 1; 4; 2; 10];
            
            symbObj1 = SymbRepObject(durations, symbols);   
            
            symbObj1 = symbObj1.mergeSequence(symbSequence);
            
            testCase.verifyEqual(symbObj1.durations, expectedReturn1.durations);
            testCase.verifyEqual(symbObj1.symbols, expectedReturn1.symbols);
            
        end
        
    end
    
end


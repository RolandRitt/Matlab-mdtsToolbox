classdef SymbRepObject_findSequence_TestClass < matlab.unittest.TestCase
    %
    % Description : Test the SymbRepObject-compressSymbols Method
    %
    % Author :
    %    Paul O'Leary
    %    Roland Ritt
    %    Thomas Grandl
    %
    % History :
    % \change{1.0}{24-Jul-2019}{Original}
    %
    % --------------------------------------------------
    % (c) 2018, Roland Ritt
    % Chair of Automation, University of Leoben, Austria
    % email: automation@unileoben.ac.at
    % url: automation.unileoben.ac.at
    % --------------------------------------------------
    %
    
    properties
        functionToTest
    end
    
    methods(TestMethodSetup)
        function setUpProperties(testCase)
        end
    end
    
    methods (Test)
        
        function testInputChecks(testCase)
        end
        
        function testFindSequence1(testCase)
            t = SymbRepObject([2,2,2,2,2,2,2,2]', categorical({'x','a','b','a','b','a', 'x','a'})');
            
            [startInds, durations, compressedStartInds, compressedStopInds] = t.findSequence({'a', 'b'});
            startInsRes = [3,7]';
            durationsRes = [4,4]';
            compressedStartIndsRes = [2, 4]';
            compressedStopIndsRes = [3,5]';
            
            testCase.verifyEqual(startInds, startInsRes);
            testCase.verifyEqual(durations, durationsRes);
            testCase.verifyEqual(compressedStartInds, compressedStartIndsRes);
            testCase.verifyEqual(compressedStopInds, compressedStopIndsRes);
            
        end
        
       function testfindSequence(testCase)
            t = SymbRepObject([2,2,2,2,2,2,2,2]', categorical({'x','a','b','a','b','a', 'x','a'})');
            
            [startInds, durations, compressedStartInds, compressedStopInds] = t.findSequence({'a', 'b', 'a'});
            startInsRes = [3,7]';
            durationsRes = [6,6]';
            compressedStartIndsRes = [2, 4]';
            compressedStopIndsRes = [4,6]';
            
            testCase.verifyEqual(startInds, startInsRes);
            testCase.verifyEqual(durations, durationsRes);
            testCase.verifyEqual(compressedStartInds, compressedStartIndsRes);
            testCase.verifyEqual(compressedStopInds, compressedStopIndsRes);
            
       end
        
       function testfindSequenceBraces(testCase)
            t = SymbRepObject([2,2,2,2,2,2,2,2]', categorical({'x','[{a}{b}]','b','a','b','a', 'x','a'})');
            
            [startInds, durations, compressedStartInds, compressedStopInds] = t.findSequence({'[{a}{b}]', 'b'});
            startInsRes = [3]';
            durationsRes = [4]';
            compressedStartIndsRes = [2]';
            compressedStopIndsRes = [3]';
            
            testCase.verifyEqual(startInds, startInsRes);
            testCase.verifyEqual(durations, durationsRes);
            testCase.verifyEqual(compressedStartInds, compressedStartIndsRes);
            testCase.verifyEqual(compressedStopInds, compressedStopIndsRes);
            
       end
        
           function testfindSequence2(testCase)
            
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
    end
    
end


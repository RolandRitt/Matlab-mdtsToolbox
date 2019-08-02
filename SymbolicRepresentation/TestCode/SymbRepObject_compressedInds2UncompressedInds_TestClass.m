classdef SymbRepObject_compressedInds2UncompressedInds_TestClass < matlab.unittest.TestCase
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
            syms = {'a', 'b','c','d','e','f'};
            nsyms = length(syms);
            symRep = {};
            durations = [];
            lengthSym = randi(30);
            for i=1:lengthSym
                randSym = randi(nsyms);
                symRep = [symRep, syms(randSym)];
                durations = [durations, randi(50)];
            end
            
            t = SymbRepObject(durations', categorical(symRep)');
            
            testInds = randi(lengthSym,1, randi(lengthSym));
            
            [staI,stoI] = t.compressedInds2UncompressedInds(testInds);
            testCase.verifyEqual(t.startInds(testInds), t.compressedInds2UncompressedInds(testInds));
            testCase.verifyEqual(t.startInds(testInds), staI);
            testCase.verifyEqual(t.stopInds(testInds), stoI);


        end

        
    end
    
end


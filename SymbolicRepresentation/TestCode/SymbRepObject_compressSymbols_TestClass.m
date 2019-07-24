classdef SymbRepObject_compressSymbols_TestClass < matlab.unittest.TestCase
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
    end
    
    methods (Test)
        function testInputChecks(testCase)
            lenghtVec = randi(20, 11,1);
            %lengthVec = [1,2,3,4,5,1,4,3,2,1,5]';
            symsVec = categorical({'a','c','b','a','c','a', 'b','a','c','a','e'})';
            
            t = SymbRepObject(lenghtVec, symsVec);
            
            tRes1 = t.compressSymbols; %without input should not throw an error
            tRes1 = t.compressSymbols('a'); %should work
            tRes1 = t.compressSymbols({'a'}); %should work
            tRes1 = t.compressSymbols({'a', 'b'}); %should work
            tRes1 = t.compressSymbols({'a'; 'b'}); %should work
            tRes1 = t.compressSymbols({'a'; 'b'; 'c'}); %should work
            
            
            testCase.verifyError(@()t.compressSymbols('a', 'b'), 'MATLAB:TooManyInputs');
            testCase.verifyError(@()t.compressSymbols([1,3]), 'SymbRepObject:compressSymbols:listOfSymbolsToCheck:wrongType');
            testCase.verifyError(@()t.compressSymbols({1,3}), 'SymbRepObject:compressSymbols:listOfSymbolsToCheck:wrongType');
            testCase.verifyError(@()t.compressSymbols({'a', 'b'; 'c', 'a'}), 'SymbRepObject:compressSymbols:listOfSymbolsToCheck:wrongSize');
            
        end
        function testCompression(testCase)
            symsVec = categorical({'a','a','a','b','b','a', 'a','c','c','c','a'})';
            lenghtVec = randi(20, 11,1);
            lengthVecRes1 = [sum(lenghtVec(1:3)), sum(lenghtVec(4:5)), sum(lenghtVec(6:7)),  sum(lenghtVec(8:10)), lenghtVec(11)];
            symsVecRes1 =  categorical({'a','b','a','c','a'})';
            
            lengthVecRes_a = [sum(lenghtVec(1:3)); lenghtVec(4:5);; sum(lenghtVec(6:7));  lenghtVec(8:10); lenghtVec(11)];
            symsVecRes_a =  categorical({'a','b','b','a','c','c','c','a'})';
            
            lengthVecRes_b = [lenghtVec(1:3); sum(lenghtVec(4:5)); lenghtVec(6:11)];
            symsVecRes_b =  categorical({'a','a','a','b','a', 'a','c','c','c','a'})';
            
            lengthVecRes_c = [lenghtVec(1:7);  sum(lenghtVec(8:10)); lenghtVec(11)];
            symsVecRes_c =  categorical({'a','a','a','b','b','a', 'a','c','a'})';
            
            lengthVecRes_ac = [sum(lenghtVec(1:3)); lenghtVec(4:5); sum(lenghtVec(6:7));  sum(lenghtVec(8:10)); lenghtVec(11)];
            symsVecRes_ac =  categorical({'a','b','b','a','c','a'})';
            
            t = SymbRepObject(lenghtVec', symsVec');
            tRes1 = t.compressSymbols;
            tRes_a = t.compressSymbols('a');
            tRes_a1 = t.compressSymbols({'a'});
            tRes_b = t.compressSymbols('b');
            tRes_b1 = t.compressSymbols({'b'});
            tRes_c = t.compressSymbols('c');
            tRes_c1 = t.compressSymbols({'c'});
            tRes_ac = t.compressSymbols({'c', 'a'});
            tRes_ac1 = t.compressSymbols({'a', 'c'});
            
            tRes1Real = SymbRepObject(lengthVecRes1, symsVecRes1');
            tRes1Rea_a = SymbRepObject(lengthVecRes_a', symsVecRes_a');
            tRes1Rea_b = SymbRepObject(lengthVecRes_b', symsVecRes_b');
            tRes1Rea_c = SymbRepObject(lengthVecRes_c', symsVecRes_c');
            tRes1Rea_ac = SymbRepObject(lengthVecRes_ac', symsVecRes_ac');
%             tRes1Rea_a = SymbRepObject(lengthVecRes_a', symsVecRes_a');
            
            testCase.verifyEqual(tRes1, tRes1Real);
            testCase.verifyEqual(tRes_a, tRes1Rea_a);
            testCase.verifyEqual(tRes_a1, tRes1Rea_a);
            testCase.verifyEqual(tRes_b, tRes1Rea_b);
            testCase.verifyEqual(tRes_b1, tRes1Rea_b);
            testCase.verifyEqual(tRes_c, tRes1Rea_c);
            testCase.verifyEqual(tRes_c1, tRes1Rea_c);
            testCase.verifyEqual(tRes_ac, tRes1Rea_ac);
            testCase.verifyEqual(tRes_ac1, tRes1Rea_ac);
        end
        
%         function testPropertyRepetitionsMerge(testCase)
%             sym1 = 'a';
%             sym2 = 'b';
%             symFill = 'x';
%             lenghtrange= 100;
%             symsVec={};
%             lengthVec = [];
%             randRepVec = [];
%             for i =1:randi(20)
%                 
%                 randRep = randi(lenghtrange);
%                 for j=1:randRep
%                 
%                 randi1 = randi(20)+1;
%                 randi2 = randi(20)+1;
%                 symsVec = [symsVec, {sym1, sym2}];
%                 lengthVec = [lengthVec, randi1, randi2];
%                 end
%                 randRepVec = [randRepVec, randRep];
%                     
%                 randiFill = randi(20);
%                 symsVec = [symsVec, {symFill}];
%                 lengthVec = [lengthVec, randiFill];
%                 randRepVec = [randRepVec, randiFill];
%             end
% 
%             symsVecIn = categorical(symsVec)';
%             
%             t = SymbRepObject(lengthVec, symsVecIn);
%             testCase.verifyEqual(t.repetitions, lengthVec);
%             t1 = t.mergeSymbols({sym1, sym2}, [sym1, sym2]);
%             testCase.verifyEqual(t1.repetitions, randRepVec);
%             t2 = t.mergeSequence({sym1, sym2});
%             testCase.verifyEqual(t2.repetitions, randRepVec);
%         end
        
    end
    
end


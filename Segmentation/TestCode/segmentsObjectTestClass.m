classdef segmentsObjectTestClass < matlab.unittest.TestCase
    %
    % Description : Test the segmentsObject
    %
    % Author :
    %    Paul O'Leary
    %    Roland Ritt
    %    Thomas Grandl
    %
    % History :
    % \change{1.0}{09-May-2018}{Original}
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
            
            expectedReturn1.nTimestamps = 100;
            
            expectedReturn1.tags = {};
            expectedReturn1.starts = {};
            expectedReturn1.durations = {};
            
            segObj1 = segmentsObject(expectedReturn1.nTimestamps);
            
            testCase.verifyEqual(segObj1.nTimestamps, expectedReturn1.nTimestamps);
            testCase.verifyEqual(segObj1.tags, expectedReturn1.tags);
            testCase.verifyEqual(segObj1.starts, expectedReturn1.starts);
            testCase.verifyEqual(segObj1.durations, expectedReturn1.durations);
            
            testCase.verifyError(@()segmentsObject('test1'), 'segmentsObject:InvalidInputnTimestamps');
            
        end
        
        function testAddSegmentVector(testCase)
            
            nTimestamps = 100;
            
            segObj1 = segmentsObject(nTimestamps);
            
            tagName1 = 'newChannel';
            bVec1 = false(nTimestamps, 1);
            bVec1(20 : 30) = true;
            bVec1(50 : 55) = true;
            bVec1(60 : 60) = true;
            bVec1(98 : 100) = true;
            
            tagName2 = 'secondChannel';
            bVec2 = false(nTimestamps, 1);
            bVec2(1 : 30) = true;
            bVec2(70 : 90) = true;
            
            tagName3 = 'emptyChannel';
            bVec3 = false(nTimestamps, 1);
            
            segObj1 = segObj1.addSegmentVector(tagName1, bVec1);
            segObj1 = segObj1.addSegmentVector(tagName2, bVec2);
            segObj1 = segObj1.addSegmentVector(tagName3, bVec3);
            
            expectedReturn1.nTimestamps = nTimestamps;
            expectedReturn1.tags = {tagName1, tagName2, tagName3};
            expectedReturn1.starts = {[20; 50; 60; 98], [1; 70], zeros(0, 1)};
            expectedReturn1.durations = {[11; 6; 1; 3], [30; 21], zeros(1, 0)};
            
            testCase.verifyEqual(segObj1.nTimestamps, expectedReturn1.nTimestamps);
            testCase.verifyEqual(segObj1.tags, expectedReturn1.tags);
            testCase.verifyEqual(segObj1.starts, expectedReturn1.starts);
            testCase.verifyEqual(segObj1.durations, expectedReturn1.durations);
            
            testCase.verifyError(@()segObj1.addSegmentVector(5, bVec1), 'addSegmentVector:InvalidInputtagName');
            testCase.verifyError(@()segObj1.addSegmentVector(tagName2, 123), 'addSegmentVector:InvalidInputbVec');
            
        end
        
        function testGetLogicalVector(testCase)
            
            nTimestamps = 100;
            
            tagName1 = 'newChannel';
            bVec1 = false(nTimestamps, 1);
            bVec1(20 : 30) = true;
            bVec1(50 : 55) = true;
            bVec1(60 : 60) = true;
            bVec1(98 : 100) = true;
            
            tagName2 = 'secondChannel';
            bVec2 = false(nTimestamps, 1);
            bVec2(1 : 30) = true;
            bVec2(70 : 90) = true;
            
            segObj1 = segmentsObject(nTimestamps);
            segObj1 = segObj1.addSegmentVector(tagName1, bVec1);
            segObj1 = segObj1.addSegmentVector(tagName2, bVec2);
            
            expectedReturn1.nTimestamps = nTimestamps;
            expectedReturn1.bVec = bVec1;
            expectedReturn2.bVec = bVec2;
            
            testCase.verifyEqual(segObj1.nTimestamps, expectedReturn1.nTimestamps);
            testCase.verifyEqual(segObj1.getLogicalVector(tagName1), expectedReturn1.bVec);
            testCase.verifyEqual(segObj1.getLogicalVector(tagName2), expectedReturn2.bVec);
            
            testCase.verifyError(@()segObj1.getLogicalVector(123), 'getLogicalVector:InvalidInputtagName');
            
        end
        
        function testGetLabeledVector(testCase)
            
            nTimestamps = 100;
            
            tagName1 = 'newChannel';
            bVec1 = false(nTimestamps, 1);
            bVec1(20 : 30) = true;
            bVec1(50 : 55) = true;
            bVec1(60 : 60) = true;
            bVec1(98 : 100) = true;
            
            lVec1 = zeros(nTimestamps, 1);
            lVec1(20 : 30) = 1;
            lVec1(50 : 55) = 2;
            lVec1(60 : 60) = 3;
            lVec1(98 : 100) = 4;
            
            segObj1 = segmentsObject(nTimestamps);
            segObj1 = segObj1.addSegmentVector(tagName1, bVec1);
            
            expectedReturn1.lVec = lVec1;
            
            testCase.verifyEqual(segObj1.getLabeledVector(tagName1), expectedReturn1.lVec);
            
            testCase.verifyError(@()segObj1.getLabeledVector(123), 'getLabeledVector:InvalidInputtagName');
            
        end
        
        function testExtractRows(testCase)
            
            nTimestamps = 100;
            
            tagName1 = 'newChannel';
            bVec1 = false(nTimestamps, 1);
            bVec1(20 : 30) = true;
            bVec1(50 : 55) = true;
            bVec1(60 : 60) = true;
            bVec1(98 : 100) = true;
            
            tagName2 = 'secondChannel';
            bVec2 = false(nTimestamps, 1);
            bVec2(1 : 30) = true;
            bVec2(70 : 90) = true;
            
            intervalInd1 = [10, 25];
            intervalInd2 = [58, 75];
            
            segObj1 = segmentsObject(nTimestamps);
            segObj1 = segObj1.addSegmentVector(tagName1, bVec1);
            segObj1 = segObj1.addSegmentVector(tagName2, bVec2);
            segObj2 = segObj1.extractRows(intervalInd1);
            segObj3 = segObj1.extractRows(intervalInd2);
            
            expectedReturn1.nTimestamps = nTimestamps;
            expectedReturn1.tags = {tagName1, tagName2};
            expectedReturn1.bVecs = {bVec1(intervalInd1(1) : intervalInd1(2)), bVec2(intervalInd1(1) : intervalInd1(2))};
            
            expectedReturn2.nTimestamps = nTimestamps;
            expectedReturn2.tags = {tagName1, tagName2};
            expectedReturn2.bVecs = {bVec1(intervalInd2(1) : intervalInd2(2)), bVec2(intervalInd2(1) : intervalInd2(2))};
            
            testCase.verifyEqual(segObj2.tags, expectedReturn1.tags);
            testCase.verifyEqual(segObj2.getLogicalVector(tagName1), expectedReturn1.bVecs{1});
            testCase.verifyEqual(segObj2.getLogicalVector(tagName2), expectedReturn1.bVecs{2});
            
            testCase.verifyEqual(segObj3.tags, expectedReturn2.tags);
            testCase.verifyEqual(segObj3.getLogicalVector(tagName1), expectedReturn2.bVecs{1});
            testCase.verifyEqual(segObj3.getLogicalVector(tagName2), expectedReturn2.bVecs{2});
            
            testCase.verifyError(@()segObj1.extractRows('test123'), 'extractRows:InvalidInputintervalIndices');
            testCase.verifyError(@()segObj1.extractRows([1; 2; 3]), 'extractRows:InvalidInputintervalIndices');
            
        end
        
        function testgetstopInds(testCase)
            
            nTimestamps = 100;
            
            segObj1 = segmentsObject(nTimestamps);
            
            tagName1 = 'newChannel';
            bVec1 = false(nTimestamps, 1);
            bVec1(20 : 30) = true;
            bVec1(50 : 55) = true;
            bVec1(60 : 60) = true;
            bVec1(98 : 100) = true;
            
            tagName2 = 'secondChannel';
            bVec2 = false(nTimestamps, 1);
            bVec2(1 : 30) = true;
            bVec2(70 : 90) = true;
            
            segObj1 = segmentsObject(nTimestamps);
            segObj1 = segObj1.addSegmentVector(tagName1, bVec1);
            segObj1 = segObj1.addSegmentVector(tagName2, bVec2);
            
            testCase.verifyEqual(segObj1.stopInds, {[30,55,60,100]', [30, 90]'});
            testCase.verifyEqual(segObj1.startInds, {[20,50,60,98]', [1, 70]'});
            
        end
        
    end
end


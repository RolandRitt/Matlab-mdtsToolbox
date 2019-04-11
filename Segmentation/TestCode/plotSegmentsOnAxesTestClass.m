classdef plotSegmentsOnAxesTestClass < matlab.unittest.TestCase
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
        D;
        x;
        xdT;
        tags;
        segs;
        segs2;
    end
    
    methods(TestMethodSetup)
        function createFigure(testCase)
            % comment
            n = 1000;
            testCase.x = linspace(0,2*pi, n)';
            testCase.xdT = linspace(datetime(2018,09,11), datetime(2018,09,12), n );
            testCase.D(:,1) = cos(testCase.x);
            testCase.D(:,2) = sin(testCase.x);
            testCase.D(:,3) = tan(testCase.x);
            testCase.tags = {'cos', 'sin', 'tan'};
            segs = segmentsObject(n);
            segs = segs.addSegmentVector('cosPos', logical(testCase.D(:,1)>0.3));
            segs = segs.addSegmentVector('cosNeg', logical(testCase.D(:,1)<-0.3));
            testCase.segs = segs;
            
            segs2 = segmentsObject(n);
            segs2 = segs2.addSegmentVector('sinPos', logical(testCase.D(:,2)>0.3));
            segs2 = segs2.addSegmentVector('sinNeg', logical(testCase.D(:,2)<-0.3));
            segs2 = segs2.addSegmentVector('sinBetween', logical((testCase.D(:,2)>-0.2)&(testCase.D(:,2)<0.2)));
            testCase.segs2 = segs2;
        end
    end
    
    methods (Test)
        
        function plotOnAllAxes(testCase)
           hF = figureGen;
           a = plotMulti(testCase.x,testCase.D, 'time', testCase.tags);
           segObj = testCase.segs;
           segObj.plotOnAxes(a,testCase.x)
     
        end
        
        function plotOnMoreAxes(testCase)
            figureGen;
           a = plotMulti(testCase.x,testCase.D, 'time', testCase.tags);
           segObj = testCase.segs;
           segObj2 = testCase.segs2;
           segObj.plotOnAxes(a([1,3]),testCase.x);
           segObj2.plotOnAxes(a(2), testCase.x);
        end
        function plotOnlyOneTag(testCase)
            figureGen;
           a = plotMulti(testCase.x,testCase.D, 'time', testCase.tags);
           segObj = testCase.segs;
           segObj.plotOnAxes(a([1,3]),testCase.x, 'segmentTags', 'cosPos');
        end
        
        function plotOnlyMoreTagsCell(testCase)
            figureGen;
           a = plotMulti(testCase.x,testCase.D, 'time', testCase.tags);
           segObj = testCase.segs2;
           tags = {'sinPos', 'sinBetween'};
           segObj.plotOnAxes(a([2,3]),testCase.x, 'segmentTags', tags);
        end
        function plotWrongTag(testCase)
            figureGen;
           a = plotMulti(testCase.x,testCase.D, 'time', testCase.tags);
           segObj = testCase.segs2;
           tags = {'sinPos', 'sinBetweens'};
           testCase.verifyWarning(@()segObj.plotOnAxes(a([2,3]),testCase.x, 'segmentTags', tags), 'plotOnAxes:InvalidInputtagName');
           segObj.plotOnAxes(a([2,3]),testCase.x, 'segmentTags', tags);
        end
    end
end


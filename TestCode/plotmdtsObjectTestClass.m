classdef plotmdtsObjectTestClass < matlab.unittest.TestCase
    %
    % Description : Test the plotmdtsObject function
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
            
            nX = 1000;
            nChannels = 4;
            
            ts = duration(0, 0, 1, 0);
            time = zeros(nX, 1);
            data = zeros(nX, nChannels);
            
            for i = 1 : nX
                
                time(i) = datenum(datetime(2017, 7, 31, 14, 3, 3 + i - 1 * seconds(ts)));
                
                data(i, 1) = sin(2 * pi * (2 * i) / (nX)) * 10;
                data(i, 2) = cos(4 * pi * (2 * i) / (nX)) * 5;
                data(i, 3) = exp(5 * i / nX);
                data(i, 4) = round(10 * i / nX);
                
            end
            
            tags = {'Channel 1', 'Channel 2', 'Channel 3', 'Channel 4'};
            units = {'s', 'min', 'Elephants', 'Giraffs'};
            name = 'mdtsPlot Test';
            who = 'Operator';
            when = 'Now';
            description = {'This is a mdtsPlot Test'; 'with two text lines'};
            comment = {'This is'; 'a comment'};
            eventInfo1.eventTime = time(10);
            eventInfo1.eventDuration = int32(0);
            eventInfo2.eventTime = time(100);
            eventInfo2.eventDuration = int32(0);
            eventInfo3.eventTime = time(750);
            eventInfo3.eventDuration = int32(0);
            eventInfo4.eventTime = time(end) + 10 / (60 *60 * 24);
            eventInfo4.eventDuration = int32(0);
            keys = {'Start', 'Middle', 'End', 'Outer'};
            tsEvents = containers.Map(keys, {eventInfo1, eventInfo2, eventInfo3, eventInfo4});
            
            returns = mdtsObject(time, data, tags, 'units', units, 'ts', ts, 'name', name, 'who', who, 'when', when, 'description', description, 'comment', comment, 'tsEvents', tsEvents);
            
            input1.object = returns;
            input1.tag = 'Channel 1';
            alphabet1 = {'a', 'b'};
            edges1 = [-inf, 0, inf];
            
            input2.object = returns;
            input2.tag = 'Channel 2';
            alphabet2 = {'a', 'b', 'c'};
            edges2 = [-inf, -4, 4, inf];
            
            input3.object = returns;
            input3.tag = 'Channel 3';
            alphabet3 = {'a', 'b', 'c', 'd', 'e', 'f', 'g', 'h'};
            edges3 = [0, 20, 40, 60, 80, 100, 120, 140, inf];
            
            input4.tag = 'Channel 4';
            
            symbObj1 = symbRepChannel(input1, edges1, alphabet1);    
            symbObj2 = symbRepChannel(input2, edges2, alphabet2);  
            symbObj3 = symbRepChannel(input3, edges3, alphabet3); 
            
            symbRepObjectsList = {symbObj1, symbObj2, symbObj3};
            symbObj4 = applyMCLA(symbRepObjectsList);           
                        
            returns = returns.addSymbRepToChannel(returns.getTagIndices(input1.tag), symbObj1);
            returns = returns.addSymbRepToChannel(returns.getTagIndices(input2.tag), symbObj2);
            returns = returns.addSymbRepToChannel(returns.getTagIndices(input3.tag), symbObj3);
            returns = returns.addSymbRepToChannel(returns.getTagIndices(input4.tag), symbObj4);
            
            [~, ~, ~] = plotmdtsObject(returns, 'plotSymbolName', true, 'plotSymbolDuration', true);
                        
        end
        
    end
    
end


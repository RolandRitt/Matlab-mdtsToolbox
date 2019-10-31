classdef SymbRepObject_plotOnAxes_TestClass < matlab.unittest.TestCase
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
        function testPlotWithDefaultXTime(testCase)
            
            nX = 1000;
            nChannels = 4;
            
            ts = duration(0, 0, 1, 0);
            time0 = zeros(nX, 1);
            time1 = zeros(nX, 1);
            data = zeros(nX, nChannels);
            
            for i = 1 : nX
                
                time0(i) = i;
                time1(i) = datenum(datetime(2017, 7, 31, 14, 3, 3 + i - 1 * seconds(ts)));
                time2(i, 1) = datetime(2017, 7, 31, 14, 3, 3 + i - 1 * seconds(ts));
                time3(i, 1) = i * ts;
                
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

    
            returns2 = mdtsObject(time2, data, tags, 'units', units, 'ts', ts, 'name', name, 'who', who, 'when', when, 'description', description, 'comment', comment);

            
            
            
            
            
            
            
            
            input1.object = returns2;
            input1.tag = 'Channel 1';
            alphabet1 = {'a', 'b'};
            edges1 = [-inf, 0, inf];
            
            input2.object = returns2;
            input2.tag = 'Channel 2';
            alphabet2 = {'b'};
            edges2 = [-4, 4];
            
            input3.object = returns2;
            input3.tag = 'Channel 3';
            alphabet3 = {'a', 'b', 'c', 'd', 'e', 'f', 'g', 'h'};
            edges3 = [0, 20, 40, 60, 80, 100, 120, 140, inf];
            
            
            symbObj1 = symbRepChannel(input1, edges1, alphabet1);
            symbObj2 = symbRepChannel(input2, edges2, alphabet2);
            symbObj3 = symbRepChannel(input3, edges3, alphabet3);
            
            symbRepObjectsList = {symbObj1, symbObj2, symbObj3};
            symbObj4 = applyMCLA(symbRepObjectsList);
            symbRepObjectsList{end+1} = symbObj4;
            
            symbRepObjectsList2 = symbRepObjectsList;
            symbRepObjectsList2{2} = [];
            input1.object = returns2;
            input1.tag = 'Channel 1';
            alphabet1 = {'a', 'b'};
            edges1 = [-inf, 0, inf];
            
            input2.object = returns2;
            input2.tag = 'Channel 2';
            alphabet2 = {'b'};
            edges2 = [-4, 4];
            
            input3.object = returns2;
            input3.tag = 'Channel 3';
            alphabet3 = {'a', 'b', 'c', 'd', 'e', 'f', 'g', 'h'};
            edges3 = [0, 20, 40, 60, 80, 100, 120, 140, inf];
            
            symbObj1 = symbRepChannel(input1, edges1, alphabet1);
            symbObj2 = symbRepChannel(input2, edges2, alphabet2);
            symbObj3 = symbRepChannel(input3, edges3, alphabet3);
            
            figure;
            pH = plot(time0, data(:,1));
            
            Ax = ancestor(pH, 'Axes');
            
            
            
            symbRepObjectsList2{1}.plotOnAxes(Ax);
            symbRepObjectsList2{3}.plotOnAxes(Ax);
            
            
            figure;
            pH = plot(time0, data(:,1));
            hold on;
            plot(time0, data(:,2));
            plot(time0, data(:,3));
            
            Ax = ancestor(pH, 'Axes');
            
            
            
            symbRepObjectsList2{1}.plotOnAxes(Ax);
            symbRepObjectsList2{3}.plotOnAxes(Ax);
        end
        
        function TestPlot2(testCase)
            %% define mdtsObject
            nX = 1000;
            ts = 1;
            time0 = datetime(2017, 7, 31, 14, 3, 3)  + (1:nX)' * seconds(ts);
            data = sin(2 * pi*4.*(1:nX)  ./nX ) * 10';
               
            return_mdts = mdtsObject(time0, data', {'Channel 1'});
            
            %% generate Symbolic Object
            inputSymb1.object = return_mdts;
            inputSymb1.tag = 'Channel 1';
            alphabet1 = {'a', 'b'};
            edges1 = [-inf, 0, inf];
            
            symbObj1 = symbRepChannel(inputSymb1, edges1, alphabet1);

            %% plot Symbolic Object possibility 1
            figureGen;
            pH = plot(time0, data);
            Ax = ancestor(pH, 'Axes'); 
            % Ax = mdtsObject.plot
            
            symbObj1.plotOnAxes(Ax);
            %% plot Symbolic Object possibility 2
            return_mdts.addSymbRepToAllChannels(symbObj1);
            [Ax] = return_mdts.plot;
            
       
        
        end
        
    end
end


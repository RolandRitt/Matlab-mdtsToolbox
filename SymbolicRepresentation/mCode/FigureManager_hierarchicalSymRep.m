classdef FigureManager_hierarchicalSymRep < FigureManager
    %
    % Description :
    %
    % Author :
    %    Roland Ritt
    %
    % History :
    % \change{1.0}{06-Dec-2017}{Original}
    %
    % --------------------------------------------------
    % (c) 2017, Roland Ritt
    % Chair of Automation, University of Leoben, Austria
    % email: automation@unileoben.ac.at
    % url: automation.unileoben.ac.at
    % --------------------------------------------------
    %
    %%
    
    properties
        HierarchicalSAXdata
        currLevel
        maxLevel
        bHierarchicalSet
        oldTitle
        axTitle
        allTitles
        
    end
    
    events
        levelForward;
        levelBackward;
    end
    
    methods
        %
        function o = FigureManager_hierarchicalSymRep( figureH )
            varArgin = {};
            if nargin>0
                varArgin{1} = figureH;
            end
            o = o@FigureManager(varArgin{:});
            
            figH = o.figureH;

            o.HierarchicalSAXdata = [];
            o.currLevel = 1;
            bHierarchicalSet = false;
            
            t = uitoolbar(figH);
            
            [icon_p] = imread('plus.png');
%             icon_p = ind2rgb(img,map);
            [icon_m] = imread('minus.png');
%             icon_m = ind2rgb(img,map);
            
            % add buttons to switch level
            uipushtool(t,'TooltipString','Next SAX level',...
                'ClickedCallback',...
                @(~,~) o.showNextLevel, 'CData', icon_p);
            
            uipushtool(t,'TooltipString','Previous SAX level',...
                'ClickedCallback',...
                @(~,~) o.showPrevLevel, 'CData', icon_m);
            
            % add plot alltoPDF
            
                uimenu( o.hMenu, ...
                'Label', 'Save All Levels to PDF',...
                'Callback', @(~,~) o.plotSaveAll);
            
            
        end
        function addHierarchicalSAXrepr(o, HierarchicalSAXrepr, SAXtitles)
            if ~isempty(o.HierarchicalSAXdata)
                warning('HierarchicalSAXrepr are overritten');
            end

            o.HierarchicalSAXdata = HierarchicalSAXrepr;
            o.currLevel = 1;
            o.maxLevel = size(HierarchicalSAXrepr, 2);
            o.bHierarchicalSet = true;
            o.oldTitle=  o.figureH.Children(end).Title.String;
            o.axTitle = o.figureH.Children(end);
            
            if nargin<3
                o.allTitles = strcat({o.oldTitle}, {' - SAX Level '},...
                    int2str((1:o.maxLevel)'), {' of '}, int2str(o.maxLevel));
            else
                o.allTitles = SAXtitles;
            end
            o.showLevel(1);
        end
        
        function showNextLevel(o)
            if o.bHierarchicalSet
                if o.currLevel<o.maxLevel
                    o.currLevel = o.currLevel +1;
                end
                o.showLevel(o.currLevel);
%                 disp(o.currLevel);
            end
        end
        
        function showPrevLevel(o)
            if o.bHierarchicalSet
                if o.currLevel>1
                    o.currLevel = o.currLevel -1;
                end
                o.showLevel(o.currLevel);
            end
        end
        
        function showLevel(o, numLevel)
            set(o.HierarchicalSAXdata, 'Visible', 'off');
            set(o.HierarchicalSAXdata(:,numLevel), 'Visible', 'on');
            title(o.axTitle,o.allTitles{numLevel});
        end
        
        function plotSaveAll(o, savename)
            
            
                
            H = o.figureH;
            LevelOld = o.currLevel;
%             titleOld = H.Children(end).Title.String;
%             axTitle = H.Children(end);
            if nargin<2
            filterSpec = '*.pdf';
            dialogTitle = 'File name to save figure';
            defaultName = ...
                ['HierarchicalSAX-All-',datestr(now,'yyyy-mm-dd'),'.pdf'];
            [fileName,filePath] = ...
                uiputfile(filterSpec,dialogTitle,defaultName);
            %
            fullFileName = [filePath, fileName];
            else
                
              fullFileName = savename;
              [~,fileName,ext] = fileparts( savename);
            end
            %
            if (fileName ~= 0 )
%                 tempPath = tempdir;
                tempFileNames = cell(o.maxLevel, 1);
                for i=1:o.maxLevel
%                     title(axTitle,[titleOld, ' - SAX Level ', int2str(i)]);
                    tempFileName = [tempname, '.pdf'];
                    o.showLevel(i);
                    export_fig(tempFileName, '-pdf', '-r 600', '-painters', H);
%                     figureSave( H, tempFileName );
                    tempFileNames{i} = tempFileName;
                end
                
                append_pdfs( fullFileName, tempFileNames{:} );
                
                delete(tempFileNames{:});
%                 title(axTitle, titleOld);
                o.showLevel(LevelOld);
            end
            
            
        end
        
    end
end
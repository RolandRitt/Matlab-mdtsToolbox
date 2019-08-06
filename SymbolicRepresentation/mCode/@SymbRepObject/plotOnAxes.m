function [paAll, tHandleAll] = plotOnAxes(SymbRepObj, axes_in, xTime, varargin)
% Purpose :
%
% Syntax :
%   gObjArr = plotOnAxes(SymbRepObj,axes_in, xTime, varargin)
%
% Input Parameters :
%   axes_in:= the axes, on which the symbolic representation should be
%               plotted;
%   SymbRepObj:= a SymbRepObject;
%   xTime:= (optional, if not given, take the x values of the first line in the axes)the original time axes where the SymbRepObject refers to;
%   plotSymbolName:= (optional key-value)a boolean indicating if the Symbol name should be
%                   shown in the plot;
%   plotSymbolDuration:= (optional key-value)a boolean indicating if the Symbol duration should be
%                   shown in the plot;
%   plotSymbolNameMinLength:= (optional key-value)an integer, symbols with a length less than
%   this value are not annotated with symbol name and/or duration;
%   colorDismiss:= (optional key-value) a color string or color triplet which should not be in
%   the colors used for shading the plots
%
% Return Parameters :
%   gObjArr:= an array containing the hggroups for all axes, containing the
%   symbolic representation;
%
% Description :
%
% Author :
%    Roland Ritt
%
% History :
% \change{1.0}{11-May-2018}{Original}
%
% --------------------------------------------------
% (c) 2018, Roland Ritt
% Chair of Automation, University of Leoben, Austria
% email: automation@unileoben.ac.at
% url: automation.unileoben.ac.at
% --------------------------------------------------
%
%%
defFontSize = 8;
p = inputParser();
p.KeepUnmatched=true;
addRequired(p, 'SymbRepObj', @(x) isa(x, 'SymbRepObject')); %check if input is SymbRepObject
addRequired(p, 'axes_in', @(x) isa(x, 'matlab.graphics.axis.Axes')||ishghandle(x)); %check if input is axes or handle object
addOptional(p, 'xTime', false, @(x) isdatetime(x)|| isreal(x) || isduration(x));
addParameter(p, 'plotSymbolName', false, @islogical);
addParameter(p, 'plotSymbolDuration', false, @islogical);
addParameter(p, 'plotSymbolNameMinLength', 0, @(x)isreal(x)&& isequal(size(x),[1,1]));
addParameter(p, 'colorDismiss', [], @(x)(isreal(x)&& isequal(size(x),[1,3]))|| ischar(x));

parse(p, SymbRepObj,axes_in,varargin{:});

tmp = [fieldnames(p.Unmatched),struct2cell(p.Unmatched)];
UnmatchedArgs = reshape(tmp',[],1)';

plotSymbolName = p.Results.plotSymbolName;
plotSymbolNameMinLength = p.Results.plotSymbolNameMinLength;
plotSymbolDuration = p.Results.plotSymbolDuration;
xTime = p.Results.xTime;
SymbRepObj = p.Results.SymbRepObj;
axes_in = p.Results.axes_in;
%%%%%
% allSymbols = {};

% for i = 1 : numel(SymbRepObj)
%
%     if~isempty(SymbRepObj{i})
%
%         if ~isa(SymbRepObj{i}, 'SymbRepObject')
%             error('the second input argument must be a SymbRepObject. See function isHierarchicalSymRep');
%         end
%         addSymbols = categories(SymbRepObj{i}.symbols);
%         allSymbols = [allSymbols; addSymbols];
%
%     end
%
% end

uniqueSymbols = categories(SymbRepObj.symbols);
nSymbols = numel(uniqueSymbols);
if isempty(p.Results.colorDismiss)
    symbolColors = distinguishable_colors(nSymbols, {'w'});
else
    symbolColors = distinguishable_colors(nSymbols, {'w', p.Results.colorDismiss});
end
alphCol = 0.3;

nAxes = numel(axes_in);
gObjArr = axes_in;
paAll = [];
tHandleAll = [];

bNoXTime = false;
if ~p.Results.xTime
    bNoXTime = true;
end
for i = 1 : nAxes
    if  isa( gObjArr(i), 'matlab.graphics.axis.Axes')
        tempAx = gObjArr(i);
        bishggroup = false;
        FontSize = tempAx.FontSize;
    elseif ishghandle(gObjArr(i))
        bishggroup = true;
        tempAx = ancestor(gObjArr(i), {'axes'});
        FontSize = defFontSize;
    else
        error('something went wrong in visu Ranges');
    end
    %% if no xTime given, take xValues of first Children
    if bNoXTime
        tempLine = findall(tempAx.Children, 'Type', 'Line');
        xTime = tempLine(1).XData';
        
    end
    %% check if there is a figureManagerRunning
    figH = ancestor(tempAx,'figure');
    fM = figH.UserData;
    bfM = true;
    ph = [];
    
    if ~isa(fM, 'FigureManager');
        bfM = false;
    end
    if bfM
        shouldAddold = fM.shouldAdd;
        fM.shouldAdd = false; %% otherwise it is too slow!!!
        
    end
    
    
    if ishold(tempAx)
        hold_old = 'on';
    else
        hold_old = 'off';
    end
    hold(tempAx, 'on');
    ylim_temp = get(tempAx, 'YLim');
    ymin = ylim_temp(1);
    ymax = ylim_temp(2);
    
    if~isempty(SymbRepObj)
        
        for j = 1 : nSymbols
            tHandle = [];
            pa=[];
            [startInds, durations] = SymbRepObj.findSymbol(uniqueSymbols{j});
            if isempty(startInds)
                continue;
            end
            
            xStart = xTime(startInds);
            xEnd = xTime(startInds + durations - 1);
            XStart = [xStart, xEnd, xEnd, xStart]';
            
            
            if(plotSymbolName || plotSymbolDuration)
                bTextPrint = durations > plotSymbolNameMinLength;
                xSymbol = xTime(startInds(bTextPrint) + round(durations(bTextPrint) ./ 2));
                
                if (plotSymbolName)
                    symbolText = uniqueSymbols{j};
                    symbolText = strrep(symbolText, '{', '\{');
                    symbolText = strrep(symbolText, '}', '\}');
                end
                if (plotSymbolDuration&&plotSymbolName)
                    symbRepText = cellstr(strcat('\begin{tabular}{c} ', symbolText, '\\', num2str(durations(bTextPrint)), ' \end{tabular}'));
                elseif(plotSymbolDuration)
                    symbRepText = cellstr(num2str(durations(bTextPrint)));
                elseif(plotSymbolName)
                    symbRepText = symbolText;
                end
                
            end
            
            pa = fill(XStart, [ymin, ymin, ymax, ymax]',...
                symbolColors(j, :), 'FaceAlpha', alphCol, 'EdgeColor', symbolColors(j, :), 'Parent', gObjArr(i), UnmatchedArgs{:});
            
            if plotSymbolName||plotSymbolDuration
                yText = (ymin + (ymax - ymin) * 0.25) * ones(size(xSymbol));
                
                tHandle = text(tempAx, xSymbol, yText, symbRepText, 'FontSize', FontSize, 'Color', 'k', 'HorizontalAlignment', 'center', 'clipping', 'on', 'Interpreter', 'latex');
                if bishggroup
                    set(tHandle, 'Parent', gObjArr(i));
                end
            end
            
            if bishggroup
                set(pa, 'Parent', gObjArr(i));
            end
            
            %             pa = fill([xStart, xEnd, xEnd, xStart], [ymin, ymin, ymax, ymax], symbolColors(j, :), 'FaceAlpha', alphCol, 'EdgeColor', symbolColors(j, :), 'Parent', gObjArr(i));
            %             if bishggroup
            %                 set(pa, 'Parent', gObjArr(i));
            %             end
            %             if(plotSymbolName && durations(k) > plotSymbolNameMinLength)
            %
            %                 yText = ymin + (ymax - ymin) * 0.25;
            %                 symbolText = uniqueSymbols{j};
            %                 symbolText = strrep(symbolText, '{', '\{');
            %                 symbolText = strrep(symbolText, '}', '\}');
            %
            %                 if(~plotSymbolDuration)
            %
            %                     symbRepText = symbolText;
            %
            %                 else
            %
            %                     symbRepText = ['\begin{tabular}{c} ', symbolText, '\\', num2str(durations(k)), ' \end{tabular}'];
            %
            %                 end
            %
            %                 xSymbol = xTime(startInds(k) + round(durations(k) / 2));
            %
            %                 text(axes_in(i), xSymbol, yText, symbRepText, 'Color', 'k', 'HorizontalAlignment', 'center', 'clipping', 'on', 'Interpreter', 'latex');
            %
            %             end
            %
            %
            %
            %         end
            
            %         uistack(ph(i), 'top');
            %         set(axes_in(i), 'Layer', 'top')
            paAll = [paAll;pa];
            tHandleAll = [tHandleAll; tHandle];
        end
    end
    hold(axes_in(i), hold_old);
    if bfM
        fM.shouldAdd = shouldAddold;
    end
end

function gObjArr = plotSymRepObjectOnAxes(axes_in, SymbRepObj, xTime, plotSymbolName, plotSymbolDuration, plotSymbolNameMinLength, colorDismiss)
% This function plots the symbolic representation onto given axes (using
% shaded patches).
%
% Purpose :
%
% Syntax :
%   gObjArr = plotSymRepObjectOnAxes(axes_in, SymbRepObj, xTime, plotSymbolName, plotSymbolDuration, plotSymbolNameMinLength, colorDismiss)
%
% Input Parameters :
%   axes_in:= the axes, on which the symbolic representation should be
%               plotted (they have to be in the same order as the SymbRepObj);
%   axes_in:= a SymbRepObject;
%   xTime:= the original time axes where the SymbRepObject refers to;
%   plotSymbolName:= a boolean indicating if the Symbol name should be
%                   shown in the plot;
%   plotSymbolDuration:= a boolean indicating if the Symbol duration should be
%                   shown in the plot;
%   plotSymbolNameMinLength:= an integer, symbols with a length less than
%   this value are not annotated with symbol name and/or duration;
%   colorDismiss:= a color string or color triplet which should not be in
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

% if ~isHierarchicalSymRep(SymbRepObj)
%     error('the second input argument must be a HierarchicalSymRep (cell of SymbRepObjects). See function isHierarchicalSymRep');
% end

allSymbols = {};

for i = 1 : numel(SymbRepObj)
    
    if~isempty(SymbRepObj{i})
        
            if ~isa(SymbRepObj{i}, 'SymbRepObject')
                error('the second input argument must be a SymbRepObject. See function isHierarchicalSymRep');
            end
        addSymbols = categories(SymbRepObj{i}.symbols);
        allSymbols = [allSymbols; addSymbols];
        
    end
    
end

uniqueSymbols = unique(allSymbols);
nSymbols = numel(uniqueSymbols);
symbolColors = distinguishable_colors(nSymbols, {'w', colorDismiss});
alphCol = 0.3;


    
nAxes = numel(axes_in);
% 
% gObjArr = gobjects(nAxes,1);
% for j = 1:nAxes
%     gObjArr(j)   = hggroup(axes_in(j));
% end
gObjArr = axes_in;

for i = 1 : nAxes
    if  isa( gObjArr(i), 'matlab.graphics.axis.Axes')
        tempAx = gObjArr(i);
        bishggroup = false;
    elseif ishghandle(gObjArr(i))
        bishggroup = true;
        tempAx = ancestor(gObjArr(i), {'axes'});
        
    else
        error('something went wrong in visu Ranges');
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
    %     ymin = min(min(ph(i).YData), -1);
    %     ymax = max(max(ph(i).YData), 1);
    
    
    
    if~isempty(SymbRepObj{i})
        
        for j = 1 : nSymbols
            
            [startInds, durations] = SymbRepObj{i}.findSymbol(uniqueSymbols{j});
            
            for k = 1 : numel(startInds)
                
                xStart = xTime(startInds(k));
                xEnd = xTime(startInds(k) + durations(k) - 1);
                %                  evInds = [xStart, xEnd];
                %                 visuRanges([startInds(k), startInds(k) + durations(k) - 1], gObjArr, xTime, symbolColors(j,:));
                pa = fill([xStart, xEnd, xEnd, xStart], [ymin, ymin, ymax, ymax], symbolColors(j, :), 'FaceAlpha', alphCol, 'EdgeColor', symbolColors(j, :), 'Parent', gObjArr(i));
                if bishggroup
                    set(pa, 'Parent', gObjArr(i));
                end
                if(plotSymbolName && durations(k) > plotSymbolNameMinLength)
                    
                    yText = ymin + (ymax - ymin) * 0.25;
                    symbolText = uniqueSymbols{j};
                    symbolText = strrep(symbolText, '{', '\{');
                    symbolText = strrep(symbolText, '}', '\}');
                    
                    if(~plotSymbolDuration)
                        
                        symbRepText = symbolText;
                        
                    else
                        
                        symbRepText = ['\begin{tabular}{c} ', symbolText, '\\', num2str(durations(k)), ' \end{tabular}'];
                        
                    end
                    
                    xSymbol = xTime(startInds(k) + round(durations(k) / 2));
                    
                    text(axes_in(i), xSymbol, yText, symbRepText, 'Color', 'k', 'HorizontalAlignment', 'center', 'clipping', 'on', 'Interpreter', 'latex');
                    
                end
                
            end
            
        end
        
        %         uistack(ph(i), 'top');
        %         set(axes_in(i), 'Layer', 'top')
        
    end
    hold(axes_in(i), hold_old);
    
end

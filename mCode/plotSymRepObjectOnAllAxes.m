function gObjArr = plotSymRepObjectOnAllAxes(axes_in, SymbRepObj, xTime, plotSymbolName, plotSymbolDuration, plotSymbolNameMinLength, colorDismiss)
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

if ~isa(SymbRepObj, 'SymbRepObject')
    error('the second input argument must be a SymbRepObject');
end


allSymbols = categories(SymbRepObj.symbols);

nSymbols = numel(allSymbols);
symbolColors = distinguishable_colors(nSymbols, {'w', colorDismiss});
alphCol = 0.3;

nAxes = numel(axes_in);
% gObjArr = gobjects(nAxes,1);
% for j = 1:nAxes
%     gObjArr(j)   = hggroup(axes_in(j));
% end
gObjArr = axes_in;

for i = 1 : nAxes
    if  isa( gObjArr(i), 'matlab.graphics.axis.Axes')
        tempAx{i} = gObjArr(i);
        bishggroup = false;
    elseif ishghandle(gObjArr(i))
        bishggroup = true;
        tempAx{i} = ancestor(gObjArr(i), {'axes'});
        
    else
        error('something went wrong in visu Ranges');
    end
    
    
    if ishold(tempAx{i})
        hold_old{i} = 'on';
    else
        hold_old{i} = 'off';
    end
    hold(tempAx{i}, 'on');
    ylim_temp = get(tempAx{i}, 'YLim');
    ymin(i) = ylim_temp(1);
    ymax(i) = ylim_temp(2);
    
end

%     ymin = min(min(ph(i).YData), -1);
%     ymax = max(max(ph(i).YData), 1);





for j = 1 : nSymbols
    
    [startInds, durations] = SymbRepObj.findSymbol(allSymbols{j});
    if isempty(startInds)
        continue;
    end
    if isdatetime(xTime(1))
        XStart = NaT(4,numel(startInds));
    else
        XStart = nam(4,numel(startInds));
    end
    
    for k = 1 : numel(startInds)
        
        xStart = xTime(startInds(k));
        xEnd = xTime(startInds(k) + durations(k) - 1);
        XStart(:,k) = [xStart, xEnd, xEnd, xStart];

        for i=1:nAxes

        end
        
    end
    

    
    if(plotSymbolName || plotSymbolDuration)
        bTextPrint = durations > plotSymbolNameMinLength;
        xSymbol = xTime(startInds(bTextPrint) + round(durations(bTextPrint) ./ 2));
        
        if (plotSymbolName)
                symbolText = allSymbols{j};
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
%         
%         if(~plotSymbolDuration)
%             
%             symbRepText = symbolText;
%         else
%             symbRepText = cellstr(strcat('\begin{tabular}{c} ', symbolText, '\\', num2str(durations(bTextPrint)), ' \end{tabular}'));
%         end
    end
    
    
    for i=1:nAxes
        pa = fill(XStart, [ymin(i), ymin(i), ymax(i), ymax(i)]',...
            symbolColors(j, :), 'FaceAlpha', alphCol, 'EdgeColor', symbolColors(j, :), 'Parent', gObjArr(i));
        
        if plotSymbolName||plotSymbolDuration
            yText = (ymin(i) + (ymax(i) - ymin(i)) * 0.25) * ones(size(xSymbol));
            
            tHandle = text(tempAx{i}, xSymbol, yText, symbRepText, 'Color', 'k', 'HorizontalAlignment', 'center', 'clipping', 'on', 'Interpreter', 'latex');
            if bishggroup
                set(tHandle, 'Parent', gObjArr(i));
            end
        end
        
        if bishggroup
                set(pa, 'Parent', gObjArr(i));  
        end
        
    end
    
end


for i = 1 : nAxes
    hold(tempAx{i}, hold_old{i});
end

end

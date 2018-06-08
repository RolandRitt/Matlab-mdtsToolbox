function gObjArr = plotSymRepObjectOnAllAxes(axes_in, SymbRepObj, xTime, varargin)
% This function plots the symbolic representation onto given axes (using
% shaded patches).
%
% Purpose :
%
% Syntax :
%   gObjArr = plotSymRepObjectOnAxes(axes_in, SymbRepObj, xTime, varargin)
%
% Input Parameters :
%   axes_in:= the axes, on which the symbolic representation should be
%               plotted (they have to be in the same order as the SymbRepObj);
%   axes_in:= a SymbRepObject;
%   xTime:= the original time axes where the SymbRepObject refers to;
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
p = inputParser();
p.KeepUnmatched=true;
addRequired(p, 'axes_in', @(x)isa(x, 'matlab.graphics.axis.Axes')|| all(ishghandle(x))); %check if input is axes or handle object
addRequired(p, 'SymbRepObj', @(x) isa(x, 'SymbRepObject')); %check if input is SymbRepObject
addRequired(p, 'xTime', @(x) isdatetime(x)|| isreal(x)); %check if input is SymbRepObject
addParameter(p, 'plotSymbolName', false, @islogical);
addParameter(p, 'plotSymbolDuration', false, @islogical);
addParameter(p, 'plotSymbolNameMinLength', 0, @(x)isreal(x)&& isequal(size(x),[1,1]));
addParameter(p, 'colorDismiss', [], @(x)(isreal(x)&& isequal(size(x),[1,3]))|| ischar(x));

parse(p, axes_in, SymbRepObj, xTime, varargin{:});

tmp = [fieldnames(p.Unmatched),struct2cell(p.Unmatched)];
UnmatchedArgs = reshape(tmp',[],1)';

plotSymbolName = p.Results.plotSymbolName;
plotSymbolNameMinLength = p.Results.plotSymbolNameMinLength;
plotSymbolDuration = p.Results.plotSymbolDuration;
xTime = p.Results.xTime;
SymbRepObj = p.Results.SymbRepObj;
axes_in = p.Results.axes_in;


allSymbols = categories(SymbRepObj.symbols);

nSymbols = numel(allSymbols);
if isempty(p.Results.colorDismiss)
    symbolColors = distinguishable_colors(nSymbols, {'w'});
else
    symbolColors = distinguishable_colors(nSymbols, {'w', p.Results.colorDismiss});
end

alphCol = 0.3;

nAxes = numel(axes_in);
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

    end
    
    
    for i=1:nAxes
        pa = fill(XStart, [ymin(i), ymin(i), ymax(i), ymax(i)]',...
            symbolColors(j, :), 'FaceAlpha', alphCol, 'EdgeColor', symbolColors(j, :), 'Parent', gObjArr(i), UnmatchedArgs{:});
        
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

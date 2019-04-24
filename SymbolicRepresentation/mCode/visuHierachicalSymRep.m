function [Ax, fM, figH] = visuHierachicalSymRep(mdtsObj, HierarchicalSymRep, varargin)

% <keywords>
%
% Purpose : function to plot hierarchical symbolic Representation for a given
% mdts object,
%
% Syntax :
%
% Input Parameters :
%
% Return Parameters :
%
% Description :
%
% Author :
%    Roland Ritt
%
% History :
% \change{1.0}{22-May-2018}{Original}
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
addRequired(p, 'TSobj', @(x) isa(x, 'mdtsObject')); %check if input is TS
addRequired(p, 'HierarchicalSymRep', @(x) isHierarchicalSymRep(x)); %check if input is TS
addParameter(p, 'Size', [18,27], @(x)isnumeric(x)&&isvector(x)); %higth and width
addParameter(p, 'FontSize', 10, @isnumeric);
addParameter(p, 'bPlotEventLegend', true, @islogical);
addParameter(p, 'figureH', [], @(x) isgraphics(x,'figure'));
addParameter(p, 'FigTitle', [], @(x) ischar(x)||isstring(x));

parse(p, mdtsObj,HierarchicalSymRep, varargin{:});

tmp = [fieldnames(p.Unmatched),struct2cell(p.Unmatched)];
UnmatchedArgs = reshape(tmp',[],1)';


TSobjIn = p.Results.TSobj;
HierarchicalSymRep = p.Results.HierarchicalSymRep;
nTags = length(TSobjIn.tags);
saxGArray = gobjects(nTags, length(HierarchicalSymRep));



figH = figureGen(p.Results.Size(1), p.Results.Size(2), p.Results.FontSize);
set(figH,'defaultLegendAutoUpdate','off'); %prevent outo updating legend;

fM = FigureManager_hierarchicalSymRep(figH);


[Ax, fM, ph] = plotmdtsObject(TSobjIn, 'figureH', figH, UnmatchedArgs{:});
% [Ax, fM, ph] = TS.plotTS(TSobjIn, 'figureH', figH, UnmatchedArgs{:});
SAXtitles = cell(0);
for  i=1:nTags
    for j = 1:length(HierarchicalSymRep)
        saxGArray(i,j) = hggroup(Ax(i));
        saxGArray(i,j).Visible = 'off';
        SAXtitles{j} = HierarchicalSymRep{j}.name;
    end
end

fM.addHierarchicalSAXrepr(saxGArray, SAXtitles);

% keysSAX = keys(HierarchicalSymRep);
for i=1:length(HierarchicalSymRep)
    %     temp_hggroup = gobjects(MultiSaxTSorig.nCols, 1);
    disp(['Plot SAX Nr.', int2str(i), ' of ', int2str(length(HierarchicalSymRep))]);
    plotSymRepObjectOnAllAxes(saxGArray(:,i), HierarchicalSymRep{i},TSobjIn.timeDateTime,'colorDismiss', get(ph(1), 'Color'));
    %     TS_SAX_Multi.visuSAX(TSobjIn, HierarchicalSymRep(keysSAX{i}) ,'gObjArr', saxGArray(:,i));
%     plotSymRepObjectOnAllAxes(Ax, symbObj4,returns6.timeDateTime, ...
%         'plotSymbolName', true,'plotSymbolNameMinLength',40 , 'plotSymbolDuration', false, 'colorDismiss', get(ph(1), 'Color'));
    
end




for i=1:length(ph)
    uistack(ph(i), 'top');
end
end
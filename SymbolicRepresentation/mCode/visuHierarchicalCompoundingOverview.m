function figureH = visuHierarchicalCompoundingOverview(compressionData, imageMatrix,varargin)
% <keywords>
%
% Purpose : 
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
% \change{1.0}{08-Jun-2018}{Original}
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
addRequired(p, 'compressionData', @isstruct); %check if input is TS
addRequired(p, 'imageMatrix', @isnumeric); %check if input is TS
addParameter(p, 'size', [18,27], @(x)isnumeric(x)&&isvector(x)); %higth and width
addParameter(p, 'figureH', [], @(x) isgraphics(x,'figure'));
addParameter(p, 'FigTitle', [], @(x) ischar(x)||isstring(x));
parse(p, compressionData,imageMatrix, varargin{:});

tmp = [fieldnames(p.Unmatched),struct2cell(p.Unmatched)];
UnmatchedArgs = reshape(tmp',[],1)';


compressionData = p.Results.compressionData;

if isempty(p.Results.figureH)
    if isempty(p.Results.size)
        figureH = figureGen;
    else
        figureH = figureGen(p.Results.size(1),p.Results.size(2));
    end
end

ratios = [5,3];
Dm = 2; %number of axis
offSetScale = 0.05;

A = horizontalDevideAxes(figureH, Dm, ratios, offSetScale);

AData  = horizontalDevideAxes(A(2), 2, [1, 1], 0);
% AData  = horizontalDevideAxes(A(2), 4, [1, 1, 1, 1], 0);
hPlot = imagesc(A(1), p.Results.imageMatrix);
xlabel(A(1), 'time');
ylabel(A(1), 'hierarchical level');
if ~isempty(p.Results.FigTitle)
    title(A(1), p.Results.FigTitle);
end
plot(AData(1),  compressionData.nSymbols);
xlim(AData(1), [0.5, numel(compressionData.nSymbols) + 0.5]);
grid(AData(1), 'on');
grid(AData(1), 'minor');
set(AData(1),'XTickLabel', []);
ylabel(AData(1), 'n Syms');

plot(AData(2), compressionData.nMergedSymbols ./ compressionData.nSymbols(1 : end-1 ));
grid(AData(2), 'on');
grid(AData(2), 'minor');
xlim(AData(2), [0, numel(compressionData.nSymbols)]);
ylabel(AData(2), 'rel No Syms');
set(AData(2),'XTickLabel', []);


view(AData(2),[90,90]);
view(AData(1),[90,90]);
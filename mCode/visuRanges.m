function visuRanges(evInds, axH, origXVals, colTriplet)
% <keywords>
%
% Purpose : Visualise ranges on plot axes
%
% Syntax :
%
% Input Parameters :
%   evInds...       nx2 matrix of event indices; [startInds endInds]
%   axH...          Handle to a single axis or multiple axes
%   origXVals...    X values of the series (original indices)
%   colTriplet...   Colour of the visualisation (OPTIONAL)
%
% Return Parameters :
%
% Description : 
%
% Author : 
%    Christopher Rothschedl
%
% History :
% \change{1.1}{2017-02-07}{Added colTriplet as additional parameter}
% \change{1.0}{2017-01-27}{Original}
%
% --------------------------------------------------
% (c) 2017, Christopher Rothschedl
% Chair of Automation, University of Leoben, Austria
% email: automation@unileoben.ac.at
% url: automation.unileoben.ac.at
% --------------------------------------------------


%% Settings
if(nargin==3)
    rgbCol = [0.5 0.5 0.5];
else
    rgbCol = colTriplet;
end

% Set alpha channel of patch colour to 20%
alphCol = 0.2;

% %% check input argument
% if (nargin == 1)
%     % find axes objects if not specified by parameter
%     axH = getCurrAxes;
% end;

%% Check if input parameter is handle to single axis or to multiple axes
if(numel(axH)==1)
    tempAxH(1) = axH;
elseif(numel(axH)>1)
    tempAxH = axH;
else
    error('No valid axes data.');
end
[r, c] = size(evInds);
if r==2 && c==1
    evInds = evInds';
end

for k=1:numel(tempAxH)
    %% Check validity of handle
    if(~isvalid(tempAxH(k)))
        return;
    end
    
    %% Get X and Y ranges of axis
    try
        tempRange = ylim(tempAxH(k));
    catch
        error('something went wrong in visu Ranges');
        return;
    end

        % get old hold status       
        g=ishold(tempAxH(k));
        hold(tempAxH(k), 'on');
        
        
    for i=1:numel(evInds(:,1))
        
        % Find edge points for color patches
        x1=origXVals(evInds(i,1));
        x2=origXVals(evInds(i,2));

        y1=tempRange(1);
        y2=tempRange(2);

        % Draw patch on existing plot
%         pa = area(tempAxH(k), [x1, x2], [y2, y2],y1, 'FaceColor', rgbCol, 'FaceAlpha', alphCol, 'EdgeColor', rgbCol);  
         pa = fill( [x1, x2, x2, x1], [y1, y1, y2, y2], rgbCol, 'FaceAlpha', alphCol, 'EdgeColor', rgbCol, 'Parent',tempAxH(k) );
    end
    
    if g==0
        hold(tempAxH(k), 'off');
    end
end

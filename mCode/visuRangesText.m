function pa = visuRangesText(evInds, TextStr, axH, colTriplet)
% text annotation, ranges
%
% Purpose : Visualise text in the middle of ranges on plot axes
%
% Syntax :
%
% Input Parameters :
%   evInds :=       nx2 matrix of event x val; [startVal endVal]
%   TextStr :=      a cellarray with length nx1, each cell contains a
%                   string or a cellstring; this text is anotated in the
%                   plot
%   axH :=          Handle to a single axis or multiple axes
%   colTriplet :=   Colour of the text color (OPTIONAL)
%
% Return Parameters :
%
% Description : 
%
% Author : 
%    Roland Ritt
%
% History :
% \change{1.0}{2017-09-05}{Original}
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
xvals = evInds(:,1) + (evInds(:,2) - evInds(:,1))/2 ;

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
    end

        % get old hold status       
        g=ishold(tempAxH(k));
        hold(tempAxH(k), 'on');
        yVal = tempRange(1);
        ySize = tempRange(2)-yVal;
        
        % plot textboxes
        pa = text(tempAxH(k), xvals, ones(size(xvals)) * (yVal+ ySize*0.001), TextStr, 'Color', rgbCol, 'HorizontalAlignment', 'center', 'clipping','on');

        for p = pa
            set(p, 'Interpreter', 'tex', 'VerticalAlignment', 'bottom');
        end
    if g==0
        hold(tempAxH(k), 'off');
    end
end

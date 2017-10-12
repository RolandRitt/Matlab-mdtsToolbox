function h = plotvline(x, varargin)
% draw vertical lines at specified positions
%
% Purpose : draws a vertical line at the positions x
%
% Syntax :
%      h = plotvline(x, varargin);
% Input Parameters :
%   x := vektor of the positions where the vertical lines should appear
%
%   'LineSpec' := string which defines the line specs for the vertical
%   lines; see LineSpecs
%
%   'Axes' := an vector of axes on which the vertical lines should be drawn
%
%   'Labels' := a cellstring of labels
% Return Parameters :
%   h := handles to the lines
%
%
% Description :
%   Bases on the version from Brandon Kuczenski (c) 2008
%
% Author :
%    Roland Ritt
%
% History :
% \change{1.0}{08 June 2017}{Original}
%
% --------------------------------------------------
% (c) 2017, Roland Ritt
% Chair of Automation, University of Leoben, Austria
% email: automation@unileoben.ac.at
% url: automation.unileoben.ac.at
% --------------------------------------------------

p = inputParser;
p.KeepUnmatched= true;
DefaultLineStyle = '--';
DefaultLineColor = 'r';
DefaultLabels = {};
DefaultAxes = [gca];
addRequired(p, 'x', @isvector);
addParameter(p, 'LineStyle', DefaultLineStyle, @ischar);
addParameter(p, 'Color', DefaultLineColor, @(x) ischar (x) || (isvector(x) & max(size(x)) == 3));
addParameter(p, 'Axes', DefaultAxes, @isvector);
addParameter(p, 'Labels', DefaultLabels, @(x) iscellstr(x) & length(x)==length(x));

parse(p, x, varargin{:});
Ax = p.Results.Axes;
LineStyle = p.Results.LineStyle;
LineColor = p.Results.Color;
Labels = p.Results.Labels;
x = p.Results.x;
tmp = [fieldnames(p.Unmatched),struct2cell(p.Unmatched)];
UnmatchedArgs = reshape(tmp',[],1)';
count = 1;
for i = 1:length(Ax)
    g=ishold(Ax(i));
    hold(Ax(i), 'on');
    y=get(Ax(i),'ylim');
    for j=1:length(x)
        
        h(count)=plot(Ax(i), [x(j) x(j)],y,'LineStyle', LineStyle, 'Color',LineColor, UnmatchedArgs{:} , 'LineWidth', 1.5);
        
        if ~isempty(Labels)
            xx=get(Ax(i),'xlim');
            xrange=xx(2)-xx(1);
            xunit=(x-xx(1))/xrange;
            if xunit<0.8
                text(x+0.01*xrange,y(1)+0.1*(y(2)-y(1)),Labels{j},'color',get(h(count),'color'))
            else
                text(x-.05*xrange,y(1)+0.1*(y(2)-y(1)),Labels{j},'color',get(h(count),'color'))
            end
        end
        count = count+1;
    end
    if g==0
        hold(Ax(i), 'off');
    end
    set(h(count-1),'tag','vline','handlevisibility','off');
end

end

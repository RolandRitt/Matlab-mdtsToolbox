function [axesOut, fM, ph] = plotmdtsObject(inputObject, varargin)
% plotc
%
% Purpose : plot channels of the given mdtsObject
%
% Syntax : plotmdtsObject(inputObject)
%
% Input Parameters :
%   inputObject : mdtsObject (with multiple channels) to be plotted
%
% Return Parameters :
%
% Description : 
%   Use the plotMulti function to plot the channels of the given object
%
% Author : 
%   Paul O'Leary
%   Roland Ritt
%   Thomas Grandl
%
% History :
% \change{1.0}{18-Dec-2017}{Original}
%
% --------------------------------------------------------
% (c) 2017 Paul O'Leary,
% Chair of Automation, University of Leoben, Leoben, Austria
% email: office@harkeroleary.org,
% url: www.harkeroleary.org
% --------------------------------------------------------

%% Parse inputs

msg = 'The method "plotmdtsObject" is deprecated and will be removed in later version. Use instead the method "plot"';
warning(msg);
[axesOut, fM, ph] = inputObject.plot(varargin{:});
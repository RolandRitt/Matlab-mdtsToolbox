function [pa, tHandleAll] = markRangeOnAxes_givenIndex(obj, axes_in, startInds,stopInds, colorSpec, varargin)
%
% Purpose : marks a given range as path on the given axes
%
% Syntax : markRangeOnAxes_givenIndex(obj, axes_in, startInds,stopInds, varargin)
%
% Input Parameters :
%   obj : mdtsObject (with multiple channels), this is used to extract the
%       x values to be used for plotting
%   axes_in : the axes which should be marked
%   startInds: the start inds of the range to be marked
%   stopInds: the stop inds of the range to be marked
%   colorSpec: colorSpec of the patches
%   textToShow: (optional key-value pair) a char or cell-array with text to
%   be shown within the patch
%   varargin := (other key-value pairs) will be forwarded to the fill command
%   
% Return Parameters :
%   pa:= the handles to the patches objects
%   tHandleAll := the handles to all text objects
%   
% Description :
%   given the start and stop values, the y-limits are automatically fetched
%
% Author :
%   Paul O'Leary
%   Roland Ritt
%   Thomas Grandl
%
% History :
% \change{1.0}{08-May-2018}{Original}
%
% --------------------------------------------------------
% (c) 2018 Paul O'Leary,
% Chair of Automation, University of Leoben, Leoben, Austria
% email: office@harkeroleary.org,
% url: www.harkeroleary.org
% --------------------------------------------------------

%% Parse inputs

[pa, tHandleAll] = mdtsObject.markRangeOnAxes_givenIndexStatic(obj.timeInFormat,axes_in, startInds,stopInds, colorSpec, varargin{:} );


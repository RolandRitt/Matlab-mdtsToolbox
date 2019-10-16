function [startInds, stopInds] = compressedInds2UncompressedInds(obj, indsCompressed)
% <keywords>
%
% Purpose : converts Compressed Inds to uncompressed startInds, stopInds
% and durations
%
% Syntax :
%
% Input Parameters :
%   indsCompressed: a list of indices of the compressed symbolic time
%   series
%
% Return Parameters :
%   startInds: start indices of the uncompressed series
%   stopInds: stop indices of the uncompressed series
%
% Description :
%
% Author : 
%    Roland Ritt
%
% History :
% \change{1.0}{02-Aug-2019}{Original}
%
% --------------------------------------------------
% (c) 2019, Roland Ritt
% Chair of Automation, University of Leoben, Austria
% email: automation@unileoben.ac.at
% url: automation.unileoben.ac.at
% --------------------------------------------------
%
%%
startInds = obj.startInds(indsCompressed);
if nargout>1
    stopInds = obj.stopInds(indsCompressed);
end

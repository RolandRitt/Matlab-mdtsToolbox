function smoothedData = smoothAsConv(input)
% vector operations, convolution, smoothing
%
% Purpose : smooth given data
%
% Syntax : smoothedData = smoothAsConv(input)
%
% Input Parameters :
%   input : Input for the computation. This can be given as:
%
%       Vector := Double vector holding the data
%
%       Struct := Struct which holds the handle to the mdtsObject as
%       input.object and the required tag as input.tag
%
% Return Parameters :
%   smoothedData : smoothed data as vector
%
% Description : 
%   Smooth the data given in 'input' by usage of the 'LDOasConv' function
%   with 'order' 0.
%
% Author : 
%   Paul O'Leary
%   Thomas Grandl
%   Roland Ritt
%
% History :
% \change{1.0}{06-Mar-2018}{Original}
%
% --------------------------------------------------------
% (c) 2018 Paul O'Leary,
% Chair of Automation, University of Leoben, Leoben, Austria
% email: office@harkeroleary.org,
% url: www.harkeroleary.org
% --------------------------------------------------------
%
%% Call LDOasConv

smoothedData = LDOasConv(input, 'order', 0);

end

